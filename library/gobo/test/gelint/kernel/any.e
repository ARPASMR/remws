indexing

	description:

		"Dummy class ANY used by gelint tests."

	library:    "Gobo Eiffel Tools Library"
	author:     "Eric Bezault <ericb@gobosoft.com>"
	copyright:  "Copyright (c) 2001, Eric Bezault and others"
	license:    "MIT License"
	date:       "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision:   "$Revision: 5877 $"

class ANY

inherit

	GENERAL

feature -- Access

	generating_type: STRING is
		do
		end

	generator: STRING is
		do
		end

feature -- Output

	print (an_object: ANY) is
		do
		end

end -- class ANY
