load 'config.rb'

guard :shell do
  watch(/(.*\.(slim|scss|md))$/) { |m|
    Brain::Generator.new.call(self, :run_on_modifications, m[1])
    n "=> #{m[1]} ", "Brain", :success; m[1]
  }
  callback(Brain::Server.new, [:start_end, :stop_end])
  callback(Brain::Scanner.new, [:start_begin, :run_all_begin, :run_on_modifications_begin])
  callback(Brain::Generator.new, [:start_end, :run_all_end])
end
