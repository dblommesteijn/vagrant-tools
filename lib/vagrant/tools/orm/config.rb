require 'open3'

module Vagrant
  module Tools
    module Orm

      class Config

        ENV_SHELL = ENV["SHELL"]

        attr_accessor :name, :project_root, :offset, :config_path, :vagrantfile, :parent

        def initialize(cfg, output, parent, config_path)
          @cfg = cfg
          @output = output
          self.parent = parent
          self.config_path = config_path
          self.project_root = File.absolute_path("#{config_path}/../")
          self.vagrantfile = File.absolute_path("#{self.project_root}/Vagrantfile")
          @machines = Dir["#{self.config_path}/machines/*"].flat_map{|t| Machine.new(@cfg, @output, self, t)}
          self.name = File.basename(File.absolute_path("#{config_path}/../"))
          self.offset = 0
          @output.append("found config: `#{self.config_path}`", :verbose)
        end

        def project_root_name
          File.basename(self.project_root)
        end

        def project_root_name_with_offset
          o = (self.offset > 0) ? "_#{self.offset}" : ""
          "#{self.project_root_name}#{o}"
        end

        def exec_vagrant_command(command)
          # TODO: add some cmd check?
          cmd = ""
          case command
          when 'shell'
            raise "no shell found (in $SHELL)" if ENV_SHELL.nil? || ENV_SHELL == ""
            cmd = "(cd #{self.project_root} && #{ENV_SHELL})"
          else
            cmd = "(cd #{self.project_root} && vagrant #{command})"
          end
          @output.append(cmd, :verbose)
          # system call to command
          system(cmd)
        end

        def names
          @machines.map(&:name)
        end

        def vagrantfile_contents
          return nil unless File.exists?(self.vagrantfile)
          File.read(self.vagrantfile)
        end

        def has_active_machines?
          @machines.map(&:has_active_providers?).include?(true)
        end

        def match_target?(target)
          self.project_root_name_with_offset == target
        end

        def pretty_name
          "#{self.project_root_name_with_offset} (#{@project_root})"
        end

        def to_outputs
          machines = @machines.map(&:to_outputs).join("")
          if !@cfg.output[:only_active]
            "#{self.project_root_name_with_offset} (#{@project_root})\n#{machines}"
          else
            if !machines.empty?
              "#{self.project_root_name_with_offset} (#{@project_root})\n#{machines}"
            end
          end
        end

        def visit(&block)
          block.call(self)
          @machines.each do |machine|
            machine.visit(&block)
          end
        end

        protected

      end

    end
  end
end