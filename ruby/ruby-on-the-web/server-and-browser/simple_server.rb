require 'socket'
require 'json'

def respond(request)
  req_header = request.split("\r\n\r\n", 2)[0]
  req_body = request.split("\r\n\r\n", 2)[1] || ""
  initial_req_line = req_header.split("\r\n")[0]
  verb, path, version = initial_req_line.split
  path = "." + path
  version.strip!

  header = ""
  body = ""

  if File.exist?(path)
    contents = File.read(path)
    case verb
    when "POST"
      params = JSON.parse(req_body)
      formatted_data = ""
      params["viking"].each do |param|
        formatted_data += "<li> #{param[0]}: #{param[1]} </li>\r\n"
      end
      contents.gsub!("<%= yield %>", formatted_data)
    else # nothing special for GET, ignoring all other verbs
    end
    header = "#{version} 200 OK\r\nContent-Type: text/html\r\nContent-Length: #{contents.bytesize}"
    body = contents
  else
    header = "#{version} 404 File \"#{path}\" Not Found"
  end
  "#{header}\r\n\r\n#{body}"
end

server = TCPServer.open(2000)
loop do
  Thread.start(server.accept) do |client|
    request = []
    while line = client.gets
      request.push(line)
      break if line.chomp.length == 0
    end
    # if line length is zero then either we're done or there's a body to fetch
    if request.length > 2
      body = client.gets
      request.push(body)
    end
    response = respond(request.join(""))
    client.puts(response)
    client.close
  end
end
