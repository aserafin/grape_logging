require 'spec_helper'
require 'ostruct'

describe GrapeLogging::Loggers::ClientEnv do
  let(:ip) { '10.0.0.1' }
  let(:user_agent) { 'user agent' }
  let(:forwarded_for) { "forwarded for" }
  let(:remote_addr) { "remote address" }

  context 'forwarded for' do
    let(:mock_request) do
      OpenStruct.new(env: {
        "HTTP_X_FORWARDED_FOR" => forwarded_for
      })
    end

    it 'sets the ip key' do
      expect(subject.parameters(mock_request, 200, nil)).to eq(ip: forwarded_for, ua: nil)
    end

    it 'prefers the forwarded_for over the remote_addr' do
      mock_request.env['REMOTE_ADDR'] = remote_addr
      expect(subject.parameters(mock_request, 200, nil)).to eq(ip: forwarded_for, ua: nil)
    end
  end

  context 'remote address' do
    let(:mock_request) do
      OpenStruct.new(env: {
        "REMOTE_ADDR" => remote_addr
      })
    end

    it 'sets the ip key' do
      expect(subject.parameters(mock_request, 200, nil)).to eq(ip: remote_addr, ua: nil)
    end
  end

  context 'user agent' do
    let(:mock_request) do
      OpenStruct.new(env: {
        "HTTP_USER_AGENT" => user_agent
      })
    end

    it 'sets the ua key' do
      expect(subject.parameters(mock_request, 200, nil)).to eq(ip: nil, ua: user_agent)
    end
  end
end
