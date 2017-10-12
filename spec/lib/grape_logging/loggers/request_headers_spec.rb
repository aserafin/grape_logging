require 'spec_helper'
require 'ostruct'

describe GrapeLogging::Loggers::RequestHeaders do
  let(:mock_request) do
    OpenStruct.new(env: {HTTP_REFERER: 'http://example.com', HTTP_ACCEPT: 'text/plain'})
  end

  it 'strips HTTP_ from the parameter' do
    expect(subject.parameters(mock_request, nil)).to eq({
      headers: {'Referer' => 'http://example.com', 'Accept' => 'text/plain'}
    })
  end
end
