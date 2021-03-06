
require 'dizzy/core'

module Dizzy::DSL

  class RuleContext

    attr_accessor :init_proc, :wire_proc

    def init(&block)
      @init_proc = block
    end

    def wire(&block)
      @wire_proc = block
    end
  end



  def di_define_method(__di__method_name, __di__init_proc, __di__wire_proc)
    unless __di__init_proc
      raise ArgumentError.new("No init proc was specified for: #{__di__method_name}")
    end

    # If wire_proc wasn't specified, then just no-op
    __di__wire_proc ||= lambda{|x| }    

    __di__variable_name = "@#{__di__method_name}".to_sym

    define_method __di__method_name do
      unless instance_variable_defined? __di__variable_name
        value = self.instance_exec(&__di__init_proc)
        instance_variable_set(__di__variable_name, value)

        self.instance_exec(value, &__di__wire_proc)
      end
      instance_variable_get(__di__variable_name)
    end
  end


  # Use this when you need to both init and wire
  # your object.
  def di(name, &block)
    rc   = ::Dizzy::DSL::RuleContext.new
    rc.instance_exec(&block)

    di_define_method(name, rc.init_proc, rc.wire_proc)
  end


  # Use this when you only need to init an object
  def di_init(name, &block)
    di_define_method(name, block, nil)
  end


  # Use this when the init logic is uninteresting.
  # For example: you're just creating an instance
  # of a class w/ a hard-coded set of arguments.
  def di_wire(name, clazz, *args, &block)
    init_proc = lambda{ clazz.new(*args) }
    di_define_method(name, init_proc, block)
  end



end
