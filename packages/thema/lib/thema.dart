import 'dart:async';

import 'package:collection/collection.dart';
import 'package:macros/macros.dart';

final _flutterMaterial = Uri.parse('package:flutter/material.dart');
final _dartCore = Uri.parse('dart:core');

macro class Thema implements ClassTypesMacro, ClassDeclarationsMacro, ClassDefinitionMacro {
  const Thema();

  @override
  FutureOr<void> buildTypesForClass(ClassDeclaration clazz, ClassTypeBuilder builder) async {
    final superType = await builder.resolveIdentifier(_flutterMaterial, 'ThemeExtension');
    final superTypeCode = NamedTypeAnnotationCode(
        name: superType,
        typeArguments: [
          RawTypeAnnotationCode.fromString(clazz.identifier.name),
        ],
      );

    builder.extendsType(superTypeCode);
  }

  @override
  FutureOr<void> buildDeclarationsForClass(ClassDeclaration clazz, MemberDeclarationBuilder builder) async {
    await _declareConstractor(clazz: clazz, builder: builder);

    await (
      _declareCopyWith(clazz: clazz, builder: builder),
      _declareLeap(clazz: clazz, builder: builder),
    ).wait;
  }

  @override
  FutureOr<void> buildDefinitionForClass(ClassDeclaration clazz, TypeDefinitionBuilder builder) async {
    await (
      _defineCopyWith(clazz: clazz, typeDefinisionBuilder: builder),
      _defineLeap(clazz: clazz, typeDefinisionBuilder: builder),
    ).wait;
  }

  Future<void> _declareConstractor({
    required ClassDeclaration clazz,
    required MemberDeclarationBuilder builder,
  }) async {
    final fields = await builder.fieldsOf(clazz);
    final constructorParameterCodes = fields.map((field) =>
     ParameterCode(
      keywords: ['required'],
      name: "this.${field.identifier.name}",
    ),
    ).toList();
    final constructorName = clazz.identifier.name;
    final constructorCode = DeclarationCode.fromParts(
      [
        '  const $constructorName({\n',
        ...constructorParameterCodes.joinAsCode(',\n'),
        '  });',
      ],
    );
    builder.declareInType(constructorCode);
  }

  Future<void> _declareCopyWith({
    required ClassDeclaration clazz,
    required MemberDeclarationBuilder builder,
  }) async {
    final fields = await builder.fieldsOf(clazz);
    final themeExtensionIdentifier = await builder.resolveIdentifier(_flutterMaterial, 'ThemeExtension');
    final copyWithReturnTypeCode = NamedTypeAnnotationCode(
        name: themeExtensionIdentifier,
        typeArguments: [
          RawTypeAnnotationCode.fromString(clazz.identifier.name),
        ],
      );
    final copyWithParameterCodes = fields.map((field) =>
     ParameterCode(
      type: NullableTypeAnnotationCode(field.type.code),
      name: field.identifier.name,
    ),
    ).toList();
    final copyWithFunctionCode = DeclarationCode.fromParts(
      [
        '  ',
        copyWithReturnTypeCode,
        ' copyWith({\n',
        ...copyWithParameterCodes.joinAsCode(',\n'),
        '  });',
      ],
    );
    builder.declareInType(copyWithFunctionCode);
  }

  Future<void> _declareLeap({
    required ClassDeclaration clazz,
    required MemberDeclarationBuilder builder,
  }) async {
    final leapReturnTypeCode = NamedTypeAnnotationCode(name: clazz.identifier);
    final doubleIdentifier = await builder.resolveIdentifier(_dartCore, 'double');
    final leapFirstParameterCode = ParameterCode(
      keywords: ['covariant'],
      type: NullableTypeAnnotationCode(leapReturnTypeCode),
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
        '  ',
        leapReturnTypeCode,
        ' lerp(',
        ...leapParameterCodes.joinAsCode(',\n'),
        ');',
      ],
    );
    builder.declareInType(leapFunctionCode);
  }

  Future<void> _defineCopyWith({
    required ClassDeclaration clazz,
    required TypeDefinitionBuilder typeDefinisionBuilder,
  }) async {
    final methods = await typeDefinisionBuilder.methodsOf(clazz);
    final copyWithDeclaration = methods.firstWhereOrNull((method) => method.identifier.name == 'copyWith');
    if (copyWithDeclaration == null) return;

    final fields = await typeDefinisionBuilder.fieldsOf(clazz);
    final instiatePareterCodes = fields.map((field) {
      final fieldName = field.identifier.name;
      return DeclarationCode.fromString(
        '$fieldName: $fieldName ?? this.$fieldName',
      );
    },
    ).toList();
    final constructorName = clazz.identifier.name;
    final copyWithFunctionBodyCode = FunctionBodyCode.fromParts([
        '  {\n',
        '    return $constructorName(\n',
        ...instiatePareterCodes.joinAsCode(',\n'),
        '    );\n',
        '  }',
    ]);

    final builder = await typeDefinisionBuilder.buildMethod(copyWithDeclaration.identifier);
    builder.augment(copyWithFunctionBodyCode);
  }

  Future<void> _defineLeap({
    required ClassDeclaration clazz,
    required TypeDefinitionBuilder typeDefinisionBuilder,
  }) async {
    final methods = await typeDefinisionBuilder.methodsOf(clazz);
    final leapDeclaration = methods.firstWhereOrNull((method) => method.identifier.name == 'lerp');
    if (leapDeclaration == null) return;

    final leapReturnTypeCode = NamedTypeAnnotationCode(name: clazz.identifier);
    final leapFirstParameterCode = ParameterCode(
      keywords: ['covariant'],
      type: NullableTypeAnnotationCode(leapReturnTypeCode),
      name: 'other',
    );
    final themeExtensionIdentifier = await typeDefinisionBuilder.resolveIdentifier(_flutterMaterial, 'ThemeExtension');
    final doubleIdentifier = await typeDefinisionBuilder.resolveIdentifier(_dartCore, 'double');
    final leapSecondParameterCode = ParameterCode(
      type: NamedTypeAnnotationCode(name: doubleIdentifier),
      name: 't',
    );
    final constructorName = clazz.identifier.name;
    final fields = await typeDefinisionBuilder.fieldsOf(clazz);
    final leapFunctionBodyCode = FunctionBodyCode.fromParts([
        '  {\n',
        '    if (${leapFirstParameterCode.name} == null) {\n',
        '      return this;\n',
        '    }\n',
        '    return $constructorName(\n',
        ...(await Future.wait(fields.map((field) async {
          final fieldName = field.identifier.name;
          final fieldTypeCode = field.type.code;

          final fieldStaticType = await typeDefinisionBuilder.resolve(fieldTypeCode);
          final themeExtensionStaticType = await typeDefinisionBuilder.resolve(NamedTypeAnnotationCode(name: themeExtensionIdentifier));
          if (await fieldStaticType.isSubtypeOf(themeExtensionStaticType)) {
            return DeclarationCode.fromParts(
              [
                '$fieldName: ',
                'this.$fieldName.lerp(${leapFirstParameterCode.name}.$fieldName, ${leapSecondParameterCode.name})',
              ],
            );
          }

          return DeclarationCode.fromParts(
            [
              '$fieldName: ',
              fieldTypeCode,
              '.lerp(this.$fieldName, ${leapFirstParameterCode.name}.$fieldName, ${leapSecondParameterCode.name})!',
            ],
          );
        }).toList())).joinAsCode(',\n'),
        '    );\n',
        '  }',
    ]);

    final builder = await typeDefinisionBuilder.buildMethod(leapDeclaration.identifier);
    builder.augment(leapFunctionBodyCode);
  }
}
