module GrapeLogging
  module Loggers
    class RequestHeaders < GrapeLogging::Loggers::Base

      HTTP_PREFIX = 'HTTP_'.freeze

      def parameters(request, _status, _response_body)
        headers = {}

        request.env.each_pair do |k, v|
          next unless k.to_s.start_with? HTTP_PREFIX

          k = k[5..-1].split('_').each(&:capitalize!).join('-')
          headers[k] = v
        end

        { headers: headers }
      end

    end
  end
end
