require 'bunny'
require 'base64'
require_relative 'mgmt_connection'
require_relative 'mgmt_queue'



class EventQueue

  @@current = nil

  def initialize(hostname = 'vsoft')
    @hostname = hostname
    @queue_name = "#{hostname}_events"
    @queue = MgmtQueue.new(@queue_name)
    @container_id = Socket.gethostname
    @@current = self
  end

  def self.post(facility, process, identifier, id_type, metrics, metrics_name, divisor, tags, comment = "")
    if (@@current.nil?)
      EventQueue.new
    end
    @@current.send(facility, process, identifier, id_type, metrics, metrics_name, divisor, tags, comment)
  end

  def send(facility, process, identifier, id_type, metrics, metrics_name, divisor, tags, comment = '')
    e = {}
    e[:container_name] = $container_name
    e[:container_id] = @container_id[0..10]
    e[:facility] = facility
    e[:process] = process
    e[:identifier] = identifier
    e[:id_type] = id_type
    e[:metrics] = metrics
    e[:metrics_name] = metrics_name
    e[:divisor] = divisor
    e[:tags] = tags.split(',')
    e[:comment] = comment
    e[:created] = Time.now
    @queue.publish(data: e.to_json)
  end

  def method_missing(m, *args, &block)
    @queue.send(m, *args, &block)
  end
end