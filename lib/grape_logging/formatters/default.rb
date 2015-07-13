module GrapeLogging
  module Formatters
    class Default
      def call(severity, datetime, _, data)
        "[#{datetime}] #{severity} -- #{format(data)}\n"
      end

      def format(data)
        if data.is_a?(String)
          data
        elsif data.is_a?(Exception)
          format_exception(data)
        elsif data.is_a?(Hash)
          "#{data.delete(:status)} -- #{format_hash(data.delete(:time))} -- #{data.delete(:method)} #{data.delete(:path)} #{format_hash(data)}"
        else
          data.inspect
        end
      end

      private
      def format_hash(hash)
        hash.keys.sort.map { |key| "#{key}=#{hash[key]}" }.join(' ')
      end

      def format_exception(exception)
        backtrace_array = (exception.backtrace || []).map { |line| "\t#{line}" }
        "#{exception.message}\n#{backtrace_array.join("\n")}"
      end
    end
  end
end
