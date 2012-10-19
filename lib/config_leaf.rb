require 'config_leaf/version'
require 'config_leaf/wrapper'

module ConfigLeaf
  class << self
    # Wraps an object and redirects public methods to it, to allow for a terse, block-based API.
    #
    # * Safer alternative to running Object#instance_eval directly, since protected/private methods and instance variables are not exposed.
    # * Less wordy than a system which operates like Object#tap (`object.tap {|o| o.fish = 5; o.run }`)
    #
    # A method call, #meth called on the wrapper will try to call #meth or #meth= on the owner, as appropriate.
    #
    # @example Using ConfigLeaf to configure an object externally.
    #     # To create a DSL block for a given object.
    #     class Cheese
    #       attr_accessor :value, :list
    #
    #       def initialize
    #         @value = 0
    #         @list = []
    #       end
    #
    #       def invert
    #         @list.reverse!
    #       end
    #     end
    #
    #     object = Cheese.new
    #     ConfigLeaf.wrap object do
    #       list [1, 2, 3]      # Calls object.list = [1, 2, 3]
    #       list << 4           # Calls object.list << 4
    #       value 5             # Calls object.value = 5
    #       value list.size     # Calls object.value = object.list.size
    #       invert              # Calls object.invert
    #     end
    #
    # @example Allowing the user to configure the object externally.
    #     # To create a DSL block for a given object.
    #     class Cheese
    #       attr_accessor :value, :list
    #
    #       def initialize(&block)
    #         @value = 0
    #         @list = []
    #
    #         ConfigLeaf.wrap object, &block if block_given?
    #       end
    #
    #       def invert
    #         @list.reverse!
    #       end
    #     end
    #
    #     # User chooses to use the ConfigLeaf block syntax.
    #     object = Cheese.new do
    #       list [1, 2, 3]      # Calls object.list = [1, 2, 3]
    #       list << 4           # Calls object.list << 4
    #       value 5             # Calls object.value = 5
    #       value list.size     # Calls object.value = object.list.size
    #       invert              # Calls object.invert
    #     end
    #
    #    # User chooses to not use ConfigLeaf block syntax by requesting a block parameter.
    #    object = Cheese.new do |c|
    #       c.list = [1, 2, 3]
    #       c.list << 4
    #       c.value = 5
    #       c.value = c.list.size
    #       c.invert
    #     end
    #
    def wrap(object, &block)
      raise ArgumentError, "block is required" unless block_given?

      if block.arity == 0 # e.g. { }
        Wrapper.wrap object, &block
      else                # e.g. {|me| }
        block.call object
      end
    end
  end
end
