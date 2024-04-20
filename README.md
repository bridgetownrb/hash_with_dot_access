# Hash with Dot Access

This gem provides a Ruby `Hash` subclass which lets you access hash values with either string or symbol keys, as well as via methods (aka dot access). It utilizes `method_missing` to access key data if available, and you can also set data using `keyname=`. Our goal is on providing good performance and if anything offering a _subset_ of standard Hash functionality (it's a non-goal to add all-new Hash-related functionality to this class).

Performance is improved over long-running processes (such as the build process of the [Bridgetown](https://www.bridgetownrb.com) framework) by automatically defining accessors on the class so that `method_missing` is only called once per key/accessor pair.

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

# You can use the `as_dots` method on Hash by loading in our refinement.

using HashWithDotAccess::Refinements

hsh2 = {test: "dot access"}.as_dots
hsh2.test
# => "dot access"

## Nested hashes work too! Pairs nicely with lonely operator: &.

nested = {a: 1, b: {c: 3}}.as_dots
nested.b.c
# => 3

nested&.d&.e&.f
# => nil

## You can also set default return values when key is missing

hsh = {a: 1, b: 2}.as_dots
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

> [!IMPORTANT]
> If you're upgrading from an earlier version, and you don't want to modify your code away from using `with_dot_access`, you can add a monkey-patch to `Hash`:
> ```ruby
> class Hash
>   def with_dot_access
>     HashWithDotAccess::Hash.new(self)
>   end
> end
> ```

## Caveats

As with any Ruby object which provides arbitrary data through dynamic method calls, you may encounter collisions between your key names and existing `Hash` methods. For example:

```ruby
hsh = {each: "this won't work!"}.as_dots
hsh.each
# => #<Enumerator: {"each"=>"this won't work!"}:each>
#
# Uh oh!
```

Of course, the easy fix is to simply use standard ways of accessing hash data in these cases:

```ruby
hsh = {each: "this will work!"}.as_dots
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
