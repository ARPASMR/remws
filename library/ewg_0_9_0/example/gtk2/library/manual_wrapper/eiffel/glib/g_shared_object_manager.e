indexing

	description:

		"Shared access to singleton G_OBJECT_MANAGER"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GObject Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/05/19 19:34:01 $"
	revision: "$Revision: 1.1 $"

class G_SHARED_OBJECT_MANAGER

feature {ANY}

	g_object_manager: G_OBJECT_MANAGER is
			-- Return G_OBJECT manager singleton.
		once
			create Result.make
		ensure
			g_object_manager_not_void: Result /= Void
		end

end
