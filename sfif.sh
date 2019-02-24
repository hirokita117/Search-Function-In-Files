#!/bin/bash

### set arguments ########################################################################
COMMAND_NAME=$0
CHECK_FILES=$1
NUMBER_OF_EXTRACTS=$2
i=0
declare -a array=()
##########################################################################################

### help #################################################################################
function usage ()
{
	printf "\033[1mUsage:\033[m \033[33m$COMMAND_NAME\033[m\n"
	echo ""
	printf "\033[1mOverview:\033[m\n"
	echo "  This script lists the functions described in the file, you can search by selecting one from the list."
	echo "  You can only search for methods that have the visibility of public defined."
	echo "  The search range is lower than the current directory."
	echo "  By passing a number as the second argument, you can specify the number of output characters of the search result."
	echo "  For example, if you pass 300, only 300 letters will be displayed."
	echo "  This is useful when search results are too long."
	echo "  The upper limit of the number that can be passed to the second argument is 999."
	echo ""
	printf "\033[1mOptions and arguments:\033[m\n"
	printf " \033[33m$COMMAND_NAME\033[m \033[36m-h, --help\033[m :\n"
	echo "    --Display help."
	echo ""
	printf " \033[33m$COMMAND_NAME\033[m \033[1mstring\033[m \033[36mFILE\033[m :\n"
	echo "    --You can list functions and choose what you want to search."
	echo "    --Files that can be specified for searching are limited to those with an extension."
	echo "    --In the search result, the file name and the number of lines in which the function is used are displayed in color."
	echo ""
	printf " \033[33m$COMMAND_NAME\033[m \033[1mstring\033[m \033[36mFILE\033[m \033[1mint\033[m \033[36mARGUMENT\033[m :\n"
	echo "    --When searching for a function, letters are displayed only up to the passed argument."
	echo "    --As in the case where no argument is passed, the file name and the number of lines are displayed, but no color is attached."
	echo ""
}
##########################################################################################

### check arguments ######################################################################
if [ -z $CHECK_FILES ]; then
	echo "Argument is missing." 1>&2
	exit 1
fi

for OPT in "$@"
do
	case "$OPT" in
		-h | --help )
			usage
			exit 1
		;;
		*.* )
			if [ ! -e $CHECK_FILES ]; then
				echo "This file does not exist." 1>&2
				exit 1
			fi
			HAS_FILE="TRUE"
			shift 1
		;;
		[1-9] | [1-9][0-9] | [1-9][0-9][0-9] )
			if [ -z $HAS_FILE ]; then
				echo "The first argument, please specify the file." 1>&2
				exit 1
			fi
			IS_NUMBER="TRUE"
			shift 1
		;;
		* )
			echo "Something is wrong."
			echo "Usage: $COMMAND_NAME -h, --help"
			exit 1
		;;
	esac
done
##########################################################################################

### check if there is a function #########################################################
FUNCTIONS_LIST=`grep -o 'function [^_][a-z|A-Z|_|0-9]*' $CHECK_FILES | awk '{if(gsub(/function /, "")) print}' | wc -l`

if [ $FUNCTIONS_LIST = 0 ]; then
	echo "The function could not be found." 1>&2
	exit 1
fi
##########################################################################################

### list functions #######################################################################
while [ "$i" -le "$FUNCTIONS_LIST" ]
do
	CUT_FUNCTION_IN_LIST=`grep -o 'function [^_][a-z|A-Z|_|0-9]*' $CHECK_FILES | awk -v i="$i" 'NR==i {if(gsub(/function /, "")) print}'`
	array+=("$CUT_FUNCTION_IN_LIST")
	if [ "$i" -gt 0 ]; then
		echo "$i) "${array[$i]}
	fi
	((i++))
done
##########################################################################################

### select function and search ###########################################################
read -p "Please select number: " KEY

if [[ $KEY =~ [^0-9]+ || -z ${array[$KEY]} ]]; then
	echo "Please enter the correct number." 1>&2
	exit 1
fi

SEARCH_THING=${array[$KEY]}

if [ "$IS_NUMBER" = "TRUE" ]; then
	grep -nrw "$SEARCH_THING" | awk -v numberOfExtracts="$NUMBER_OF_EXTRACTS" 'extractionResult=substr($0, 1, numberOfExtracts) {print extractionResult}'
elif [ "$HAS_FILE" = "TRUE" ]; then
	grep -nrw "$SEARCH_THING" --color=auto
fi
##########################################################################################
