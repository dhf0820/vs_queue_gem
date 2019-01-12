require 'spec_helper'
require './lib/models/mgmt_connection'
require './lib/models/event_queue'
require 'json'


RSpec.describe EventQueue, focus: true do
  before :all do
    @url = "amqp://dhf:Sacj0nhat1@cat.vertisoft.com/ChartArchive"
    MgmtConnection.url = @url
  end

  it 'Confirms there is an ENV for the queue'  do
    expect(ENV['MGMT_AMQP']).to eql @url
    expect(MgmtConnection.url).to eql @url
  end

  it 'Queues and receives a message', focus: true do
    queue = EventQueue.new('test')  #hostname
    queue.send('id-1234', 'testing', '47', 'TestId', 10.19, 'ms', 1, 'tag1, tag2')
    queue.subscribe(manual: true, block:true) do |data, delivery_info, properties|
      puts "properties: #{properties}"
      queue.ack
       expect(data).to_not be_nil
       expect(data[:container_name]).to eql 'test'
       exit
    end


    queue.close

  end



end