#!/bin/bash

usage="$(basename $0) [-h] [-d directory] [-v version] -- create a separate zip archive of every subdirectory of the current directory

where:
    -h  show this help text
    -d  limit the zip creation to the given directory
    -v  a version text to place in the VERSION file in every directory"

while getopts ':hd:v:' option; do
    case $option in
        h) echo "$usage"
           exit
           ;;
        v) printf "using version=$OPTARG\n"
           version=$OPTARG
           ;;
        d) printf "limiting to directory=$OPTARG\n"
           directory=$OPTARG
           ;;
        :) printf "missing argument for -%s\n" "$OPTARG" >&2
           echo "$usage" >&2
           exit 1
           ;;
        \?) printf "illegal option: -%s\n" "$OPTARG" >&2
           echo "$usage" >&2
           exit 1
           ;;
    esac
done

if ((OPTIND == 1))
then
    echo "no options specified"
    echo "$usage"
    exit 1
fi

shift $((OPTIND - 1))

if [ $directory ] ; then
    targetDirectories=$directory/
else
    targetDirectories=*/ #every directory in the current directory
fi

for i in $targetDirectories; do
    printf "Creating ${i}VERSION...\n"
    echo $version > ${i}VERSION
    printf "Compressing $i into archive...\n"
    zip -dc -r "${i%/}.zip" "$i" # zip displaying count of files
done
