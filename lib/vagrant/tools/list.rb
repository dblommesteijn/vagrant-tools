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
        puts "find_by_project_root: #{project_root_name}" if @cfg.verbose
        if @dirs.include?(project_root_name)
          cs = @dirs[project_root_name]
          puts cs.inspect if @cfg.verbose
          raise "multiple configs found" if cs.size > 1
        end
      end

      def to_outputs
        output = @cfg.output
        ret = []
        if @cfg.target.nil?
          # print all
          ret << @dirs.flat_map{|k,t| t.map(&:to_outputs)}
        else
          # print only selected target
          tmp = @cfg.target.split("_")
          if tmp.size > 1
            n = tmp.first.to_sym
            o = (tmp.last.to_i - 1)
            if @dirs.include?(n)
              ret << @dirs[n][o].to_outputs
            end
          else
            n = @cfg.target.to_sym
            ret << @dirs[n].map(&:to_outputs).first
          end          
        end
        ret.join
      end

      def find_vagrant_configs
        return @dirs unless @dirs.empty?
        prefix = @cfg.prefix
        @dirs = {}
        cmd = "find \"#{prefix}\" -type d -name \"#{LOOKUP_DIR}\""
        puts cmd if @cfg.verbose
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

    end
  end
end