import 'package:macros/macros.dart';

final _dartCore = Uri.parse('dart:core');

macro class Hello implements ClassDeclarationsMacro {
  const Hello();

  @override
  Future<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    final fields = await builder.fieldsOf(clazz);
    final fieldsString = fields.map((f) => f.identifier.name).join(', ');

    final print = await builder.resolveIdentifier(_dartCore, 'print');

    builder.declareInType(
      DeclarationCode.fromParts([
        'void hello() {',
        print,
        '("Hello! I am ${clazz.identifier.name}. I have $fieldsString.");}',
      ]),
    );
  }
}
