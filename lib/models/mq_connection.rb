


class MqConnection
    @@connection = Bunny.new(ENV['VS_AMQP'])
    @@connection.start

    def self.connection
      @@connection
    end
  
    def self.close
      @@connection.close
    end
end