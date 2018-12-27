


class MqConnection
    @@connection = nil

    def self.connection
      if @@connection.nil?
        @@connection = Bunny.new(ENV['VS_AMQP'])
        @@connection.start
      end
      @@connection
    end
  
    def self.close
      @@connection.close
      @@connection = nil
    end
end