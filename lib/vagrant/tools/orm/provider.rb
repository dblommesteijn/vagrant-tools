require 'sys/proctable'

module Vagrant
  module Tools
    module Orm

      class Provider

        attr_accessor :id

        def initialize(provider_path)
          @provider_path = provider_path
          @id_file = "#{@provider_path}/id"
          self.id = File.read(@id_file) if self.valid?
          puts self.id
        end

        def valid?
          File.exists?(@id_file)
        end

        def process
          ret = nil
          Sys::ProcTable.ps do |p|
            ret = p if p.cmdline.include?(self.id)
          end
          ret
        end

        def to_outputs
          @provider_path
        end

      end

    end
  end
end