require 'bunny'
require 'base64'


#module DemoGem
  class WorkQueue

    def initialize(queue_name)
      @connection = MqConnection.connection
      @ch = @connection.create_channel
      @ch.prefetch(1) # allow for more than one worker
      @queue = @ch.queue(queue_name, :persistent => true, durable: true, auto_delete: false, exclusive: false)
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
      @ch.close
    end

    def ack(msg)
      @ch.ack(msg)
    end

    def nack(msg)
      @ch.nack(msg)
    end
  end
#end
