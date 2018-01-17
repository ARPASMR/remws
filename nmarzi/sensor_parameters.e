note
	description : "Summary description for {SENSOR_PARAMETERS}."
	copyright   : "$Copiright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	source      : "[
		Luca Paganotti <luca.paganotti (at) gmail.com>
		Via dei Giardini, 9
		21035 Cunardo (VA)
	]"
	date        : "$Date 2017-12-10 19:11:38 (dom 10 dic 2017, 19.11.38, CET) buck $"
	revision    : "$Revision 48 $"

class
	SENSOR_PARAMETERS
	inherit
		ANY

create
	make,
	make_with_parameters

feature -- Initialization

	make
			--
		do
		end

	make_with_parameters(i, f, o, g: INTEGER)
			-- make with parameters
		do
			id          := i
			function    := f
			operator    := o
			granularity := g
		end

feature -- Access

	id: INTEGER
			-- sensor id

	function: INTEGER
			-- sensor function

	operator: INTEGER
			-- sensor operator

	granularity: INTEGER
			-- sensor granularity

feature -- Status setting

	set_id(i: INTEGER)
			--
		do
			id := i
		end

	set_function(f: INTEGER)
			--
		do
			function := f
		end

	set_operator(o: INTEGER)
			--
		do
			operator := o
		end

	set_granularity(g:INTEGER)
			--
		do
			granularity := g
		end

end
