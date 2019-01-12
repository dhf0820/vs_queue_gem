
class MgmtConnection
  DEFAULT_URL='amqp://zvarvoot:hjFqTq-3JGVRB14eIa3dU3uQMjbfcS06@caterpillar.rmq.cloudamqp.com/zvarvoo'
  @@connection = nil
  @@url = ENV['MGMT_AMQP']
  if @@url.nil? || @url.blank?
    @@url = ENV['MGMT_AMQP'] = DEFAULT_URL
  end

  def self.connection
    if @@connection.nil?
      @@connection = Bunny.new(@@url)
      @@connection.start
    end
    @@connection
  end

  def self.url=(url)
    @@url = ENV['MGMT_AMQP'] = url
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