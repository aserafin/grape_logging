module Reporters
  class LoggerReporter
    def initialize(logger, formatter)
      @logger = logger || Logger.new(STDOUT)
      if @logger.respond_to?(:formatter=)
        @logger.formatter = formatter || @logger.formatter || GrapeLogging::Formatters::Default.new
      end
    end

    def perform(params)
      @logger.info params
    end
  end
end