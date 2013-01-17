require 'spec_helper'

describe OpenAuth2::Token do
  context '#initialize' do
    it 'accepts config as argument' do
      config = OpenAuth2::Config.new do |c|
        c.provider = OpenAuth2::Provider::Facebook
      end
      subject = described_class.new(config)
      subject.config.should == config
    end
  end
end
