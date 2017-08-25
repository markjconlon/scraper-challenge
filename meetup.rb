require 'Nokogiri'
require 'open-uri'
require 'csv'

start_url = "https://www.meetup.com/fintechto/members/?offset="
offset = "0"
end_url = "&sort=name&desc=0"
page = Nokogiri::HTML(open(start_url + offset + end_url))
mem_list = page.css("#member_list h4>a")
counter = 0
names_ids = []
mem_list.each do |li|
  id = (mem_list[counter]["href"]).split.map {|char| char.gsub(/[^\d]/, '')}
  names_ids << [mem_list[counter].text, id.join]
  counter += 1
end
names_ids.each do |person|
  CSV.open('names_ids.csv', 'a+') do |csv|
    csv << [person[0],person[1]]
  end
end
