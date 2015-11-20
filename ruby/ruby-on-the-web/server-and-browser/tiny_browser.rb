require 'socket'

hostname = "localhost"
port = 2000
path = "/index.html"

request = "GET #{path} HTTP/1.0\r\n\r\n"

socket = TCPSocket.open(hostname, port)
socket.print(request)
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
