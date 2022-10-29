// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cars.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CarAdapter extends TypeAdapter<Car> {
  @override
  final int typeId = 0;

  @override
  Car read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Car(
      icon: fields[0] as dynamic,
      name: fields[1] as String,
      localization: fields[2] as String,
      matricula: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Car obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.icon)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.localization)
      ..writeByte(3)
      ..write(obj.matricula);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CarAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
