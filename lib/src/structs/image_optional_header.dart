import 'dart:ffi';

import 'image_data_directory.dart';

class IMAGE_OPTIONAL_HEADER32 extends Struct {
  @Uint16() external int Magic;
  @Uint8() external int MajorLinkerVersion;
  @Uint8() external int MinorLinkerVersion;
  @Uint32() external int SizeOfCode;
  @Uint32() external int SizeOfInitializedData;
  @Uint32() external int SizeOfUninitializedData;
  @Uint32() external int AddressOfEntryPoint;
  @Uint32() external int BaseOfCode;
  @Uint32() external int BaseOfData;
  @Uint32() external int ImageBase;
  @Uint32() external int SectionAlignment;
  @Uint32() external int FileAlignment;
  @Uint16() external int MajorOperatingSystemVersion;
  @Uint16() external int MinorOperatingSystemVersion;
  @Uint16() external int MajorImageVersion;
  @Uint16() external int MinorImageVersion;
  @Uint16() external int MajorSubsystemVersion;
  @Uint16() external int MinorSubsystemVersion;
  @Uint32() external int Win32VersionValue;
  @Uint32() external int SizeOfImage;
  @Uint32() external int SizeOfHeaders;
  @Uint32() external int CheckSum;
  @Uint16() external int Subsystem;
  @Uint16() external int DllCharacteristics;
  @Uint32() external int SizeOfStackReserve;
  @Uint32() external int SizeOfStackCommit;
  @Uint32() external int SizeOfHeapReserve;
  @Uint32() external int SizeOfHeapCommit;
  @Uint32() external int LoaderFlags;
  @Uint32() external int NumberOfRvaAndSizes;
  external Pointer<IMAGE_DATA_DIRECTORY> DataDirectory; // TODO : change to inline array when available in stable branch (size = IMAGE_NUMBEROF_DIRECTORY_ENTRIES)
}

class IMAGE_OPTIONAL_HEADER64 extends Struct {
  @Uint16() external int Magic;
  @Uint8() external int MajorLinkerVersion;
  @Uint8() external int MinorLinkerVersion;
  @Uint32() external int SizeOfCode;
  @Uint32() external int SizeOfInitializedData;
  @Uint32() external int SizeOfUninitializedData;
  @Uint32() external int AddressOfEntryPoint;
  @Uint32() external int BaseOfCode;
  @Uint64() external int ImageBase;
  @Uint32() external int SectionAlignment;
  @Uint32() external int FileAlignment;
  @Uint16() external int MajorOperatingSystemVersion;
  @Uint16() external int MinorOperatingSystemVersion;
  @Uint16() external int MajorImageVersion;
  @Uint16() external int MinorImageVersion;
  @Uint16() external int MajorSubsystemVersion;
  @Uint16() external int MinorSubsystemVersion;
  @Uint32() external int Win32VersionValue;
  @Uint32() external int SizeOfImage;
  @Uint32() external int SizeOfHeaders;
  @Uint32() external int CheckSum;
  @Uint16() external int Subsystem;
  @Uint16() external int DllCharacteristics;
  @Uint64() external int SizeOfStackReserve;
  @Uint64() external int SizeOfStackCommit;
  @Uint64() external int SizeOfHeapReserve;
  @Uint64() external int SizeOfHeapCommit;
  @Uint32() external int LoaderFlags;
  @Uint32() external int NumberOfRvaAndSizes;
  external Pointer<IMAGE_DATA_DIRECTORY> DataDirectory; // TODO : change to inline array when available in stable branch (size = IMAGE_NUMBEROF_DIRECTORY_ENTRIES)
}