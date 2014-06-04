module Vagrant
  module Tools
    module Orm

      class Config

        attr_accessor :name, :project_root, :offset

        def initialize(config_path)
          @config_path = config_path
          self.project_root = File.absolute_path("#{config_path}/../")
          @machines = Dir["#{@config_path}/machines/*"].flat_map{|t| Machine.new(t)}
          self.name = File.basename(File.absolute_path("#{config_path}/../"))
          self.offset = 0
        end

        def project_root_name
          File.basename(self.project_root).to_sym
        end

        def project_root_name_with_offset
          o = (self.offset > 0) ? "_#{self.offset}" : ""
          "#{self.project_root_name}#{o}"
        end

        def names
          @machines.map(&:name)
        end

        def to_outputs
          machines = @machines.map(&:to_outputs).join("")
          "#{self.project_root_name_with_offset} (#{@project_root})\n#{machines}"
        end

      end

    end
  end
end