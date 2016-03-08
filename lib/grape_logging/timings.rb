module GrapeLogging
  module Timings
    extend self

    def db_runtime=(value)
      Thread.current[:grape_db_runtime] = value
    end

    def db_runtime
      Thread.current[:grape_db_runtime] ||= 0
    end

    def reset_db_runtime
      self.db_runtime = 0
    end

    def append_db_runtime(event)
      self.db_runtime += event.duration
    end
  end
end