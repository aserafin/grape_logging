require 'grape/middleware/base'

module GrapeLogging
  module Middleware
    class RequestLogger < Grape::Middleware::Base

      ActiveSupport::Notifications.subscribe('sql.active_record') do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        GrapeLogging::Timings.append_db_runtime(event)
      end if defined?(ActiveRecord)


      def before
        reset_db_runtime
        start_time
      end

      def after
        stop_time
        logger.info parameters
        nil
      end

      def call!(env)
        super
      end

      protected
      def parameters
        {
            path: request.path,
            params: request.params.to_hash,
            method: request.request_method,
            total: total_runtime,
            db: db_runtime,
            view: view_runtime,
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

      def view_runtime
        total_runtime - db_runtime
      end

      def db_runtime
        GrapeLogging::Timings.db_runtime.round(2)
      end

      def reset_db_runtime
        GrapeLogging::Timings.reset_db_runtime
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
