module GrapeLogging
  module Loggers
    class Base
      def before
      end

      def parameters(request, response)
        {}
      end
    end
  end
end
