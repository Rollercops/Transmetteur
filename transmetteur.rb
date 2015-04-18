require 'socket'

if (ARGV[0] == "T") 
then
   receve = TCPServer.open(ARGV[2])
   loop {
   	source = receve.accept
	host = ARGV[1]
	port = ARGV[2]

      filename = source.gets.chomp

      puts "Reading contents of #{filename}.raw"
      raw_data = source.gets("\r\r\n\n").chomp("\r\r\n\n")
      file = File.open(filename + ".raw", 'wb')
      file.print raw_data
      file.close

      puts "Converting #{filename}"
      system "scriptit.bat " + filename + ".raw"

      puts "Sending contents of #{filename}.mzML"
      data = IO.read(filename + ".mzML")
      source.print data
      source.print "\r\r\n\n"

      puts "Done"
      source.close
      break
  }
elsif (ARGV[0] == "R")
then
	host = ARGV[1]
	port = ARGV[2]
	fileName = ARGV[3]

	source = TCPSocket.open(host, port)

	puts "Sending raw file"
	source.puts fileName
	data = IO.read("#{fileName}")
	source.print data
	source.print "\r\r\n\n"  #This is the delimiter for the server

	puts "Receiving mzML file"
	file = File.open("./#{fileName}.mzML", 'wb')
	data = source.gets("\r\r\n\n")
	file.print data
	source.close
else
	puts "Argument non conforme.\n Veillez suivre la documentation fourni ou contacter un administrateur."
end