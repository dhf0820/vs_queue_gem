require 'bunny'
require 'base64'
require_relative 'mgmt_connection'
require_relative 'mgmt_queue'



class Metrics

  @@current = nil


  def initialize(customer_name, container_name, container_id)
    @container_name = container_name
    @container_id = container_id 
    #@hostname = $hostname
    @queue_name = "#{customer_name}_metrics"
    @queue = MgmtQueue.new(@queue_name)
    STDERR.puts "ContainerId: #{container_id}"
    @@current = self
  end


  def self.post(facility, metric_name, identifier, id_type, metric, metric_type, divisors, tags, comment = "")
    if (@@current.nil?)
      STDERR.puts "\n\n!!!  EventQueue was not created, there is NO Event logging   !!!\n\n"
      return
    end
    @@current.send(facility, metric_name, identifier, id_type, metric, metric_type,  divisors, tags, comment)
  end

  def self.active
    @@current
  end

  def send(facility, metric_name, identifier, id_type, metric, metric_type,  divisors, tags, comment = '')
    e = {}
    e[:container_name] = @container_name
    e[:container_id] = @container_id  #[0..10]
    e[:facility] = facility
    e[:metric_name] = metric_name
    e[:identifier] = identifier
    e[:id_type] = id_type
    e[:metric] = metric
    e[:metric_type] = metric_type
    e[:divisors] = divisors       #[{name => value}]
    e[:tags] = tags.split(',')
    
    e[:comment] = comment
    e[:created] = Time.now
    @queue.publish(data: e.to_json)
  end

  def method_missing(m, *args, &block)
    @queue.send(m, *args, &block)
  end
end