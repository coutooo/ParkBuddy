import 'package:hive/hive.dart';

part 'cars.g.dart';

@HiveType(typeId: 0)
class Car {
  @HiveField(0)
  var icon;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String address;
  @HiveField(3)
  final String matricula;
  @HiveField(4)
  final String latitude;
  @HiveField(5)
  final String longitude;
  @HiveField(6)
  final String street;

  Car(
      {required this.icon,
      required this.name,
      required this.address,
      required this.matricula,
      required this.latitude,
      required this.longitude,
      required this.street});
}
