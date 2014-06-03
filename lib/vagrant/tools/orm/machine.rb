module Vagrant
  module Tools
    module Orm

      class Machine

        attr_accessor :name

        def initialize(machine_path)
          @machine_path = machine_path
          self.name = File.basename(machine_path)
          @provider = Dir["#{@machine_path}/*"].flat_map{|t| Provider.new(t)}
        end

        def ids
          @provider.map(&:id)
        end

        def processes
          @provider.map(&:process)
        end

        def to_outputs
          provider = @provider.map(&:to_outputs).join("")
          "- #{self.name} (#{provider})\n"
        end

      end

    end
  end
end