require 'open3'

module Vagrant
  module Tools
    module Orm

      class Config

        ENV_SHELL = ENV["SHELL"]

        attr_accessor :name, :project_root, :offset, :config_path, :vagrantfile, :parent, :hidden

        def initialize(cfg, output, parent, config_path)
          @cfg = cfg
          @output = output
          self.parent = parent
          self.config_path = config_path
          self.hidden = self.hidden_path?(config_path)
          self.project_root = File.absolute_path("#{config_path}/../")
          self.vagrantfile = File.absolute_path("#{self.project_root}/Vagrantfile")
          machine_paths = self.get_machine_paths()
          @output.append("machine dirs found: #{machine_paths.size}", :verbose)
          # lookup if machines path is created (else run vagrant status)
          machine_paths = []
          if !self.hidden && @cfg.refresh_cache
            @output.append("reloading machine paths `vagrant status`", :verbose)
            # create machines path
            self.exec_vagrant_command("status", :silent)
            machine_paths = self.get_machine_paths()
          end
          @machines = machine_paths.flat_map{|t| Machine.new(@cfg, @output, self, t)}
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

        def exec_vagrant_command(command, options=[])
          options = [options] unless options.is_a?(Array)
          silent = options.include?(:silent) ? " > /dev/null" : ""
          # TODO: add some cmd check?
          cmd = ""
          case command
          when 'shell'
            raise "no shell found (in $SHELL)" if ENV_SHELL.nil? || ENV_SHELL == ""
            cmd = "(cd #{self.project_root} && #{ENV_SHELL})"
          else
            cmd = "(cd #{self.project_root} && vagrant #{command}#{silent})"
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

        def hidden_path?(config_path)
          @output.append("check hidden path? `#{config_path}`", :verbose)
          @output.flush()
          !config_path.match(/\/\.[\w]+/).nil?
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

        def get_machine_paths()
          #TODO: get from config
          Dir["#{self.config_path}/machines/*"]
        end

      end

    end
  end
end