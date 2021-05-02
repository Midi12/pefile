import 'dart:io';

import 'package:pefile/pefile.dart' as pefile;

Future<void> main() async {
  var pe64 = pefile.parse('C:\\Windows\\System32\\notepad.exe') as pefile.PeFile64;

  var dos_hdr = pe64.dos_header;
  print(dos_hdr.e_magic);
}
