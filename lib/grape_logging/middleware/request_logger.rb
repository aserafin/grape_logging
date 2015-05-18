require 'grape/middleware/base'

module GrapeLogging
  module Middleware
    class RequestLogger < Grape::Middleware::Base
      def before
        start_time

        @db_duration = 0
        ActiveSupport::Notifications.subscribe('sql.active_record') do |*args|
          event = ActiveSupport::Notifications::Event.new(*args)
          @db_duration += event.duration
        end if defined?(ActiveRecord)
      end

      def after
        stop_time
        logger.info parameters(request, response)
        nil
      end

      protected
      def parameters(request, response)
        {
            path: request.path,
            params: request.params.to_hash,
            method: request.request_method,
            total: total_runtime,
            db: @db_duration.round(2),
            status: response.status
        }
      end

      private
      def logger
        @logger ||= @options[:logger] || Logger.new(STDOUT)
      end

      def request
        @request ||= ::Rack::Request.new(env)
      end

      def total_runtime
        ((stop_time - start_time) * 1000).round(2)
      end

      def start_time
        @start_time ||= Time.now
      end

      def stop_time
        @stop_time ||= Time.now
      end
    end
  end
end