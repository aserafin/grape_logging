require 'grape/middleware/base'

module GrapeLogging
  module Middleware
    class RequestLogger < Grape::Middleware::Base
      def before
        @env[:db_duration] = 0

        ActiveSupport::Notifications.subscribe('sql.active_record') do |*args|
          event = ActiveSupport::Notifications::Event.new(*args)
          @env[:db_duration] += event.duration
        end if defined?(ActiveRecord)
      end

      def call!(env)
        original_response = nil
        duration = Benchmark.realtime { original_response = super(env) }

        @app.logger.info parameters(::Rack::Request.new(env), original_response, duration)
        original_response
      end

      protected
        def parameters(request, response, duration)
          {
              path: request.path,
              params: request.params,
              method: request.request_method,
              total: (duration * 1000).round(2),
              db: request.env[:db_duration].round(2),
              status: response.first
          }
        end
    end
  end
end