require 'spec_helper'
require './lib/models/mgmt_connection'
require './lib/models/event_queue'
require 'json'


RSpec.describe EventQueue do
  before :all do
    $customer_name = 'test'
    @url = "amqp://dhf:Sacj0nhat1@cat.vertisoft.com/ChartArchive"
    MgmtConnection.url = @url
  end

  it 'Confirms there is an ENV for the Eventqueue'  do

    expect(MgmtConnection.url).to eql @url
    c = MgmtConnection.connection
    expect(ENV['MGMT_AMQP']).to eql @url
  end

  it 'Queues and receives a message' do
    queue = EventQueue.new('customer_name', 'container_name', 'id') 
    EventQueue.post("mmr", 'pages_submitted', 'id-1234', :release_id, 10.19, 'ms', 5, 'tag1, tag2')

    queue.subscribe(manual: true, block:true) do |data, delivery_info, properties|
      puts "properties: #{properties}"
      queue.ack
       expect(data).to_not be_nil
       expect(data[:container_name]).to eql 'container_name'
       exit
    end


    queue.close

  end



end