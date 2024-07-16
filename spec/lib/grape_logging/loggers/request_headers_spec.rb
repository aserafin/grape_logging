require 'spec_helper'
require 'ostruct'

describe GrapeLogging::Loggers::RequestHeaders do
  let(:mock_request) do
    OpenStruct.new(env: {HTTP_REFERER: 'http://example.com', HTTP_ACCEPT: 'text/plain'})
  end

  let(:mock_request_with_unhandle_headers) do
    OpenStruct.new(env: {
      HTTP_REFERER: 'http://example.com',
      "PATH_INFO"=>"/api/v1/users"
    })
  end

  let(:mock_request_with_long_headers) do
    OpenStruct.new(env: {
      HTTP_REFERER: 'http://example.com',
      HTTP_USER_AGENT: "Mozilla/5.0"
    })
  end

  it 'strips HTTP_ from the parameter' do
    expect(subject.parameters(mock_request, 200, nil)).to eq({
      headers: {'Referer' => 'http://example.com', 'Accept' => 'text/plain'}
    })
  end

  it 'only handle things which start with HTTP_' do
    expect(subject.parameters(mock_request_with_unhandle_headers, 200, nil)).to eq({
      headers: {'Referer' => 'http://example.com' }
    })
  end

  it 'substitutes _ with -' do
    expect(subject.parameters(mock_request_with_long_headers, 200, nil)).to eq({
      headers: {'Referer' => 'http://example.com', 'User-Agent' => 'Mozilla/5.0' }
    })
  end
end
