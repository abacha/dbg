require "sinatra"
require "amqp"

get "/sinacor" do
  erb :sinacor
end

post "/sinacor/close" do
  EventMachine.run do
    connection = AMQP.connect(host: "127.0.0.1")
    channel  = AMQP::Channel.new(connection)
    queue = channel.queue("sinacor")
    exchange = channel.direct("")
    date = Date.today
    exchange.publish("Detectado fechamento Sinacor #{date}",
      {routing_key: queue.name, headers: {ref_date: date.to_s}})
    EventMachine.add_timer(2) do
      exchange.delete
      connection.close { EventMachine.stop }
    end
  end
end


