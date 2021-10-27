# Somehow this needs to be imported before our config.rb
# Otherwise it will cause bad requests for all requests to the server
require "webrick"
require_relative 'config.rb'

PORT = 33333

class Server
  include WEBrick

  def call(guard_class, event, *args)
    case event
    when :start_end
      log_file = File.open('/tmp/brain.log', 'a+')
      @server = HTTPServer.new(DocumentRoot: BUILD_PATH,
                               Port: PORT,
                               AccessLog: [[log_file, AccessLog::COMBINED_LOG_FORMAT]],
                               Logger: Log.new(log_file))
      Thread.new { @server.start }     # Let's Rock!
      puts "Open preview at http://localhost:#{PORT}".green
    when :stop_end
      @server.shutdown                 # shutdown with guard
    end
  end
end

class Generator < Brain::Generator
  def run_on_modifications(args)
    path = Pathname.new(args.first)
    # if layout changes all files will be re-generated
    if LAYOUT_PATH.children.include? path
      generate_all
    elsif path.exist? # ignore if not exists
      generate_file(Brain::BrainFile.new(path))
    end
  end

  def call(guard_class, event, *args)
    if respond_to? event
      send(event, args)
    else
      generate_all
    end
  end
end

guard :shell do
  generator = Generator.new

  # watch configs
  watch("config.rb") {
    load 'config.rb'
    generator.call(self, :start_end)
    n "=> config.rb ", "Brain", :success
    "config.rb"
  }
  # watch scss partials
  watch(%r{assets/stylesheets/_.*\.scss$}) {
    path = "assets/stylesheets/default.css.scss"
    generator.call(self, :run_on_modifications, path)
    n "=> #{path} ", "Brain", :success
    path
  }
  # watch all files
  watch(/.*/) { |m|
    path = m[0]
    generator.call(self, :run_on_modifications, path)
    n "=> #{path} ", "Brain", :success
    path
  }
  callback(generator, [:start_end, :run_all_end])
  callback(Server.new, [:start_end, :stop_end])
end
