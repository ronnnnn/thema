import 'dart:async';

import 'package:collection/collection.dart';
import 'package:macros/macros.dart';

final _flutterMaterial = Uri.parse('package:flutter/material.dart');
final _dartCore = Uri.parse('dart:core');

macro class Thema
    implements ClassTypesMacro, ClassDeclarationsMacro, ClassDefinitionMacro {
  const Thema();

  @override
  FutureOr<void> buildTypesForClass(
    ClassDeclaration clazz,
    ClassTypeBuilder builder,
  ) async {
    final superType =
        await builder.resolveIdentifier(_flutterMaterial, 'ThemeExtension');
    final superTypeCode = NamedTypeAnnotationCode(
      name: superType,
      typeArguments: [
        RawTypeAnnotationCode.fromString(clazz.identifier.name),
      ],
    );

    builder.extendsType(superTypeCode);
  }

  @override
  FutureOr<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    final hasUnexpetedFields =
        !await _validateFields(clazz: clazz, builder: builder);
    if (hasUnexpetedFields) return;

    await _declareConstractor(clazz: clazz, builder: builder);

    await (
      _declareCopyWith(clazz: clazz, builder: builder),
      _declareLeap(clazz: clazz, builder: builder),
    ).wait;
  }

  @override
  FutureOr<void> buildDefinitionForClass(
    ClassDeclaration clazz,
    TypeDefinitionBuilder builder,
  ) async {
    await (
      _defineCopyWith(clazz: clazz, typeDefinisionBuilder: builder),
      _defineLeap(clazz: clazz, typeDefinisionBuilder: builder),
    ).wait;
  }

  Future<bool> _validateFields({
    required ClassDeclaration clazz,
    required MemberDeclarationBuilder builder,
  }) async {
    final fields = await builder.fieldsOf(clazz);
    final hasUnexpectedFields = fields.any((field) =>
        field.hasAbstract ||
        field.hasConst ||
        field.hasExternal ||
        !field.hasFinal ||
        field.hasInitializer ||
        field.hasLate ||
        field.hasStatic ||
        field.type.isNullable);
    if (hasUnexpectedFields) {
      builder.report(
        Diagnostic(
          DiagnosticMessage(
            'Class contains unexpected fields to construst ThemeExtension.',
          ),
          Severity.error,
        ),
      );
      return false;
    }

    return true;
  }

  Future<void> _declareConstractor({
    required ClassDeclaration clazz,
    required MemberDeclarationBuilder builder,
  }) async {
    final fields = await builder.fieldsOf(clazz);
    final constructorParameterCodes = fields
        .map((field) => RawCode.fromParts([
              'required',
              ' ',
              field.identifier,
            ]))
        .toList();
    final constructorName = clazz.identifier.name;
    final constructorCode = DeclarationCode.fromParts(
      [
        'const $constructorName({'.indent(),
        ...constructorParameterCodes.trailingComma().indent(size: 4),
        '});'.indent(),
      ].joinAsCode('\n'),
    );
    builder.declareInType(constructorCode);
  }

  Future<void> _declareCopyWith({
    required ClassDeclaration clazz,
    required MemberDeclarationBuilder builder,
  }) async {
    final fields = await builder.fieldsOf(clazz);
    final copyWithParameterCodes = fields
        .map(
          (field) => ParameterCode(
            type: NullableTypeAnnotationCode(field.type.code),
            name: field.identifier.name,
          ),
        )
        .toList();
    final copyWithFunctionCode = DeclarationCode.fromParts(
      [
        RawCode.fromParts([clazz.identifier, ' ', 'copyWith({']).indent(),
        ...copyWithParameterCodes.trailingComma().indent(size: 4),
        '});'.indent(),
      ].joinAsCode('\n'),
    );
    builder.declareInType(copyWithFunctionCode);
  }

  Future<void> _declareLeap({
    required ClassDeclaration clazz,
    required MemberDeclarationBuilder builder,
  }) async {
    final doubleIdentifier =
        await builder.resolveIdentifier(_dartCore, 'double');
    final leapFirstParameterCode = ParameterCode(
      keywords: ['covariant'],
      type: NullableTypeAnnotationCode(
        NamedTypeAnnotationCode(name: clazz.identifier),
      ),
      name: 'other',
    );
    final leapSecondParameterCode = ParameterCode(
      type: NamedTypeAnnotationCode(name: doubleIdentifier),
      name: 't',
    );
    final leapParameterCodes = [
      leapFirstParameterCode,
      leapSecondParameterCode,
    ].toList();
    final leapFunctionCode = DeclarationCode.fromParts(
      [
        RawCode.fromParts([
          clazz.identifier,
          ' ',
          'lerp(',
        ]).indent(),
        ...leapParameterCodes.trailingComma().indent(size: 4),
        ');'.indent(),
      ].joinAsCode('\n'),
    );
    builder.declareInType(leapFunctionCode);
  }

  Future<void> _defineCopyWith({
    required ClassDeclaration clazz,
    required TypeDefinitionBuilder typeDefinisionBuilder,
  }) async {
    final methods = await typeDefinisionBuilder.methodsOf(clazz);
    final copyWithDeclaration = methods
        .firstWhereOrNull((method) => method.identifier.name == 'copyWith');
    if (copyWithDeclaration == null) return;

    final fields = await typeDefinisionBuilder.fieldsOf(clazz);
    final instancePareterCodes = fields.map(
      (field) {
        final fieldName = field.identifier.name;
        return RawCode.fromParts([
          '$fieldName:',
          ' ',
          '$fieldName',
          ' ?? ',
          field.identifier,
        ]);
      },
    ).toList();
    final copyWithFunctionBodyCode = FunctionBodyCode.fromParts([
      '{',
      RawCode.fromParts([
        'return',
        ' ',
        clazz.identifier,
        '(',
      ]).indent(size: 4),
      ...instancePareterCodes.trailingComma().indent(size: 6),
      ');'.indent(size: 4),
      '}'.indent(),
    ].joinAsCode('\n'));

    final builder =
        await typeDefinisionBuilder.buildMethod(copyWithDeclaration.identifier);
    builder.augment(copyWithFunctionBodyCode);
  }

  Future<void> _defineLeap({
    required ClassDeclaration clazz,
    required TypeDefinitionBuilder typeDefinisionBuilder,
  }) async {
    final methods = await typeDefinisionBuilder.methodsOf(clazz);
    final leapDeclaration =
        methods.firstWhereOrNull((method) => method.identifier.name == 'lerp');
    if (leapDeclaration == null) return;

    final leapReturnTypeCode = NamedTypeAnnotationCode(name: clazz.identifier);
    final leapFirstParameterCode = ParameterCode(
      keywords: ['covariant'],
      type: NullableTypeAnnotationCode(leapReturnTypeCode),
      name: 'other',
    );
    final themeExtensionIdentifier = await typeDefinisionBuilder
        .resolveIdentifier(_flutterMaterial, 'ThemeExtension');
    final doubleIdentifier =
        await typeDefinisionBuilder.resolveIdentifier(_dartCore, 'double');
    final leapSecondParameterCode = ParameterCode(
      type: NamedTypeAnnotationCode(name: doubleIdentifier),
      name: 't',
    );
    final fields = await typeDefinisionBuilder.fieldsOf(clazz);
    final instancePareterCodes = await Future.wait(fields.map((field) async {
      final fieldName = field.identifier.name;
      final fieldTypeCode = field.type.code;
      final fieldStaticType =
          await typeDefinisionBuilder.resolve(fieldTypeCode);
      final themeExtensionStaticType = await typeDefinisionBuilder
          .resolve(NamedTypeAnnotationCode(name: themeExtensionIdentifier));
      if (await fieldStaticType.isSubtypeOf(themeExtensionStaticType)) {
        return RawCode.fromParts(
          [
            '$fieldName:',
            ' ',
            field.identifier,
            '.lerp(${leapFirstParameterCode.name}.$fieldName, ${leapSecondParameterCode.name})',
          ],
        );
      }

      return RawCode.fromParts(
        [
          '$fieldName: ',
          fieldTypeCode,
          '.lerp(',
          field.identifier,
          ', ${leapFirstParameterCode.name}.$fieldName, ${leapSecondParameterCode.name})!',
        ],
      );
    }));
    final leapFunctionBodyCode = FunctionBodyCode.fromParts([
      '{',
      RawCode.fromParts([
        'if (${leapFirstParameterCode.name} == null) {'.indent(size: 4),
        'return this;'.indent(size: 6),
        '}'.indent(size: 4),
      ].joinAsCode('\n')),
      RawCode.fromParts(['return', ' ', clazz.identifier, '(']).indent(size: 4),
      ...instancePareterCodes.trailingComma().indent(size: 6),
      ');'.indent(size: 4),
      '}'.indent(),
    ].joinAsCode('\n'));

    final builder =
        await typeDefinisionBuilder.buildMethod(leapDeclaration.identifier);
    builder.augment(leapFunctionBodyCode);
  }
}

extension _Indent<T extends Object> on T {
  Code indent({int size = 2}) {
    return RawCode.fromParts([
      ' ' * size,
      this,
    ]);
  }
}

extension _Indents<T extends Object> on List<T> {
  List<Code> indent({int size = 2}) {
    return this.map((element) => element.indent(size: size)).toList();
  }
}

extension _Commas<T extends Object> on List<T> {
  List<Code> trailingComma() {
    return this.map((element) => RawCode.fromParts([element, ','])).toList();
  }
}
