require 'bunny'
require 'base64'
require_relative 'mgmt_queue'


class LogQueue

  @@current = nil

  def self.post(process, tags, message)
    if (@@current.nil?)
      STDERR.puts "\n\n!!!!   Logging was not initialized, NO LOGGING   !!!!\n\n"
      return
    end
    @@current.send(process, tags, message)
  end

  def self.active
    @@current
  end


  def initialize(customer_name, container_name, container_id)
    @container_name = container_name
    @container_id = container_id
    @queue_name = "#{customer_name}_logs"
    @queue = MgmtQueue.new(@queue_name)
   # @container_id = Socket.gethostname
    @@current = self
  end
  
  def send(process, tags, message)
    l = {}
    l[:container_name] = @container_name
    l[:container_id] = @container_id[0..10]
    l[:process] = process
    l[:tags] = tags.split(',')
    l[:message] = message
    l[:created] = Time.now
    @queue.publish(data: l.to_json, content_type: 'application/json')
  end

  def method_missing(m, *args, &block)
    puts "Delegating #{m}"
    @queue.send(m, *args, &block)
  end
end