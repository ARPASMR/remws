		Matisse-Eiffel Binding Unit Test Suite
		+------------------------------------+


1. Requirements
+-------------+

 * Windows Vista/7/8, or Linux.
 * Matisse 9.1.x or higher.
 * EiffelStudio 7 or higher 
   (Either GNU gcc compiler or Microsoft C/C++ complier).
 * Gobo delivered with EiffelStudio
   (The binding relies on the Gobo Unicode String classes)


2. Load Test Data
+---------------+

Prior to running the test suite, you need to initialize a Matisse database, and
load the test data.

- Step 1: Initialize the 'example' database

   Launch the Enterprise Manager, then
   Select the icon of the 'example' database and right-click on it to select
   'Re-initialize'.

   or in a command line window execute:
   % mt_server -d example init
   

- Step 2: Import the database schema

   From the Enterprise Manager, import the database schema using the ODL file 
   (test.odl) located in $MATISSE_HOME/eiffel/test

   or in a command line window execute:
   % mt_sdl -d example import --odl -f $MATISSE_HOME/eiffel/test/test.odl
   % mt_sdl -d example import --odl -f $MATISSE_HOME/eiffel/test/testundefined.odl


- Step 3: Load the test data.

   From the Enterprise Manager, import the XML data (test.xml) located in the
   same directory

   or in a command line window execute:
   % mt_xml -d example import -f test.xml


3. Generate the source code for testing
+-------------------------------------+

- Step 1:

   To generate the Eiffel clesses from the database schema, run the following
   command:
   % mt_sdl stubgen --lang eiffel -f $MATISSE_HOME/eiffel/test/test.odl


- Step 2:

   To generate Eiffel source code for testing, run the following command:

   % $ISE_EIFFEL/library/gobo/spec/$ISE_PLATFORM/bin/getest -g getest.config



Edit $ISE_LIBRARY/library/gobo/gobo_test.ecf
Add line:
<library name="gobo_regexp" location="$ISE_LIBRARY\library\gobo\gobo_regexp.ecf"/>



4. Compile the Test Suite
+-----------------------+

To compile the Eiffel project, open the test_sample.ecf file located in 
$MATISSE_HOME/eiffel/test.


Now, you can run the unit tests.

NOTE: in order to change the database name used in the test suite, edit
      the class COMMON_FEATURE's target_host and target_database.

