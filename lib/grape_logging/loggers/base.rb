module GrapeLogging
  module Loggers
    class Base
      def parameters(request, _status, _response_body)
        {}
      end
    end
  end
end
