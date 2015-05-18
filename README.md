# SimpleOperation

The idea behind SimpleOperation is to provide a very basic class creator that facilitates using service objects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_operation'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_operation

## Usage

Example usage for SimpleOperation is creating user:

```ruby
class CreateUser < SimpleOperation.new(:login, :password)

  InvalidUser = Class.new(RuntimeError)

  def call
    user = User.new(login, password)
    raise InvalidUser unless valid_user?(user)
    UserRepository.persist(user)
    user
  end

  private
    def valid_user?(user)
      !UserRepository.fetch_all_logins.include?(user.login)
    end

end


CreateUser.('Grzegorz', 'arnvald.to@gmail.com')

# the same effect as line above
CreateUser.new('Grzegorz', 'arnvald.to@gmail.com').()

# `perform` is an alias for `call`
CreateUser.new('Grzegorz', 'arnvald.to@gmail.com').perform
```

There's a sugar syntax for creating classes:

```ruby
require 'simple_operation/ext'

class CreateUser < SimpleOperation(:login, :password)
  def call
    ...
  end
end
```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/simple_operation/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
