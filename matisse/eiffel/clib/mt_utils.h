/*
 * The contents of this file are subject to the Matisse Interfaces 
 * Public License Version 1.0 (the "License"); you may not use this 
 * file except in compliance with the License. You may obtain a copy of
 * the License at http://www.matisse.com/pdf/developers/MIPL.html
 *
 * Software distributed under the License is distributed on an "AS IS" 
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See 
 * the License for the specific language governing rights and
 * limitations under the License.
 *
 * The Original Code was created by Matisse Software Inc. 
 * and its successors.
 *
 * The Initial Developer of the Original Code is Matisse Software Inc. 
 * Portions created by Matisse Software are Copyright (C) 
 * Matisse Software Inc. All Rights Reserved.
 *
 * Contributor(s): Kazuhiro Nakao
 *                 Didier Cabannes
 *                 Neal Lester
 *                 Luca Paganotti
 *
 */

#include <stdio.h>

#ifndef __MT_UTILS__
#define __MT_UTILS__

#if defined(WIN32)
#define STRDUP      _strdup
#define STRCASECMP  _stricmp
#elif defined(LINUX)
#define STRDUP      strdup
#define STRCASECMP  strcasecmp
#else
#error define missing functions
#endif


void divide_numeric_into_high_low (MtNumeric* num, EIF_INTEGER_32* ptr);

void build_numeric_from_high_low (MtNumeric* num, 
                                  EIF_INTEGER_32 i1, 
                                  EIF_INTEGER_32 i2, 
                                  EIF_INTEGER_32 i3,
                                  EIF_INTEGER_32 i4, 
                                  EIF_INTEGER_32 i5, 
                                  EIF_INTEGER_32 i6);

EIF_DOUBLE fine_seconds_of_MtInterval(MtInterval* ti);

EIF_OBJECT create_eif_integer_array (EIF_INTEGER_32 size, MtOid* keys);

EIF_REFERENCE eif_array_area (EIF_OBJ obj);

EIF_INTEGER_32 eif_array_count (EIF_OBJ obj);


#endif
