require "bundler/setup"
require 'pry'
require 'bunny'
Bundler.setup
#require 'vs_queue'

# require "demo_gem"

$:.unshift(File.dirname(__FILE__) + './lib/lib')
$:.unshift(File.dirname(__FILE__) + './lib/models')
#$:.unshift(File.dirname(__FILE__) + '../sys_models')
require 'thread'

RSpec.configure do |config|

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

        #rspec configuration

        
  config.filter_run :focus => true


  config.expect_with :rspec

  # config.before(:suite) do
  #     DatabaseCleaner[:mongoid].clean_with :truncation
  # end

  # config.before(:suite) do
  #     DatabaseCleaner[:mongoid].strategy = :truncation
  #     DatabaseCleaner[:mongoid].clean_with(:truncation)
  # end

  # config.before(:all) do
  #     # Clean before each example group if clean_as_group is set
  #     if self.class.metadata[:clean_as_group]
  #       DatabaseCleaner[:mongoid].clean
  #     end
  # end

  # config.after(:all) do
  #     # Clean after each example group if clean_as_group is set
  #     if self.class.metadata[:clean_as_group]
  #       DatabaseCleaner[:mongoid].clean
  #     end
  # end

  # config.before(:each) do
  #     # Clean before each example unless clean_as_group is set
  #     unless self.class.metadata[:clean_as_group]
  #       DatabaseCleaner[:mongoid].start
  #     end
  # end

  # config.after(:each) do
  #     # Clean before each example unless clean_as_group is set
  #     unless self.class.metadata[:clean_as_group]
  #       DatabaseCleaner[:mongoid].clean
  #     end
  # end
end
