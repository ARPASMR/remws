indexing

	description:

		"Deferred base class for OpenGL applications"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/10/25 19:26:09 $"
	revision: "$Revision: 1.4 $"

class EWG_OPENGL_APPLICATION

inherit

	GLUT_FUNCTIONS_EXTERNAL
		export {NONE} all end

	EWG_IMPORTED_EXTERNAL_ROUTINES
		export {NONE} all end
		
feature {NONE} -- Initialisation

	make is
		local
			argvp: EWG_MANAGED_POINTER
			argv: EWG_MANAGED_POINTER
			arg: EWG_ZERO_TERMINATED_STRING
		do
				-- GLUT needs the `agrc' and `argv' tuple (command line parameters)
				-- We could do that, but for this demonstration a simple mockup
				-- of a very small parameter list works too
			create argvp.make_new_unshared (EXTERNAL_MEMORY_.sizeof_int_external)
			argvp.put_integer (1, 0)
			create arg.make_unshared_from_string ("foo")
			create argv.make_new_unshared (EXTERNAL_MEMORY_.sizeof_pointer_external)
			argv.put_pointer (arg.item, 0)

				-- Initialize GLUT
			glut_init_external (argvp.item, argv.item)
		end

end
