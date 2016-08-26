indexing

	description:

		"Tag count XML event consumer"

	library: "Gobo Eiffel XML Library"
	copyright: "Copyright (c) 2003, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"
	
class TAGCOUNT_CALLBACKS

inherit

	XM_CALLBACKS_NULL
		redefine
			on_start,
			on_start_tag
		end

create

	make

feature -- Events
	
	on_start is
			-- Reset tag count.
		do
			count := 0
		end
		
	on_start_tag (a_namespace: STRING; a_prefix: STRING; a_local_part: STRING) is
			-- Count start tags.
		do
			count := count + 1
		end
	
feature -- Access
	
	count: INTEGER
			-- Number of tags seen
			
end
