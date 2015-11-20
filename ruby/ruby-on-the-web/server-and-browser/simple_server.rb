require 'socket'

def parse(request)
  parts = request.split
  verb = parts[0]
  path = "." + parts[1]
  version = parts[2].strip
  [verb, path, version]
end

def respond(request)
  verb, path, version = request
  header = ""
  body = ""
  case verb
  when "GET"
    if File.exist?(path)
      contents = File.read(path)
      header = "#{version} 200 OK\r\nContent-Type: text/html\r\nContent-Length: #{contents.bytesize}"
      body = contents
    else
      header = "#{version} 404 File \"#{path}\" Not Found"
    end
  else
  end
  "#{header}\r\n\r\n#{body}"
end

server = TCPServer.open(2000)
loop do
  Thread.start(server.accept) do |client|
    request = client.gets
    response = respond(parse(request))
    client.puts(response)
    client.close
  end
end
