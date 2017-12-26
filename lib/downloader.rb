require_relative "downloader/version.rb"
require 'open-uri'
require 'net/http'
require 'uri'
require 'filesize'

module Downloader
 class Downloader
  # Get Header Data And Download It
  def download(url, path = nil)
      uri = URI.parse(url)
      Net::HTTP.start(uri.host, uri.port) do |http|
      	 puts "Connecting..."
         header = http.head(uri)
         puts "Connected."
         filesize = header['content-length']
         print "Filesize Is :"
         p Filesize.from("#{filesize} B").pretty
         print "Do Yoy Want To Continue? [y/n]: "
      end
      input = gets.chomp
      if input == 'y' then
         filename = URI.parse(url).to_s.split('/').last
  	     req = open(uri)
  	     res = req.read
  	     if path != nil then
            file = File.open("#{path}/#{filename}", 'w')
         else
            file = File.open(filename, 'w')
         end
         file.write(res)
      else
      	puts "GoodBye"
      end
  end
  class << self
    # Get Url
  	def run
        print "Please Enter Url :"
        @url = gets.chomp
        start
  	end
    # Check Url For Valid Or Invalid And Were Not Empty
     def start(path = nil)
     	url = @url
     	check = url.split('/').first
     	if url == nil or url == " " then
            begin
              raise ArgumentError, "Url Can t Be Empty"
              rescue Exception => e
                puts e
            end
        elsif check != "http:"
        	if check != "https:" then
              begin
               raise ArgumentError, "Invalid Url"
               rescue Exception => e
             	  puts e
              end
            end
     	else
             Downloader.new.download(url) 
        end
     end
  end 
 end
end

Downloader::Downloader.run