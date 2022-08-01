// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'endpoints.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EndpointsAdapter extends TypeAdapter<Endpoints> {
  @override
  final int typeId = 0;

  @override
  Endpoints read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Endpoints.jsonPlaceholder;
      default:
        return Endpoints.jsonPlaceholder;
    }
  }

  @override
  void write(BinaryWriter writer, Endpoints obj) {
    switch (obj) {
      case Endpoints.jsonPlaceholder:
        writer.writeByte(0);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EndpointsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
