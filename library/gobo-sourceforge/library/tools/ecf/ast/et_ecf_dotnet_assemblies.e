indexing

	description:

		".NET assembly lists read from ECF file"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2006, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

class ET_ECF_DOTNET_ASSEMBLIES

inherit

	ET_DOTNET_ASSEMBLIES
		redefine
			assembly
		end

create

	make, make_empty

feature -- Access

	assembly (i: INTEGER): ET_ECF_DOTNET_ASSEMBLY is
			-- `i'-th assembly
		do
			Result := assemblies.item (i)
		end

end
