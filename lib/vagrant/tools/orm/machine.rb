module Vagrant
  module Tools
    module Orm

      class Machine

        def initialize(machine_path)
          @machine_path = machine_path
        end

        def to_outputs
          @machine_path
        end

      end

    end
  end
end