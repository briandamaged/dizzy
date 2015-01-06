# dizzy #

Dependency Injection that won't make your head spin!

## Purpose ##

```dizzy``` provides a declarative mechanism for assembling complex objects.  Its main advantages include:

1. Objects are only initialized when they are needed.
2. Objects are only assembled after all of their dependencies have already been initialized.


## 5-minute Tour ##

Typically, you would use ```dizzy``` when you have several objects that need to be assembled in a specific way.  But, for the sake of example, let's just assemble 2 objects.  First, let's define a ```Person``` class:

```ruby
class Person
  attr_accessor :name, :friend

  def initialize(name = nil)
    @name = name
  end
end
```

We'd like ```bob``` and ```joe``` to be instances of ```Person```.  Furthermore, we'd like them both to be friends.  So:

```ruby
require 'dizzy'

class IocContainer
  extend Dizzy::DSL

  # This will define the IocContainer#bob method
  di :bob do
    # Constructor dependency injection occurs here.
    init do
      Person.new "Bob"
    end

    # Setter dependency injection occurs here.
    wire do |instance|
      # Get the value from IocContainer#joe
      instance.friend = joe
    end
  end


  di :joe do
    init do
      Person.new "Joe"
    end

    wire do |instance|
      instance.friend = bob
    end
  end

end

container = IocContainer.new

# Prints "Joe"
puts container.bob.friend.name


# Prints "Bob"
puts container.joe.friend.name
```

Holy cow!  That seems like a TON of work just to assemble 2 objects!  Is all of that really necessary?  Fortunately, the answer is usually "No".  In many cases, an object's ```init``` logic is uninteresting.  It just creates an instance of a class with a few hard-coded parameters.  So, you can simplify things by using the ```di_wire``` method:


```ruby
require 'dizzy'

class IocContainer
  extend Dizzy::DSL


  di_wire :bob, Person, "Bob" do |bob|
    bob.friend = joe
  end


  di_wire :joe, Person, "Joe" do |joe|
    joe.friend = bob
  end

end

container = IocContainer.new

# Prints "Joe"
puts container.bob.friend.name


# Prints "Bob"
puts container.joe.friend.name
```

