#require 'pry'

#puts "Current Folder: #{Dir.pwd}"
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "lib/version"


Gem::Specification.new do |spec|
  spec.name          = "vs_queue"
  spec.version       =  VsQueueGem::VERSION
  spec.authors       = ["Donald French"]
  spec.email         = ["dhfrench@vertisoft.com"]

  spec.summary       = %q{All models used by IDS processes.}
  spec.description   = %q{require 'vs_queue' then require necessary models/libs using
  require 'models' or 'lib'.  Local models ar require './models' or './lib'}
  spec.homepage      = "http://vertisoft.com"


  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "http://gemfury.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # spec.files = [
  #   "lib/vs_queue.rb",
  #   "lib/models/version.rb",
  #   "lib/models/theresa.rb",
  #   "lib/models/work_queue.rb"
  # ]
  


  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  #spec.files         = Dir.chdir(File.expand_path('../lib', __FILE__)) do


#dhf = File.expand_path('../lib', __FILE__)

  #files         = Dir.chdir(File.expand_path('./lib', __FILE__)) do  
  spec.files         = Dir.chdir(File.expand_path('../', __FILE__)) do 
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

#binding.pry

  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'bunny', '~> 2.11'
  spec.add_runtime_dependency 'pry', '~> 0.11'
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "minitest", "~> 5.1"
  spec.add_development_dependency 'pry-byebug', '~> 3.6'
  spec.add_development_dependency 'pry-coolline'
  spec.add_development_dependency "simplecov" 
  spec.add_development_dependency "guard-bundler" 
  spec.add_development_dependency "guard" 
  spec.add_development_dependency "guard-livereload"
  spec.add_development_dependency "guard-rspec"  
  #spec.add_development_dependency "guard-rubocop"
end
