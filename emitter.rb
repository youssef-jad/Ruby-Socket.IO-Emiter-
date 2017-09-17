# @author Youssef Jad <youssef.j4d@gmail.com>
# Date : 17-09-2017

require 'rubygems'
require 'socket.io-client-simple'
require 'yaml'
require 'json'

class IoEmmit
  $socket

  def initialize
    begin
      config = YAML.load_file('config.yml')
      io = SocketIO::Client::Simple
      $socket = io.connect "#{config['socketURI']}"
    rescue => error
      puts "#{error.to_s} "
      puts "NodejS Example : localhost:3000"
      puts "Nodejs on Domain Example : node.domain.com"
    end
  end

  def runit
    puts 'Provide Channel Name :  '
    channel = gets.chomp
    puts "You will sent Your Data on #{channel} / (To Change Your Channel Type 'channel' )"
    loop do
      msg = STDIN.gets.strip
      if msg === "channel"
        self.runit
      end

      if msg === "json"
        json = File.read('data.json')
        msg = JSON.parse(json)
      end
      $socket.emit "#{channel}" , { :content => msg, :at => Time.now}
    end
  end

end

socket = IoEmmit.new
socket.runit