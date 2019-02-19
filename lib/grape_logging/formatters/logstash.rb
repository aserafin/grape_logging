module GrapeLogging
  module Formatters
    class Logstash
      def call(severity, datetime, _, data)
        {
          :'@timestamp' => datetime.iso8601,
          :'@version' => '1',
          :severity => severity
        }.merge!(format(data)).to_json + "\n"
      end

      private

      def format(data)
        if data.is_a?(Hash)
          data
        elsif data.is_a?(String)
          { message: data }
        elsif data.is_a?(Exception)
          format_exception(data)
        else
          { message: data.inspect }
        end
      end

      def format_exception(exception)
        {
          exception: {
            message: exception.message
          }
        }
      end
    end
  end
end
