# 1 "test_049.h"
# 1 "<built-in>"
# 1 "<command line>"
# 1 "test_049.h"

typedef struct _ImageArchitectureHeader {
    unsigned int AmaskValue: 1;

    int :7;
    unsigned int AmaskShift: 8;
    int :16;
    int FirstEntryRVA;
} IMAGE_ARCHITECTURE_HEADER, *PIMAGE_ARCHITECTURE_HEADER;
