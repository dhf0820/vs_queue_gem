require 'pry'
binding.pry
require './lib/models/mq_connection'
require 'json'
require 'pry'

RSpec.describe MqConnection do
  before :all do
    ENV['VS_AMQP']="amqp://ChartAArchive:Sacj0nhat1@cat.vertisoft.com/ChartArchive"
  end

  it 'COnfirms there is an ENV for the queue'  do 
    expect(ENV['VS_AMQP']).to eql 'amqp://ChartAArchive:Sacj0nhat1@cat.vertisoft.com/ChartArchive'
  end
end