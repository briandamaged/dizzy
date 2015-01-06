
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



  def di_define_method(__di__options = {})
    __di__method_name   = __di__options.fetch(:name).to_sym
    __di__variable_name = "@#{__di__method_name}".to_sym

    __di__init_proc     = __di__options.fetch(:init_proc)
    __di__wire_proc     = __di__options.fetch(:wire_proc)

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

    di_define_method(
      name: name,
      init_proc: rc.init_proc,
      wire_proc: rc.wire_proc
    )
  end


  # Use this when you only need to init an object
  def di_init(name, &block)
    di_define_method(
      name:      name,
      init_proc: block,
      wire_proc: lambda{|x| }
    )
  end


  # Use this when the init logic is uninteresting.
  # For example: you're just creating an instance
  # of a class w/ a hard-coded set of arguments.
  def di_wire(name, clazz, *args, &block)
    di_define_method(
      name:      name,
      init_proc: lambda{ clazz.new(*args) },
      wire_proc: block
    )
  end



end
