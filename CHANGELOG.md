# Changelog

## [2.1.0] - 2024-04-20

- Adds conversion back to a hash with `to_h` and `to_dot_h` for enumeration.

## [2.0.0] - 2024-04-20

- Completely rewrite internals and remove Active Support as a dependency
  (this means HashWithDotAccess::Hash supports string, symbol, and dot access with zero dependencies)
- Dot access now writes accessors to the class, improving performance (`method_missing` only runs once per key/accessor, essentially)

## [1.2.0] - 2021-12-16

- Support Rails 7
