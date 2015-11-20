require 'thread'
require 'logger'

module GrapeLogging
  module Middleware
    class RequestLogger

      def initialize(app, options = {})
        @app = app
        @logger = options[:logger] || Logger.new(STDOUT)

        subscribe_to_active_record if defined? ActiveRecord
      end

      def call(env)
        request = ::Rack::Request.new(env)

        init_db_runtime

        start_time = Time.now

        response = @app.call(env)

        stop_time = Time.now

        total_runtime = calculate_runtime(start_time, stop_time)

        log(request, response, total_runtime)

        clear_db_runtime

        response
      end

      protected

      def subscribe_to_active_record
        ActiveSupport::Notifications.subscribe('sql.active_record') do |*args|
          event = ActiveSupport::Notifications::Event.new(*args)
          increase_db_runtime(event.duration)
        end
      end

      def log(request, response, total_runtime)
        @logger.info(
          path: request.path,
          params: request.params.to_hash,
          method: request.request_method,
          total: format_runtime(total_runtime),
          db: format_runtime(db_runtime),
          status: response.is_a?(Rack::Response) ? response.status : response[0]
        )
      end

      def calculate_runtime(start_time, stop_time)
        (stop_time - start_time) * 1000
      end

      def format_runtime(time)
        time.round(2)
      end

      def init_db_runtime
        Thread.current[:db_runtime] = 0
      end

      def clear_db_runtime
        Thread.current[:db_runtime] = nil
      end

      def increase_db_runtime(time)
        Thread.current[:db_runtime] += time
      end

      def db_runtime
        Thread.current[:db_runtime]
      end
    end

  end
end
