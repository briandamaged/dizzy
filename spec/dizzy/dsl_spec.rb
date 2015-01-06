
require 'dizzy/dsl'


class Foo
  attr_accessor :name, :bar

  def initialize(name = nil)
    @name = name
  end
end


class Bar
  attr_accessor :name, :foo

  def initialize(name = nil)
    @name = name
  end
end



describe Dizzy::DSL do 

  # TODO: Split this into many many many more tests
  it "works" do

    frame = Class.new do
      extend Dizzy::DSL

      di :foo do
        init do
          Foo.new("foo")
        end

        wire do |foo|
          foo.bar = bar
        end
      end

      di_wire :bar, Bar, "bar" do 
        bar.foo = foo
      end
    end


    f = frame.new

    expect(f.foo.name).to eq "foo"
    expect(f.bar.name).to eq "bar"

    expect(f.foo.bar).to equal f.bar
    expect(f.bar.foo).to equal f.foo

  end

end

