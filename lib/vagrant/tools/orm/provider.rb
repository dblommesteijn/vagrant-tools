require 'sys/proctable'

module Vagrant
  module Tools
    module Orm

      class Provider

        attr_accessor :id, :parent

        def initialize(cfg, output, parent, provider_path)
          @cfg = cfg
          @output = output
          self.parent = parent
          @provider_path = provider_path
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
        # alias_method :has_active?, :active?

        def process
          return @process if !@process.nil? || self.id.nil?
          Helper.iterate_processes do |p|
            next if p.cmdline.nil?
            @process = p if p.cmdline.include?(self.id)
          end
          @process
        end

        def status_s
          ret = []
          if self.valid?
            p = self.process
            if !self.active?
              ret << "vmid: #{self.id}"
            else
              ret << "pid: #{p.pid}"
            end
          else
            ret << "never started"
          end
          ret.join
        end

        def visit(&block)
          block.call(self)
        end

      end

    end
  end
end