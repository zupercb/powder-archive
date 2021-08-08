#!/bin/bash

echo If this fails due to trying to write
echo to allrooms.cpp, make sure you do not
echo have MSVC running, as it is trying to
echo do an auto-load and thrashing.

echo Compiling rooms...

nummap=`ls -r *.map | wc -w`

for s in *.map; do
    echo Compiling $s...
    # I really hate bash.
    cname=`echo ${s} | sed s/.map/.cpp/g`
    ../support/map2c/map2c $s $cname
done

echo Building header file...
echo "// Auto-generated .h file" > allrooms.h
echo "// DO NOT HAND EDIT" >> allrooms.h
echo "// Generated by buildrooms.sh" >> allrooms.h
echo " " >> allrooms.h
echo "#define NUM_ALLROOMDEFS $nummap" >> allrooms.h
echo "extern const ROOM_DEF *glb_allroomdefs[$nummap+1];" >> allrooms.h

echo Building .cpp file..
echo "// Auto-generated .cpp file" > allrooms.cpp
echo "// DO NOT HAND EDIT" >> allrooms.cpp
echo "// Generated by buildrooms.sh" >> allrooms.cpp
echo " " >> allrooms.cpp
echo '#include "../map.h"' >> allrooms.cpp

for s in *.map; do
    echo -n '#include "' >> allrooms.cpp
    cname=`echo ${s} | sed s/.map/.cpp/g`
    echo -n $cname >> allrooms.cpp
    echo '"' >> allrooms.cpp
done

echo " " >> allrooms.cpp

echo "const ROOM_DEF *glb_allroomdefs[$nummap+1] =" >> allrooms.cpp
echo "{" >> allrooms.cpp
for s in *.map; do
    cname=`echo ${s} | sed s/.map//g`
    echo "	&glb_${cname}_roomdef," >> allrooms.cpp
done
echo "	0" >> allrooms.cpp
echo "};" >> allrooms.cpp
