#ifndef H3DREADER_DL_H
#define H3DREADER_DL_H

#include <stdint.h>
#include <stdbool.h>

/* Interface to the reader wrappers implemented in h3dreader_dl.c. */
typedef void H3DReaderInfo;
typedef void (*H3DReaderMessageFunctionType)(H3DReaderInfo* context, const char* msg);
typedef void (*H3DReaderErrorFunctionType)(H3DReaderInfo* context, const char* msg);

#ifdef __cplusplus
extern "C" {
#endif

void h3dreaderlib_load_(int* ierror);
H3DReaderInfo* Hyper3DImportOpen(const char* filename,
                               H3DReaderMessageFunctionType message,
                               H3DReaderErrorFunctionType error);
bool Hyper3DImportClose(H3DReaderInfo* file);
bool Hyper3DLookupString(H3DReaderInfo* file, uint32_t string_id, const char** value);

#ifdef __cplusplus
}
#endif

#endif
