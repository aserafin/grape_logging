require 'spec_helper'
require 'ostruct'

describe GrapeLogging::Loggers::Response do
  context 'with a parseable JSON body' do
    let(:response) do
      OpenStruct.new(body: [{"one": "two", "three": {"four": 5}}])
    end

    it 'returns an array of parsed JSON objects' do
      expect(subject.parameters(nil, response)).to eq({
        response: [response.body.first]
      })
    end
  end

  context 'with a body that is not parseable JSON' do
    let(:response) do
      OpenStruct.new(body: "this is a body")
    end

    it 'just returns the body' do
      expect(subject.parameters(nil, response)).to eq({
        response: response.body.dup
      })
    end
  end
end
