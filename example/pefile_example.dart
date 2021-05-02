import 'package:pefile/pefile.dart' as pefile;

void parse<T extends pefile.PeFileBase>(String path) {
  print('parsing $path');
  var pe = pefile.parse(path) as T;

  var dos_hdr = pe.dos_header;
  print(dos_hdr.e_magic);
  print(pe.header_data.entry_point_rva.toRadixString(16));
  for(var section in pe.sections) {
    print('Section ${section.name}\taddress ${section.virtual_address.toRadixString(16)}h\tsize ${section.virtual_size.toRadixString(16)}h');
  }
}

Future<void> main() async {
  parse<pefile.PeFile64>('C:\\Windows\\System32\\notepad.exe');
  parse<pefile.PeFile32>('C:\\Windows\\SysWOW64\\notepad.exe');
}
