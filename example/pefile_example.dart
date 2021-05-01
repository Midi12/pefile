import 'dart:io';

import 'package:pefile/pefile.dart' as pefile;
import 'package:pefile/src/structs/image_dos_header.dart';

Future<void> main() async {
  var pe32 = pefile.parse('example32.exe') as pefile.PeFile32;

  var dos_hdr = pe32.dos_header();
  print(dos_hdr.e_magic);
}
