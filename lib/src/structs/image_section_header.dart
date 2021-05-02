import 'dart:ffi';

import 'package:ffi/ffi.dart';

class IMAGE_SECTION_HEADER extends Struct {
  @Uint64() external int Name; // TODO : change to inline array when available in stable branch (size = 8) -> UCHAR  Name[8]
  @Uint32() external int VirtualSize;
  @Uint32() external int VirtualAddress;
  @Uint32() external int SizeOfRawData;
  @Uint32() external int PointerToRawData;
  @Uint32() external int PointerToRelocations;
  @Uint32() external int PointerToLinenumbers;
  @Uint16() external int NumberOfRelocations;
  @Uint16() external int NumberOfLinenumbers;
  @Uint32() external int Characteristics;
}

/// extension while waiting for inline arrays in structs
/// https://github.com/dart-lang/sdk/issues/35763
// ignore: camel_case_extensions
extension IMAGE_SECTION_HEADERExtension on Pointer<IMAGE_SECTION_HEADER> {
  String get szName => cast<Uint8>().elementAt(0).cast<Utf8>().toDartString(length: 8);
}