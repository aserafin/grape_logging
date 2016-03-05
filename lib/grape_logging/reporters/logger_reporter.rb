module Reporters
  class LoggerReporter
    def initialize(logger, formatter)
      @logger = logger || Logger.new(STDOUT)
      @logger.formatter = formatter || GrapeLogging::Formatters::Default.new
    end

    def perform(params)
      @logger.info params
    end
  end
end