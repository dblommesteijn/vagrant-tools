require 'open3'
require 'json'

module Vagrant
  module Tools

    class Root

      attr_accessor :cache

      LOOKUP_DIR = ".vagrant"

      def initialize
        @cfg = Vagrant::Tools.get_config
        @dirs = {}
        self.cache = Cache.new
        self.find_vagrant_configs
      end

      def find_by_project_root(project_root_name)
        self.get_config_without_offset(project_root_name)
      end

      def find_vagrant_configs
        unless @dirs.empty?
          puts "Config already loaded (use -x to force reload)" if @cfg.verbose
          return @dirs
        end
        prefix = @cfg.prefix
        cache_configs = self.cache.get_config
        # break if config found (unless refreshing)
        if !cache_configs.empty? && !@cfg.refresh_cache
          puts "Reading config from cache" if @cfg.verbose
          cache_configs.each do |config|
            # create new config instance
            self.add_config_dirs(config)
          end
          return self 
        end
        # findin configs via find
        cmd = "find \"#{prefix}\" -type d -name \"#{LOOKUP_DIR}\""
        puts "Finding vagrant configs: `#{cmd}`..." if @cfg.verbose
        Open3.popen3(cmd) do |stdin, stdout, stderr|
          stdin.close_write
          stdout.read.split("\n").each do |config|
            # create new config instance
            self.add_config_dirs(config)
          end
          stderr.close_read
        end
        self.cache.set_config(@dirs)
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

      def add_config_dirs(config)
        orm_config = Orm::Config.new(config)
        n = orm_config.project_root_name
        @dirs[n] ||= []
        orm_config.offset = @dirs[n].size + 1 if @dirs[n].size > 0
        @dirs[n] << orm_config
        nil
      end

      def get_config_without_offset(name)
        tmp = name.split("_")
        if tmp.size > 1
          n = tmp.first
          o = tmp.last.to_i - 1
          if @dirs.include?(n)
            return @dirs[n][o]
          end
        else
          n = name
          return @dirs[n].first
        end
        nil
      end

    end
  end
end