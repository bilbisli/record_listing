#!/bin/bash

# imports
for import in $(dirname "${BASH_SOURCE[0]}")/*/*.sh; do
	source $import
done


# get_log_file()
# This function returns the log file relative path
# value output: value output (return) is done by the echo method
# usage: local log_file_path=$(get_log_file)
function get_log_file()
{
	
	echo "$(dirname "${BASH_SOURCE[0]}")/logging/listing_log"
	return 0
}

# get_record_file()
# This function returns the database file located in relative path, if it does not exists - function will create it
# value output: value output (return) is done by the echo method
# return status: 0 if record listing databse file existed before function call, 1 otherwise
# usage: local listing_path=$(get_record_file)
function get_record_file()
{
	local ret_status=0
	local db_file_path="$(dirname "${BASH_SOURCE[0]}")/db/listing.csv"
	
	if [ ! -f "${db_file_path}" ]; then
		touch "${db_file_path}"
		ret_status=1
	fi
	
	return $ret_status
}

# menu()
# This function displays the menu for the record listing management and lets the user choose an operation to be executed
# value output: none
# usage: menu()
function menu()
{
	local keep_running_flag=true
	local exit_option="Exit"
	local ret_status=1							# successful return status (0) only when exit option is chosen from menu
	local result=0
	local function_parameters=()
	
	# options displayed to user
	local options=("Insert record" "Delete record" "Search records" "Update record name" "Update record amount")
	local options+=("$exit_option")
	# parallel operations (functions) to each option displayed to user
	# TODO: add the remaining functions
	local operations=("insert_record" "delete_record" "search_record" "update_name" "update_count")
	local operations+=('exit 0')
	# parallel result message (if different messages are needed)
	# local operation_result=("insert_record" "delete_record" "search_record" "update_name" "update_count")
	
	while [[ "$keep_running_flag" == true ]]; do
		# menu presentation
		echo "Choose an item:"
		for (( i=0 ; i < ${#operations[@]} ; i++ )) do
			echo -e "\t$(($i + 1))) ${options[i]}"
		done
		
		# menu choice
		read -p "Choice: " choice
		if [[ "$choice" == [1-${#operations[@]}] ]]; then
			echo "Option chosen: ${options[choice - 1]}"

			if [[ "${options[choice - 1]}" == "$exit_option" ]]; then	# exit condition
				keep_running_flag=false
				ret_status=0						# successful return status (0)
			else								# operations
				# operands validation
				${operations[choice - 1]}
			fi
		else
			echo "Error - no such option."  >> /dev/stderr
		fi
		echo -e "\n#################################################\n"
	done
	
	return $ret_status
}


function main()
{
	menu ${@}
	local ret_status="$?"

	exit "$ret_status"
}


# in case of running as a script
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "${@}"
fi

