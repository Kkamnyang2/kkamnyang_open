// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aac_card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AACCardAdapter extends TypeAdapter<AACCard> {
  @override
  final int typeId = 0;

  @override
  AACCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AACCard(
      id: fields[0] as String,
      text: fields[1] as String,
      imageUrl: fields[2] as String,
      backgroundColor: fields[3] as String?,
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime,
      sortOrder: fields[6] as int,
      category: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AACCard obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.backgroundColor)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.sortOrder)
      ..writeByte(7)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AACCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
