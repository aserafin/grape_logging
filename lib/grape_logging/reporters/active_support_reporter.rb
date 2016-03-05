module Reporters
  class ActiveSupportReporter
    def initialize(instrumentation_key)
      @instrumentation_key = instrumentation_key
    end

    def perform(params)
      ActiveSupport::Notifications.instrument @instrumentation_key, params
    end
  end
end