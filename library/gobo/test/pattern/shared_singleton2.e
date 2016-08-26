indexing

	description:

		"Shared singleton2"

	library: "Gobo Eiffel Pattern Library"
	copyright: "Copyright (c) 2003, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

class SHARED_SINGLETON2

feature -- Access

	singleton2: SINGLETON2 is
			-- Singleton object
		do
			Result := singleton2_cell.item
			if Result = Void then
				create Result.make
			end
		ensure
			singleton2_created: singleton2_created
			singleton2_not_void: Result /= Void
		end

feature -- Status report

	singleton2_created: BOOLEAN is
			-- Has singleton already been created?
		do
			Result := singleton2_cell.item /= Void
		end

feature {NONE} -- Implementation

	singleton2_cell: DS_CELL [SINGLETON2] is
			-- Cell containing the singleton if already created
		once
			create Result.make (Void)
		ensure
			cell_not_void: Result /= Void
		end

end
