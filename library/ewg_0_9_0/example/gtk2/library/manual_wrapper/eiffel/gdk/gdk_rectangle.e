indexing

	description:

		"Objects represent something drawable. It allows for drawing points, %
		%lines, arcs, and text."

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/03/27 12:48:31 $"
	revision: "$Revision: 1.3 $"

class GDK_RECTANGLE

inherit

	GDK_RECTANGLE_STRUCT

	GDK_FUNCTIONS_EXTERNAL
		export {NONE} all end

creation

	make_unshared,
	make_shared,
	make_new_unshared,
	make_new_shared

feature {ANY} -- Basic Routines

	intersect (a_other, a_intersection: GDK_RECTANGLE): BOOLEAN is
			-- Calculate the intersection of `Current' with `a_other'.
			-- `a_intersetction':	the intersection of `Current' and `a_other'.
			-- Returns `True' if the rectangles intersect.
		require
			a_other_not_void: a_other /= Void
			a_intersection_not_void: a_intersection /= Void
		do
			if gdk_rectangle_intersect_external (item, a_other.item, a_intersection.item) = 1 then
				Result := True
			end
		end

invariant

	exists: exists
	
end
