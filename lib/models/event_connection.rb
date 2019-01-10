
class EventConnection
  @@connection = nil
  @@url = ENV['EVENT_AMQP']

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
  
  def self.close
    if @@connection
      @@connection.close
      @@connection = nil
    end
  end
end