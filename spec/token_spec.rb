require 'spec_helper'

describe OpenAuth2::Token do
  let(:config) do
    OpenAuth2::Config.new do |c|
      c.provider = OpenAuth2::Provider::Facebook
    end
  end

  subject { OpenAuth2::Token.new(config) }

  context '#initialize' do
    it 'accepts config as argument' do
      subject = described_class.new(config)
      subject.config.should == config
    end
  end
end
