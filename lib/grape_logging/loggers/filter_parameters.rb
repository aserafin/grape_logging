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
        original_encoding_map = build_encoding_map(parameters)
        params = transform_key_encoding(parameters, Hash.new { |h, _| [Encoding::ASCII_8BIT, h] })
        cleaned_params = parameter_filter.filter(params).reject { |key, _value| @exceptions.include?(key) }
        transform_key_encoding(cleaned_params, original_encoding_map)
      end

      def build_encoding_map(parameters)
        parameters.each_with_object({}) do |(k, v), h|
          h[k.dup.force_encoding(Encoding::ASCII_8BIT)] = [k.encoding, v.is_a?(Hash) ? build_encoding_map(v) : nil]
        end
      end

      def transform_key_encoding(parameters, encoding_map)
        parameters.each_with_object({}) do |(k, v), h|
          encoding, children_encoding_map = encoding_map[k]
          h[k.dup.force_encoding(encoding)] = v.is_a?(Hash) ? transform_key_encoding(v, children_encoding_map) : v
        end
      end
    end
  end
end
