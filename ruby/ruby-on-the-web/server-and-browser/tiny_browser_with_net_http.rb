require 'net/http'

host = "www.tutorialspoint.com"
path = "/index.htm"

http = Net::HTTP.new(host)
headers, body = http.get(path)
p headers
p body
if headers.code == "200"
  print body # nil
else
  puts "#{headers.code} #{headers.message}"
end
# This is supposed to be equivalent to tiny_browser.rb but it isn't - never gets a body.
