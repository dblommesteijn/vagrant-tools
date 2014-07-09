require 'open3'
require 'json'

module Vagrant
  module Tools

    class Root

      attr_accessor :cache

      LOOKUP_DIR = "Vagrantfile"

      def initialize(cfg, output)
        @cfg = cfg
        @output = output
        @dirs = {}
        self.cache = Cache.new(@output)
        self.find_vagrant_configs
      end

      def find_vagrant_configs
        unless @dirs.empty?
          @output.append("config already loaded (use -x to force reload)", :verbose)
          return @dirs
        end
        prefix = @cfg.prefix
        cache_configs = self.cache.get_config
        # break if config found (unless refreshing)
        if !cache_configs.empty? && !@cfg.refresh_cache
          @output.append("reading config from cache", :verbose)
          cache_configs.each do |config|
            # create new config instance
            self.add_config_dirs(config)
          end
          return self
        end
        self.find_configs(prefix)
        self
      end

      def visit(&block)
        configs = @dirs.flat_map{|k,t| t}
        block.call(self)
        configs.each do |config|
          config.visit(&block)
        end
      end

      def to_s
        "root"
      end

      def has_active?
        false
      end

      def match_target?(target)
        false
      end

      protected

      def add_config_dirs(config)
        orm_config = Orm::Config.new(@cfg, @output, self, config)
        n = orm_config.project_root_name
        @dirs[n] ||= []
        orm_config.offset = @dirs[n].size + 1 if @dirs[n].size > 0
        @dirs[n] << orm_config
        nil
      end

      def find_configs(prefix)
        # findin configs via find
        cmd = "find \"#{prefix}\" -type f -name \"#{LOOKUP_DIR}\""
        @output.append("finding vagrant configs: `#{cmd}`...", :verbose)
        @output.flush()
        Open3.popen3(cmd) do |stdin, stdout, stderr|
          stdin.close_write
          stdout.read.split("\n").each do |config_file|
            # create new config instance
            self.add_config_dirs(config_file)
          end
          stderr.close_read
        end
        self.cache.set_config(@dirs)
      end

    end
  end
end