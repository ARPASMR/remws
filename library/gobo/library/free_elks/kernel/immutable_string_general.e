indexing
	description: "Common ancestors to all immutable STRING classes."
	library: "Free implementation of ELKS library"
	copyright: "Copyright (c) 1986-2008, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2008-08-11 10:12:45 +0200 (Mon, 11 Aug 2008) $"
	revision: "$Revision: 6473 $"

deferred class
	IMMUTABLE_STRING_GENERAL

inherit
	READABLE_STRING_GENERAL
		redefine
			is_immutable
		end

feature -- Status report

	is_immutable: BOOLEAN is True
			-- Can the character sequence of `Current' be changed?

invariant
	immutable: is_immutable

end
