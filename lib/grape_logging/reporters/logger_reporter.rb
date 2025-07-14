module Reporters
  class LoggerReporter
    def initialize(logger, formatter, log_level)
      @logger = logger.clone || Logger.new(STDOUT)
      @log_level = log_level || :info
      @logger.formatter = formatter || @logger.formatter || GrapeLogging::Formatters::Default.new if @logger.respond_to?(:formatter=)
    end

    def perform(params)
      @logger.send(@log_level, params)
    end
  end
end
