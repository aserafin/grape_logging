module GrapeLogging
  module Formatters
    class Lograge
      def call(severity, datetime, _, data)
        time = data.delete :time
        attributes = {
          severity: severity,
          duration: time[:total],
          db: time[:db],
          view: time[:view],
          datetime: datetime.iso8601
        }.merge(data)
        ::Lograge.formatter.call(attributes) + "\n"
      end
    end
  end
end
