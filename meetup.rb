# both of the sites do not display emails probably for this very reason
# of scraping. Meetup used to however they now encourage in app messaging
# therefore I chose to grab member ids
require 'Nokogiri'
require 'open-uri'
require 'csv'

# takes the data passed from get_page and appends desired pieces
# to names_ids.csv
def scrape_page(mem_list)
  counter = 0
  mem_list.each do |li|
    id = (mem_list[counter]["href"]).split.map {|char| char.gsub(/[^\d]/, '')}
    CSV.open('names_ids.csv', 'a+') do |csv|
      csv << [mem_list[counter].text, id.join]
    end
    counter += 1
  end
end

# get_page simply does that it gets the data from the page we
# want and then sends it for further extraction and appending
# via scrape_page
def get_page(num_pages)
  counter = 0
  num_pages.times do
    # split the url up for readability and allows easy subustitution
    # if we would like to scrape other groups in the future
    start_url = "https://www.meetup.com/fintechto/members/?offset="
    offset = (counter * 20).to_s
    end_url = "&sort=name&desc=0"
    page = Nokogiri::HTML(open(start_url + offset + end_url))
    mem_list = page.css("#member_list h4>a")
    scrape_page(mem_list)
    counter += 1
    # added a short random sleep timer in order to lower the frequecy
    # of requests to meetups servers
    sleep rand(1..3)
  end
end

# Meetup displays 20 results per page 20*25 pages = 500 names
get_page(25)
