import '../../domain/entities/market.dart';
import '../database/app_database.dart';

/// Market Model - Data Transfer Object
class MarketModel extends Market {
  const MarketModel({
    required super.id,
    required super.name,
    super.address,
    required super.createdAt,
    required super.updatedAt,
  });

  /// From Entity
  factory MarketModel.fromEntity(Market entity) {
    return MarketModel(
      id: entity.id,
      name: entity.name,
      address: entity.address,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// From Database Row
  factory MarketModel.fromDatabase(MarketsTableData data) {
    return MarketModel(
      id: data.id,
      name: data.name,
      address: data.address,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  /// From JSON (Firebase)
  factory MarketModel.fromJson(Map<String, dynamic> json) {
    return MarketModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// To JSON (Firebase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// To Entity
  Market toEntity() {
    return Market(
      id: id,
      name: name,
      address: address,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
