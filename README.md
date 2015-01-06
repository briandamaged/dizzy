# dizzy #

Dependency Injection that won't make your head spin!

## Purpose ##

```dizzy``` provides a declarative mechanism for assembling complex objects.  Its main advantages include:

1. Objects are only initialized when they are needed.
2. Objects are only assembled after all of their dependencies have already been initialized.


## 2-minute Tour ##

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

  di :bob do
    # Constructor dependency injection occurs here.
    init do
      Person.new "Bob"
    end

    # Setter dependency injection occurs here.
    wire do |instance|
      instance.friend = joe
    end
  end


  # Shortcut syntax: The 'init' phase is just creating
  # an instance of a Person named "Joe".
  di_wire :joe, Person, "Joe" do |instance|
    instance.friend = bob
  end
end

container = IocContainer.new

# Prints "Joe"
puts container.bob.friend.name


# Prints "Bob"
puts container.joe.friend.name
```
