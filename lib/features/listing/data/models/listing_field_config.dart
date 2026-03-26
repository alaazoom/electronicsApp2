import 'package:equatable/equatable.dart';

enum ListingFieldType { text, number, selection }

class ListingFieldConfig extends Equatable {
  /// Attribute ID from backend, reused as key in draft map.
  final String key;
  final String attributeId;
  final String label;
  final String hint;
  final bool required;
  final ListingFieldType type;
  final List<String> options;
  final String legacyKey;

  const ListingFieldConfig({
    required this.key,
    required this.attributeId,
    required this.label,
    this.hint = '',
    this.required = false,
    this.type = ListingFieldType.text,
    this.options = const [],
    this.legacyKey = '',
  });

  @override
  List<Object?> get props => [
    key,
    attributeId,
    label,
    hint,
    required,
    type,
    options,
    legacyKey,
  ];
}

class ListingCategoryConfig extends Equatable {
  final String id;
  final String name;
  final String icon;
  final List<ListingFieldConfig> fields;

  const ListingCategoryConfig({
    required this.id,
    required this.name,
    required this.icon,
    required this.fields,
  });

  @override
  List<Object?> get props => [id, name, icon, fields];
}
