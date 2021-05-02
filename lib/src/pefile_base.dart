import 'dart:io';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import 'idisposable.dart';
import './structs/image_dos_header.dart';
import './structs/image_nt_headers.dart';
import './structs/image_optional_header.dart';
import './structs/image_section_header.dart';
import './structs/image_file_header.dart';

class PeFileException implements Exception {
  final String _message;

  PeFileException(this._message);

  String get message => _message;

  @override
  String toString() => 'PeFileException: $_message';
}

class Section {
  final String _name;
  final int _virtual_size;
  final int _virtual_address;
  final int _size_of_raw_data;
  final int _pointer_to_raw_data;
  final int _characteristics;

  Section(this._name, this._virtual_size, this._virtual_address, this._size_of_raw_data, this._pointer_to_raw_data, this._characteristics);

  String get name => _name;
  int get virtual_size => _virtual_size;
  int get virtual_address => _virtual_address;
  int get size_of_raw_data => _size_of_raw_data;
  int get pointer_to_raw_data => _pointer_to_raw_data;
  int get characteristics => _characteristics;

  bool get isCodeSection => (_characteristics & IMAGE_SCN_CNT_CODE) == 1;
  bool get isDataSection => (_characteristics & IMAGE_SCN_CNT_INITIALIZED_DATA) == 1 || (_characteristics & IMAGE_SCN_CNT_UNINITIALIZED_DATA) == 1;
}

class Import {

}

class Export {

}

class PeFileBase implements IDisposable {

  late Pointer<Uint8> _buffer;
  late int _size;

  final List<Section> _sections = <Section>[];
  final List<Export> _exports = <Export>[];
  final List<Import> _imports = <Import>[];

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

  List<Section> get sections => _sections;
  List<Export> get exports => _exports;
  List<Import> get imports => _imports;
}

List<Section> _parseSectionImpl(Pointer<Uint8> buffer, int nt_hdr_offset, int nt_hdr_size, int num_sections, List<Section> sections) {
  var sections_it = buffer.elementAt(nt_hdr_offset + sizeOf<IMAGE_FILE_HEADER>() + 4 + nt_hdr_size).cast<IMAGE_SECTION_HEADER>();

  for (var i = 0; i < num_sections; i++) {
    var section = sections_it.elementAt(i);
    sections.add(Section(
      section.szName,
      section.ref.VirtualSize,
      section.ref.VirtualAddress,
      section.ref.SizeOfRawData,
      section.ref.PointerToRawData,
      section.ref.Characteristics
    ));
  }

  return sections;
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

  @override
  List<Section> get sections => _sections.isEmpty ? _parseSectionImpl(_buffer, dos_header.e_lfanew, nt_headers.FileHeader.SizeOfOptionalHeader, nt_headers.FileHeader.NumberOfSections, _sections) : _sections;

  @override
  List<Export> get exports => throw UnimplementedError();

  @override
  List<Import> get imports => throw UnimplementedError();
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

  @override
  List<Section> get sections => _sections.isEmpty ? _parseSectionImpl(_buffer, dos_header.e_lfanew, nt_headers.FileHeader.SizeOfOptionalHeader, nt_headers.FileHeader.NumberOfSections, _sections) : _sections;

  @override
  List<Export> get exports => throw UnimplementedError();

  @override
 List<Import> get imports => throw UnimplementedError();
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