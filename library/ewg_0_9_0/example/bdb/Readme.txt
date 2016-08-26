
This example demonstrates how to wrap and use the Berkeley database (bdb).
Please note that not only must Berkeley db 4.1 runtime be installed, 
but also the Berkeley db development files must be present.

On Linux this usually means installing the corresponding packages.

BDB uses structs whos members are function pointers. This is their way
to do OO style programming in C. It is a concept similar to C++ vtables.
Right now, it is a bit cumbersome to use those with ewg (this will improve
in the future). For each function pointer (callback) a certain callback class
will be generated. One of the features in there is a feature (call_*) that takes a
function pointer as first argument, followed by the parameters of that
particular function type. The example demonstrates how one can use these
features to call function pointer.

Also note that BDB on Linux uses a dirty macro trick to add the version number
to function names. On windows this does not happen. We have to manually provide an
additional wrapper to make things portable again. These things can hopefully be
automated once ewg implements custom mappings.

Using Windows you need to get the source package of BDB from:
http://www.sleepycat.com/download/index.shtml

unpack and compile it. Set the environment variable BDB to point to
the root directory of the unpacked package. Now using Visual C, read the
documentation of the package of how to build it. Make sure you build the
debug/dynamically linked version.

lcc-win32/se has not yet been tested with BDB.
