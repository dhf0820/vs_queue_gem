require 'spec_helper'
require './lib/models/mq_connection'
require 'json'


RSpec.describe MqConnection, focus: true do
  before :all do
    @url = "amqp://dhf:Sacj0nhat1@cat.vertisoft.com/ChartArchive"
    ENV['VS_AMQP']=@url
  end

  it 'Confirms there is an ENV for the queue'  do 
    expect(ENV['VS_AMQP']).to eql @url
  end

  it "sets the url to custom", focus: true do
    MqConnection.set_url("testurl")
    expect(MqConnection.current_url()).to eql "testurl"
  end

  it 'creates a connection with the server' do
    MqConnection.set_url("amqp://dhf:Sacj0nhat1@cat.vertisoft.com/ChartArchive")  
    connection = MqConnection.connection
    expect(connection).to_not be_nil
    connection.close
  end

end