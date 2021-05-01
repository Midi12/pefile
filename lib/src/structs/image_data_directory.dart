import 'dart:ffi';

class IMAGE_DATA_DIRECTORY extends Struct {
  @Uint32() external int VirtualAddress;
  @Uint32() external int Size;
}