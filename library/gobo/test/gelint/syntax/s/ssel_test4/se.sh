#!/bin/sh

# system:     "SSEL test 4"
# library:    "Gobo Eiffel Tools Library"
# compiler:   "SmallEiffel -0.78"
# author:     "Eric Bezault <ericb@gobosoft.com>"
# copyright:  "Copyright (c) 1999, Eric Bezault and others"
# license:    "MIT License"
# date:       "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
# revision:   "$Revision: 5877 $"


export geoptions="-no_split -no_style_warning -no_gc"
compile $geoptions A make
