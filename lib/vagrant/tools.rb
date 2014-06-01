require File.expand_path(File.dirname(__FILE__) + "/tools/version")
require 'open3'
require 'sys/proctable'

module Vagrant
  module Tools
    
    LOOKUP_DIR = ".vagrant"
    FIND_PREFIX = ENV["HOME"]

    class << self
      
      def find_dirs(prefix = FIND_PREFIX)
        dirs = []
        Open3.popen3("find /Users/pinguin/Programming -type d -name \"#{LOOKUP_DIR}\"") do |stdin, stdout, stderr|
          # stdin.write("hello from parent")
          stdin.close_write
          stdout.read.split("\n").each do |line|
            dirs << line
          end
          stderr.close_read
        end
        dirs
      end

      def list_machines()
        # get all vagrant dirs
        dirs = Tools.find_dirs
        # locate machines
        machines = dirs.flat_map{|t| Dir["#{t}/machines/*"]}
        # iterate providers
        providers = machines.flat_map{|t| Dir["#{t}/*"]}
        # collect file containing id
        id_files = providers.map{|p| "#{p}/id"}
        # read id from file
        provision_ids = id_files.map{|f| File.read(f)}
        # lookup active pids by id
        pid_ids = provision_ids.map{|t| lookup_provider_by_id(t)}
      end

      def lookup_provider_by_id(id)
        Sys::ProcTable.ps do |p|
          puts p.pid if p.cmdline.include?(id)
        end
      end


      # TODO: list all instances
      # add controls for instances


    end

  end
end
