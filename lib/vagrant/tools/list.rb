require 'open3'
require 'sys/proctable'

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
        # full:
        if output[:long]
          ret << @dirs.map{|t| "#{t}\n"}
        else
          ret << @dirs.map{|t| "#{File.basename(File.absolute_path(t+ "/../"))}\n"}
        end
        ret.join
      end

      def find_vagrant_dirs
        return @dirs unless @dirs.empty?
        prefix = Vagrant::Tools.get_config.prefix
        @dirs = []
        Open3.popen3("find \"#{prefix}\" -type d -name \"#{LOOKUP_DIR}\"") do |stdin, stdout, stderr|
          stdin.close_write
          stdout.read.split("\n").each {|line| @dirs << line}
          stderr.close_read
        end
        self
      end

    end
  end
end