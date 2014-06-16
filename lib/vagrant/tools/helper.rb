module Vagrant
  module Tools
    class Helper
      class << self
        def iterate_processes(&block)
          Sys::ProcTable.ps(&block)
        end

        def get_running_vms
          vms = []
          Helper.iterate_processes do |p|
            if p.cmdline.include?("VBoxHeadless")
              vms << p
            #elsif... add other providers
            end
          end
          # remove all non-vagrant boxes
          # vms.reject{|vm| vm.cmdline.match(/--startvm ([0-9a-f\-]+)/).size <= 0}#.map{|t| {t.pid => t}}

          ret = {}
          vms.each do |vm|
            tmp = vm.cmdline.match(/--startvm ([0-9a-f\-]+)/)
            next if tmp.size <= 0
            ret[vm.pid] = vm
          end
          ret
        end
      end
    end
  end
end