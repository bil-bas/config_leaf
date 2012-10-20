module ConfigLeaf

  class Wrapper
    # @return [Object] Object that the Wrapper object is redirecting to.
    attr_reader :_owner

    class << self
      # Synonym for .new.
      alias_method :wrap, :new
    end

    # If passed a block, the Wrapper will #instance_eval it automatically.
    #
    # @param owner [Object] Object to redirect the public methods of.
    def initialize(owner, &block)
      @_owner = owner

      metaclass = class << self; self; end

      (@_owner.public_methods - Object.public_instance_methods).each do |target_method|
        redirection_method = target_method.to_s.chomp('=').to_sym

        metaclass.class_eval do
          define_method redirection_method do |*args, &inner_block|
            if @_owner.respond_to? "#{redirection_method}=" and (args.any? or not @_owner.respond_to? redirection_method)
              # Has a setter and we are passing argument(s) or if we haven't got a corresponding getter.
              @_owner.send "#{redirection_method}=", *args, &inner_block
            elsif @_owner.respond_to? redirection_method
              # We have a getter or general method
              @_owner.send redirection_method, *args, &inner_block
            else
              # Should never reach here, but let's be paranoid.
              raise NoMethodError, "#{@_owner} does not have a public method, ##{redirection_method}"
            end
          end
        end
      end

      instance_eval &block if block_given?

      if instance_variables != [:@_owner]
        altered = instance_variables - [:@_owner]
        raise "Instance variable#{altered.one? ? '' : 's'} #{altered.join ", "} set in ConfigLeaf scope"
      end
    end

    private
    def method_missing(meth, *args, &block)
      raise NoMethodError, "#{_owner} does not have either public method, ##{meth} or ##{meth}="
    end
  end
end