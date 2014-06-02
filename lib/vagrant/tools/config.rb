module Vagrant
  module Tools

    class Config

      attr_accessor :prefix, :verbose, :output, :options

      def initialize
        @errors = {}
        self.prefix = ENV["HOME"]
        self.verbose = false
        self.output = {machine: false, long: false}
      end

      def verify?
        @errors[:prefix] = "file does not exist" unless File.exists?(self.prefix)
        @errors.empty?
      end

      def error_messages
        @errors.map{|k,v| "Error `#{k}`: #{v}"}
      end

    end

  end
end