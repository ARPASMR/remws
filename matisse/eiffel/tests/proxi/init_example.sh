#!/bin/bash
mt_server -d example -s stop
sleep 1
mt_server -d example -s initialize
mt_sdl -d example import --odl -f ./test.odl
mt_sdl -d example import --odl -f ./testundefined.odl
mt_xml -d example import -f ./test.xml
