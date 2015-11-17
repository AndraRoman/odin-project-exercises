require "csv"
require "erb"
require "sunlight/congress"

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zipcode)
  zipcode.to_s[0...5].rjust(5, '0')
end

def get_legislator_names(zipcode)
  legislators = Sunlight::Congress::Legislator.by_zipcode(zipcode)
end

def save_form_letter(id, form_letter, message)
  Dir.mkdir("output") unless Dir.exists?("output")
  
  filename = "output/#{message}_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

template_letter = File.read "form_letter.erb"
erb_template = ERB.new(template_letter)

puts "EventManager Initialized!"

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol
contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  legislators = get_legislator_names(zipcode)
  form_letter = erb_template.result(binding)
  save_form_letter(id, form_letter, "thanks")
end

