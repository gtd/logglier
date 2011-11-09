require 'spec_helper'

describe Logglier::Client::HTTP::DeferredDeliveryThread do
  subject { described_class.new(URI.parse('http://localhost')) }

  it "should not instantiate a DeliveryThread initially" do
    Logglier::Client::HTTP::DeliveryThread.should_not_receive(:new)
    subject
  end

  it "should instantiate a DeliveryThread on deliver" do
    @mock_thread = Object.new
    Logglier::Client::HTTP::DeliveryThread.should_receive(:new).once.and_return(@mock_thread)
    @mock_thread.should_receive(:deliver).once.with('foo')

    subject.deliver('foo')
  end
end
