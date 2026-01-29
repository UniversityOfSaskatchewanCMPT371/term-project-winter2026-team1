class CounterEntity {
  // Counter id (UUID).
  final String id;

  // The counter's current value.
  final int count;

  // The ID of the user who owns this counter.
  final String? ownerId;

  // The creation timestamp.
  final DateTime createdAt;
  // The modification timestamp
  final DateTime modifiedAt;

  CounterEntity({
    required this.id,
    required this.count,
    required this.ownerId,
    required this.createdAt,
    required this.modifiedAt,
  });
}