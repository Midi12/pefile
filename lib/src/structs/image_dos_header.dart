import 'dart:ffi';

const int IMAGE_DOS_SIGNATURE = 0x5A4D; // MZ

class IMAGE_DOS_HEADER extends Struct {
  @Uint16() external int e_magic;
  @Uint16() external int e_cblp;
  @Uint16() external int e_cp;
  @Uint16() external int e_crlc;
  @Uint16() external int e_cparhdr;
  @Uint16() external int e_minalloc;
  @Uint16() external int e_maxalloc;
  @Uint16() external int e_ss;
  @Uint16() external int e_sp;
  @Uint16() external int e_csum;
  @Uint16() external int e_ip;
  @Uint16() external int e_cs;
  @Uint16() external int e_lfarlc;
  @Uint16() external int e_ovno;
  @Uint16() external int e_res_0; // TODO : change to inline array when available in stable branch (size = 4)
  @Uint16() external int e_res_1;
  @Uint16() external int e_res_2;
  @Uint16() external int e_res_3;
  @Uint16() external int e_oemid;
  @Uint16() external int e_oeminfo;
  @Uint16() external int e_res2_0; // TODO : change to inline array when available in stable branch (size = 10)
  @Uint16() external int e_res2_1;
  @Uint16() external int e_res2_2;
  @Uint16() external int e_res2_3;
  @Uint16() external int e_res2_4;
  @Uint16() external int e_res2_5;
  @Uint16() external int e_res2_6;
  @Uint16() external int e_res2_7;
  @Uint16() external int e_res2_8;
  @Uint16() external int e_res2_9;
  @Uint32() external int e_lfanew;
}