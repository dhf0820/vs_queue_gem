require 'bunny'
require 'base64'
require_relative 'mgmt_connection'
require_relative 'mgmt_queue'



class EventQueue

  def initialize(hostname = 'vsoft')
    @hostname = hostname
    @queue_name = "#{hostname}_events"
    @queue = MgmtQueue.new(@queue_name)
  end

  def send(container_id, process, identifier, id_type, metrics, metrics_name, divisor, tags)
    e = {}
    e[:container_name] = @hostname
    e[:container_id] = container_id
    e[:process] = process
    e[:identifier] = identifier
    e[:id_type] = id_type
    e[:metrics] = metrics
    e[:metrics_name] = metrics_name
    e[:divisor] = divisor
    e[:tags] = tags.split(',')
    e[:created] = Time.now
    @queue.publish(data: e.to_json)
  end

  def method_missing(m, *args, &block)
    @queue.send(m, *args, &block)
  end
end