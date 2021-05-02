import 'dart:ffi';

import 'package:ffi/ffi.dart';

// credits : https://github.com/DarthTon/Blackbone/blob/607e9a3be9ca01133de2b190f2efb17b3d51db40/src/BlackBoneDrv/PEStructs.h

//
// Section characteristics.
//
const int IMAGE_SCN_TYPE_REG = 0x00000000; // Reserved.
const int IMAGE_SCN_TYPE_DSECT = 0x00000001; // Reserved.
const int IMAGE_SCN_TYPE_NOLOAD = 0x00000002; // Reserved.
const int IMAGE_SCN_TYPE_GROUP = 0x00000004; // Reserved.
const int IMAGE_SCN_TYPE_NO_PAD = 0x00000008; // Reserved.
const int IMAGE_SCN_TYPE_COPY = 0x00000010; // Reserved.

const int IMAGE_SCN_CNT_CODE = 0x00000020; // Section contains code.
const int IMAGE_SCN_CNT_INITIALIZED_DATA = 0x00000040; // Section contains initialized data.
const int IMAGE_SCN_CNT_UNINITIALIZED_DATA = 0x00000080; // Section contains uninitialized data.

const int IMAGE_SCN_LNK_OTHER = 0x00000100; // Reserved.
const int IMAGE_SCN_LNK_INFO = 0x00000200; // Section contains comments or some other type of information.
const int IMAGE_SCN_TYPE_OVER = 0x00000400; // Reserved.
const int IMAGE_SCN_LNK_REMOVE = 0x00000800; // Section contents will not become part of image.
const int IMAGE_SCN_LNK_COMDAT = 0x00001000; // Section contents comdat.
const int IMAGE_SCN_RESERVED = 0x00002000; // Reserved.
const int IMAGE_SCN_NO_DEFER_SPEC_EXC = 0x00004000; // Reset speculative exceptions handling bits in the TLB entries for this section.
const int IMAGE_SCN_GPREL = 0x00008000; // Section content can be accessed relative to GP
const int IMAGE_SCN_MEM_FARDATA = 0x00008000;
const int IMAGE_SCN_MEM_PURGEABLE = 0x00020000;
const int IMAGE_SCN_MEM_16BIT = 0x00020000;
const int IMAGE_SCN_MEM_LOCKED = 0x00040000;
const int IMAGE_SCN_MEM_PRELOAD = 0x00080000;

const int IMAGE_SCN_ALIGN_1BYTES = 0x00100000;
const int IMAGE_SCN_ALIGN_2BYTES = 0x00200000;
const int IMAGE_SCN_ALIGN_4BYTES = 0x00300000;
const int IMAGE_SCN_ALIGN_8BYTES = 0x00400000;
const int IMAGE_SCN_ALIGN_16BYTES = 0x00500000; // Default alignment if no others are specified.
const int IMAGE_SCN_ALIGN_32BYTES = 0x00600000;
const int IMAGE_SCN_ALIGN_64BYTES = 0x00700000;
const int IMAGE_SCN_ALIGN_128BYTES = 0x00800000;
const int IMAGE_SCN_ALIGN_256BYTES = 0x00900000;
const int IMAGE_SCN_ALIGN_512BYTES = 0x00A00000;
const int IMAGE_SCN_ALIGN_1024BYTES = 0x00B00000;
const int IMAGE_SCN_ALIGN_2048BYTES = 0x00C00000;
const int IMAGE_SCN_ALIGN_4096BYTES = 0x00D00000;
const int IMAGE_SCN_ALIGN_8192BYTES = 0x00E00000;
const int IMAGE_SCN_ALIGN_MASK = 0x00F00000;

const int IMAGE_SCN_LNK_NRELOC_OVFL = 0x01000000; // Section contains extended relocations.
const int IMAGE_SCN_MEM_DISCARDABLE = 0x02000000; // Section can be discarded.
const int IMAGE_SCN_MEM_NOT_CACHED = 0x04000000; // Section is not cachable.
const int IMAGE_SCN_MEM_NOT_PAGED = 0x08000000; // Section is not pageable.
const int IMAGE_SCN_MEM_SHARED = 0x10000000; // Section is shareable.
const int IMAGE_SCN_MEM_EXECUTE = 0x20000000; // Section is executable.
const int IMAGE_SCN_MEM_READ = 0x40000000; // Section is readable.
const int IMAGE_SCN_MEM_WRITE = 0x80000000; // Section is writeable.

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