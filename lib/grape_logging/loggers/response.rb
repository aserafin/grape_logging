module GrapeLogging
  module Loggers
    class Response < GrapeLogging::Loggers::Base
      def parameters(request, response)
        {
          response: JSON.parse(response.body.first)
        }
      end
    end
  end
end
