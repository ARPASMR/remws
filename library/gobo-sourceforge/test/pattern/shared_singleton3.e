indexing

	description:

		"Shared singleton3"

	library: "Gobo Eiffel Pattern Library"
	copyright: "Copyright (c) 2003, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

class SHARED_SINGLETON3

feature -- Access

	singleton3: SINGLETON3 is
			-- Singleton object
		do
			Result := singleton3_cell.item
			if Result = Void then
				create Result.make
			end
		ensure
			singleton3_created: singleton3_created
			singleton3_not_void: Result /= Void
		end

feature -- Status report

	singleton3_created: BOOLEAN is
			-- Has singleton already been created?
		do
			Result := singleton3_cell.item /= Void
		end

feature {NONE} -- Implementation

	singleton3_cell: DS_CELL [SINGLETON3] is
			-- Cell containing the singleton if already created
		once
			create Result.make (Void)
		ensure
			cell_not_void: Result /= Void
		end

end
