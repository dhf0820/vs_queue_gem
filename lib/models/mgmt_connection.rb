
class MgmtConnection
  DEFAULT_URL='amqp://zvarvoot:hjFqTq-3JGVRB14eIa3dU3uQMjbfcS06@caterpillar.rmq.cloudamqp.com/zvarvoot'
  @@connection = nil
  #@@url = DEFAULT_URL    
  @@url = ENV['MGMT_AMQP'] || DEFAULT_URL
  # if @@url.nil? || @url.blank?
  #   @@url = ENV['MGMT_AMQP'] = DEFAULT_URL
  # end
  STDERR.puts "Default MgmtConnection AMQP: #{@@url}"

  def self.connection
    if @@connection.nil?
      if @@url.nil? || @@url.empty?
        @@url = DEFAULT_URL
      end
      ENV['MGMT_AMQP'] = @@url
      STDERR.puts "MgmtConnection starting #{@@url}"
      @@connection = Bunny.new(@@url)
      @@connection.start
    end
    @@connection
  end

  def self.url=(url)
    @@url  = url
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