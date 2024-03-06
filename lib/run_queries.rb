# Inspired by http://ngauthier.com/2014/06/scraping-the-web-with-ruby.html

require 'capybara'
require 'capybara/dsl'
require 'capybara/cuprite'
require 'json'

class RunQueries
  include Capybara::DSL


  def initialize(quepid_case, username, password, quepid_url)
    @quepid_case = quepid_case
    @username = username
    @password = password
    @quepid_url = quepid_url
    
    Capybara.register_driver :cuprite do |app|
      Capybara::Cuprite::Driver.new(app, timeout: 30) # Increase timeout to 30 seconds
    end

    Capybara.default_driver = :cuprite
    Capybara.default_max_wait_time = 30 # Increase timeout to 30 seconds
    # Capybara.app_host = @quepid_url
  end

  def run

    # we go direct to the case, which then prompts the login process.  That way we only
    # score the requested case
    visit("#{@quepid_url}/case/#{@quepid_case}/query/0")
    save_screenshot('quepid.png')
    within('#login') do
      fill_in('user_email', with: @username)
      fill_in('user_password', with: @password)

      click_button('Sign in')
    end
    save_screenshot('quepid_login.png')

    

    visit("#{@quepid_url}/case/#{@quepid_case}/query/0")

    

    save_screenshot('quepid_case_queries.png')
    
    page.has_css?('.search-feedback', visible: true, wait: 60)
    
    save_screenshot('quepid_case_queries2.png')

    page.has_no_css?('.search-feedback', wait: 60)

     save_screenshot('quepid_case_queries3.png')

    content = find('.snapshot-payload').text
    
    puts content

    
  end
  
end
