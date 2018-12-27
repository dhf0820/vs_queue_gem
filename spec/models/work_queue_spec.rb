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
    queue.close_channel
  end

  it 'queues a message' do
    queue = WorkQueue.new('test_queue')
    data = {}
    data[:field1] = "Theresa French"
    val = queue.publish(data)
    expect(val).to_not be_nil
    queue.close_channel
  end

  it "Retrieves a message" do
    queue = WorkQueue.new('test_queue')
    data = {}
    data[:my_love] = "Theresa French"
    val = queue.publish(data)
    queue.queue.subscribe(manual_ack: true, block: true) do |delivery_info, properties, body|
      @body = body
      queue.ack(delivery_info.delivery_tag)
      exit
    end
    #queue.ack(@delivery_info.delivery_tag)
    sleep 1  
    expect(@body).to_not be_nil
    data = JSON.parse(@body)
    expect(data[:my_love]).to eql "Theresa French"
  end
end