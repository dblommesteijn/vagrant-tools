module Vagrant
  module Tools
    module Orm

      class Config

        attr_accessor :name

        def initialize(config_path)
          @config_path = config_path
          @machines = Dir["#{@config_path}/machines/*"].flat_map{|t| Machine.new(t)}
          self.name = File.basename(File.absolute_path("#{config_path}/../"))
        end

        def names
          @machines.map(&:name)
        end

        def to_outputs
          machines = @machines.map(&:to_outputs).join(" ")
          "#{self.name}:\n#{machines}"
        end

      end

    end
  end
end