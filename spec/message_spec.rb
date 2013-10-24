# encoding: binary

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require 'protocol_buffers'

describe ProtocolBuffers, "message" do
  before(:each) do
    # clear our namespaces
    %w( Simple Featureful Foo Packed TehUnknown TehUnknown2 TehUnknown3 Enums A C Services).each do |klass|
      Object.send(:remove_const, klass.to_sym) if Object.const_defined?(klass.to_sym)
    end

    # load test protos
    %w( simple featureful packed enums no_package services).each do |proto|
      load File.join(File.dirname(__FILE__), "proto_files", "#{proto}.pb.rb")
    end
  end

  it "1" do
    a = Featureful::A.new(
      :i2 => 1,
      :sub2 => Featureful::A::Sub.new(
        :payload => "test_payload"
      )
    )

    a.value_for_tag?(1).should == true
    a.value_for_tag?(5).should == true
  end

  it "2" do
    d = Featureful::D.new(
      :f => [1, 2, 3].map do |num|
        Featureful::F.new(
          :s => "#{num}"
        )
      end
    )
    c = Featureful::C.new(
      :d => d,
      :e => [1].map do |num|
        Featureful::E.new(
          :d => d
        )
      end
    )

    c.value_for_tag?(1).should == true
  end

  it "3" do
    d = Featureful::D.new
    d.f = [1, 2, 3].map do |num|
      Featureful::F.new(
        :s => "#{num}"
      )
    end
    c = Featureful::C.new
    c.d = d
    c.e = [1].map do |num|
      Featureful::E.new(
        :d => d
      )
    end

    c.value_for_tag?(1).should == true
  end

  it "4" do
    c = Featureful::C.new
    c_d = c.d
    c_d.f = [1, 2, 3].map do |num|
      Featureful::F.new(
        :s => "#{num}"
      )
    end
    d = Featureful::D.new
    d.f = [1, 2, 3].map do |num|
      Featureful::F.new(
        :s => "#{num}"
      )
    end
    c.e = [1].map do |num|
      Featureful::E.new(
        :d => d
      )
    end

    c.value_for_tag?(1).should == true
  end

  it "5" do
    c = Featureful::C.new
    c_d = c.d
    c_d.f = [1, 2, 3].map do |num|
      Featureful::F.new(
        :s => "#{num}"
      )
    end
    d = Featureful::D.new
    d.f = [1, 2, 3].map do |num|
      Featureful::F.new(
        :s => "#{num}"
      )
    end
    d.f2 = Featureful::F.new(
      :s => "4"
    )
    c.e = [1].map do |num|
      Featureful::E.new(
        :d => d
      )
    end

    c.value_for_tag?(1).should == true
  end
end
