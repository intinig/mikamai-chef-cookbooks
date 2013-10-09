# figure out where ruby is.  We have this kind of cumbersome thing
# since rvm may or may not be installed.

class Chef
  class Recipe
    def run_passenger_config *opts
      passenger_config = Proc.new do
        `/usr/local/rvm/bin/rvm default exec passenger-config #{opts * ' '}`.chomp
      end

      other_passenger_config = Proc.new do
        `passenger-config #{opts * ' '}`.chomp
      end

      if File.exists?("/usr/local/rvm/bin/rvm")
        return passenger_config.call
      else
        return other_passenger_config.call
      end
    end
  end
end
