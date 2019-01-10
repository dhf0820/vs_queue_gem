


class MqConnection
    @@connection = nil
    @@url = ENV['EVENT_URL']

    def self.connection
      if @@connection.nil?
        @@connection = Bunny.new(@@url)
        @@connection.start
      end
      @@connection
    end
  
    def self.url=(url)
      @@url = ENV['EVENT_URL'] = url
    end

    def self.url
      @@url
    end

    def self.set_url(url)
      @@url = ENV['EVENT_URL'] = url
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