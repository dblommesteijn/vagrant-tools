require File.expand_path(File.dirname(__FILE__) + "/tools/config")
require File.expand_path(File.dirname(__FILE__) + "/tools/cache")
require File.expand_path(File.dirname(__FILE__) + "/tools/root")
require File.expand_path(File.dirname(__FILE__) + "/tools/version")
require File.expand_path(File.dirname(__FILE__) + "/tools/orm/config")
require File.expand_path(File.dirname(__FILE__) + "/tools/orm/machine")
require File.expand_path(File.dirname(__FILE__) + "/tools/orm/provider")


module Vagrant
  module Tools

    @@config = ::Vagrant::Tools::Config.new

    class << self

      def config(&block)
        block.call(@@config)
        @@config
      end

      def get_config
        @@config.dup
      end

    end

  end
end
