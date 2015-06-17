load 'config.rb'

guard :shell do
  watch(/(.*\.(slim|scss|md))$/) { |m|
    Brain::Generator.new.call(self, :run_on_modifications, m[1])
    n "=> #{m[1]} ", "Brain", :success; m[1]
  }
  callback(Brain::Server.new, [:start_end, :stop_end])
  callback(Brain::Generator.new, [:start_end, :run_all_end])
  callback(:start_end) do
    `open http://localhost:#{PORT}`
  end
end
