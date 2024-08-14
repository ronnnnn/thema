import 'dart:async';

import 'package:macros/macros.dart';

final _flutterMaterial = Uri.parse('package:flutter/material.dart');
final _dartCore = Uri.parse('dart:core');

macro class Thema implements ClassTypesMacro, ClassDeclarationsMacro {
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
    final instiatePareterCodes = fields.map((field) {
      final fieldName = field.identifier.name;
      return DeclarationCode.fromString(
        '$fieldName: $fieldName ?? this.$fieldName',
      );
    },
    ).toList();
    final copyWithFunctionBodyCode = FunctionBodyCode.fromParts([
        '    return $constructorName(\n',
        ...instiatePareterCodes.joinAsCode(',\n'),
        '    );\n',
    ]);
    final copyWithFunctionCode = DeclarationCode.fromParts(
      [
        '  ',
        copyWithReturnTypeCode,
        ' copyWith({\n',
        ...copyWithParameterCodes.joinAsCode(',\n'),
        '  }) {\n',
        copyWithFunctionBodyCode,
        '  }',
      ],
    );
    builder.declareInType(copyWithFunctionCode);

    final leapReturnTypeCode = NamedTypeAnnotationCode(
        name: themeExtensionIdentifier,
        typeArguments: [
          RawTypeAnnotationCode.fromString(constructorName),
        ],
      );
    final doubleIdentifier = await builder.resolveIdentifier(_dartCore, 'double');
    final leapParameterCodes = [
      ParameterCode(
        keywords: ['covariant'],
        type: NullableTypeAnnotationCode(leapReturnTypeCode),
        name: 'other',
      ),
      ParameterCode(
        type: NamedTypeAnnotationCode(name: doubleIdentifier),
        name: 't',
      ),
    ].toList();
    final leapFunctionBodyCode = FunctionBodyCode.fromParts([
        '    if (other is! $constructorName) {\n',
        '      return this;\n',
        '    }\n',
        '    return $constructorName(\n',
        ...(await Future.wait(fields.map((field) async {
          final fieldName = field.identifier.name;
          final fieldTypeCode = field.type.code;

            return DeclarationCode.fromParts(
              [
                '$fieldName: ',
                fieldTypeCode,
                '.lerp(this.$fieldName, other.$fieldName, t)!',
              ],
            );
        }).toList())).joinAsCode(',\n'),
        '    );\n',
    ]);
    final leapFunctionCode = DeclarationCode.fromParts(
      [
        '  ',
        leapReturnTypeCode,
        ' lerp(',
        ...leapParameterCodes.joinAsCode(',\n'),
        ') {\n',
        leapFunctionBodyCode,
        '  }',
      ],
    );

    builder.declareInType(leapFunctionCode);
  }
}