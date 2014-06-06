module Vagrant
  module Tools

    class Config

      attr_accessor :prefix, :verbose, :output, :options, :target, :cmd, :refresh_cache

      def initialize
        @errors = {}
        self.prefix = ENV["HOME"]
        self.verbose = false
        self.output = {machine: false, long: false, only_active: false}
        self.target = nil
        self.cmd = nil
      end

      def verify?(&block)
        # general checks
        @errors[:prefix] = "file does not exist" unless File.exists?(self.prefix)
        unless self.cmd.nil?
          if self.cmd.start_with?("vagrant")
            @errors[:cmd] = "all commands are prepended with `vagrant`"
          end
        end
        # file specific checks
        block.call(@errors)
        # @errors[:target] = "unknown target" if self.target.present? && 
        @errors.empty?
      end

      def error_messages
        @errors.map{|k,v| "Error `#{k}`: #{v}"}
      end

    end

  end
end