require 'open3'
require 'json'

module Vagrant
  module Tools

    class Root

      attr_accessor :cache

      LOOKUP_DIR = ".vagrant"

      def initialize(cfg, output)
        @cfg = cfg
        @output = output
        @dirs = {}
        self.cache = Cache.new
        self.find_vagrant_configs
      end

      # def find_by_project_root(project_root_name)
      #   self.get_config_without_offset(project_root_name)
      # end

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
        # findin configs via find
        cmd = "find \"#{prefix}\" -type d -name \"#{LOOKUP_DIR}\""
        @output.append("finding vagrant configs: `#{cmd}`...", :verbose)
        Open3.popen3(cmd) do |stdin, stdout, stderr|
          stdin.close_write
          stdout.read.split("\n").each do |config_file|
            # create new config instance
            self.add_config_dirs(config_file)
          end
          stderr.close_read
        end
        self.cache.set_config(@dirs)
        self
      end

      # def to_outputs
      #   ret = []
      #   if @cfg.target.nil?
      #     # print all
      #     ret << @dirs.flat_map{|k,t| t.map(&:to_outputs)}
      #   else
      #     ret << self.get_config_without_offset(@cfg.target).to_outputs      
      #   end
      #   ret.join
      # end

    #     if @cfg.target.nil?
    #       configs = @dirs.flat_map{|k,t| t}
    #     else
    #       configs = [self.get_config_without_offset(@cfg.target)]
    #     end

    #         # filter `target`
    # elsif !cfg.target.nil?
    #   if node.is_a?(Vagrant::Tools::Orm::Root)
    #     nodes << node
    #   end

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

    end
  end
end