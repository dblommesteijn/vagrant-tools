require 'open3'

module Vagrant
  module Tools
    module Orm

      class Config

        attr_accessor :name, :project_root, :offset

        def initialize(config_path)
          @cfg = Vagrant::Tools.get_config
          @config_path = config_path
          self.project_root = File.absolute_path("#{config_path}/../")
          @machines = Dir["#{@config_path}/machines/*"].flat_map{|t| Machine.new(t)}
          self.name = File.basename(File.absolute_path("#{config_path}/../"))
          self.offset = 0
        end

        def project_root_name
          File.basename(self.project_root)
        end

        def project_root_name_with_offset
          o = (self.offset > 0) ? "_#{self.offset}" : ""
          "#{self.project_root_name}#{o}"
        end

        def exec_command(cmd)
          res = false
          # NOTE: destroy requires an additonal -f flag (interactive tty otherwise)
          if cmd.include?("destroy")
            Helper.collect_input_yn_exit!("Destroying VM,")
            cmd += " -f"
          end
          cmd = "(cd #{self.project_root} && vagrant #{cmd})"
          puts cmd if @cfg.verbose
          Open3.popen3(cmd) do |stdin, stdout, stderr|
            stdin.close_write
            # read smallest buffer, and flush output buffer (vagrant cmd)
            while (data = stdout.read(1))
              break if data.nil?
              STDOUT.write data
              STDOUT.flush
            end
            stderr.close_read
          end
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