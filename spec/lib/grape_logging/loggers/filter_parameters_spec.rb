require 'spec_helper'
require 'ostruct'

describe GrapeLogging::Loggers::FilterParameters do
  let(:filtered_parameters) { %w[one four] }

  let(:mock_request) do
    OpenStruct.new(params: {
                     'this_one' => 'this one',
                     'that_one' => 'one',
                     'two' => 'two',
                     'three' => 'three',
                     'four' => 'four',
                     "\xff" => 'invalid utf8',
                   })
  end

  let(:mock_request_with_deep_nesting) do
    deep_clone = lambda { Marshal.load Marshal.dump mock_request.params }
    OpenStruct.new(
      params: deep_clone.call.merge(
        'five' => deep_clone.call.merge(
          deep_clone.call.merge({'six' => {'seven' => 'seven', 'eight' => 'eight', 'one' => 'another one'}})
        )
      )
    )
  end

  let(:subject) do
    GrapeLogging::Loggers::FilterParameters.new filtered_parameters, replacement
  end

  let(:replacement) { nil }

  shared_examples 'filtering' do
    it 'filters out sensitive parameters' do
      expect(subject.parameters(mock_request, nil)).to eq(params: {
                                                            'this_one' => subject.instance_variable_get('@replacement'),
                                                            'that_one' => subject.instance_variable_get('@replacement'),
                                                            'two' => 'two',
                                                            'three' => 'three',
                                                            'four' => subject.instance_variable_get('@replacement'),
                                                            "\xff" => 'invalid utf8',
                                                          })
    end

    it 'deeply filters out sensitive parameters' do
      expect(subject.parameters(mock_request_with_deep_nesting, nil)).to eq(params: {
                                                                              'this_one' => subject.instance_variable_get('@replacement'),
                                                                              'that_one' => subject.instance_variable_get('@replacement'),
                                                                              'two' => 'two',
                                                                              'three' => 'three',
                                                                              'four' => subject.instance_variable_get('@replacement'),
                                                                              "\xff" => 'invalid utf8',
                                                                              'five' => {
                                                                                'this_one' => subject.instance_variable_get('@replacement'),
                                                                                'that_one' => subject.instance_variable_get('@replacement'),
                                                                                'two' => 'two',
                                                                                'three' => 'three',
                                                                                'four' => subject.instance_variable_get('@replacement'),
                                                                                "\xff" => 'invalid utf8',
                                                                                'six' => {
                                                                                  'seven' => 'seven',
                                                                                  'eight' => 'eight',
                                                                                  'one' => subject.instance_variable_get('@replacement'),
                                                                                },
                                                                              },
                                                                            })
    end
  end

  context 'with default replacement' do
    it_behaves_like 'filtering'
  end

  context 'with custom replacement' do
    let(:replacement) { 'CUSTOM_REPLACEMENT' }
    it_behaves_like 'filtering'
  end
end
