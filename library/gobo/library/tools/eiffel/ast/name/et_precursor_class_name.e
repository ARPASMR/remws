indexing

	description:

		"Eiffel class names in precursor calls"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2002, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

deferred class ET_PRECURSOR_CLASS_NAME

inherit

	ET_AST_NODE

feature -- Access

	class_name: ET_CLASS_NAME is
			-- Class name
		deferred
		ensure
			class_name_not_void: Result /= Void
		end

end
