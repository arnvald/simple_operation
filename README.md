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

## Background

Working with large business applications means working with a big business logic layer.
There are many Ruby gems that help building business logic layer, notably:

* Trailblazer (http://trailblazer.to)
* dry-transaction (http://dry-rb.org/gems/dry-transaction/)

Why another gem then? I wanted something very simple and easy to use
and I wanted to be able to call my services like labmdas, without having to create new objects outside of the service.
I wanted to achieve syntax like `CreateOrder.(articles, user)` with the flexibility of memoizing objects inside the service.

## Usage

### Basic service

To define a new service, you have to do 2 steps:

1. Create a new class by calling `SimpleOperation.new` with parameters you will be providing to the service
2. Put your business logic into `call` method.

Example:

```
CreateOrder = SimpleOperation.new(:articles, :user) do

  def call
    order = Order.new(articles_ids: articles.map(&:id), user_is: user.id)
    OrderRepository.persist(order)
    order
  end
end
```

or in a more common class definition style:

```
class CreateOrder < SimpleOperation.new(:articles, :user)

  def call
    # your business logic here, methods articles and user are available
  end

end
```

Then you can call your service in one of two ways. A more functional way:

```
CreateOrder.(some_articles, some_user)
```

or by instantiating the object first

```
CreateOrder.new(some_articles, some_user).()
```

### Returning result

SimpleOperation allows defining results by using success/failure definitions

```
class CreateUser < SimpleOperation.new(:login, :password)
  success :user
  failure :error

  def call
    if unique_login?
      user = User.new(login, hashed_password)
      UserRepository.persist(user)
      Success(user)
    else
      Failure("login taken")
    end
  end

  private

  def hashed_password
    ...
  end

  def unique_login?
    ...
  end

end
```

Using result definitions allows to easily check for status of the transaction and to define callbacks:

```
result1 = CreateUser.("grzegorz", "witek")

result1.success? # => true
result1.user # => instance of User object
result1.failure? # => false

result2 = CreateUser.("grzegorz", "witek")
result2.success? # => false
result2.error # => "login taken"
result2.failure? # => true
```

### Result callbacks

Returning success and failure allows using callbacks:

```
result1
.on_success { |s| puts "user created with login #{s.user.login}" }
.on_failure { |f| puts "creation failed because #{f.error}" }

# the code above will print "user created with login grzegorz"

result2
.on_success { |s| puts "user created with login #{s.user.login}" }
.on_failure { |f| puts "creation failed because #{f.error}" }

# the code above will print "creation failed because login taken"
```

Failure callbacks can be assigned to specific reasons, which requires adding `:reason`
field to the failed response:

```
class Authenticate < SimpleOperation.new(:login, :password)
  success :user
  failure :reason, :message

  def call
    return Failure("NO_USER", "user does not exist") unless login_exists?
    return Failure("WRONG_PASS", "wrong password") unless valid_password?
    return Success(user)
  end
end
```

Then each error can be easily handled in a different way:

```
result = Authenticate.(login, password)

result
.on_failure("NO_USER") { create_new_user(login, password) }
.on_failure("WRONG_PASS") { increase_invalid_attempt_count }
.on_failure() { raise DontKnowWhatToDo } # this will be called only if the previous reasons don't match
.on_success { |s| s.user }
```

### Generic results

If you don't need a distinction between success and failure, you can define generic result

```
class AggregateSalesData < SimpleOperation.new(:orders)

  result :average_transaction, :number_of_transactions, :maximum_transaction

  def call
    Result(
      find_average_transaction,
      transactions.size,
      find_max_transaction
    )
  end

end

result = AggregateSalesData.(orders)

result.average_transaction
result.number_of_transactions
result.maximum_transaction
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/simple_operation/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
