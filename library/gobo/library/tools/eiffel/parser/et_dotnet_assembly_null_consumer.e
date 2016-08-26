indexing

	description:

		"Null consumers of .NET assemblies"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2006, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

class ET_DOTNET_ASSEMBLY_NULL_CONSUMER

inherit

	ET_DOTNET_ASSEMBLY_CONSUMER

create

	make

feature -- Consuming

	consume_class (a_class: ET_CLASS) is
			-- Consume `a_class'.
		do
				-- Enforce postcondition.
			a_class.set_parsed
			a_class.set_syntax_error
		end

feature {ET_DOTNET_ASSEMBLY} -- Consuming

	consume_assembly (an_assembly: ET_DOTNET_ASSEMBLY) is
			-- Consume `an_assembly' and put the classes in `universe'.
		do
			-- Do nothing.
		end

	consume_gac_assembly (an_assembly: ET_DOTNET_GAC_ASSEMBLY) is
			-- Consume `an_assembly' and put the classes in `universe'.
		do
			-- Do nothing.
		end

end
