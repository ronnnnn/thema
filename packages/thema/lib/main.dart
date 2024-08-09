import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:json/json.dart';
import 'package:thema/hello.dart';
import 'package:thema/thema.dart';

@JsonCodable()
@Hello()
class User {
  final int? age;
  final String name;
  final String username;
}

@Thema()
class ColorThemeExt {
  final Color primary;
  final Color secondary;
  final Color accent;
}

void main() {
  // Given some arbitrary JSON:
  var userJson = {'age': 5, 'name': 'Roger', 'username': 'roger1337'};

  // Use the generated members:
  var user = User.fromJson(userJson);
  print(user);
  print(user.toJson());
}
