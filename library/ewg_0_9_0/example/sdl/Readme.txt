
This example demonstrates how to wrap and use sdl.
Please note that not only must sdl 1.2 runtime be installed, 
but also the sdl 1.2 development files must be present.

On Linux this usually means installing the corresponding packages.

On Windows this means getting SDL-devel-1.2.5a-VC6.zip 
(from from http://www.libsdl.org/download-1.2.php) and
http://www.libsdl.org/projects/SDL_image/ 
(from http://www.libsdl.org/projects/SDL_image/) or getting
and compiling the source package yourself.

Then after unpacking resp. unpacking and compiling set the variables 
SDL to the dir where you unpacked the above packages in.
Copy all dlls found in the package into your system dir.

Using lcc-win32 you need to also import the files SDL.lib and SDL_image.lib
and use the newly generated files instead.

The SDL wrapper provided here is only a proof of concept, if you are
looking for an Eiffel SDL wrapper, there is a EWG based one at
http://eiffelsdl.sourceforge.net/ .
