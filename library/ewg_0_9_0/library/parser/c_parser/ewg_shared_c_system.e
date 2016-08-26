indexing

	description:

		"Singleton access for EWG_C_SYSTEM"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/10/25 19:19:25 $"
	revision: "$Revision: 1.1 $"

class EWG_SHARED_C_SYSTEM
feature

	c_system: EWG_C_SYSTEM is
		once
			create Result.make
		end
	
end
