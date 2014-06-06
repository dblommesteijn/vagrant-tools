require 'sys/proctable'

module Vagrant
  module Tools
    module Orm

      class Provider

        attr_accessor :id

        def initialize(provider_path)
          @provider_path = provider_path
          @cfg = Vagrant::Tools.get_config
          @id_file = "#{@provider_path}/id"
          self.id = File.read(@id_file) if self.valid?
          @process = nil
          self.process
        end

        def valid?
          File.exists?(@id_file)
        end

        def active?
          !@process.nil?
        end

        def process
          return @process if !@process.nil? || self.id.nil?
          Sys::ProcTable.ps do |p|
            # puts p.cmdline
            # puts self.id
            @process = p if p.cmdline.include?(self.id)
          end
          @process
        end

        def to_outputs
          ret = []
          if self.valid?
            p = self.process
            if !self.active?
              ret << "vmid: #{self.id}" if !@cfg.output[:only_active]
            else
              ret << "pid: #{p.pid}" if @cfg.output[:only_active]
            end
          else
            ret << "never started" if !@cfg.output[:only_active]
          end
          ret.join
        end

      end

    end
  end
end