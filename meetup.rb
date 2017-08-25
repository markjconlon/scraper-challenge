require 'Nokogiri'
require 'open-uri'
require 'csv'

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

def get_page(num_pages)
  counter = 0
  num_pages.times do
    start_url = "https://www.meetup.com/fintechto/members/?offset="
    offset = (counter * 20).to_s
    end_url = "&sort=name&desc=0"
    page = Nokogiri::HTML(open(start_url + offset + end_url))
    mem_list = page.css("#member_list h4>a")
    scrape_page(mem_list)
    counter += 1
    sleep rand(1..3)
  end
end

# Meetup displays 20 results per page 20*25 pages = 500 names
get_page(25)
