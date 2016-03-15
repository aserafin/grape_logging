module Reporters
  class LoggerReporter
    def initialize(logger, formatter)
      @logger = logger || Logger.new(STDOUT)
      @logger.formatter = formatter || GrapeLogging::Formatters::Default.new if @logger.respond_to?(:formatter=)
    end

    def perform(params)
      @logger.info params
    end
  end
end