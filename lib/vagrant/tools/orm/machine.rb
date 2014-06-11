module Vagrant
  module Tools
    module Orm

      class Machine

        attr_accessor :name, :parent

        def initialize(cfg, output, parent, machine_path)
          @cfg = cfg
          @output = output
          self.parent = parent
          @machine_path = machine_path
          self.name = File.basename(machine_path)
          @provider = Dir["#{@machine_path}/*"].flat_map{|t| Provider.new(@cfg, @output, parent, t)}
        end

        def ids
          @provider.map(&:id)
        end

        def processes
          @provider.map(&:process)
        end

        def has_active_providers?
          @provider.map(&:active?).include?(true)
        end

        def visit(&block)
          block.call(self)
          @provider.each do |provider|
            provider.visit(&block)
          end
        end

      end

    end
  end
end