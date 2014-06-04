require 'open3'

module Vagrant
  module Tools

    class List

      LOOKUP_DIR = ".vagrant"

      def initialize
        @cfg = Vagrant::Tools.get_config
        @dirs = {}
        self.find_vagrant_configs
      end

      def find_by_project_root(project_root_name)
        self.get_config_without_offset(project_root_name)
      end

      def find_vagrant_configs
        return @dirs unless @dirs.empty?
        prefix = @cfg.prefix
        @dirs = {}
        cmd = "find \"#{prefix}\" -type d -name \"#{LOOKUP_DIR}\""
        puts "Finding vagrant configs: `#{cmd}`... (caching find results? -x)" if @cfg.verbose
        Open3.popen3(cmd) do |stdin, stdout, stderr|
          stdin.close_write
          stdout.read.split("\n").each do |line|
            # create new config instance
            orm_config = Orm::Config.new(line)
            n = orm_config.project_root_name
            @dirs[n] ||= []
            orm_config.offset = @dirs[n].size + 1 if @dirs[n].size > 0
            @dirs[n] << orm_config
          end
          stderr.close_read
        end
        self
      end

      def to_outputs
        ret = []
        if @cfg.target.nil?
          # print all
          ret << @dirs.flat_map{|k,t| t.map(&:to_outputs)}
        else
          ret << self.get_config_without_offset(@cfg.target).to_outputs      
        end
        ret.join
      end

      protected

      def get_config_without_offset(name)

        tmp = name.split("_")
        if tmp.size > 1
          n = tmp.first
          o = tmp.last.to_i - 1
          if @dirs.include?(n)
            return @dirs[n][o]
          end
        # elsif @dirs[n].nil?
          # puts @dirs.inspect
        else
          n = name
          return @dirs[n].first
        end
        nil
      end

    end
  end
end