module GrapeLogging
  module Loggers
    class Response < GrapeLogging::Loggers::Base
      def parameters(_, response)
        response ? { response: serialized_response_body(response) } : {}
      end

      private

      # In some cases, response.body is not parseable by JSON.
      # For example, if you POST on a PUT endpoint, response.body is equal to """".
      # It's strange but it's the Grape behavior...
      def serialized_response_body(response)

        if response.respond_to?(:body)
          # Rack responses
          begin
            response.body.map { |body| JSON.parse(body.to_s) }
          rescue
            response.body
          end
        else
          # Error & Exception responses
          response
        end
      end
    end
  end
end
