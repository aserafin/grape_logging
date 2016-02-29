require 'grape/middleware/base'

module GrapeLogging
  module Middleware
    class RequestLogger < Grape::Middleware::Base
      def before
        start_time

        @db_duration = 0
        @subscription = ActiveSupport::Notifications.subscribe('sql.active_record') do |*args|
          event = ActiveSupport::Notifications::Event.new(*args)
          @db_duration += event.duration
        end if defined?(ActiveRecord)
      end

      def after
        stop_time
        logger.info parameters
        nil
      end

      def call!(env)
        super
      ensure
        ActiveSupport::Notifications.unsubscribe(@subscription) if @subscription
      end

      protected
      def parameters
        {
            path: request.path,
            params: obfuscate_parameters(request.params),
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

      def obfuscate_parameters(request_parameters)
        filtered_parameters = request_parameters.clone.to_hash
        sensitive_parameters.each do |param|
          filtered_parameters[param.to_s] = '***'
        end
        filtered_parameters
      end

      def sensitive_parameters
        defined?(Rails.application) ? Rails.application.config.filter_parameters : []
      end
    end
  end
end