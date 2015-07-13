module GrapeLogging
  module Logger
    class Base
      def before
      end

      def parameters(request, response)
        {}
      end
    end
  end
end
