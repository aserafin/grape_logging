if defined?(::Rails.application)
  if Gem::Version.new(Rails.version) < Gem::Version.new('6.0.0')
    class ParameterFilter < ActionDispatch::Http::ParameterFilter
      def initialize(_replacement, filter_parameters)
        super(filter_parameters)
      end
    end
  else
    class ParameterFilter < ActiveSupport::ParameterFilter
      def initialize(_replacement, filter_parameters)
        super(filter_parameters)
      end
    end
  end
else
  #
  # lifted from https://github.com/rails/rails/blob/master/actionpack/lib/action_dispatch/http/parameter_filter.rb
  # we could depend on Rails specifically, but that would us way to hefty!
  #
  class ParameterFilter
    def initialize(replacement, filters = [])
      @replacement = replacement
      @filters = filters
    end

    def filter(params)
      compiled_filter.call(params)
    end

    private

    def compiled_filter
      @compiled_filter ||= CompiledFilter.compile(@replacement, @filters)
    end

    class CompiledFilter # :nodoc:
      def self.compile(replacement, filters)
        return lambda { |params| params.dup } if filters.empty?

        strings, regexps, blocks = [], [], []

        filters.each do |item|
          case item
          when Proc
            blocks << item
          when Regexp
            regexps << item
          else
            strings << Regexp.escape(item.to_s)
          end
        end

        deep_regexps, regexps = regexps.partition { |r| r.to_s.include?("\\.".freeze) }
        deep_strings, strings = strings.partition { |s| s.include?("\\.".freeze) }

        regexps << Regexp.new(strings.join('|'.freeze), true) unless strings.empty?
        deep_regexps << Regexp.new(deep_strings.join('|'.freeze), true) unless deep_strings.empty?

        new replacement, regexps, deep_regexps, blocks
      end

      attr_reader :regexps, :deep_regexps, :blocks

      def initialize(replacement, regexps, deep_regexps, blocks)
        @replacement = replacement
        @regexps = regexps
        @deep_regexps = deep_regexps.any? ? deep_regexps : nil
        @blocks  = blocks
      end

      def call(original_params, parents = [])
        filtered_params = {}

        original_params.each do |key, value|
          parents.push(key) if deep_regexps
          if regexps.any? { |r| key =~ r }
            value = @replacement
          elsif deep_regexps && (joined = parents.join('.')) && deep_regexps.any? { |r| joined =~ r }
            value = @replacement
          elsif value.is_a?(Hash)
            value = call(value, parents)
          elsif value.is_a?(Array)
            value = value.map { |v| v.is_a?(Hash) ? call(v, parents) : v }
          elsif blocks.any?
            key = key.dup if key.duplicable?
            value = value.dup if value.duplicable?
            blocks.each { |b| b.call(key, value) }
          end
          parents.pop if deep_regexps

          filtered_params[key] = value
        end

        filtered_params
      end
    end
  end
end
