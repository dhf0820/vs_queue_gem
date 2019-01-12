require 'bunny'
require 'base64'
require_relative 'mgmt_queue'


class LogQueue
  @@connection = nil
  
  def initialize(hostname = 'vsoft')
    @hostname = hostname
    @queue_name = "#{hostname}_logs"
    @queue = MgmtQueue.new(@queue_name)
  end
  
  def send(container_id, process, tags, message)
    l = {}
    l[:container_name] = @hostname
    l[:container_id] = container_id
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