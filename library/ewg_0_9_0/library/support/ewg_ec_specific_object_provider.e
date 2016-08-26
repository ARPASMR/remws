indexing

	description:

		"Generic class whos instances provide Eiffel compiler specific objects"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/02/27 12:18:32 $"
	revision: "$Revision: 1.2 $"

class EWG_EC_SPECIFIC_OBJECT_PROVIDER [G]

inherit

	EWG_SHARED_EIFFEL_COMPILER_NAMES

creation

	make

feature {NONE} -- Initialization

	make (a_se: G; a_ise: G; a_ve: G; a_mode: EWG_EIFFEL_COMPILER_MODE) is
		require
			a_se_not_void: a_se /= Void
			a_ise_not_void: a_ise /= Void
			a_ve_not_void: a_ve /= Void
			a_mode_not_void: a_mode /= Void
		do
			se := a_se
			ise := a_ise
			ve := a_ve
			mode := a_mode
		ensure
			se_set: se = a_se
			ise_set: ise = a_ise
			ve_set: ve = a_ve
			mode_set: mode = a_mode
		end

feature -- Access

	item: G is
		do
			if mode.eiffel_compiler_mode = eiffel_compiler_names.se_code then
				Result := se
			elseif mode.eiffel_compiler_mode = eiffel_compiler_names.ise_code then
				Result := ise
			elseif mode.eiffel_compiler_mode = eiffel_compiler_names.ve_code then
				Result := ve
			else
					check
						dead_end: False
					end
			end
		end

	se: G

	ise: G

	ve: G

	mode: EWG_EIFFEL_COMPILER_MODE

invariant

	se_not_void: se /= Void
	ise_not_void: ise /= Void
	ve_not_void: ve /= Void
	item_not_void: item /= Void
	item_valid: item = se or item = ise or item = ve
	mode_not_void: mode /= Void

end
