module GrapeLogging
  module Timings
    def self.db_runtime=(value)
      Thread.current[:grape_db_runtime] = value
    end

    def self.db_runtime
      Thread.current[:grape_db_runtime] ||= 0
    end

    def self.reset_db_runtime
      self.db_runtime = 0
    end

    def self.append_db_runtime(event)
      self.db_runtime += event.duration
    end
  end
end
