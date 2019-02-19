require 'vs_queue'
require 'pry'

ENV['VS_AMQP']="amqp://ChartArchive:Sacj0nhat1@cat.vertisoft.com/ChartArchive"


puts "Env = #{ENV['VS_AMQP']}"
binding.pry

MgmtConnection.url = "amqp://ChartArchive:Sacj0nhat1@cat.vertisoft.com/ChartArchive"
binding.pry
