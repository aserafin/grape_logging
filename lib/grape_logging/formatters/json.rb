module GrapeLogging
  module Formatters
    class Json
      def call(severity, datetime, _, data)
        {
          date: datetime,
          severity: severity,
          data: format(data)
        }.to_json
      end

      private

      def format(data)
        if data.is_a?(String) || data.is_a?(Hash)
          data
        elsif data.is_a?(Exception)
          format_exception(data)
        else
          data.inspect
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
