/// A simple command-line tool that generates an `analysis_options.yaml` file.
///
/// ```bash
/// $ dart tool/lints.dart
/// $ dart tool/lints.dart > lib/neodart.yaml
/// ```
library neodart.tool.lints;

import 'dart:io';

void main(List<String> args) {
  if (args.isNotEmpty) {
    stderr.writeln('Usage: dart tool/lints.dart');
    exit(1);
  }

  var spaces = 0;

  final output = StringBuffer();
  void write(String line) {
    output.writeln('${' ' * spaces}$line');
  }

  write('# AUTO-GENERATED. DO NOT EDIT. See tool/lints.dart');
  write('');
  write('include: package:lints/recommended.yaml');
  write('');

  write('analyzer:');

  spaces += 2;
  write('language:');

  spaces += 2;
  _languageRules.forEach((name, value) {
    write('$name: $value');
  });
  spaces -= 2;

  write('errors:');
  spaces += 2;
  for (final lint in _lints.toList()
    ..sort((a, b) => a.name.compareTo(b.name))) {
    if (lint.severity != _Severity.info) {
      write('${lint.name}: ${lint.severity.name}');
    }
  }
  spaces -= 2;

  spaces -= 2;
  write('');

  write('linter:');
  spaces += 2;
  write('rules:');
  spaces += 2;
  for (final lint in _lints) {
    write('# https://dart-lang.github.io/linter/lints/${lint.name}');
    write('# ${lint.reason}');
    write('- ${lint.name}');
  }
  spaces -= 2;
  spaces -= 2;

  if (args.isEmpty) {
    stdout.write(output);
  }
}

const _consistentStyleIsImportant = 'Consistent style is important';

const _languageRules = <String, Object?>{
  'strict-casts': true,
  'strict-inference': true,
  'strict-raw-types': true,
};

const _lints = [
  _Lint(
    name: 'avoid_dynamic_calls',
    severity: _Severity.warning,
    reason: 'Neo-Dart Principle: Do not make dynamic calls',
  ),
  _Lint(
    name: 'comment_references',
    reason: 'Dartdoc comments should either work or not be used',
  ),
  _Lint(
    name: 'no_adjacent_strings_in_list',
    reason: 'Common source of subtle bugs',
  ),
  _Lint(
    name: 'always_put_required_named_parameters_first',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'avoid_bool_literals_in_conditional_expressions',
    reason: 'Usually a misunderstanding of boolean expressions',
  ),
  _Lint(
    name: 'avoid_catches_without_on_clauses',
    reason: 'Unconditional try-catch is rarely what you want',
  ),
  _Lint(
    name: 'avoid_catching_errors',
    reason: 'Errors are not intended to be caught in standard programming',
  ),
  _Lint(
    name: 'avoid_classes_with_only_static_members',
    reason: 'Now with proper enums and extension methods should be rare',
  ),
  _Lint(
    name: 'avoid_double_and_int_checks',
    reason: 'Will behave differently on the web/JS',
  ),
  _Lint(
    name: 'avoid_equals_and_hash_code_on_mutable_classes',
    reason: 'Common source of subtle bugs as collections do not re-hash',
  ),
  _Lint(
    name: 'avoid_escaping_inner_quotes',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'avoid_field_initializers_in_const_classes',
    reason: 'Using an explicit field is limiting compared to a getter',
  ),
  _Lint(
    name: 'avoid_final_parameters',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'avoid_implementing_value_types',
    reason: 'Neo-Dart Principle: Avoid inheritance and mocking',
  ),
  _Lint(
    name: 'avoid_js_rounded_ints',
    reason: 'Will behave differently on the web/JS',
  ),
  _Lint(
    name: 'avoid_multiple_declarations_per_line',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'avoid_positional_boolean_parameters',
    reason: 'Usually the sign of a confusing API',
  ),
  _Lint(
    name: 'avoid_private_typedef_functions',
    reason: 'Better served by a function type',
  ),
  _Lint(
    name: 'avoid_redundant_argument_values',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'avoid_renaming_method_parameters',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'avoid_setters_without_getters',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'avoid_types_on_closure_parameters',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'avoid_unused_constructor_parameters',
    reason: 'YAGNI',
  ),
  _Lint(
    name: 'cascade_invocations',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'cast_nullable_to_non_nullable',
    reason: 'Common source of subtle bugs',
  ),
  _Lint(
    name: 'conditional_uri_does_not_exist',
    reason: 'Avoids clear mistakes',
  ),
  _Lint(
    name: 'deprecated_consistency',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'directives_ordering',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'do_not_use_environment',
    reason: 'Confusing and error-prone',
  ),
  _Lint(
    name: 'noop_primitive_operations',
    reason: 'Avoids clear mistakes',
  ),
  _Lint(
    name: 'omit_local_variable_types',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'only_throw_errors',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'package_api_docs',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'parameter_assignments',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'prefer_asserts_with_message',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'prefer_const_constructors',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'prefer_const_constructors_in_immutables',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'prefer_const_declarations',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'prefer_const_literals_to_create_immutables',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'prefer_final_fields',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'prefer_final_in_for_each',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'prefer_final_locals',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'prefer_generic_function_type_aliases',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'prefer_mixin',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'prefer_single_quotes',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'public_member_api_docs',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'unawaited_futures',
    reason: 'Avoids clear mistakes',
  ),
  _Lint(
    name: 'unnecessary_await_in_return',
    reason: 'No effect',
  ),
  _Lint(
    name: 'unnecessary_lambdas',
    reason: 'No effect',
  ),
  _Lint(
    name: 'unnecessary_overrides',
    reason: 'No effect',
  ),
  _Lint(
    name: 'unnecessary_parenthesis',
    reason: 'No effect',
  ),
  _Lint(
    name: 'unnecessary_raw_strings',
    reason: 'No effect',
  ),
  _Lint(
    name: 'use_enums',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'use_named_constants',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'use_late_for_private_fields_and_variables',
    reason: _consistentStyleIsImportant,
  ),
  _Lint(
    name: 'secure_pubspec_urls',
    reason: 'Security is important',
  ),
  _Lint(
    name: 'sort_pub_dependencies',
    reason: _consistentStyleIsImportant,
  )
];

/// A lint rule that will be enforced by the generated YAML file.
class _Lint {
  /// Name of the rule (i.e. `annotate_overrides`).
  final String name;

  /// Severity of the rule.
  final _Severity severity;

  /// Human-readable description of why the rule is being enforced.
  final String reason;

  const _Lint({
    required this.name,
    required this.reason,
    this.severity = _Severity.info,
  });
}

enum _Severity {
  info,
  warning,
}
