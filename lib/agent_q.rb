# Inspired by http://ngauthier.com/2014/06/scraping-the-web-with-ruby.html

require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'json'

class AgentQ
  include Capybara::DSL


  def initialize(quepid_case, threshold_score, username, password, quepid_url)
    @quepid_case = quepid_case
    @threshold_score = threshold_score
    @username = username
    @password = password
    @quepid_url = quepid_url

    Capybara.default_driver = :poltergeist
    Capybara.app_host = @quepid_url
  end

  def run

    # we go direct to the case, which then prompts the login process.  That way we only
    # score the requested case
    visit("/case/#{@quepid_case}/try/0")
    #save_screenshot('quepid.png')
    fill_in('Email', with: @username)
    within(:xpath, "/html/body/div[3]/div/div/div[1]/div[1]/div/form") do
      fill_in('Password', with: @password)
    end
    #save_screenshot('quepid_login.png')

    click_button('Login')

    sleep(20)

    #save_screenshot('quepid_dashboard.png')

    visit "/api/cases/#{@quepid_case}/scores/all.json"
    html = page.html
    json = html[html.index('{')..html.rindex('}')]
    case_results = JSON.parse(json)

    visit "/api/cases/#{@quepid_case}.json"
    html = page.html
    json = html[html.index('{')..html.rindex('}')]
    case_details = JSON.parse(json)

    case_name = case_details["caseName"]

    if case_results['message']
      puts "Error checking case #{@quepid_case}: #{case_results['message']}"
      exit 1
    else
      score = case_results['scores'].first['score']
      if score.to_i >= @threshold_score.to_i
        puts "Case #{case_name} (#{@quepid_case}) scored #{score}, \e[32mwhich meets the threshold of #{@threshold_score}\e[0m"
        exit 0
      else
        puts "Case #{case_name} (#{@quepid_case}) scored #{score}, \e[31mwhich is below the threshold of #{@threshold_score}\e[0m"
        exit 1
      end
    end
  end
end
