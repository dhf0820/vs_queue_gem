


class MqConnection
    @@connection = nil
    @@url = ENV['VS_AMQP']

    def self.connection
      if @@connection.nil?
        @@connection = Bunny.new(@@url)
        @@connection.start
      end
      @@connection
    end
  
    def self.set_url(url)
      @@url = url
    end

    def self.current_url
      @@url
    end
    
    def self.close
      if @@connection
        @@connection.close
        @@connection = nil
      end
    end
end