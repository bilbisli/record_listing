#! /bin/bash
source ./search_record.sh

function get_record_file()
{
	echo "../db/listing.csv"
	return 0
}


function insert_record()
{
	
	local record_amount=$1
	shift
	local record_name="$@"
	local ret_status=0
	local RECORD_FILE=$(get_record_file)
	local search_function_result=0
	
	
	search_record_get_single "search_function_result" "--add" "$record_name"
	search_status="$?"
	echo "$search_status"
	
	
	var1=$(echo $search_function_result)
	echo "$var1"

    	if [[ "$search_status" -eq 0 ]]; then
        	echo $result_search_fun

    	fi
	
	
	
	
	
	return $ret_status
	
	
	

	## if we want to insert new record
#	echo "new_record,record_amount" >> $RECORD_FILE
	## if we want to change the name record	
#	echo $(cat "$RECORD_FILE")
}


function main()
{

	### workaround to handle the pitfall of local declaration changing the return status ($?) - 'insert_record_func_result'    		must be globaly unique

	insert_record  "${@}"
	local ret_status="$?"
	
	exit "$ret_status"
}


# in case of running as a script
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "${@}"
fi

