/*
	description:

		"C functions used for object traversal"

	system: "Gobo Eiffel Compiler"
	copyright: "Copyright (c) 2006, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-09-13 20:19:54 +0200 (Thu, 13 Sep 2007) $"
	revision: "$Revision: 6067 $"
*/

#ifndef EIF_TRAVERSE_H
#define EIF_TRAVERSE_H

#ifdef __cplusplus
extern "C" {
#endif

extern EIF_REFERENCE find_referers(EIF_REFERENCE target, EIF_INTEGER result_type);
extern EIF_REFERENCE find_instance_of(EIF_INTEGER instance_type, EIF_INTEGER result_type);
extern EIF_REFERENCE find_all_instances(EIF_INTEGER result_type);

#ifdef __cplusplus
}
#endif

#endif
