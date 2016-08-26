indexing

	description:

		"Provides shared access to GTK_MAIN"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/05/19 19:39:24 $"
	revision: "$Revision: 1.2 $"

class GTK_SHARED_MAIN

feature

	gtk_main: GTK_MAIN is
			-- Returns objcect that provides routines
			-- to manage the GTK main loop
		once
			create Result.make
		ensure
			gtk_main_not_void: Result /= Void
		end
	
end
