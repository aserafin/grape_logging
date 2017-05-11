require 'spec_helper'
require 'rack'

describe GrapeLogging::Middleware::RequestLogger do
  let(:subject) { request.send(request_method, path) }
  let(:app) { proc{ [status, {} , ['response body']] } }
  let(:stack) { described_class.new app, options }
  let(:request) { Rack::MockRequest.new(stack) }
  let(:options) { {include: [], logger: logger} }
  let(:logger) { double('logger') }
  let(:path) { '/' }
  let(:request_method) { 'get' }
  let(:status) { 200 }

  it 'logs to the logger' do
    expect(logger).to receive('info') do |arguments|
      expect(arguments[:status]).to eq 200
      expect(arguments[:method]).to eq 'GET'
      expect(arguments[:params]).to be_empty
      expect(arguments[:host]).to eq 'example.org'
      expect(arguments).to have_key :time
      expect(arguments[:time]).to have_key :total
      expect(arguments[:time]).to have_key :db
      expect(arguments[:time]).to have_key :view
    end
    subject
  end

  [301, 404, 500].each do |the_status|
    context "when the respnse status is #{the_status}" do
      let(:status) { the_status }
      it 'should log the correct status code' do
        expect(logger).to receive('info') do |arguments|
          expect(arguments[:status]).to eq the_status
        end
        subject
      end
    end
  end

  %w[info error debug].each do |level|
    context "with level #{level}" do
      it 'should log at correct level' do
        options[:log_level] = level
        expect(logger).to receive(level)
        subject
      end
    end
  end

  context 'with a nil response' do
    let(:app) { proc{ [500, {} , nil] } }
    it 'should log "fail" instead of a status' do
      expect(Rack::MockResponse).to receive(:new) { nil }
      expect(logger).to receive('info') do |arguments|
        expect(arguments[:status]).to eq 'fail'
      end
      subject
    end
  end

  context 'additional_loggers' do
    before do
      options[:include] << GrapeLogging::Loggers::RequestHeaders.new
      options[:include] << GrapeLogging::Loggers::ClientEnv.new
      options[:include] << GrapeLogging::Loggers::Response.new
      options[:include] << GrapeLogging::Loggers::FilterParameters.new(["replace_me"])
    end

    %w[get put post delete options head patch].each do |the_method|
      let(:request_method) { the_method }
      context "with HTTP method[#{the_method}]" do
        it 'should include additional information in the log' do
          expect(logger).to receive('info') do |arguments|
            expect(arguments).to have_key :headers
            expect(arguments).to have_key :ip
            expect(arguments).to have_key :response
          end
          subject
        end
      end
    end

    it 'should filter parameters in the log' do
      expect(logger).to receive('info') do |arguments|
        expect(arguments[:params]).to eq(
          "replace_me" => '[FILTERED]',
          "replace_me_too" => '[FILTERED]',
          "cant_touch_this" => 'should see'
        )
      end
      parameters = {
        'replace_me' => 'should not see',
        'replace_me_too' => 'should not see',
        'cant_touch_this' => 'should see'
      }
      request.post path, params: parameters
    end
  end
end
