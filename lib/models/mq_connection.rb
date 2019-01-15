


class MqConnection
  DEFAULT_URL='amqp://zvarvoot:hjFqTq-3JGVRB14eIa3dU3uQMjbfcS06@caterpillar.rmq.cloudamqp.com/zvarvoot'
  @@connection = nil
  #@@url = nil
  #@@url = ENV['VS_AMQP']
  # if @@url.nil? || @url.blank?
  #   @@url = ENV['VS_AMQP'] = DEFAULT_URL
  # end


    def self.connection
      if @@connection.nil?
        if @@url.nil? || @@url.blank?
          @@url = DEFAULT_URL
        end
STDERR.puts "MqConnection starting #{@@url}"
        @@connection = Bunny.new(@@url)
        @@connection.start
      end
      @@connection
    end
  
    def self.url=(url)
      @@url = ENV['VS_AMQP'] = url
    end

    def self.url
      @@url
    end

    def self.set_url(url)
      @@url = ENV['VS_AMQP'] = url
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