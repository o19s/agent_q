# Inspired by http://ngauthier.com/2014/06/scraping-the-web-with-ruby.html

require 'capybara'
require 'capybara/dsl'
require 'capybara/cuprite'
require 'json'

class AgentQ
  include Capybara::DSL


  def initialize(quepid_case, threshold_score, username, password, quepid_url)
    @quepid_case = quepid_case
    @threshold_score = threshold_score
    @username = username
    @password = password
    @quepid_url = quepid_url

    Capybara.default_driver = :cuprite
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

    #within(:xpath, "/html/body/div[3]/div/div/div[1]/div[1]/div/form") do
    #  fill_in('Password', with: @password)
    #end
    #save_screenshot('quepid_login.png')



    sleep(20)

    #save_screenshot('quepid_dashboard.png')

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
