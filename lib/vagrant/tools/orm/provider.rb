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
          @process = nil
        end

        def valid?
          File.exists?(@id_file)
        end

        def process
          return @process unless @process.nil?
          Sys::ProcTable.ps do |p|
            @process = p if p.cmdline.include?(self.id)
          end
          @process
        end

        def to_outputs
          ret = []
          if self.valid?
            p = self.process
            if p.nil?
              ret << "vmid: #{self.id}"
            else
              ret << "pid: #{p.pid}"
            end
          else
            ret << "never started"
          end
          ret.join
        end

      end

    end
  end
end