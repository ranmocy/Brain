load 'config.rb'

guard :shell do
  # watch scss partials
  watch(%r{assets/stylesheets/_.*\.scss$}) {
    path = "assets/stylesheets/default.css.scss"
    Brain::Generator.new.call(self, :run_on_modifications, path)
    n "=> #{path} ", "Brain", :success
    path
  }
  # watch all files
  watch(".*") { |m|
    path = m[0]
    Brain::Generator.new.call(self, :run_on_modifications, path)
    n "=> #{path} ", "Brain", :success
    path
  }
  callback(Brain::Server.new, [:start_end, :stop_end])
  callback(Brain::Generator.new, [:start_end, :run_all_end])
  callback(:start_end) { `open http://localhost:#{PORT}` }
end
