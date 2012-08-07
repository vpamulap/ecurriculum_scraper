require 'capybara'
require 'capybara/dsl'
require 'selenium-webdriver'
require 'google_calendar'
require 'chronic'

include Capybara::DSL

# Capybara Functions
# initializes Capybara / sets up the webdriver to control firefox
def init_capy(username, password)
  Capybara.register_driver :selenium do |app|
    client = Selenium::WebDriver::Remote::Http::Default.new
    client.timeout = 120
    Capybara::Selenium::Driver.new(app, :browser => :firefox, :http_client => client, :resynchronization_timeout => 10000)
  end

  Capybara.current_driver = :seleniumrequire "scrape"
  
  Capybara.app_host = "https://#{username}:#{password}@casemed.case.edu"
  page.driver.options[:resynchronize] = true
  page.visit("/ecurriculum")
end

def get_week_data
  week = []
  (0..5).each do |n|
    day = {date: get_date(n), events: []}
    day[:events].concat(get_events(n))
    # day[:announcements].append(get_announcements(n))
    week.push(day)
  end
  week
end

def get_date(n)
  puts "Getting date..."
  id = generate_date_id(n)
  date = Chronic.parse(page.find(:css, "span##{id}").text)
  puts date.to_s
end

def get_events(day)
  puts "Getting events..."
  events = []
  # try an event id until one is not found, when not found, return
  (0..100).each do |event_number|
    title_selector = generate_event_title_id(day, event_number)
    time_selector = generate_event_time_id(day, event_number)
    break if page.has_no_selector?(time_selector)
    event_title = page.find(:css, title_selector).text
    # get event details
    events.push(event_title)
    puts event_title
  end
  events
end

# takes in a day 0-5 (mon-sat) and outputs the id of the date string
def generate_date_id(weekday) 
  if weekday < 3
    "cphBody_gvWeek_lblgvDay1_#{weekday}"
  else
    "cphBody_gvWeek_lblgvDay2_#{weekday - 3}"
  end
end

def generate_event_time_id(weekday, event_number)
  if weekday < 3
    "span#cphBody_gvWeek_gvDay1_#{weekday}_lblHrs_#{event_number}"
  else
    "span#cphBody_gvWeek_gvDay2_#{weekday - 3}_lblHrs_#{event_number}"
  end
end

def generate_event_title_id(weekday, event_number)
  if weekday < 3
    "a#cphBody_gvWeek_gvDay1_#{weekday}_btnTitle1_#{event_number}"
  else
    "a#cphBody_gvWeek_gvDay2_#{weekday - 3}_btnTitle2_#{event_number}"
  end
end

def get_event_details(event_title_id)
  page.find(:css, event_title_id).click
  # grab each day of the week
  new_window = page.driver.browser.window_handles.last
  page.within_window new_window do
    # get more details
  end
end

###### BEGIN EXECUTION ######

# puts "Please type in your Case username"
# username = gets
# puts "Please type in your Case password"
# password = gets
username = "vxp109"
password = "Iggy2000!"
# puts "Type in your gmail username"
# gmail_username = gets
# puts "Type in your gmail password"
# gmail_password = gets

init_capy(username, password)

get_week_data

# week = get_week_data
# update_google_calendar

# puts page.find(:css, "span#cphBody_gvWeek_lblgvDay1_0").text
# page.find(:css, "a#cphBody_gvWeek_gvDay1_0_btnTitle1_0").click

# grab each day of the week
# new_window = page.driver.browser.window_handles.last
# page.within_window new_window do
#   puts page.find_link("Goldstein, David").click
# end

# gets
# page.find(:css, "a#cphBody_gvWeek_gvDay1_0_btnTitle1_1").click
# gets






