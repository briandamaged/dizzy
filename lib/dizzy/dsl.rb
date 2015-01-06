
require 'dizzy/core'
require 'dizzy/rule'

module Dizzy::DSL

  class RuleContext

    attr_reader :rule

    def initialize(rule = ::Dizzy::Rule.new)
      @rule = rule
    end

    def init(&block)
      rule.init_proc = block
    end

    def wire(&block)
      rule.wire_proc = block
    end
  end


  def di(name, &block)
    ___method_name   = name.to_sym
    ___variable_name = "@#{name}".to_sym

    rc   = ::Dizzy::DSL::RuleContext.new
    rc.instance_exec(&block)
    rule = rc.rule

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
