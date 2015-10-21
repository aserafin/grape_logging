module GrapeLogging
  module Loggers
    class DatabaseTime < GrapeLogging::Loggers::Base
      def before
        @duration = 0
        ActiveSupport::Notifications.subscribe('sql.active_record') do |*args|
          event = ActiveSupport::Notifications::Event.new(*args)
          @duration += event.duration
        end
      end

      def parameters(request, response)
        {
          time: {
            db: @duration.round(2)
          }
        }
      end
    end
  end
end
