module GrapeLogging
  module Logger
    class Response < GrapeLogging::Logger::Base
      def parameters(request, response)
        {
          response: response.body
        }
      end
    end
  end
end
