import 'dart:ffi';

import 'image_file_header.dart';
import 'image_optional_header.dart';

class IMAGE_NT_HEADERS32 extends Struct {
  @Uint32()
  external int Signature;
  external IMAGE_FILE_HEADER FileHeader;
  external IMAGE_OPTIONAL_HEADER32 OptionalHeader;
}

class IMAGE_NT_HEADERS64 extends Struct {
  @Uint32()
  external int Signature;
  external IMAGE_FILE_HEADER FileHeader;
  external IMAGE_OPTIONAL_HEADER64 OptionalHeader;
}
