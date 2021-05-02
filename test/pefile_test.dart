import 'package:pefile/pefile.dart' as pefile;
import 'package:test/test.dart';

void test_pe<T extends pefile.PeFileBase>(String path) {
  var pe = pefile.parse(path) as T;
  expect(pe, isNotNull);

  var dos_hdr = pe.dos_header;
  expect(dos_hdr, isNotNull);
  expect(dos_hdr.e_magic, pefile.IMAGE_DOS_SIGNATURE);

  expect(pe.header_data.entry_point_rva, isNotNull);
  expect(pe.header_data.entry_point_rva, isPositive);

  expect(pe.sections, isPositive);
  for(var section in pe.sections) {
    expect(section.name, isNotNull);
    expect(section.name, isNotEmpty);
    expect(section.virtual_address, isPositive);
    expect(section.virtual_size, isPositive);
  }
}

void main() {
  group('A group of tests', () {
    setUp(() {});

    test('Test 32 bit', () => test_pe<pefile.PeFile32>('C:\\Windows\\SysWOW64\\notepad.exe'));

    test('Test 64 bit', () => test_pe<pefile.PeFile64>('C:\\Windows\\System32\\notepad.exe'));
  });
}
