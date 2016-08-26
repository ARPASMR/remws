The following commands assume the database is example@localhost.

1 - Initialize the database:

mt_server -d example -s stop

mt_server -d example init


2 - Load the schema:

mt_sdl -d example import --odl -f examples.odl


3 - Generate the Persistent Classes:

mt_sdl stubgen --lang eiffel -f examples.odl


3 - Compile the Eiffel projects

3.1 - Learn about relationships

open the rshp.ecf file and click compile 


3.2 - Learn about Indexes

open the index.ecf file and click compile


3.3 - Learn about Entry-Point Dictionaries

open the epdict.ecf file and click compile



For more information on this sample application, see the Matisse Eiffel 
Programmer's Guide.

http://www.matisse.com/developers/documentation/

***
