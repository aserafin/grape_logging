module GrapeLogging
  module Loggers
    class Response < GrapeLogging::Loggers::Base
      def parameters(request, response)
        {
          response: response.body.to_s
        }
      end
    end
  end
end
