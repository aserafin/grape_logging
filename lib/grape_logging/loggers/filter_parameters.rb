module GrapeLogging
  module Loggers
    class FilterParameters < GrapeLogging::Loggers::Base
      AD_PARAMS = 'action_dispatch.request.parameters'.freeze

      def initialize(filter_parameters = nil, replacement = nil, exceptions = %w(controller action format))
        @filter_parameters = filter_parameters || (defined?(::Rails.application) ? ::Rails.application.config.filter_parameters : [])
        @replacement = replacement || '[FILTERED]'
        @exceptions = exceptions
      end

      def parameters(request, _)
        { params: safe_parameters(request) }
      end

      private

      def parameter_filter
        @parameter_filter ||= ParameterFilter.new(@replacement, @filter_parameters)
      end

      def safe_parameters(request)
        # Now this logger can work also over Rails requests
        if request.params.empty?
          clean_parameters(request.env[AD_PARAMS] || {})
        else
          clean_parameters(request.params)
        end
      end

      def clean_parameters(parameters)
        parameter_filter.filter(parameters).reject{ |key, _value| @exceptions.include?(key) }
      end
    end
  end
end
