module Vagrant
  module Tools

    class Output

      def initialize(config)
        @cfg = config
        @buffer = []
      end

      def render()
        @buffer.each do |buffer|
          if (!buffer.last.include?(:verbose) || @cfg.verbose)
            STDOUT.write(buffer.first)
            STDOUT.write("\n") if !buffer.last.include?(:nonewline)
            STDOUT.flush
          end
        end
      end

      def append(node, options=[])
        options = [options] unless options.is_a?(Array)
        if node.is_a?(Vagrant::Tools::Orm::Config)
          @buffer << [node.pretty_name, options]
        elsif node.is_a?(String)
          @buffer << [node, options]
        end
      end

    end
  end
end