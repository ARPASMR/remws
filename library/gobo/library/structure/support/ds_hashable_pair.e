indexing

	description:

		"Cells containing two hashable items"

	library: "Gobo Eiffel Structure Library"
	copyright: "Copyright (c) 2005, Colin Adams and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

class DS_HASHABLE_PAIR [G -> HASHABLE, H -> HASHABLE]

inherit

	DS_PAIR [G, H]

	HASHABLE

create

	make

feature -- Access

	hash_code: INTEGER is
			-- Hash code value
		do
			if first /= Void then
				if second /= Void then
					Result := first.hash_code // 2 + second.hash_code // 2
				else
					Result := first.hash_code
				end
			elseif second /= Void then
				Result := second.hash_code
			else
				Result := 0
			end
		end

end
