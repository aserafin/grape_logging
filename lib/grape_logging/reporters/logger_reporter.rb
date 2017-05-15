module Reporters
  class LoggerReporter
    def initialize(logger, formatter, log_level)
      @logger = logger || Logger.new(STDOUT)
      @log_level = log_level || :info
      if @logger.respond_to?(:formatter=)
        @logger.formatter = formatter || @logger.formatter || GrapeLogging::Formatters::Default.new
      end
    end

    def perform(params)
      @logger.send(@log_level, params)
    end
  end
end
