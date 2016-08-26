indexing

	description:

		"Abstract Base for Event Sources"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GObject Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/05/21 13:28:22 $"
	revision: "$Revision: 1.2 $"

class G_SOURCE

inherit

	GSOURCE_STRUCT
		export
			{NONE} all
		redefine
			make_unshared,
			make_shared,
			make_new_unshared,
			make_new_shared
		end

	GSOURCECLOSURE_FUNCTIONS_EXTERNAL
		export {NONE} all end

	GMAIN_FUNCTIONS_EXTERNAL
		export {NONE} all end

	MEMORY
		redefine
			dispose
		end

feature {NONE} -- Initialization

	make_new_unshared is
			-- G_SOURCEs are always shared, because
			-- they are reference counted
		do
				check
					forbidden: False
				end
		end

	make_new_shared is
			-- G_SOURCEs are always shared, because
			-- they are reference counted
		do
				check
					forbidden: False
				end
		end

	make_unshared (a_item: POINTER) is
			-- G_SOURCEs are always shared, because
			-- they are reference counted
		do
				check
					forbidden: False
				end
		end

	make_shared (a_item: POINTER) is
			-- G_SOURCEs are always shared, because
			-- they are reference counted
		do
			Precursor (a_item)
			add_reference
		end

feature {ANY}

	id: INTEGER is
			-- Returns the numeric ID for a particular source. The
			-- ID of a source is unique within a particular main
			-- loop context.
		do
			Result := g_source_get_id_external (item)
		end

	is_attached: BOOLEAN is
			-- Has the current source already been attached to a
			-- G_MAIN_CONTEXT
		do
			Result := g_source_get_context_external (item) /= Default_pointer
		end

feature {ANY}

	attach_to_default_context is
			-- Attach source to the default context
		require
			not_attached: not is_attached
		local
			int_result: INTEGER
		do
			int_result := g_source_attach_external (item, g_main_context_default_external)
		ensure
			is_attached: is_attached
		end

	detatch is
			-- Detatch source from context
		require
			is_attached: is_attached
		local
			success: INTEGER
		do
			success := g_source_remove_external (id)
				check
					success: success = 1
				end
		ensure
			not_attached: not is_attached
		end

feature {NONE} -- Callbacks

	set_closure (a_closure: G_CLOSURE) is
			-- Let `a_closure' be called whenever the
			-- current source emits a signal
		require
			a_closure_not_void: a_closure /= Void
		do
			if not a_closure.exists then
				a_closure.set_existent
			end
			g_source_set_closure_external (item, a_closure.item)
		end


feature {NONE} -- Implementation

	add_reference is
		local
			p: POINTER
		do
			p := g_source_ref_external (item)
		end

	remove_reference is
		do
			g_source_unref_external (item)
		end

feature {ANY} -- Garbage Collector routines

	dispose is
		do
			remove_reference
		end

invariant

	exists: exists

end
