module GrapeLogging
  module Formatters
    class Default
      def call(severity, datetime, _, data)
        "[#{datetime}] #{severity} -- #{data.delete(:status)} -- total=#{data.delete(:total)} db=#{data.delete(:db)} -- #{data.delete(:method)} #{data.delete(:path)} #{format(data)}\n"
      end

      def format(data)
        if data.is_a?(String)
          data
        elsif data.is_a?(Exception)
          [data.to_s, data.backtrace].flatten.join('\n')
        elsif data.is_a?(Hash)
          data.keys.sort.map { |key| "#{key}=#{data[key]}" }.join(' ')
        else
          data.inspect
        end
      end
    end
  end
end