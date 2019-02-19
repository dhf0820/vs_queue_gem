require 'spec_helper'
require './lib/vs_queue'
# require './lib/models/mgmt_connection'
# require './lib/models/mgmt_work_queue'
require 'json'



RSpec.describe MgmtWorkQueue do
  before :all do
    url = "amqp://dhf:Sacj0nhat1@cat.vertisoft.com/ChartArchive"
    MgmtConnection.url = url
    #ENV['VS_AMQP']=url
  end

  it 'creates a connection with the server', focus: true do

    queue = MgmtWorkQueue.new('test_queue')
    binding.pry
    queue.close
  end

  it 'queues a message' do
    queue = MgmtWorkQueue.new('test_queue')
    data = {}
    data[:my_love] = "Theresa French"
    val = queue.publish(data)
    expect(val).to_not be_nil
    queue.close
  end

  it "Retrieves a message" do
    puts "Retrieves a message from the queue"
    queue = MgmtWorkQueue.new('test_queue')
    data = {}
    data[:my_love] = "Theresa French"
    val = queue.publish(data)
    puts "calling queue.subscribe"
    queue.subscribe(manual: true, block: true) do |body, delivery_info, properties|
      data = body
      puts " \nsubscribe received:#{data.class} -- #{data}  :  #{body}\n"
      #queue.ack(delivery_info.delivery_tag)
      queue.ack
      expect(data).to_not be_nil
      expect(data[:my_love]).to eql "Theresa French"
      exit
    end
    #queue.ack(@delivery_info.delivery_tag)
    sleep 1  
    # expect(@body).to_not be_nil
    # data = JSON.parse(@body)
    # expect(data[:my_love]).to eql "Theresa French"
  end
end