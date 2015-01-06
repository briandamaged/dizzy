# dizzy #

Dependency Injection that won't make your head spin!

## Usage ##

Here's a really terrible example to get you started:


    require 'dizzy'

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


    class IocContainer
      extend Dizzy::DSL

      di :foo do
        init do
         Foo.new("foo name")
        end

        wire do |foo_instance|
          foo_instance.bar = bar
        end
      end

      di :bar, Bar, "bar name" do |bar_instance|
        bar_instance.foo = foo
      end
    end

    container = IocContainer.new

    puts container.foo.bar.name
