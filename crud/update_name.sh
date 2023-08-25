#! /bin/bash

source ./search_record.sh  


function get_record_file()
{
	echo "../db/listing.csv"
	return 0
}

function update_record_count()
{
	local listing_path=$(get_record_file)
	local ret_status=0
	local result_search_fun=0
	local old_name=0
	local new_name=""
		 
	if [[ "$#" -ne 2 ]]; then
		
		read -p "inset record name: " old_name
		while [[ "$new_name" == "" ]]; do
    			
    			read -p "insert new name: " new_name
    			if [[ "$new_name" == "" ]]; then
    				echo invalid name >> /dev/stderr
    			fi 
       		done
	fi



	search_record_get_single result_search_fun $old_name 

	ret_status="$?"

	if [[ "$ret_status" -eq 0 ]]; then
	    sed -i "s/^${result_search_fun},/${new_name},/" "${listing_path}"
	    echo "name updated"
	fi  

	return $ret_status
}

function main()
{
	### workaround to handle the pitfall of local declaration changing the return status ($?) - 'update_count_func_result' must be globaly unique
	update_record_count $@
	local ret_status="$?"
	###
	local result="$update_count_func_result"
	
	if [[ "$ret_status" -eq 0 ]]; then
		echo "$result"
	fi
	
	exit "$ret_status"
}


# in case of running as a script
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "${@}"
fi

