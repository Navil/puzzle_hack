import 'sand_position.dart';

class SandMovement {
  const SandMovement(
      {required this.from, required this.to, required this.speed});

  final SandPosition from;
  final SandPosition to;
  final double speed;
}
