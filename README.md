# Hash with Dot Access

Rails' ActiveSupport gem provides `HashWithIndifferentAccess` which allows you to access hash keys with either strings or symbols. This gem provides `HashWithDotAccess` which subclasses `HashWithIndifferentAccess` and allows you to access or set those keys using dot access (aka methods). It utilizes `method_missing` to access key data if available, and you can also set data using `keyname=`.

## Example

```ruby
require "hash_with_dot_access"
 
hsh = HashWithDotAccess::Hash.new({a: 1, b: 2, c: "abc"})
# => {"a"=>1, "b"=>2, "c"=>"abc"}

hsh.a
# => 1

hsh.c
# => "abc"

hsh.d = "Indeed!"
hsh.d
# => "Indeed!"

hsh[:d]
# => "Indeed!"

hsh["d"]
# => "Indeed!"

hsh2 = {test: "dot access"}.with_dot_access
hsh2.test
# => "dot access"

## Nested hashes work too! Pairs nicely with lonely operator: &.

nested = {a: 1, b: {c: 3}}.with_dot_access
nested.b.c
# => 3

nested&.d&.e&.f
# => nil

## You can also set default return values when key is missing

hsh = {a: 1, b: 2}.with_dot_access
hsh.default = 0
hsh.a
# => 1
hsh.x
# => 0
```

## Installation

Add this line to your application's Gemfile:

```
$ bundle add hash_with_dot_access
```

Then simply require `hash_with_dot_access`:

```ruby
require "hash_with_dot_access"
```

## Caveats

As with any Ruby object which provides arbitrary data through dynamic method calls, you may encounter collisions between your key names and existing `Hash` methods. For example:

```ruby
hsh = {each: "this won't work!"}.with_dot_access
hsh.each
# => #<Enumerator: {"each"=>"this won't work!"}:each>
#
# Uh oh!
```

Of course, the easy fix is to simply use standard ways of accessing hash data in these cases:

```ruby
hsh = {each: "this will work!"}.with_dot_access
hsh[:each]
# => "this will work!"
```

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bridgetownrb/hash_with_dot_access.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Hash with Dot Access project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bridgetownrb/hash_with_dot_access/blob/main/CODE_OF_CONDUCT.md).
