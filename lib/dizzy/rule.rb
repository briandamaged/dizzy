
require 'dizzy/core'

class Dizzy::Rule

  attr_accessor :init_proc, :wire_proc

  def initialize(options = {})
    @init_proc = lambda{}
    @wire_proc = lambda{|x| }
  end

end
