#! /bin/bash
source ./search_record.sh




function insert_record()
{
	
	local record_name=$1
	local record_amount_from_user=$2
#	local record_amount_from_user=$2
	local result=0
	local ret_status=0
	local result_arr=$(search_record "$1")
	echo "${result_arr[@]}" 
#	echo "$(cat ../db/listing.csv)"
	
	return $ret_status
}


function main()
{

	### workaround to handle the pitfall of local declaration changing the return status ($?) - 'insert_record_func_result'    		must be globaly unique
	insert_record_func_result=$(divide "$1" "$2")
	local ret_status="$?"
	###
	local result="$insert_record_func_result"
	
	if [[ "$ret_status" -eq 0 ]]; then
		echo "$result"
	fi
	
	exit "$ret_status"
}


# in case of running as a script
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "${@}"
fi

