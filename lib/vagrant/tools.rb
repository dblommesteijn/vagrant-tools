require File.expand_path(File.dirname(__FILE__) + "/tools/config")
require File.expand_path(File.dirname(__FILE__) + "/tools/list")
require File.expand_path(File.dirname(__FILE__) + "/tools/version")
require File.expand_path(File.dirname(__FILE__) + "/tools/orm/config")
require File.expand_path(File.dirname(__FILE__) + "/tools/orm/machine")


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
      
      

      # def list_machines()
      #   # get all vagrant dirs
      #   dirs = Tools.find_dirs
      #   # locate machines
      #   machines = dirs.flat_map{|t| Dir["#{t}/machines/*"]}
      #   # iterate providers
      #   providers = machines.flat_map{|t| Dir["#{t}/*"]}
      #   # collect file containing id
      #   id_files = providers.map{|p| "#{p}/id"}
      #   # read id from file
      #   provision_ids = id_files.map{|f| File.read(f)}
      #   # lookup active pids by id
      #   pid_ids = provision_ids.map{|t| lookup_provider_by_id(t)}
      #   return pid_ids
      # end

      # def lookup_provider_by_id(id)
      #   Sys::ProcTable.ps do |p|
      #     puts p.pid if p.cmdline.include?(id)
      #   end
      # end


      # TODO: list all instances
      # add controls for instances


    end

  end
end
