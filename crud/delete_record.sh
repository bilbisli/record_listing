#! /bin/bash
source ./search_record.sh

# get_record_file()
# This function returns the database file relative path
# value output: value output (return) is done by the echo method
# usage: local listing_path=$(get_record_file)
function get_record_file()
{
	echo "../db/listing.csv"
	return 0
}

# delete_record(record_amonut,record_name...)
# This function uses search function to find and make a list of options if the search cant find the record it make a new listing in the database
# value output: value output (return) is done by the echo method
# @return ret_status: 0 for succesful delleting or updating the record listing , 1 otherwise

function delete_record()
{
	
	local record_amount=$1
	shift
	local record_name="$@"
	local ret_status=0
	local RECORD_FILE=$(get_record_file)
	local search_function_result=0
	
	
	search_record_get_single "search_function_result" "$record_name"
	search_status="$?"
	
	if [[ $search_status -eq 2 ]];then
		echo ""
	fi
	
	##update_name_function
	
	##update_amount_function

    	if [[ "$search_status" -eq 0 ]]; then
        	echo $result_search_fun

    	fi
	
	
	
	
	
	return $ret_status
	
}


function main()
{

	### workaround to handle the pitfall of local declaration changing the return status ($?) - 'insert_record_func_result'    		must be globaly unique

	delete_record  "${@}"
	local ret_status="$?"
	
	exit "$ret_status"
}


# in case of running as a script
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "${@}"
fi

