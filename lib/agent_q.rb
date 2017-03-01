# Inspired by http://ngauthier.com/2014/06/scraping-the-web-with-ruby.html

require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'json'

class AgentQ
  include Capybara::DSL

  QUEPID_URL = 'http://app.quepid.com'

  def initialize(quepid_case, threshold_score, username, password)
    Capybara.default_driver = :poltergeist
    Capybara.app_host = QUEPID_URL
    @quepid_case = quepid_case
    @threshold_score = threshold_score
    @username = username
    @password = password
  end

  def run


    visit("/case/#{@quepid_case}/try/0")
    #save_screenshot('quepid.png')
    fill_in('Email', with: @username)
    within(:xpath, "/html/body/div[2]/div/div/div[1]/div[1]/div/form") do
      fill_in('Password', with: @password)
    end
    #save_screenshot('quepid_login.png')

    click_button('Login')

    sleep(20)

    #save_screenshot('quepid_dashboard.png')

    visit "/api/cases/#{@quepid_case}/scores/all.json"

    html = page.html
    json = html[html.index('{')..html.rindex('}')]

    results = JSON.parse(json)

    if results['message']
      puts "Error checking case #{@quepid_case}: #{results['message']}"
      exit 1
    else
      score = results['scores'].first['score']
      if score.to_i > @threshold_score.to_i
        puts "Case #{@quepid_case} scored (#{score}) above threshold of #{@threshold_score}"
        exit 0
      else
        puts "Case #{@quepid_case} scored (#{score}) below threshold of #{@threshold_score}"
        exit 1
      end
    end
  end
end
