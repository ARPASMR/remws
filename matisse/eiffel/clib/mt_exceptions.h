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

#ifndef __MT_EXCEPTIONS__
#define __MT_EXCEPTIONS__

#define MtEif_Too_Many_Objects 1002
#define MtEif_No_Such_Class    1004

#define CHECK_STS(MtFunc,dbctx)			\
{\
	MtSTS status;\
	if (MtFailure(status = (MtFunc))){              \
		EIF_MT_LOG(MtCtxError(dbctx));  /** temporary **/ \
		EIF_MT_LOG("\n");                         \
		raise_mt_exception(status, MtCtxError(dbctx));    \
	}	/** Raise Eiffel exception **/            \
}


/*
 * Check return status.
 * Ignore an error specified by an argument
 */
#define CHECK_STS_IGNERR(MtFunc,sts_to_be_ignored,dbctx) \
{\
	MtSTS status;\
	status = (MtFunc); \
	if (status != sts_to_be_ignored) {   \
		if (MtFailure(status)){            \
			EIF_MT_LOG("sts ignored mode\n");\
			EIF_MT_LOG(MtCtxError(dbctx));           \
			EIF_MT_LOG("\n");                \
			raise_mt_exception(status, MtCtxError(dbctx));\
		}	/** Raise Eiffel exception **/   \
	} \
}

void raise_mt_exception(EIF_INTEGER_32 status, char* err_msg);
EIF_INTEGER_32 c_matisse_exception_code(void);

#endif
