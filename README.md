# ActsAsLockableBy

[![Gem Version](https://badge.fury.io/rb/acts_as_lockable_by.svg)](http://badge.fury.io/rb/acts_as_lockable_by)
[![Build Status](https://travis-ci.com/tareksamni/acts_as_lockable_by.svg?branch=master)](https://travis-ci.com/tareksamni/acts_as_lockable_by)

This gem was originally developed and maintained by [ABTION](https://abtion.com/). Its main goal is providing the ability to lock a resource/object so that no other users/lockers can access it till the lock is released or the ttl timesout.

An example usage for this gem is when you need a blog post (resource) to be only edtiable by 1 user concurrently. So the first user to lock the blog post to himself will always have access and be able to edit it. This user will need to renew the lock before the `ttl` expires otherwise the post will be unlocked and any other users can lock it to themselves.

ActsAsLockableBy uses `redis` as a distributed efficient lock manager/backend with its built-in ability to expire locks when `ttl` expires.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'acts_as_lockable_by'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install acts_as_lockable_by

### Post Installation

You need to configure the gem as follows:

```ruby
# config/initializers/acts_as_lockable_by.rb
ActsAsLockableBy.configure do |config|
  config.redis = Redis.new(url: ENV['REDIS_URL']) # redis client
  config.ttl = 30.seconds # global ttl
end
```

## Usage

Setup

```ruby
class User < ActiveRecord::Base
  # :id is a unique identifier(attribute/method) for this object
  # :ttl default to global configured ttl if not provided
  acts_as_lockable_by :id, ttl: 60.seconds
end
# or
class Post
  acts_as_lockable_by :post_id # default to global configured ttl

  def post_id
    "SOME UNIQUE IDENTIFIER"
  end
end

post = Post.new
```

Lock and unlock a post

```ruby
post.lock('Tarek Elsamni') # true
post.lock('Tarek Elsamni') # false - already locked!
post.unlock('Someone Else') # false - 'Someone Else' did not lock it!
post.unlock('Tarek Elsamni') # true - 'Tarek Elsamni' locked it!
post.unlock('Tarek Elsamni') # false - It is already unlocked!
post.lock!('Tarek Elsamni') # true
post.lock!('Tarek Elsamni') # will raise LockError - already locked!
post.unlock!('Tarek Elsamni') # true - 'Tarek Elsamni' locked it!
post.unlock!('Tarek Elsamni') # will raise UnLockError - not locked!
```

Check if an object/resource is locked

```ruby
post.locked? # false
post.lock('Tarek Elsamni') # true
post.locked? # true
```

Who locked an object?

```ruby
post.lock('Tarek Elsamni') # true
post.locked? # true
post.locked_by_id # 'Tarek Elsamni'
```

Is a class lockable?

```ruby
Post.lockable? # true - an alias to Post.is_lockable?
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tareksamni/acts_as_lockable_by. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActsAsLockable project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/tareksamni/acts_as_lockable_by/blob/master/CODE_OF_CONDUCT.md).
