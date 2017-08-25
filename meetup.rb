# both of the sites do not display emails probably for this very reason
# of scraping. Meetup used to however they now encourage in app messaging
# therefore I chose to grab member ids
require 'Nokogiri'
require 'open-uri'
require 'csv'

# master method
def scrape(num_pages)
  num_pages.times do |page_number|
    page = get_page(page_number)
    data = scrape_page(page)
    write_to_csv(data)
    # added a short random sleep timer in order to lower the frequecy of requests
    sleep rand(1..3)
  end
end

# gets the page and turns it into a Nokogiri object
def get_page(page_number)
  start_url = "https://www.meetup.com/fintechto/members/?offset="
  offset = (page_number * 20).to_s
  end_url = "&sort=name&desc=0"
  page = Nokogiri::HTML(open(start_url + offset + end_url))
  page
end

# takes the data passed from get_page and returns the members array [name, ids]
def scrape_page(page)
  mem_list = page.css("#member_list h4>a")
  members = []
  mem_list.each_with_index do |mem_link|
    id = (mem_link["href"]).split.map {|char| char.gsub(/[^\d]/, '')}
    members << [mem_link.text, id.join]
  end
  members
end

# accepts the members data and writes each member on a new line
def write_to_csv(data)
  CSV.open('names_ids.csv', 'a+') do |csv|
    data.each do |member|
      csv << member
    end
  end
end
# each page represents 20 members 25*20 = 500 members
scrape(25)
