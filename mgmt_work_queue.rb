require 'bunny'
require 'base64'
require 'json'
require_relative 'mgmt_connection'


  class MgmtWorkQueue
    @@connection = nil

    def initialize(queue_name)
      if @@connection.nil?
        puts "Creating new Rabbit Connection"
        @@connection = MgmtConnection.connection
      end
      @ch = @@connection.create_channel
      @ch.prefetch(1) # allow for more than one worker
      @queue = @ch.queue(queue_name, :persistent => true, durable: true, 
            auto_delete: false, exclusive: false)
    end

    def publish(data)
      unless data['image'].nil?
        data['image'] = Base64.encode64(data['image'])
      end
      json = data.to_json
      @ch.default_exchange.publish(json, routing_key: @queue.name, :persistent => true, :auto_delete => false,
                                  :durable => true, :exclusive => false)
    end

    def publish_topic(topic, data)
      unless data['image'].nil?
        data['image'] = Base64.encode64(data['image'])
      end
      json = data.to_json
      topic_exchange(topic).publish(json, routing_key: @queue.name, :persistent => true, :auto_delete => false,
                                  :durable => true, :exclusive => false)
    end
    
    def subscribe(manual: true, block: true)
      @queue.subscribe(:manual_ack => manual, :block => block) do |delivery_info, properties, body|
        @delivery_info = delivery_info
        @properties =  properties
puts " Properties: #{@properties}"
        puts "Received from queue: #{body.class}  -   #{body}"

        # if body
          data = JSON.parse body, symbolize_names: true
        # end
        puts "Yielding"
        yield(data, delivery_info, properties)
        puts "@@@back from yield\n\n"
      end
    end 

    def subscribe_simple(manual: true, block: true)
      @queue.subscribe(:manual_ack => manual, :block => block) do |delivery_info, properties, body|
        @delivery_info = delivery_info
        @properties =  properties

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
      #@ch.close  # this also closes the connection
      puts "Clossing Channel"
      # @@connection.close
      # @@connection = nil
    end

    def close
      #@ch.close
      puts "Closing Connection"
      MgmtConnection.close
      @@connection = nil
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
#end
