module Vagrant
  module Tools

    class Cache

      # attr_accessor :prefix, :verbose, :output, :options, :target, :cmd
      PATH = "#{ENV["HOME"]}/.vagrant-tools"

      def initialize(path = PATH)
        @path = path
        @cfg = Vagrant::Tools.get_config
        unless File.exists?(@path)
          puts "Creating `#{path}`" if @cfg.verbose
          FileUtils.mkpath(@path)
        end
        @filename = "#{@path}/settings.json"
        @delta = 0.0
      end

      def get_config
        return {} unless File.exists?(@filename)
        #TODO: read from file
        begin
          puts "Reading cache file: `#{@filename}`" if @cfg.verbose
          json = JSON.parse(File.read(@filename), {symbolize_names: true})
          c_time = Time.at(json[:configs_date])
          puts "Cache time: `#{c_time}`" if @cfg.verbose
          @delta = Cache.time_delta(c_time) #if json.include?(:configs_date)
          return json[:configs]
        rescue Exception => e
          puts e.message
          puts e
          return {}
        end
      end

      def set_config(dirs)
        puts "Writing to `#{@filename}`" if @cfg.verbose
        config_paths = { configs_date: Time.now.to_i, configs: dirs.flat_map{|k,v| v.map(&:config_path)} }
        flat_json = JSON.pretty_generate(config_paths)
        puts flat_json if @cfg.verbose
        File.open(@filename,"w") do |f|
          f.write(flat_json)
        end
      end

      def cache_old?
        @delta > 864000.0
      end

      def cache_time_a
        mm, ss = @delta.divmod(60) 
        hh, mm = mm.divmod(60) 
        dd, hh = hh.divmod(24)
        [dd, hh, mm, ss]
      end

      protected

      class << self
        def time_delta(time)
          now = Time.now
          Time.now - time
        end
      end
    end

  end
end