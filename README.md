# Sqlighter

schema definition for static sqlite dbs. Define you sqlite database with one hash.

best for small static website projects where the db is included in the repository.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sqlighter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sqlighter

## Usage

```ruby
sl = Sqlighter.new("test.db")
sl.schema({
  test_table: {
    col1: [ "VARCHAR(100)" ],
    col2: [ "VARCHAR(101)" ]
  }
})
```

## ToDo

- delete fields
- change rows


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/sqlighter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
