class InvalidInput < Exception; end

require 'socket'
require 'json'

hostname = "localhost"
port = 2000
path = "/index.html"

puts "What kind of request would you like to send? Press 'p' for POST or 'g' for GET."
begin
  verb = case gets[0].downcase
         when "g" then "GET"
         when "p"
           path = "/thanks.html"
           "POST"
         else raise InvalidInput
         end
rescue InvalidInput
  puts "I don't understand that kind of request. Try again."
end

request_header = "#{verb} #{path} HTTP/1.0"
request_body = ""

if verb == "POST"
  puts "Enter your Viking's name."
  name = gets.chomp
  puts "Enter your Viking's email."
  email = gets.chomp
  data = {:viking => {:name => name, :email => email}}
  request_body = data.to_json
  request_header += "\r\nContent-Type: application/json\r\nContent-Length: #{request_body.bytesize}"
end

request = "#{request_header}\r\n\r\n#{request_body}"

socket = TCPSocket.open(hostname, port)
socket.puts(request)
response = socket.read
socket.close

headers, body = response.split("\r\n\r\n", 2)

status = headers.split("\r\n")[0]
case status.split[1] # code
when "200"
  print body
else
  puts "#{status}"
end
