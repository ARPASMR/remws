note
	description: "Summary description for {RT10_SENSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RT10_SENSOR

inherit
	TIME_GRANULARITY_CODES
	redefine
		out
	end
	APPLIED_OPERATOR_CODES
	redefine
		out
	end
	SENSOR_TYPOLOGY_CODES
	redefine
		out
	end
	DEFAULTS
	redefine
		out
	end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create typology.make_empty
			create destination.make_empty
			create last_dates.make (0)
			create table.make_empty
			create operators.make (0)
			create measures.make (0)
		end

feature -- Access

	sensor_id: INTEGER
			-- Sensor identifier
	destination: STRING
			-- Destination
	time_granularity: INTEGER
			-- Time granularity
	typology: STRING
			-- Sensor typology
	last_dates: ARRAYED_LIST[DATE_TIME]
			-- Last acquisition date time
	table: STRING
			-- Referenced table
	operators: ARRAYED_LIST[INTEGER]
			-- Applied operators
	measures:  ARRAYED_LIST[ARRAYED_LIST[MEASURE]]
			-- Operator related measures

feature -- Status setting

	set_sensor_id(id: INTEGER)
			-- Sets `sensor_id'
		do
			sensor_id := id
		end

	set_destination(dest: STRING)
			-- Sets `destination'
		require
			dest_not_void: dest /= Void
		do
			destination.copy (dest)
		end

	set_time_granularity(granularity: INTEGER)
			-- Sets `time_granularity'
		do
			if granularity = 1 then
				time_granularity := one_minute
			elseif granularity = 5 then
				time_granularity := five_minutes
			elseif granularity = 10 then
				time_granularity := ten_minutes
			elseif granularity = 30 then
				time_granularity := thirty_minutes
			elseif granularity = 60 then
				time_granularity := sixty_minutes
			elseif granularity = 180 then
				time_granularity := three_hours
			else
				time_granularity := ten_minutes
			end
		end

	set_typology(t: STRING)
			-- Sets `typology'
		require
			t_not_void: t /= Void
		do
			operators.wipe_out
			typology.copy (t)
			if typology.is_equal (temperature) then
				table.copy ("M_Termometri")
				operators.extend (average)
				operators.extend (minimum)
				operators.extend (maximum)
			elseif typology.is_equal (wind_speed) then
				table.copy ("M_AnemometriVV")
				operators.extend (average)
				operators.extend (maximum)
			elseif typology.is_equal (wind_direction) then
				table.copy ("M_AnemometriDV")
				operators.extend (average)
				operators.extend (maximum)
			elseif typology.is_equal (relative_humidity) then
				table.copy ("M_Igrometri")
				operators.extend (average)
			elseif typology.is_equal (rainfall) then
				table.copy ("M_Pluviometri")
				--operators.extend (average)
				operators.extend (cumulated)
			elseif typology.is_equal (global_radiation) then
				table.copy ("M_RadiometriG")
				operators.extend (average)
			elseif typology.is_equal (net_radiation) then
				table.copy ("M_RadiometriN")
				operators.extend (average)
			elseif typology.is_equal (atmospheric_pressure) then
				table.copy ("M_Barometri")
				operators.extend (average)
			elseif typology.is_equal (snow) then
				table.copy ("M_Nivometri")
				operators.extend (average)
			elseif typology.is_equal (sonic_wind_direction) then
				table.copy ("M_AnemometriDV")
				operators.extend (average)
			elseif typology.is_equal (sonic_wind_speed) then
				table.copy ("M_AnemometriVV")
				operators.extend (average)
			elseif typology.is_equal (idro) then
				table.copy ("M_Idrometri")
				operators.extend (average)
			--elseif typology.is_equal (present_time) then
			--	table.copy ("M_")
			--	operators.extend (average)
			end
		end

	set_table (tbl: STRING)
			-- Sets `table'
		do
			table.copy (tbl)
		end

feature -- Representation

	out: STRING
			-- String representation
		do
			Result := "{" + sensor_id.out + ", "
			              + destination + ", "
			              + time_granularity.out + ", "
			              + typology + ", "
			              + table + ", "

			if operators.is_empty then
				Result := Result + "No operators, "
			else
				from operators.start
				until operators.after
				loop
					Result := Result + "%N%T" + operators.item.out + "%N"

					if last_dates.is_empty then
						Result := Result + "No last dates, "
					else
						from last_dates.start
						until last_dates.after
						loop
							Result := Result + "%T" + last_dates.item.formatted_out (default_date_time_format) + "%N"
							last_dates.forth
						end
					end

					if measures.is_empty then
						Result := Result + "No measures"
					else
						from measures.start
						until measures.after
						loop
							from measures.item.start
							until measures.item.after
							loop
								Result := Result + "%T" + measures.item.out + "%N"
								measures.item.forth
							end

							measures.forth
						end
					end

					operators.forth
				end
			end

			Result := Result + "}"
		end

end
