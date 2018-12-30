require 'spec_helper'
require './lib/models/mq_connection'
require './lib/models/work_queue'
require 'json'


RSpec.describe WorkQueue do
  before :all do
    url = "amqp://dhf:Sacj0nhat1@cat.vertisoft.com/ChartArchive"
    ENV['VS_AMQP']=url
  end

  it 'creates a connection with the server' do
    queue = WorkQueue.new('test_queue')
    queue.close
  end

  it 'queues a message' do
    
    queue = WorkQueue.new('test_queue')
    data = {}
    data[:my_love] = "Theresa French"
    val = queue.publish(data)
    expect(val).to_not be_nil
    queue.close
  end

  it "Retrieves a message", focus: true do
    puts "Retrieves a message from the queue"
    queue = WorkQueue.new('test_queue')
    data = {}
    data[:my_love] = "Theresa French"
    val = queue.publish(data)
    puts "calling queue.subscribe"
    queue.subscribe(manual: true, block: true) do |body, delivery_info, properties|
      data = body
      puts " subscribe received: #{data}  :  #{body}"
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