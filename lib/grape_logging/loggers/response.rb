module GrapeLogging
  module Loggers
    class Response < GrapeLogging::Loggers::Base
      def parameters(request, response)
        {
          response: response.body.map{ |body| JSON.parse(body) }
        }
      end
    end
  end
end
