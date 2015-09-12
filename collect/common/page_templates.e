note
	description: "Summary description for {PAGE_TEMPLATES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PAGE_TEMPLATES

feature -- Implementation

--	main_static_page: STRING = "[
--	  <html>
--	    <header>
--	     <title>
--	       COLLECT
--	     </title>
--	   </header>
--	   <body>
--	     <h1>This is collect main page</h1>
--	     <h2>An HTML static page</h2>
--	     <p>Using the nino connector</p>
--	     <p>
--	       An attempt to use EWF for something usefull and in the meantime learn it
--	     </p>
--	   </body>
--	 </html>
--    ]"

	main_template: STRING = "[
	  <html> 
	    <header>
	     <title>
	       COLLECT
	     </title>
	   </header>
	   <body>
	     <h1>This is collect main page</h1>
	     <h2>An HTML dynamic page</h2>
	     <p>Using the nino connector</p>
	     <p>
	       An attempt to use EWF for something usefull and in the meantime learn it
	     </p>
	     <p>Server URL: $url</p>
	     <p>Content type: $ctype</p>
	   </body>
	 </html>
	]"

end
