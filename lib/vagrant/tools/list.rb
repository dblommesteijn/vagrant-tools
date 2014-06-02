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
        ret << @dirs.map{|t| "#{t.to_outputs}\n"}  
        
        # full:
        # if output[:long]
        #  
        # else
        #   ret << @dirs.map{|t| "#{File.basename(File.absolute_path(t+ "/../"))}\n"}
        # end
        ret.join
      end

      def find_vagrant_configs
        return @dirs unless @dirs.empty?
        prefix = Vagrant::Tools.get_config.prefix
        @dirs = []
        Open3.popen3("find \"#{prefix}\" -type d -name \"#{LOOKUP_DIR}\"") do |stdin, stdout, stderr|
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