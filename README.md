# pefile

A Dart library to parse Portable Executable (PE) format

## Usage

A simple usage example:

```dart
var pe = pefile.parse('C:\\Windows\\System32\\notepad.exe');
print('Is 64bit ? ${pe.is64bit}');

var dos_hdr = pe.dos_header;
print('DOS magic ${dos_hdr.e_magic}');
print('Entry point ${pe.header_data.entry_point_rva.toRadixString(16)}h');

for(var section in pe.sections) {
  print('Section ${section.name}\taddress ${section.virtual_address.toRadixString(16)}h\tsize ${section.virtual_size.toRadixString(16)}h');
}
```

Todos:
* Add export directory parsing
* Add import directory parsing