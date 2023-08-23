#! /bin/bash


function search_record()
{
	local RECORD_FILE="../db/listing.csv"
	local result=0
	local ret_status=0
	local search_phrase="${@}"
	local record_names=""
	
	
	result="`grep "${search_phrase[@]}" "${RECORD_FILE}" | sort -k 1`"
	record_names="`echo "${result}" | cut -d "," -f 1 `"
	
	if [[ "${#result}" -eq 0 ]]; then
		echo "Search failed - no such record" >> /dev/stderr
		ret_status=1
	else
		echo "${result}"
	fi
	
	# TODO: Add logging
	
	return $ret_status
}


function main()
{
	local search_phrase="${@}"
	### workaround to handle the pitfall of local declaration changing the return status ($?) - 'search_record_func_result' must be globaly unique
	if [[ "${#@}" -eq 0 ]]; then
		read -p "Enter a search phrase: " search_phrase
	fi
	search_record_func_result=$(search_record "${search_phrase}")
	local ret_status="$?"
	###
	local result="$search_record_func_result"
	
	if [[ "$ret_status" -eq 0 ]]; then
		echo "$result"
	fi
	
	exit "$ret_status"
}


# in case of running as a script
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "${@}"
fi

