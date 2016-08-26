indexing

	description:

		"Eiffel compiler mode"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/02/27 12:18:32 $"
	revision: "$Revision: 1.2 $"

class EWG_EIFFEL_COMPILER_MODE

inherit

	EWG_SHARED_EIFFEL_COMPILER_NAMES

creation

	make

feature {NONE} -- Initialization

	make is
			-- Initialize to SmartEiffel mode.
		do
			eiffel_compiler_mode := eiffel_compiler_names.se_code
		ensure
			se_mode_set: eiffel_compiler_mode = eiffel_compiler_names.se_code
		end

feature -- Access

	eiffel_compiler_mode: INTEGER
			-- Eiffel compiler mode; See EWG_EIFFEL_COMPILER_NAMES

	eiffel_compiler_name: STRING is
			-- Eiffel compiler name; See EWG_EIFFEL_COMPILER_NAMES
		do
			Result := eiffel_compiler_names.eiffel_compiler_name_from_code (eiffel_compiler_mode)
		ensure
			name_not_void: Result /= Void
			name_valid_eiffel_name: eiffel_compiler_names.is_valid_eiffel_compiler_name (Result)
		end

feature -- Setting

	is_se_mode: BOOLEAN is
			-- Is current mode SmartEiffel mode?
		do
			Result := eiffel_compiler_mode = eiffel_compiler_names.se_code
		ensure
			definition: Result = (eiffel_compiler_mode = eiffel_compiler_names.se_code)
		end

	is_ise_mode: BOOLEAN is
			-- Is current mode ISE Eiffel mode?
		do
			Result := eiffel_compiler_mode = eiffel_compiler_names.ise_code
		ensure
			definition: Result = (eiffel_compiler_mode = eiffel_compiler_names.ise_code)
		end

	is_ve_mode: BOOLEAN is
			-- Is current mode Visual Eiffel mode?
		do
			Result := eiffel_compiler_mode = eiffel_compiler_names.ve_code
		ensure
			definition: Result = (eiffel_compiler_mode = eiffel_compiler_names.ve_code)
		end

feature -- Status setting

	set_eiffel_compiler_mode (a_mode: INTEGER) is
			-- Set `eiffel_compiler_mode' to `a_mode'.
			-- See EWG_EIFFEL_COMPILER_NAMES.
		require
			valid_a_mode: eiffel_compiler_names.is_valid_eiffel_compiler_code (a_mode)
		do
			eiffel_compiler_mode := a_mode
		ensure
			eiffel_compiler_mode_set: eiffel_compiler_mode = a_mode
		end

	set_se_mode is
			-- Set `eiffel_compiler_mode' to SmartEiffel mode.
		do
			set_eiffel_compiler_mode (eiffel_compiler_names.se_code)
		ensure
			mode_set: eiffel_compiler_mode = eiffel_compiler_names.se_code
		end

	set_ise_mode is
			-- Set `eiffel_compiler_mode' to ISE Eiffel mode.
		do
			set_eiffel_compiler_mode (eiffel_compiler_names.ise_code)
		ensure
			mode_set: eiffel_compiler_mode = eiffel_compiler_names.ise_code
		end

	set_ve_mode is
			-- Set `eiffel_compiler_mode' to Visual Eiffel mode.
		do
			set_eiffel_compiler_mode (eiffel_compiler_names.ve_code)
		ensure
			mode_set: eiffel_compiler_mode = eiffel_compiler_names.ve_code
		end

invariant

	valid_eiffel_compiler_mode: eiffel_compiler_names.is_valid_eiffel_compiler_code (eiffel_compiler_mode)

end
