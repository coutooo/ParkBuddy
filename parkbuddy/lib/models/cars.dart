import 'package:hive/hive.dart';

part 'cars.g.dart';

@HiveType(typeId: 0)
class Car {
  @HiveField(0)
  var icon;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String localization;
  @HiveField(3)
  final String matricula;

  Car(
      {required this.icon,
      required this.name,
      required this.localization,
      required this.matricula});
}
