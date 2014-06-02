module Vagrant
  module Tools
    module Orm

      class Config

        def initialize(config_path)
          @config_path = config_path
          @machines = Dir["#{@config_path}/machines/*"].flat_map{|t| Machine.new(t)}
          puts @machines.inspect
        end

        def to_outputs
          @config_path
        end

      end

    end
  end
end