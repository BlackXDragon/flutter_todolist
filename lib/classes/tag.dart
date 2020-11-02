import 'package:flutter/material.dart';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

class Tag {
  String name = '';
  Color color = Colors.grey;

  Tag(this.name, {this.color});

  Tag.fromJSON(json)
    : name = json['name'],
      color = (json['color'] == 'null')? Colors.grey : HexColor.fromHex(json['color']);

  Map<String, dynamic> toJSON() {
    return {
    'name': name,
    'color': ((this.color != null)? this.color.toHex(): 'null')
    };
  }

  String toString() {
    return '<Tag ' + this.name + ',' + ((this.color != null)? this.color.toHex(): 'null') + '>';
  }
}