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

#ifndef __MT_TRACE__
#define __MT_TRACE__

void EifMt_Trace (char *filename, int line, char* msg);

/* debug */
#ifdef EIF_MT_LOGGING
#define EIF_MT_LOG(msg) { EifMt_Trace(__FILE__, __LINE__, msg); }
#define EIF_MT_LOG1(format,arg1) \
        { char trace[512]; sprintf(trace, format, arg1); EifMt_Trace(__FILE__,__LINE__,trace); }
#define EIF_MT_LOG2(format,arg1,arg2) \
        { char trace[512]; sprintf(trace, format, arg1, arg2); EifMt_Trace(__FILE__,__LINE__,trace); }

#define EIF_MT_LOG3(format,arg1,arg2,arg3) \
        { char trace[512]; sprintf(trace, format, arg1, arg2, arg3); EifMt_Trace(__FILE__,__LINE__,trace); }

#define EIF_MT_LOG4(format,arg1,arg2,arg3,arg4) \
        { char trace[512]; sprintf(trace, format, arg1, arg2, arg3, arg4); EifMt_Trace(__FILE__,__LINE__,trace); }
#else
#define EIF_MT_LOG(msg) 
#define EIF_MT_LOG1(format,arg1) 
#define EIF_MT_LOG2(format,arg1,arg2) 
#define EIF_MT_LOG3(format,arg1,arg2,arg3) 
#define EIF_MT_LOG4(format,arg1,arg2,arg3,arg4) 
#endif


#endif

