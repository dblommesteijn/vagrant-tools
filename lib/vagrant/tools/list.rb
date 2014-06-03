require 'open3'

module Vagrant
  module Tools

    class List

      LOOKUP_DIR = ".vagrant"

      def initialize
        @dirs = []
      end

      def to_outputs
        output = Vagrant::Tools.get_config.output
        ret = []
        ret << @dirs.map{|t| "#{t.to_outputs}"}
        ret.join
      end

      def find_vagrant_configs
        return @dirs unless @dirs.empty?
        cfg = Vagrant::Tools.get_config
        prefix = cfg.prefix
        @dirs = []
        cmd = "find \"#{prefix}\" -type d -name \"#{LOOKUP_DIR}\""
        puts cmd if cfg.verbose
        Open3.popen3(cmd) do |stdin, stdout, stderr|
          stdin.close_write
          stdout.read.split("\n").each do |line|
            @dirs << Orm::Config.new(line)
          end
          stderr.close_read
        end
        self
      end

    end
  end
end