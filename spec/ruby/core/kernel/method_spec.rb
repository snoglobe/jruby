require_relative '../../spec_helper'
require_relative 'shared/method'
require_relative 'fixtures/classes'

describe "Kernel#method" do
  it_behaves_like :kernel_method, :method

  before :each do
    @obj = KernelSpecs::A.new
  end

  it "can be called on a private method" do
    @obj.send(:private_method).should == :private_method
    @obj.method(:private_method).should be_an_instance_of(Method)
  end

  it "can be called on a protected method" do
    @obj.send(:protected_method).should == :protected_method
    @obj.method(:protected_method).should be_an_instance_of(Method)
  end

  it "will see an alias of the original method as == when in a derived class" do
    obj = KernelSpecs::B.new
    obj.method(:aliased_pub_method).should == obj.method(:pub_method)
  end

  it "can call methods created with define_method" do
    m = @obj.method(:defined_method)
    m.call.should == :defined
  end

  it "can be called even if we only respond_to_missing? method, true" do
    m = KernelSpecs::RespondViaMissing.new.method(:handled_privately)
    m.should be_an_instance_of(Method)
    m.call(1, 2, 3).should == "Done handled_privately([1, 2, 3])"
  end

  it "can call a #method_missing accepting zero or one arguments" do
    cls = Class.new do
      def respond_to_missing?(name, *)
        name == :foo or super
      end
      def method_missing
        :no_args
      end
    end
    m = cls.new.method(:foo)
    -> { m.call }.should raise_error(ArgumentError)

    cls = Class.new do
      def respond_to_missing?(name, *)
        name == :bar or super
      end
      def method_missing(m)
        m
      end
    end
    m = cls.new.method(:bar)
    m.call.should == :bar
  end

  describe "converts the given name to a String using #to_str" do
    it "calls #to_str to convert the given name to a String" do
      name = mock("method-name")
      name.should_receive(:to_str).and_return("hash")
      Object.method(name).should == Object.method(:hash)
    end

    it "raises a TypeError if the given name can't be converted to a String" do
      -> { Object.method(nil) }.should raise_error(TypeError)
      -> { Object.method([])  }.should raise_error(TypeError)
    end

    it "raises a NoMethodError if the given argument raises a NoMethodError during type coercion to a String" do
      name = mock("method-name")
      name.should_receive(:to_str).and_raise(NoMethodError)
      -> { Object.method(name) }.should raise_error(NoMethodError)
    end
  end
end
