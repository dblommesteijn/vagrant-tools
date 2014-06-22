module Vagrant
  module Tools

    class Cache

      # attr_accessor :prefix, :verbose, :output, :options, :target, :cmd
      PATH = "#{ENV["HOME"]}/.vagrant-tools"

      def initialize(output, path = PATH)
        @output = output
        @path = path
        @cfg = Vagrant::Tools.get_config
        unless File.exists?(@path)
          @output.append("creating `#{path}`", :verbose)
          FileUtils.mkpath(@path)
        end
        @filename = "#{@path}/settings.json"
        @delta = 0.0
      end

      def get_config
        return {} unless File.exists?(@filename)
        begin
          @output.append("reading cache file: `#{@filename}`", :verbose)
          json = JSON.parse(File.read(@filename), {symbolize_names: true})
          c_time = Time.at(json[:configs_date])
          @output.append("cache time: `#{c_time}`", :verbose)
          @delta = Cache.time_delta(c_time) #if json.include?(:configs_date)
          return json[:configs]
        rescue Exception => e
          @output.append(e.message)
          @output.append(e)
          @output.flush()
          return {}
        end
      end

      def set_config(dirs)
        @output.append("writing to `#{@filename}`", :verbose)
        config_paths = {}
        config_paths[:configs_date] = Time.now.to_i
        config_paths[:configs] = dirs.flat_map{|k,v| v.map(&:config_path)}
        flat_json = JSON.pretty_generate(config_paths)
        @output.append(flat_json, :verbose)
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