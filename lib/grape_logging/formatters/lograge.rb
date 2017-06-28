module GrapeLogging
  module Formatters
    class Lograge
      def call(severity, datetime, _, data)
        time = data[:time]
        attributes = {
          severity: severity,
          duration: time[:total],
          db: time[:db],
          view: time[:view],
          headers: data[:headers].except('Host', 'Authorization'),
          params: data[:params],
          path: data[:path],
          method: data[:method],
          host: data[:host],
          status: data[:status],
          ip: data[:ip],
          ua: %("#{data[:ua]}"),
        }
        ::Lograge.formatter.call(attributes) + "\n"
      end
    end
  end
end
