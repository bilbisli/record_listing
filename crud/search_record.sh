#! /bin/bash


function get_record_file()
{
	echo "../db/listing.csv"
	return 0
}

function search_record()
{
	local RECORD_FILE=$(get_record_file)
	local result=0
	local ret_status=0
	local search_phrase="${@}"
	local record_names=""
	
	result="`grep "${search_phrase[@]}" "${RECORD_FILE}" | sort -k 1`"
	
	if [[ "${#result}" -eq 0 ]]; then
		echo "Search failed - no such record" >> /dev/stderr
		ret_status=1
	else
		echo "${result}"
	fi
	
	# TODO: Add logging
	
	return $ret_status
}

# search_record_get_single(search_record_get_single_result,optional:--add,search_phrase...)
# A function that searches a given record and lets the user choose one if multiple records are found
# @param search_record_get_single_result: the variable name (reference) to store the result in
# @param --add: indicated whether the search term itself should be an option for the user to choose from
# @param search_phrase: the rest of the parameters will be assigned to the search phrase
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
			fi
			echo "Choose the desired record:"
			select record in "${options[@]}"; do
				if [[ -n "$record" ]]; then
					search_record_get_single_result="${record}"
					break
				else
					echo "Invalid option" >> /dev/stderr
				fi
			done
		fi
	else
		if [[ "${add_option}" == true ]]; then
			search_record_get_single_result="${search_phrase[@]}"
			ret_status=0
		fi
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
	ret_status=$?
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

