require 'bunny'
require 'base64'


#module DemoGem
  class WorkQueue
    @@connection = nil

    def initialize(queue_name)
      if @@connection.nil?
        puts "Creating new Rabbit Connection"
        @@connection = MqConnection.connection
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

        puts "Received from queue: #{body}"

        # if body
           body = JSON.parse body, symbolize_names: true
        # end
        puts "Yielding"
        yield(body, delivery_info, properties)
        puts "@@@back from yield\n\n"
        exit
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
      MqConnection.close
      @@connection = nil
    end

    def ack(msg)
      @ch.ack(msg)
    end

    def nack(msg)
      @ch.nack(msg)
    end
  end
#end
