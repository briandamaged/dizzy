
require 'dizzy/core'
require 'dizzy/rule'

module Dizzy::DSL

  def di(name)
    ___method_name   = name.to_sym
    ___variable_name = "@#{name}".to_sym

    rule = Dizzy::Rule.new

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
