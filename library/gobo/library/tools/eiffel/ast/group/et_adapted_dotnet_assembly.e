indexing

	description:

		"Eiffel adapted .NET assemblies of classes"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2008, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-04-22 17:56:35 +0200 (Tue, 22 Apr 2008) $"
	revision: "$Revision: 6372 $"

class ET_ADAPTED_DOTNET_ASSEMBLY

inherit

	ET_ADAPTED_UNIVERSE
		rename
			universe as dotnet_assembly
		redefine
			dotnet_assembly
		end

create

	make

feature -- Access

	dotnet_assembly: ET_DOTNET_ASSEMBLY
			-- .NET assembly being adapted

invariant

	dotnet_assembly_not_void: dotnet_assembly /= Void

end
