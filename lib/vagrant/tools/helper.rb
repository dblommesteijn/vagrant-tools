module Vagrant
  module Tools

    class Helper

      # attr_accessor :prefix, :verbose, :output, :options, :target, :cmd

      # def initialize
      # end

      class << self

        # collecting user input, continue if input == y else exit
        def collect_input_yn_exit!(action)
          STDOUT.write "#{action} are you sure [y/N]? "
          STDOUT.flush
          a = gets
          case a.downcase
          when "y\n"
            return true
          else
            exit
          end
        end

      end

    end
  end
end