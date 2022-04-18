#!/bin/bash
# set -x
# set -f

# create tmp file to track built services.
> BUILT_LIST

build () {
  echo "Build input = $1"  
  DIRNAME=`echo $1`
  MKFILE=`echo "${DIRNAME}/Makefile"`
  DEPTH=${1//[^\/]/}

  # Try walking up the path until we find a makefile.
  for (( n=${#DEPTH}; n>0; --n )); do    
    if [ -f $MKFILE ]; then      
      break
    else      
      DIRNAME="${DIRNAME}/.."
      MKFILE=`echo "${DIRNAME}/Makefile"`
    fi
  done

  # Get the full path of the makefile.
  MKFILE_FULL=`readlink -e ${MKFILE}`
  # Build only if it's not on our list of built makefiles.    
  BUILT=$(<BUILT_LIST)    
  if [[ $BUILT != *"${MKFILE_FULL}"* ]]; then
    echo "Build ${DIRNAME} (${MKFILE_FULL})"
    DIR=`dirname ${MKFILE_FULL}`
    VERSION_FILE=`echo "${DIR}/VERSION.ver"`
    TEST=$MKFILE make ${ACTION} VERSION_FILE=${VERSION_FILE} DIR=${DIR}
  
    if [ $? -ne 0 ]; then
      echo "Build failed"         
      exit 1
    fi

    echo "${MKFILE_FULL}" > BUILT_LIST
  else
    echo "Skip ${MKFILE_FULL} already built"
  fi
}

git diff-tree --name-only -r HEAD HEAD^ | while read line; do  
    echo "building line: $line"
    build `dirname $line`
    echo "------------------------------"
done