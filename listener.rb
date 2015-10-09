#!/usr/bin/env ruby

require "rubygems"
require "amqp"
require "json"
require "net/http"
require "awesome_print"

class Sinacor
  BASE_URL = "http://localhost:3000"
  def fetch(date)
    uri = URI(BASE_URL + "/sinacor/revenue/#{date}")
    data = JSON.parse(Net::HTTP.get(uri))
  end
end

EventMachine.run do
  connection = AMQP.connect(host: "127.0.0.1")
  puts "Conectado"

  channel  = AMQP::Channel.new(connection)
  queue    = channel.queue("sinacor")
  exchange = channel.direct("")

  queue.subscribe do |metadata, payload|
    puts "Mensagem recebida: #{payload}"
    date = metadata.headers["ref_date"]
    puts "Sinacor (#{date}) fechado!"

    ap Sinacor.new.fetch(date)
  end
end
