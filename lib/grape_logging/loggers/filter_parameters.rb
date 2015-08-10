module GrapeLogging
  module Loggers
    class FilterParameters < GrapeLogging::Loggers::Base
      def initialize(filter_parameters = nil, replacement = '[FILTERED]')
        @filter_parameters = filter_parameters || (defined?(Rails.application) ? Rails.application.config.filter_parameters : [])
        @replacement = replacement
      end

      def parameters(request, response)
        filtered_parameters = request.params.clone
        @filter_parameters.each do |param|
          if filtered_parameters[param.to_s]
            filtered_parameters[param.to_s] = @replacement
          end
        end

        {
          params: filtered_parameters
        }
      end
    end
  end
end
