require 'spec_helper'
require './lib/models/mgmt_connection'
require './lib/models/log_queue'
require 'json'


RSpec.describe LogQueue, focus: true do
  before :all do
    @url = "amqp://dhf:Sacj0nhat1@cat.vertisoft.com/ChartArchive"
    MgmtConnection.url = @url
    $customer_name = 'test'
    $container_name = 'container'
    $container_id = 'id'
  end

  it 'Confirms there is an ENV for the queue'  do
    expect(MgmtConnection.url).to eql @url
    c = MgmtConnection.connection
    expect(ENV['MGMT_AMQP']).to eql @url
  end

  it 'Queues and receives a message' do
    #queue = LogQueue.new('test', 'container_name', 'container_id')  #hostname
    LogQueue.post('mmr','rspec', "starting, tersting", "Queues and receives a message")
    queue = LogQueue.active
    queue.subscribe(manual: true, block:false) do |data, delivery_info, properties|
      puts "properties: #{properties}"
      queue.ack
      expect(data).to_not be_nil
      expect(data[:process]).to eql 'rspec'
      #exit
    end
    queue.close
  end
end