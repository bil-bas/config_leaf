require File.expand_path("../../teststrap", __FILE__)

describe ConfigLeaf::Wrapper do
  let :owner_class do
    Owner ||= Class.new do
      def frog; end
      def fish; end
      def fish=(fish); end
      def knees=(knees); end
      def add_cheese(a, b); end
      def add_peas(a, &block); end

      protected
      def wibble; end
    end
  end

  let(:owner) { owner_class.new }
  let(:subject) { described_class.wrap owner }

  let :expected_methods do
    methods = [:frog, :fish, :add_cheese, :_owner, :add_peas, :knees]
    methods.map! &:to_s if RUBY_VERSION =~ /^1\.8\./
    methods
  end

  describe "#public_methods" do
    it "should be the same as the owner's + #_owner" do
      subject.public_methods(false).sort.should eq expected_methods.sort
    end
  end
  
  describe "#_owner" do
    it "should be set to the owner of the wrapper" do
      subject._owner.should eq owner
    end
  end
  
  context "dynamic method redirection" do
    it "a method that doesn't exist on the wrapped object should fail" do
      ->{ subject.wobble }.should raise_error NoMethodError, /<Owner:0x\w+> does not have either public method, #wobble or #wobble=/
    end

    it "a protected method on the wrapped object should not be accessible" do
      ->{ subject.wibble }.should raise_error NoMethodError, /<Owner:0x\w+> does not have either public method, #wibble or #wibble=/
    end

    it "redirect to a setter, that has no corresponding getter, even if no arguments are passed" do
      ->{ subject.knees }.should raise_error ArgumentError
    end

    it "redirect to a getter, that has no corresponding setter, even if arguments are passed" do
      ->{ subject.frog 25 }.should raise_error ArgumentError
    end

    it "redirect a getter (that has no corresponding setter)" do
      mock(owner, :frog).returns 5
      subject.frog.should eq 5
    end

    it "redirect a setter (that has no corresponding getter)" do
      mock(owner, :knees=).with(1).returns(5)
      subject.knees(1).should eq 5
    end

    it "redirect a getter (that has a corresponding setter)" do
      mock(owner, :fish).returns(5)
      subject.fish.should eq 5
    end

    it "redirect a setter (that has a corresponding getter)" do
      mock(owner, :fish=).with(5).returns(5)
      subject.fish(5).should eq 5
    end

    it "redirect a setter (that has a corresponding getter)" do
      mock(owner).add_cheese(1, 2).returns(99)
      subject.add_cheese(1, 2).should eq 99
    end

    it "should redirect a block as well as pass arguments" do
      mock(owner).add_peas(1).yields(:knees)

      yielded = nil
      subject.add_peas(1) do |arg|
        yielded = arg
      end

      yielded.should eq :knees
    end
  end

  describe "" do
    it "should instance_eval when given a block on the constructor (.new)" do
      mock(owner).frog(5)

      ConfigLeaf::Wrapper.new owner do
        frog 5
      end
    end
  end

  describe ".wrap" do
    it "should be an alias for .new" do
      described_class.wrap(owner).should be_kind_of described_class
    end

    it "should be an alias for .new given a block" do
      described_class.wrap(owner) {}.should be_kind_of described_class
    end
  end
end