
note
	description: "Generated with Matisse Schema Definition Language 9.0.0";
	date: "$Date: 2011/12/03 00:41:49 $"

class 
	MTMETHOD

inherit

-- BEGIN generation of inheritance by Matisse SDL
-- BEGIN generation of ancestor by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
	MTOBJECT
-- END of Matisse SDL generation of end
-- END of Matisse SDL generation of inheritance

-- BEGIN generation of create by Matisse SDL
create
	make_from_mtoid
	, make_from_mtclass
-- END of Matisse SDL generation of create
	, make_mtmethod


feature -- Creation Function

	make_mtmethod (a_db: MT_DATABASE)
		-- Default make feature provided as an example
		-- You may delete or modify it to suit your needs.
		do
			make_from_mtclass (a_db.get_mtclass ("MTMETHOD"))
		end

-- BEGIN generation of accessors by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
-- generated with Matisse Schema Definition Language 9.0.0
-- Date: Fri Dec  2 11:53:12 2011

feature -- Entry Point Dictionary Access

	mtnamedictionary_name: STRING = "MtNameDictionary"

feature -- Property Access

	get_mtname_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of MtName from the database
		do
			Result := mtdb.get_mtattribute("MtName", mtdb.get_mtclass("MTMETHOD"))
		end

	mtname, get_mtname (): STRING
		-- get the value of MtName from the database
		do
			Result := get_string (get_mtname_attribute ())
		end

	is_mtname_default_value (): BOOLEAN
		-- Check if MtName attribute value is set to its default value
		do
			Result := is_default_value (get_mtname_attribute ())
		end

	get_mtstatic_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of MtStatic from the database
		do
			Result := mtdb.get_mtattribute("MtStatic", mtdb.get_mtclass("MTMETHOD"))
		end

	mtstatic, get_mtstatic (): BOOLEAN
		-- get the value of MtStatic from the database
		do
			Result := get_boolean (get_mtstatic_attribute ())
		end

	is_mtstatic_default_value (): BOOLEAN
		-- Check if MtStatic attribute value is set to its default value
		do
			Result := is_default_value (get_mtstatic_attribute ())
		end

	get_mtsource_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of MtSource from the database
		do
			Result := mtdb.get_mtattribute("MtSource", mtdb.get_mtclass("MTMETHOD"))
		end

	mtsource, get_mtsource (): STRING
		-- get the value of MtSource from the database
		do
			Result := get_string (get_mtsource_attribute ())
		end

	is_mtsource_default_value (): BOOLEAN
		-- Check if MtSource attribute value is set to its default value
		do
			Result := is_default_value (get_mtsource_attribute ())
		end

	get_mtsignature_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of MtSignature from the database
		do
			Result := mtdb.get_mtattribute("MtSignature", mtdb.get_mtclass("MTMETHOD"))
		end

	mtsignature, get_mtsignature (): ARRAY [NATURAL_8]
		-- get the value of MtSignature from the database
		do
			Result := get_bytes (get_mtsignature_attribute ())
		end

	is_mtsignature_default_value (): BOOLEAN
		-- Check if MtSignature attribute value is set to its default value
		do
			Result := is_default_value (get_mtsignature_attribute ())
		end

	get_mtsignature_elements (buffer: ARRAY [NATURAL_8]; count, offset: INTEGER_32) : INTEGER_32
		do
			Result := get_byte_list_elements (get_mtsignature_attribute(), buffer, count, offset)
		end

	get_mtsignature_size () : INTEGER_32
		do
			Result := get_list_size (get_mtsignature_attribute())
		end

	get_mtmethodof_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtMethodOf from the database
		do
			Result := mtdb.get_mtrelationship ("MtMethodOf", mtdb.get_mtclass("MTMETHOD"))
		end

	mtmethodof, get_mtmethodof (): MTCLASS
		-- get the MtMethodOf relationship successor from the database
		do
			Result ?= get_successor (get_mtmethodof_relationship ())
		end


feature -- Update Attributes

	set_mtname (a_val: STRING)
		-- update MtName attribute value in the database
		do
			set_string (get_mtname_attribute (), a_val)
		end

	remove_mtname ()
		-- remove MtName attribute value in the database
		do
			remove_value (get_mtname_attribute ())
		end

	set_mtstatic (a_val: BOOLEAN)
		-- update MtStatic attribute value in the database
		do
			set_boolean (get_mtstatic_attribute (), a_val)
		end

	remove_mtstatic ()
		-- remove MtStatic attribute value in the database
		do
			remove_value (get_mtstatic_attribute ())
		end

	set_mtsource (a_val: STRING)
		-- update MtSource attribute value in the database
		do
			set_string (get_mtsource_attribute (), a_val)
		end

	remove_mtsource ()
		-- remove MtSource attribute value in the database
		do
			remove_value (get_mtsource_attribute ())
		end

	set_mtsignature (a_val: ARRAY [NATURAL_8])
		-- update MtSignature attribute value in the database
		do
			set_bytes (get_mtsignature_attribute (), a_val)
		end

	remove_mtsignature ()
		-- remove MtSignature attribute value in the database
		do
			remove_value (get_mtsignature_attribute ())
		end

	set_mtsignature_elements(buffer: ARRAY [NATURAL_8]; buffer_size, offset: INTEGER_32;
			discard_after: BOOLEAN)
		do
			set_byte_list_elements (get_mtsignature_attribute (), buffer,
					buffer_size, offset, discard_after)
		end

	set_mtmethodof (succ: MTCLASS)
		-- Update MtMethodOf relationship successor
		do
			set_successor (get_mtmethodof_relationship (), succ)
		end

	clear_mtmethodof ()
		-- Remove MtMethodOf relationship successor
		do
			clear_successors (get_mtmethodof_relationship ())
		end


-- END of Matisse SDL generation of accessors


end -- class MTMETHOD

