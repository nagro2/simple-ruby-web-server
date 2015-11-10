require 'socket'                # Get sockets from stdlib

server = TCPServer.open(2000)   # Socket to listen on port 2000
loop {                          # Servers run forever
  Thread.start(server.accept) do |client|
    request = client.gets
    print "Request: '#{request}'\n"
    request=request.split
    print "Request.split #{request}\n"

    page_requested = request[1]
    case page_requested
     when '/index.htm' then 
	puts "index.htm requested"
	htmlpage = File.open("index.html", "r")
	contents = htmlpage.read
	htmlpage.close
	puts contents
	client.puts "HTTP/1.0 200 OK"
	client.puts "Date: #{Time.now.ctime}"
	client.puts "Content-Type: text/html"
	client.puts "Content.length: #{contents.length}"
	client.puts contents
     else
       puts "unknown page requested"
	htmlpage = File.open("400notfound.html", "r")
	contents = htmlpage.read
	htmlpage.close
	puts contents
	client.puts "HTTP/1.0 404 Not Found"
	client.puts contents
    end

    print "Served web request at #{Time.now.ctime}\n"
    client.close                # Disconnect from the client
  end
}
