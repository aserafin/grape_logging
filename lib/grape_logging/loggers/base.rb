module GrapeLogging
  module Loggers
    class Base
      def before
      end

      def parameters(request, response)
        {}
      end

      def ensure
      end
    end
  end
end
