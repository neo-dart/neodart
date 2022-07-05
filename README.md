# neodart

_Neo_-Dart, or "new" Dart, is a series of recommended packages and principles
that break out of classic conventions ("we've always done it that way") and have
a bias towards _change_ versus stability for stability sake.

> **TIP**: Importantly, nobody should feel _forced_ to use neo-Dart conventions.
>
> We've contributed these to help others understand some of the trade-offs
> involved in building Dart/Flutter apps and libraries, but you can feel free to
> have your own opinion.
>
> Additionally, some or all of these guidelines may not apply to a short-lived
> prototype, weekend warrior project, or something that just _doesn't_ need to
> be particularly robust or contributed to by others.

## Usage

Neo-Dart is a _convention_, and you can "use" it just by reading (and
optionally, contributing) to this repository.

However, if you'd like to use a _very opiniated_ set of lints that represent the
conventions being used here:

```bash
# Add neodart as a development dependency.
dart pub add --dev neodart
```

```yaml
# analysis_options.yaml
include: package:neodart/neodart.yaml
```

These rules contain `include: package:lints/core.yaml`, and then include
_additional_ stricter lints on top of them, _always_ with a reason/rationale.

## Contributing

To contribute, simply open an issue (major discussion) or a pull request (minor
or no discussion needed, such as a spelling fix). There is no guarantee your
request will be fulfilled, but changes to the guidelines are welcome in general.

As of 2022-07-05, [github.com/matanlurey](https://github.com/matanlurey) is the
only decision maker, with hopes to expand.

### Requirements

1. Your request must have a well-documented reason beyond personal preference.
2. Your request must be communictable in written English.
3. Requests of the form "but X language/framework/library ..." are not enough.

## Principles

The following are principles of neo-Dart packages and code:

- **Do not use**: Should never occur in any code that is non-experimental.
- **Avoid**: Should rarely occur in non-experimental code; is well documented.
- **Consider**: Should be considered when appropriate.
- **Prefer**: Should be the default unless well-documented otherwise.

### Do not use `dart:mirrors`

**Enforced**: _None_. Ideally there would be a lint, so TBD.

Runtime reflection was never truly fully baked within Dart 1.x, and in modern
Dart (2.x) it is relegated as third-class citizen, no longer supported in either
Dart AOT (i.e. most Flutter binaries) or any Dart for the Web program.

In addition, even for command-line Dart JIT programs, mirrors is intentionally
no longer being supported or updated to keep up with new language paradigms or
primitives.

As a result **do not use `dart:mirrors`**, at all, even for testing. Runtime
reflection often makes it difficult for new users and maintainers of a package
and becomes overly clever. There is always a better way.

### Do not use or override `noSuchMethod`

**Enforced**: _None_. Ideally there would be a lint, so TBD.

Somewhat similar to `dart:mirrors`, is `noSuchMethod`, a user-implementable
"catch-all" for an unimplemented member on a Dart class. In modern Dart, it is
mostly used for either _stubbing_ (this class is not yet or intentionally not
implemented) or _mocking_ (i.e. with something like `package:mockito`).

Like mirrors, `noSuchMethod` has largely not caught up in the language and has
both performance (runtime and code size) costs that aren't apparent to most
developers.

There is almost always a better way than overriding `noSuchMethod`.

### Do not make dynamic calls

**Enforced**: (via optional lint)
[`avoid_dynamic_calls`](https://dart.dev/tools/linter-rules#avoid_dynamic_calls)
.

In Dart 1.x, _every_ call was a dynamic call, and type signatures were only
used for (quite limited) static analysis. Starting in Dart 2.x, _most_ calls are
static, and dynamic calls are limited only to objects (implicitly or explicitly)
typed `dynamic`.

Dynamic calls are completely avoidable technical debt, disabling any sort of
useful static analysis, making compilers work harder (and in most cases generate
slower and less compact code), and are increasingly _by_ accident.

Either use:

- `Object?` with type checks (i.e. `is`) and casting.
- Type inference, including with method generics.
- Strongly typed custom objects instead of relying on `foo.someMethod()`.

> **NOTE**: Calls to type `Function` or `Function.apply` are also dynamic calls.

### Do not use mocks

**Enforced**: (partially via lint)
[`avoid_implementing_value_types`](https://dart.dev/tools/linter-rules#avoid_implementing_value_types)
, but requires more; TBD.

Mocking, or creating short-lived proxy objects that _pretend_ to implement a
type _can_ be useful when testing certain contracts between related objects;
for example, you may want to ensure that `pet.eat(bowl)` _only_ calls the
`bowl.grab(...)` method once with specific arguments (the pet's mouth size?).

However, mocking is generally extremely over-used. Typical apps and libraries
usually have _no_ need for mocking, and would be better served either by using
the _real_ object (especially for value-type immutable objects), and/or using
or contributing to _fakes_ - intentional sub-types intended for testing.

### Avoid code generation

**Enforced**: _None_; not a hard rule and easy to catch in code review.

As a follow-up to not using `dart:mirrors`, _also_ do not use code generation.
Code generation can be a powerful tool, but is almost always overused and is not
well supported in the Dart ecosystem (as of 2022-07-05).

Why to avoid code generation:

- There is not strong support of tooling necessary; the [`build`][] ecosystem is
  considered "best effort" and is not widely used by the Dart team itself; tools
  such as the analyzer do not understand the concept of code generation.

- Code generation often produces patterns that would never be permitted within a
  codebase, but are otherwise hidden or obscured behind "generated code". Just
  because it's generated doesn't mean the code shouldn't be well understood and
  of good quality.

- Code generation is too slow to be part of most serious developer cycles; often
  taking much longer than running Dart code otherwise, particularly within the
  VM.

However, this rule is _avoid_, not _do not use_; targeted use of code generation
(i.e. to generate API clients or for JSON serialization) _is_ permitted, but
should be used _judiciously_; try developing your feature or library without
code generation and narrow down the patterns before deciding on code generation.

> **NOTE**: There is some promising upcoming language work in the form of
> [macros][] that might allow this rule to be softened in the future, but even
> with macros you'll want to be careful around overuse.

[`build`]: https://github.com/dart-lang/build
[macros]: https://github.com/dart-lang/language/blob/master/working/macros/feature-specification.md

### Avoid heavy-weight dependencies when developing a library

**Enforced**: _None_; not a hard rule and easy to catch in code review.

Dependencies are _not_ evil, they are what lets you create any non-trivial app
without spending time re-inventing the wheel (particularly important when it
comes to things like security, privacy, performance, or low-level computing).

However, be _judicious_ when adding non-development dependencies to a _library_
package, as each dependency you add will make it harder and harder for users of
_your_ library to upgrade and maintain over time. You should even _consider_
using `show` when importing symbols from other packages into your library:

```dart
import 'package:other/other.dart' show ExplicitThingIAmUsing;
```

For example, when creating a hypothetical `number_parser` class, it might be
tempting to use existing libraries for number formatting, string parsing, or
anything in-between. However, ask yourself if you _truly_ need many of the
exact features in your dependencies, or if you could get away with a smaller
(private) bespoke implementation.

> **TL;DR**: In general, try to abide by the [YAGNI][] policy.

[yagni]: https://martinfowler.com/bliki/Yagni.html

### Avoid creating classes that can or should be extended or implemented

**Enforced**: _Partially_ through the analyzer (`@sealed` and `factory`).

This is shamelessly copied from _Effective Java_ (Item 17):

> Design and document for inheritance or else prohibit it.

In Dart, there are limited mechanisms for accomplishing this outside of
documentation (i.e. `/// Do not extend this class`), but some suggestions are:

- Use [`@sealed`][] from `package:meta`; prohibits most kinds of inheritance:

  ```dart
  import 'package:meta/meta.dart';

  @sealed
  class Animal {
    final String name;

    Animal(this.name);
  }
  ```

- Ensure all your public constructors are `factory` constructors:

  ```dart
  class Animal {
    final String name;

    // Factory constructors cannot be called/used by super-classes.
    factory Animal(String name) = Animal._;

    // Having a private constructor prevents `extends` and `with` (mixins).
    Animal._(this.name);
  }
  ```

[`@sealed`]: https://pub.dev/documentation/meta/latest/meta/sealed-constant.html

### Avoid mutable objects in public APIs

**Enforced**: _None_. Ideally there would be a lint, so TBD.

It's not desirable to _completely_ avoid mutable state and APIs; at the end of
the day all immutability is an abstraction.

However, for _public_ APIs, design for _immutability_ unless mutability is
required (i.e. for performance or correctness reasons). _Avoid_ mutating objects
that provided to you (unless explicitly documenting you will mutate them):

```dart
/// Removes elements from [names] that match our explicit name filter.
void removeExplicit(Set<String> names) {
  // OK: Documented in the public API that "names" will be mutated.
}
```
