require File.expand_path("../../teststrap", __FILE__)

describe ConfigLeaf do
  describe ".wrap" do
    it "should fail without a block" do
      lambda { ConfigLeaf.wrap Object.new }.should raise_error ArgumentError, "block is required"
    end

    context "without block arguments" do
      it "should alter the context to that of the wrapper within the block" do
        passed = nil
        ConfigLeaf.wrap Object.new do
          passed = self
        end
        passed.should be_kind_of ConfigLeaf::Wrapper
      end
    end

    context "with block arguments" do
      it "should pass object into the block" do
        object = Object.new
        passed = nil

        ConfigLeaf.wrap object do |x|
          passed = x
        end

        passed.should eq object
      end

      it "should not alter the context in the block" do
        object = Object.new
        block_self = nil
        original_self = self

        ConfigLeaf.wrap object do |x|
          block_self = self
        end

        # Use id or the two rspec contexts will barf.
        original_self.__id__.should eq block_self.__id__
      end
    end
  end
end