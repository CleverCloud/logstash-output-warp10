
# encoding: utf-8

require 'logstash/devutils/rspec/spec_helper'
require 'logstash/outputs/warp10'
require 'logstash/codecs/plain'
require 'logstash/event'

describe LogStash::Outputs::Warp10 do
  let(:output) do
    LogStash::Outputs::Warp10.new(
      'warp_uri' => 'http://127.0.0.1:8080/api/v0/update',
      'token' => 'token',
      'gts_name' => 'log'
    )
  end

  before do
    output.register
  end

  context '#decode' do
    it 'should show how much time takes warp10 to handle messages' do
      counter = 0
      while counter < 100_000
        output.receive(LogStash::Event.new('message' => 'test' + counter.to_s, 'host' => 'test'))
        counter += 1
      end
    end
  end
end
