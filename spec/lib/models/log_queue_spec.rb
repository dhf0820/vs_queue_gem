require 'spec_helper'
require './lib/models/mgmt_connection'
require './lib/models/log_queue'
require 'json'


RSpec.describe LogQueue, focus: true do
  before :all do
    @url = "amqp://dhf:Sacj0nhat1@cat.vertisoft.com/ChartArchive"
    MgmtConnection.url = @url
  end

  it 'Confirms there is an ENV for the queue'  do
    expect(ENV['MGMT_AMQP']).to eql @url
    expect(MgmtConnection.url).to eql @url
  end

  it 'Queues and receives a message', focus: true do
    queue = LogQueue.new('test')  #hostname
    queue.send("log_1234", 'rspec', "starting", "Queues and receives a message")
    queue.subscribe(manual: true, block:true) do |data, delivery_info, properties|
      puts "properties: #{properties}"
      queue.ack
       expect(data).to_not be_nil
       expect(data[:process]).to eql 'rspec'
       exit
    end


    queue.close

  end



end