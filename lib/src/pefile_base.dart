import 'dart:io';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:pefile/src/structs/image_nt_headers.dart';

import 'idisposable.dart';
import './structs/image_dos_header.dart';

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

  PeFileBase.fromPath(String path) {
    var uri = Uri.parse(path);
    var file = File.fromUri(uri);
    PeFileBase.fromBuffer(file.readAsBytesSync());
  }

  PeFileBase.fromBuffer(Uint8List bytes) {
    _buffer = calloc.allocate(bytes.length);
    _size = bytes.length;
  }

  @override
  void dispose() {
    if (_buffer != nullptr) {
      calloc.free(_buffer);
    }
  }

  Uint8List get buffer => _buffer.asTypedList(_size);

  bool get is64bit => true;

  IMAGE_DOS_HEADER dos_header() {
    var pDosHdr = _buffer.cast<IMAGE_DOS_HEADER>();
    if (pDosHdr.ref.e_magic != IMAGE_DOS_SIGNATURE) {
      throw PeFileException('Invalid DOS signature');
    }

    return pDosHdr.ref;
  }

  Struct nt_headers() => throw UnimplementedError();

}

class PeFile32 extends PeFileBase {

  PeFile32(Uint8List data) : super.fromBuffer(data);

  @override
  IMAGE_NT_HEADERS32 nt_headers() {
    var pNtHdrs = _buffer.elementAt(dos_header().e_lfanew).cast<IMAGE_NT_HEADERS32>();
    if (pNtHdrs.ref.Signature != IMAGE_NT_SIGNATURE) {
      throw PeFileException('Invalid NT signature');
    }

    return pNtHdrs.ref;
  }
}

class PeFile64 extends PeFileBase {

  PeFile64(Uint8List data) : super.fromBuffer(data);

  @override
  IMAGE_NT_HEADERS64 nt_headers() {
    var pNtHdrs = _buffer.elementAt(dos_header().e_lfanew).cast<IMAGE_NT_HEADERS64>();
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
    pe = PeFileBase.fromBuffer(file);
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