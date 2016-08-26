indexing

	description:

		"Error: TODO"

	copyright: "Copyright (c) 2004, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/03/20 22:44:14 $"
	revision: "$Revision: 1.2 $"

class EWG_ILLEGAL_REGULAR_EXPRESSION_IN_ATTRIBUTE_ERROR

inherit

	UT_ERROR

creation

	make

feature {NONE} -- Initialization


	make (a_containing_element: XM_ELEMENT;
			an_attribute_name: STRING;
			a_position: XM_POSITION;
			a_error_message: STRING;
			a_error_position: INTEGER) is
		require
			a_containing_element_not_void: a_containing_element /= Void
			an_attribute_name_not_void: an_attribute_name /= Void
			an_attribute_name_not_empty: an_attribute_name.count > 0
			a_containing_element_has_attribute: a_containing_element.has_attribute_by_name (an_attribute_name)
			a_position_not_void: a_position /= Void
			a_error_message_not_void: a_error_message /= Void
		do
			create parameters.make (1, 6)
			parameters.put (a_containing_element.name, 1)
			parameters.put (an_attribute_name, 2)
			parameters.put (a_position.out, 3)
			parameters.put (a_containing_element.attribute_by_name (an_attribute_name).value, 4)
			parameters.put (a_error_message, 5)
			parameters.put (a_error_position.out, 6)
		end

feature -- Access

	default_template: STRING is "The value '$4' of attribute '$2' of element '$1' is not a valid regular expression%N. Error '$5' at position $6 in string $3"
			-- Default template used to built the error message

	code: STRING is "EWG0005"
			-- Error code

end
