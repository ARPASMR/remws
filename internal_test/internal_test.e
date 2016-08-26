note
	description : "internal_test application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	INTERNAL_TEST

inherit
	ARGUMENTS
	INTERNAL

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			i:         INTEGER
			a_mean:    VEHICLE
			a_car:     CAR
			a_bycicle: BYCICLE
			a_field:   detachable ANY
			a_oid:     OID
		do
			--| Create some usefull objects
			create a_mean
			create a_car
			create a_bycicle
			create a_oid

			--| Add your code here
			print ("Internal test!%N")
			print ("Create an OID object: "          + a_oid.id.string                                + "%N")

			print ("I am an instance of class: "     + class_name (Current)                           + "%N")
			print ("My generating type: "            + generator                                      + "%N")

			print ("my type name is: "               + type_name (Current)                            + "%N")
			print ("my dynamic type is: "            + dynamic_type (Current).out                     + "%N")
			print ("I have "                         + field_count (Current).out        + " fields"   + "%N")
			print ("my physical size is: "           + physical_size (Current).out      + " bytes"    + "%N")
			print ("my deep physical size is: "      + deep_physical_size (Current).out + " bytes"    + "%N")
			if is_special (Current) then
				print ("I am ")
			else
				print ("I am not ")
			end
			print ("a special class%N%N")

			print ("a_mean is an instance of class: " + class_name(a_mean)                       + "%N")
			print ("a_mean generating type: "         + a_mean.generator                         + "%N")
			print ("a_mean type name is: "            + type_name (a_mean)                       + "%N")
			print ("a_mean dynamic type is: "         + dynamic_type (a_mean).out                + "%N")
			print ("a_mean has "                      + field_count (a_mean).out     + " fields" + "%N")
			from
				i := 1
			until
				i > field_count(a_mean)
			loop
				a_field ?= field (i, a_mean)
				print ("Field " + i.out + " name is: " + field_name (i, a_mean) + " of type: " + field_type(i, a_mean).out)
				if attached a_field then
					print(" (" + type_name (a_field) + ")")
				end
				print ("%N")
				i := i + 1
			end
			print ("a_mean physical size is: "        + physical_size (a_mean).out      + " bytes"  + "%N")
			print ("a_mean deep physical size is: "   + deep_physical_size (a_mean).out + " bytes"    + "%N")
			if is_special (a_mean) then
				print ("a_mean is ")
			else
				print ("a_mean is not ")
			end
			print ("a special class%N%N")

			print ("a_car is an instance of class: " + class_name(a_car)                         + "%N")
			print ("a_car generating type: "         + a_car.generator                           + "%N")
			print ("a_car type name is: "            + type_name (a_car)                         + "%N")
			print ("a_car dynamic type is: "         + dynamic_type (a_car).out                  + "%N")
			print ("a_car has "                      + field_count (a_car).out     + " fields"   + "%N")
			from
				i := 1
			until
				i > field_count(a_car)
			loop
				a_field ?= field (i, a_car)
				print ("%TField " + i.out + " name is: " + field_name (i, a_car) + " of type: " + field_type(i, a_car).out)
				if attached a_field then
					print(" (" + type_name (a_field) + ")")
				end
				print ("%N")
				i := i + 1
			end
			print ("a_car physical size is: "        + physical_size (a_car).out      + " bytes"    + "%N")
			print ("a_car deep physical size is: "   + deep_physical_size (a_car).out + " bytes"    + "%N")
			if is_special (a_car) then
				print ("a_car is ")
			else
				print ("a_car is not ")
			end
			print ("a special class%N%N")

			print ("a_bycicle is an instance of class: " + class_name(a_bycicle)                         + "%N")
			print ("a_bycicle generating class: "        + a_bycicle.generator                           + "%N")
			print ("a_bycicle type name is: "            + type_name (a_bycicle)                         + "%N")
			print ("a_bycicle dynamic type is: "         + dynamic_type (a_bycicle).out                  + "%N")
			print ("a_bycicle has "                      + field_count (a_bycicle).out     + " fields"   + "%N")
			from
				i := 1
			until
				i > field_count(a_bycicle)
			loop
				a_field ?= field (i, a_bycicle)
				print ("%TField " + i.out + " name is: " + field_name (i, a_bycicle) + " of type: " + field_type(i, a_bycicle).out)
				if attached a_field then
					print(" (" + type_name (a_field) + ")")
				end
				print ("%N")
				i := i + 1
			end
			print ("a_bycicle physical size is: "        + physical_size (a_bycicle).out      + " bytes"    + "%N")
			print ("a_bycicle deep physical size is: "   + deep_physical_size (a_bycicle).out + " bytes"    + "%N")
			if is_special (a_bycicle) then
				print ("a_bycicle is ")
			else
				print ("a_bycicle is not ")
			end
			print ("a special class%N%N")

			print ("Now assign a_car to a_mean%N")
			a_mean := a_car
			print ("a_mean is an instance of class: " + class_name(a_mean)                       + "%N")
			print ("a_mean generating class: "        + a_mean.generator                         + "%N")
			print ("a_mean type name is: "            + type_name (a_mean)                       + "%N")
			print ("a_mean dynamic type is: "         + dynamic_type (a_mean).out                + "%N")
			print ("a_mean has "                      + field_count (a_mean).out     + " fields" + "%N")
			from
				i := 1
			until
				i > field_count(a_mean)
			loop
				a_field ?= field (i, a_mean)
				print ("%TField " + i.out + " name is: " + field_name (i, a_mean) + " of type: " + field_type(i, a_mean).out)
				if attached a_field then
					print(" (" + type_name (a_field) + ")")
				end
				print ("%N")
				i := i + 1
			end
			print ("a_mean physical size is: "        + physical_size (a_mean).out      + " bytes"  + "%N")
			print ("a_mean deep physical size is: "   + deep_physical_size (a_mean).out + " bytes"    + "%N")
			if is_special (a_mean) then
				print ("a_mean is ")
			else
				print ("a_mean is not ")
			end
			print ("a special class%N%N")


		end

end
