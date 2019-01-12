require 'bunny'
require 'base64'
require 'json'
require_relative 'mgmt_connection'


class MgmtQueue
  
  def initialize(queue_name= 'vsoft_mgmt')
    @queue_name = queue_name
    @connection = MgmtConnection.connection
    @ch = @connection.create_channel
    @ch.prefetch(1) # allow for more than one worker
    @queue = @ch.queue(queue_name, :persistent => true, durable: true, 
          auto_delete: false, exclusive: false)
  end

  def publish(data: data, content_type: 'application/json')
    "Publishing #{data.class}"
    unless data['image'].nil?
      data['image'] = Base64.encode64(data['image'])
    end
    json = data.to_json
    header = {}
    header[:test] = "Theresa"
    @ch.default_exchange.publish(json, routing_key: @queue.name, :persistent => true, :auto_delete => false,
            :durable => true, :exclusive => false, :content_type => content_type)
  end

  def publish_topic(topic: topic, data: data, content_type: 'application/json')
    unless data['image'].nil?
      data['image'] = Base64.encode64(data['image'])
    end
    json = data.to_json
    topic_exchange(topic).publish(json, routing_key: @queue.name, :persistent => true, :auto_delete => false,
                                :durable => true, :exclusive => false, :content_type => content_type)
  end
  
  def subscribe(manual: true, block: true)
    @queue.subscribe(:manual_ack => manual, :block => block) do |delivery_info, properties, body|
      @delivery_info = delivery_info
      @properties =  properties

     # puts "\nReceived from Rabbit queue: #{body.class}  -  #{body}\n"
      data = JSON.parse (JSON.parse body, symbolize_names: true), symbolize_names: true

      #puts "\n    !!! data type: #{data.class} -- #{data}"
      yield(data, delivery_info, properties)
      # puts "@@@back from yield\n\n"
    end
  end 

  def subscribe_simple(manual: true, block: true)
    @queue.subscribe(:manual_ack => manual, :block => block) do |delivery_info, properties, body|
      @delivery_info = delivery_info
      @properties =  properties
      body = JSON.parse body, symbolize_names: true
      puts "Received from queue: #{body}"

      # if body
          body = JSON.parse body, symbolize_names: true
      # end
      puts "Yielding"
      yield(body)
      puts "@@@back from yield\n\n"
    end
  end 

  def queue
    @queue
  end

  def ch
    @ch
  end

  def default_exchange
    @ch.exchange('')
  end

  def direct_exchange(name)
    @ch.exchange(name)
  end

  def topic_exchange(topic_name)
    @ch.topic(topic_name)
  end

  def queue
    @queue
  end

  def channel
    @ch
  end

  def close_channel
    @ch.close  # this also closes the connection
    puts "Clossing Channel"
    # @@connection.close
    # @@connection = nil
  end

  def close
    @ch.close
    # puts "Closing Connection"
    # MqConnection.close
    # @@connection = nil
  end

  def ack(msg = @delivery_info.delivery_tag)
    @ch.ack(msg)
  end

  # def ack()
  #   @ch.ack(@delivery_info.delivery_tag)
  # end

  def nack(msg = @delivery_info.delivery_tag)
    @ch.nack(msg)
  end

  # def nack()
  #   @ch.nack(@delivery_info.delivery_tag)
  # end
end