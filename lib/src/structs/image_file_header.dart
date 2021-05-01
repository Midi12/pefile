import 'dart:ffi';

class IMAGE_FILE_HEADER extends Struct {
  @Uint16() external int Machine;
  @Uint16() external int NumberOfSections;
  @Uint32() external int TimeDateStamp;
  @Uint32() external int PointerToSymbolTable;
  @Uint32() external int NumberOfSymbols;
  @Uint16() external int SizeOfOptionalHeader;
  @Uint16() external int Characteristics;
}