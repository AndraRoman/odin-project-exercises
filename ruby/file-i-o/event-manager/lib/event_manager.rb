require "csv"
require "sunlight/congress"

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zipcode)
  zipcode.to_s[0...5].rjust(5, '0')
end

def get_legislator_names(zipcode)
  legislators = Sunlight::Congress::Legislator.by_zipcode(zipcode)
  legislators.map { |l| "#{l.first_name} #{l.last_name}" }.join(", ")
end

puts "EventManager Initialized!"

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol
contents.each do |row|
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  legislators = get_legislator_names(zipcode)
  puts "#{name} #{zipcode} #{legislators}"
end

