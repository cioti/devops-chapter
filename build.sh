
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
    VERSION_FULL="${DIR/VERSION.ver}"
    echo "version = ${VERSION_FULL}"
    PATH_FULL="${MKFILE_FULL/Makefile/}"
    INCLUDE_MAKEFILE=$MKFILE make ${ACTION} WORKDIR=${DIRNAME} VERSION_FULL=${VERSION_FULL} BRANCH_NAME=${BRANCH_NAME} \
                       PATH_FULL=${PATH_FULL::-1} GH_TOKEN=${GH_TOKEN}
                      
     if [ $? -ne 0 ]; then
         echo "Build failed"         
         exit 1
     fi

    echo "${MKFILE_FULL}" > BUILT_LIST
    echo "BuiltList = ${BUILT_LIST}"
  else
    echo "Skip ${MKFILE_FULL} already built"
  fi
}

git diff-tree --name-only -r HEAD HEAD^ | while read line; do  
    echo "line is $line"
    build `dirname $line`
done