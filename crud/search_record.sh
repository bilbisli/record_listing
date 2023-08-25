#! /bin/bash

source ../logging/insert_log.sh


function get_log_file()
{
	echo "../logging/listing_log"
	return 0
}

# get_record_file()
# This function returns the database file relative path
# value output: value output (return) is done by the echo method
# usage: local listing_path=$(get_record_file)
function get_record_file()
{
	echo "../db/listing.csv"
	return 0
}

# search_record(search_phrase...)
# This function searches a given phrase (might be multiple words in one phrase) in the database and returns the result
# value output: value output (return) is done by the echo method
# @return ret_status: 0 for succesful search result and record retrieval, 1 otherwise
function search_record()
{
	local RECORD_FILE=$(get_record_file)
	local LOG_EVENT="Search"
	local log_status="Success"
	local result=0
	local ret_status=0
	local search_phrase="${@}"
	
	result="`grep "${search_phrase[@]}" "${RECORD_FILE}" | sort -k 1`"
	
	if [[ "${#result}" -eq 0 ]]; then
		echo "No such record" >> /dev/stderr
		ret_status=1
	else
		echo "${result}"
	fi
	
	if [[ "${ret_status}" -ne 0 ]]; then
		log_status="Failure"
	fi
	insert_log ${LOG_EVENT} ${log_status}
	
	return $ret_status
}

# search_record_get_single(search_record_get_single_result,optional:--add,search_phrase...)
# This function searches a given record and lets the user choose one if multiple records are found
# @param search_record_get_single_result: the variable name (reference) to store the result in
# @param --add: indicated whether the search term itself should be an option for the user to choose from if more than one record is found
# @param search_phrase: the rest of the parameters will be assigned to the search phrase
# @return ret_status: returns the status of the ofunction peration - 2 if record not in database and is returned, 0 for successful record return, 1 otherwise
# usage: search_record_get_single calling_func_result_var --add ${search_phrase}
# NOTE: the parameter 'calling_func_result_var' should be the name of a valid declared variable to store the result in
# IMPORTANT: make sure to no call the 'calling_func_result_var' the same as 'search_record_get_single_result' - it willresult in a circular name reference
function search_record_get_single()
{
	local RECORD_FILE=$(get_record_file)
	local ADD_OPTION="--add"
	
	local results_count=0
	local ret_status=0
	local add_option=false
	local is_phrase_exist=true
	local added_search_phrase_flag=false
	local record_names=""
	local search_phrase_copy=""
	local -n search_record_get_single_result="$1"
	shift
	local search_phrase=("${@}")
	local options=()
	
	if [[ "${search_phrase[0]}" == "${ADD_OPTION}" ]]; then
		add_option=true
		search_phrase=("${search_phrase[@]:1}")
	fi

	### workaround to handle the pitfall of local declaration changing the return status ($?) - 'search_record_func_result_in_get_single' must be globaly unique
	search_record_func_result_in_get_single="$(search_record "${search_phrase[@]}")"
	ret_status="$?"
	###
	record_names=`echo "${search_record_func_result_in_get_single}" | cut -d "," -f1`
	results_count="`echo "${search_record_func_result_in_get_single}" | wc -l`"
	search_record_get_single_result="${record_names}"

	if [[ "$ret_status" -eq 0 ]]; then
		if [[ "${results_count}" -gt 1 ]]; then
			mapfile -t options <<< "${record_names}"
			search_phrase_copy=${search_phrase[@]}
			# for the case that the phrase itself needs to be added - checks for the add parameter and that the record does not exist already
			if [[ "${add_option}" == true ]] && [[ "`echo "${record_names}" | grep -o "^${search_phrase_copy}$" | wc -l`" -eq 0 ]]; then	
				options+=("${search_phrase_copy}")		# must check for this string if this option is chosen!
				added_search_phrase_flag=true
			fi
			echo "Choose the desired record:"
			select record in "${options[@]}"; do
				if [[ -n "$record" ]]; then
					search_record_get_single_result="${record}"
					if [[ "${added_search_phrase_flag}" == true && "${options[-1]}" == "${record}" ]]; then
						ret_status=2
					fi
					break
				else
					echo "Invalid option" >> /dev/stderr
				fi
			done
			
		fi
	elif [[ "${add_option}" == true ]]; then
		search_record_get_single_result="${search_phrase[@]}"
		ret_status=2
	fi
	
	# TODO: Add logging
	
	return $ret_status
}


function main()
{
	local params_and_search_phrase="${@}"
	local main_result="main_result"		# keep the default value the same as the variable name to be sent as reference to search_record_get_single which will store the result in it
	local ret_status=0
	if [[ "$1" == "--add" ]]; then
		shift
	fi
	local search_phrase="${@}"
	
	if [[ "${#@}" -eq 0 ]]; then
		read -p "Enter a search phrase: " search_phrase
	fi
	
	### workaround to handle the pitfall of local declaration changing the return status ($?) - 'search_record_func_result' must be globaly unique
	search_record_func_result=$(search_record "${search_phrase}")
	ret_status="$?"
	###

	if [[ "$ret_status" -eq 0 ]]; then
		echo "search_record results:"
		echo "$search_record_func_result"
	fi
	
	echo -e "\n#######################\n"
	
	search_record_get_single ${main_result} ${params_and_search_phrase}
	local ret_status="$?"
	
	if [[ "$ret_status" -eq 0 ]]; then
		echo "search_record_get_single results:"
		echo "$main_result"
	fi
	
	exit "$ret_status"
}


# in case of running as a script
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "${@}"
fi

