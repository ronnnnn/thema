import 'dart:async';

import 'package:macros/macros.dart';

final _flutterMaterial = Uri.parse('package:flutter/material.dart');

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

    final copyWithReturnType = await builder.resolveIdentifier(_flutterMaterial, 'ThemeExtension');
    final copyWithReturnTypeCode = NamedTypeAnnotationCode(
        name: copyWithReturnType,
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
    final copyWithFunctionCode = DeclarationCode.fromParts(
      [
        '  ',
        copyWithReturnTypeCode,
        'copyWith({\n',
        ...copyWithParameterCodes.joinAsCode(',\n'),
        '  }) {\n',
        '    return $constructorName(\n',
        ...instiatePareterCodes.joinAsCode(',\n'),
        '    );\n',
        '  }',
      ],
    );
    builder.declareInType(copyWithFunctionCode);
  }
}