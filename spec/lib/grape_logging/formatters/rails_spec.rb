require 'spec_helper'

describe GrapeLogging::Formatters::Rails do
  let(:formatter) { described_class.new }
  let(:severity) { "INFO" }
  let(:datetime) { Time.new('2018', '03', '02', '10', '35', '04', '+13:00') }

  let(:exception_data) { ArgumentError.new('Message') }
  let(:hash_data) {
    {
      status: 200,
      time: {
        total: 272.4,
        db: 40.63,
        view: 231.76999999999998
      },
      method: "GET",
      path: "/api/endpoint",
      host: "localhost"
    }
  }

  describe '#call' do
    context 'string data' do
      it 'returns a formatted string' do
        message = formatter.call(severity, datetime, nil, 'value')

        expect(message).to eq "I [2018-03-02 10:35:04 +1300] INFO -- : value\n"
      end
    end

    context 'exception data' do
      it 'returns a string with a backtrace' do
        exception_data.set_backtrace(caller)

        message = formatter.call(severity, datetime, nil, exception_data)
        lines = message.split("\n")

        expect(lines[0]).to eq "I [2018-03-02 10:35:04 +1300] INFO -- : Message (ArgumentError)"
        expect(lines[1]).to include '.rb'
        expect(lines.size).to be > 1
      end
    end

    context 'hash data' do
      it 'returns a formatted string' do
        message = formatter.call(severity, datetime, nil, hash_data)

        expect(message).to eq "Completed 200 OK in 272.4ms (Views: 231.77ms | DB: 40.63ms)\n"
      end

      it 'includes params if included (from GrapeLogging::Loggers::FilterParameters)' do
        hash_data.merge!(
          params: {
            "some_param" => {
              value_1: "123",
              value_2: "456"
            }
          }
        )

        message = formatter.call(severity, datetime, nil, hash_data)
        lines = message.split("\n")

        expected_output = if RUBY_VERSION >= '3.4'
          '  Parameters: {"some_param" => {value_1: "123", value_2: "456"}}'
                          else
          '  Parameters: {"some_param"=>{:value_1=>"123", :value_2=>"456"}}'
        end
        expect(lines.first).to eq expected_output
        expect(lines.last).to eq "Completed 200 OK in 272.4ms (Views: 231.77ms | DB: 40.63ms)"
      end
    end

    context "unhandled data" do
      it 'returns the #inspect string representation' do
        message = formatter.call(severity, datetime, nil, [1, 2, 3])

        expect(message).to eq "[1, 2, 3]\n"
      end
    end
  end

end
