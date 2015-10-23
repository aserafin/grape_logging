module GrapeLogging
  module Loggers
    class Response < GrapeLogging::Loggers::Base
      def parameters(request, response)
        {
          response: response.body
        }
      end
    end
  end
end
