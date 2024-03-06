# Inspired by http://ngauthier.com/2014/06/scraping-the-web-with-ruby.html

require 'capybara'
require 'capybara/dsl'
require 'capybara/cuprite'
require 'json'

class CheckCase
  include Capybara::DSL


  def initialize(quepid_case, threshold_score, username, password, quepid_url)
    @quepid_case = quepid_case
    @threshold_score = threshold_score
    @username = username
    @password = password
    @quepid_url = quepid_url
    
    Capybara.register_driver :cuprite do |app|
      Capybara::Cuprite::Driver.new(app, timeout: 30) # Increase timeout to 30 seconds
    end

    Capybara.default_driver = :cuprite
    Capybara.default_max_wait_time = 30 # Increase timeout to 30 seconds
    #Capybara.app_host = @quepid_url
  end

  def run

    # we go direct to the case, which then prompts the login process.  That way we only
    # score the requested case
    visit("#{@quepid_url}/case/#{@quepid_case}/try/0")
    #save_screenshot('quepid.png')
    within('#login') do
      fill_in('user_email', with: @username)
      fill_in('user_password', with: @password)

      click_button('Sign in')
    end
    #save_screenshot('quepid_login.png')

    visit("#{@quepid_url}/case/#{@quepid_case}")

    page.has_css?('.search-feedback', visible: true, wait: Capybara.default_max_wait_time)
    
    #save_screenshot('quepid_case_queries2.png')

    page.has_no_css?('.search-feedback', wait: Capybara.default_max_wait_time)
    
    #save_screenshot('quepid_case.png')

    visit "#{@quepid_url}/api/cases/#{@quepid_case}/scores/all.json"
    html = page.html
    json = html[html.index('{')..html.rindex('}')]
    case_results = JSON.parse(json)
    if case_results['reason'] == 'Unauthorized!'
      puts "API reporting Unauthorized!  Username/Password issue in accessing API."
      exit 1
    end

    visit "#{@quepid_url}/api/cases/#{@quepid_case}.json"
    html = page.html
    json = html[html.index('{')..html.rindex('}')]
    case_details = JSON.parse(json)
    case_name = case_details["case_name"]

    if case_results['message']
      puts "Error checking case #{@quepid_case}: #{case_results['message']}"
      exit 1
    else
      score = case_results['scores'].first['score']
      if score.to_f >= @threshold_score.to_f
        puts "Case #{case_name} (#{@quepid_case}) scored #{score}, \e[32mwhich meets the threshold of #{@threshold_score}\e[0m"
        exit 0
      else
        puts "Case #{case_name} (#{@quepid_case}) scored #{score}, \e[31mwhich is below the threshold of #{@threshold_score}\e[0m"
        exit 1
      end
    end
  end
end
