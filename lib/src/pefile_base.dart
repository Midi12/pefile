import 'dart:io';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import 'idisposable.dart';
import './structs/image_dos_header.dart';
import './structs/image_nt_headers.dart';
import './structs/image_optional_header.dart';

class PeFileException implements Exception {
  final String _message;

  PeFileException(this._message);

  String get message => _message;

  @override
  String toString() => 'PeFileException: $_message';
}

class PeFileBase implements IDisposable {

  late Pointer<Uint8> _buffer;
  late int _size;

  factory PeFileBase.fromPath(String path) {
    var file = File(path);
    return PeFileBase(file.readAsBytesSync());
  }

  PeFileBase(Uint8List bytes) {
    _buffer = calloc.allocate(bytes.length);
    _size = bytes.length;
    _buffer.asTypedList(_size).setAll(0, bytes);
  }

  @override
  void dispose() {
    if (_buffer != nullptr) {
      calloc.free(_buffer);
    }
  }

  Uint8List get buffer => _buffer.asTypedList(_size);

  bool get is64bit {
    var magic = _buffer.elementAt(dos_header.e_lfanew).cast<IMAGE_NT_HEADERS32>().ref.OptionalHeader.Magic;

    if (magic == IMAGE_NT_OPTIONAL_HDR32_MAGIC) {
      return false;
    } else if (magic == IMAGE_NT_OPTIONAL_HDR64_MAGIC) {
      return true;
    } else {
      throw PeFileException('Unsupported OptionalHeader magic');
    }
  }

  IMAGE_DOS_HEADER get dos_header {
    var pDosHdr = _buffer.cast<IMAGE_DOS_HEADER>();
    if (pDosHdr.ref.e_magic != IMAGE_DOS_SIGNATURE) {
      throw PeFileException('Invalid DOS signature');
    }

    return pDosHdr.ref;
  }

  Struct get nt_headers => throw UnimplementedError();

}

class PeFile32 extends PeFileBase {

  PeFile32(Uint8List data) : super(data);

  @override
  IMAGE_NT_HEADERS32 get nt_headers {
    var pNtHdrs = _buffer.elementAt(dos_header.e_lfanew).cast<IMAGE_NT_HEADERS32>();
    if (pNtHdrs.ref.Signature != IMAGE_NT_SIGNATURE) {
      throw PeFileException('Invalid NT signature');
    }

    return pNtHdrs.ref;
  }
}

class PeFile64 extends PeFileBase {

  PeFile64(Uint8List data) : super(data);

  @override
  IMAGE_NT_HEADERS64 get nt_headers {
    var pNtHdrs = _buffer.elementAt(dos_header.e_lfanew).cast<IMAGE_NT_HEADERS64>();
    if (pNtHdrs.ref.Signature != IMAGE_NT_SIGNATURE) {
      throw PeFileException('Invalid NT signature');
    }

    return pNtHdrs.ref;
  }
}

PeFileBase parse(dynamic file) {
  PeFileBase pe;

  if (file is String) {
    pe = PeFileBase.fromPath(file);
  } else if (file is Uint8List) {
    pe = PeFileBase(file);
  } else {
    throw PeFileException('file must be String or Uint8List');
  }

  PeFileBase ret;

  if (pe.is64bit) {
    ret = PeFile64(pe.buffer);
  } else {
    ret = PeFile32(pe.buffer);
  }

  pe.dispose();
  return ret;
}