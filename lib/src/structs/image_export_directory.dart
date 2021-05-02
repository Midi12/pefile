import 'dart:ffi';

class IMAGE_EXPORT_DIRECTORY extends Struct {
    @Uint32() external int Characteristics;
    @Uint32() external int TimeDateStamp;
    @Uint16() external int MajorVersion;
    @Uint16() external int MinorVersion;
    @Uint32() external int Name;
    @Uint32() external int Base;
    @Uint32() external int NumberOfFunctions;
    @Uint32() external int NumberOfNames;
    @Uint32() external int AddressOfFunctions;     // RVA from base of image
    @Uint32() external int AddressOfNames;         // RVA from base of image
    @Uint32() external int AddressOfNameOrdinals;  // RVA from base of image
}