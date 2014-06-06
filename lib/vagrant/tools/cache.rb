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
      end

      def get_config
        return {} unless File.exists?(@filename)
        #TODO: read from file
        begin
          json = JSON.parse(File.read(@filename), {symbolize_names: true})
          json[:configs]
        rescue
          return {}
        end
      end

      def set_config(dirs)
        puts "Writing to `#{@filename}`" if @cfg.verbose
        config_paths = { configs: dirs.flat_map{|k,v| v.map(&:config_path)} }
        flat_json = JSON.pretty_generate(config_paths)
        puts flat_json if @cfg.verbose
        File.open(@filename,"w") do |f|
          f.write(flat_json)
        end
      end

    end

  end
end