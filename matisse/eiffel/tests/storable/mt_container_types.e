
note
	description: "Generated with Matisse Schema Definition Language 8.4.0";
	date: "$Date: 2010/10/24 02:22:54 $"

class
	MT_CONTAINER_TYPES

feature {NONE}

	container_class_for_relationship (rel_name: STRING): STRING
		-- Find the class name for a MATISSE relationship 'rel_name'
		-- Default class is MT_LINKED_LIST.
		do
			container_class_names.search (rel_name)
			if container_class_names.found then
				Result := container_class_names.found_item
			else
				Result := "MT_LINKED_LIST"
			end
		end

	Container_class_names: HASH_TABLE [STRING, STRING]
		-- Value is a container class name in upper case.
		-- Key is a MATISSE relationship name.
		once
			Create Result.make (20)
			Result.put ("MT_HASH_TABLE", "Person__cars_ht")
		end

end -- class MT_CONTAINER_TYPES
