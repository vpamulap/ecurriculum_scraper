require 'capybara'
require 'capybara/dsl'
require 'selenium-webdriver'





include Capybara::DSL

def basic_auth(user, pass)

end

def init_capy
  Capybara.register_driver :selenium do |app|
    client = Selenium::WebDriver::Remote::Http::Default.new
    client.timeout = 120
    Capybara::Selenium::Driver.new(app, :browser => :firefox, :http_client => client, :resynchronization_timeout => 10000)
  end

  Capybara.current_driver = :selenium
  Capybara.app_host = "https://vxp109:Iggy2000!@casemed.case.edu"
  page.driver.options[:resynchronize] = true
  page.visit("/ecurriculum")
end


init_capy
sleep(2)
page.find(:css, "a#cphBody_gvWeek_gvDay1_0_btnTitle1_0").click


new_window = page.driver.browser.window_handles.last
page.within_window new_window do
  puts page.find_link("Goldstein, David").click
end

gets
page.find(:css, "a#cphBody_gvWeek_gvDay1_0_btnTitle1_1").click
gets