
note
	description: "Generated with Matisse Schema Definition Language 9.0.0";
	date: "$Date: 2011/12/03 00:41:49 $"

class 
	MTMETACLASS

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
	, make_mtmetaclass

-- BEGIN generation of accessors by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
-- generated with Matisse Schema Definition Language 9.0.0
-- Date: Thu Dec  1 10:19:33 2011



-- END of Matisse SDL generation of accessors

--
-- You may add your own code here...
--

feature -- Default Creation Function

	make_mtmetaclass (a_db: MT_DATABASE)
		-- Default make feature provided as an example
		-- You may delete or modify it to suit your needs.
		do
			make_from_mtclass (a_db.get_mtclass ("MTMETACLASS"))
		end

end -- class MTMETACLASS

