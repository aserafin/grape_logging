module GrapeLogging
  module Loggers
    class FilterParameters < GrapeLogging::Loggers::Base
      def initialize(filter_parameters = nil, replacement = '[FILTERED]')
        @filter_parameters = filter_parameters || (defined?(Rails.application) ? Rails.application.config.filter_parameters : [])
        @replacement = replacement
      end

      def parameters(request, _)
        { params: replace_parameters(request.params.clone) }
      end

      private
      def replace_parameters(parameters)
        @filter_parameters.each do |parameter_name|
          if parameters.key?(parameter_name.to_s)
            parameters[parameter_name.to_s] = @replacement
          end
        end
        parameters
      end
    end
  end
end
