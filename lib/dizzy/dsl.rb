
require 'dizzy/core'
require 'dizzy/rule'

module Dizzy::DSL

  class RuleContext

    attr_reader :rule

    def initialize(rule)
      @rule = rule
    end

    def init(&block)
      rule.init_proc = block
    end

    def wire(&block)
      rule.wire_proc = block
    end
  end


  def di(name, clazz = nil, *args, &block)
    ___method_name   = name.to_sym
    ___variable_name = "@#{name}".to_sym


    rule = Dizzy::Rule.new

    if clazz
      rule.init_proc = lambda{ clazz.new(*args) }
      rule.wire_proc = block || lambda{|x| }
    else
      rc   = ::Dizzy::DSL::RuleContext.new(rule)
      rc.instance_exec(&block)
    end


    define_method ___method_name do
      unless instance_variable_defined? ___variable_name
        value = self.instance_exec(&rule.init_proc)
        instance_variable_set(___variable_name, value)

        self.instance_exec(value, &rule.wire_proc)
      end
      instance_variable_get(___variable_name)
    end

  end




end
