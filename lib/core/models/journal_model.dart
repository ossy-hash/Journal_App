import 'package:uuid/uuid.dart';

class JournalModel {
  final String id;
  final String title;
  final String content; // JSON string for rich text
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFavorite;
  final List<String> tags;
  final String userId;
  final bool isSynced;

  JournalModel({
    String? id,
    required this.title,
    required this.content,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isFavorite = false,
    List<String>? tags,
    required this.userId,
    this.isSynced = false,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        tags = tags ?? [];

  // Convert to JSON for Supabase
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'is_favorite': isFavorite,
        'tags': tags,
        'user_id': userId,
      };

  // Create from JSON
  factory JournalModel.fromJson(Map<String, dynamic> json) => JournalModel(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        isFavorite: json['is_favorite'] ?? false,
        tags: List<String>.from(json['tags'] ?? []),
        userId: json['user_id'],
        isSynced: true,
      );

  // Copy with method for immutability
  JournalModel copyWith({
    String? title,
    String? content,
    bool? isFavorite,
    List<String>? tags,
    bool? isSynced,
  }) {
    return JournalModel(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      isFavorite: isFavorite ?? this.isFavorite,
      tags: tags ?? this.tags,
      userId: userId,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}