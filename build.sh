#!/bin/bash
# set -x
# set -f

# create tmp file to track built services.
> BUILT_LIST

build () {
  echo "Build input = $1"  
  DIRNAME=`echo $1`
  MKFILE=`echo "${DIRNAME}/Makefile"`
# depth represents the number of folders in the path e.g: /golang/ping-service/deploy will have a depth of 3
  DEPTH=${1//[^\/]/}

  # try to find a makefile starting from the last folder and "walking" to the first one
  for (( n=${#DEPTH}; n>0; --n )); do    
    if [ -f $MKFILE ]; then      
      break
    else      
      DIRNAME="${DIRNAME}/.."
      MKFILE=`echo "${DIRNAME}/Makefile"`
    fi
  done

  # get the full path of the makefile.
  MKFILE_FULL=`readlink -e ${MKFILE}`
  # build only if it's not on our list of built makefiles.    
  BUILT=$(<BUILT_LIST)    
  if [[ $BUILT != *"${MKFILE_FULL}"* ]]; then
    echo "Build ${DIRNAME} (${MKFILE_FULL})"
    DIR=`dirname ${MKFILE_FULL}`
  # by convention Version.ver should be in the same location as the Makefile
    VERSION_FILE=`echo "${DIR}/VERSION.ver"`
  # execute the Makefile
    make -f $MKFILE ${ACTION} VERSION_FILE=${VERSION_FILE} DIR=${DIR}
  
    if [ $? -ne 0 ]; then
      echo "Build failed"         
      exit 1
    fi

  # add makefile path to the already built list
    echo "${MKFILE_FULL}" > BUILT_LIST
  else
    echo "Skip ${MKFILE_FULL}; Already built"
  fi
}

# script starts here
# get list of all modified files for the current branch 
git diff-tree --name-only -r HEAD HEAD^ | while read line; do  
    echo "processing modified file: $line" 
    build `dirname $line`
    echo "------------------------------"
done