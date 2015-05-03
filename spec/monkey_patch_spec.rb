require 'spec_helper'

describe Mongoid::Document do
  it 'register model' do
    class TestModel
      include Mongoid::Document
    end
    expect(Mongoid.models).to be_include(TestModel)
  end
end
