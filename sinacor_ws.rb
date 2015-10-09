require "sinatra"
require "sinatra/json"

get "/sinacor/revenue/:date" do |date|
  data = 3.times.map do
    { date: Date.strptime(date, "%Y-%m-%d") + rand(10),
      client_id: rand(100),
      value: rand(100000) }
  end
  json data: data
end
