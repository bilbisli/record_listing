#! /bin/bash

### the script will input 2 argument, old and new name.
### if there arn't args, the function ask the use them.
### the result of the scripts will document in log file

source $(dirname "${BASH_SOURCE[0]}")/search_record.sh  
source $(dirname "${BASH_SOURCE[0]}")/../logging/insert_log.sh


### the ralative path of csv file 
function get_record_file()
{
	echo "$(dirname "${BASH_SOURCE[0]}")/../db/listing.csv"

	return 0
}

### the function check if the use inset 2 args- name of record and new number 
function update_record_count() {

	local ret_status=0
	local new_value=$1
	shift
	local record_name=$@ 
	local listing_path=$(get_record_file)
	local LOG_EVENT="Update"
	local log_status="Success"

	### validation- ask user to insert positive integer number
	if [[  "${new_value}" -lt 1 ]]; then
		echo "Error, the count should be a positive integer" >> /dev/stderr
  		ret_status=1
	else    
		### Changes the number of copies of the records with sed command 
		sed -i "s/^${record_name},[1-9][0-9]*/${record_name},${new_value}/" "${listing_path}"
		echo "amount updated"
	fi      
	
	
	### if the scrips didn't success to update name, it will insert failure massage to log file.
	if [[ $ret_status -ne 0 ]]; then
		log_status="Failure"
	fi
	### update log file
	insert_log ${LOG_EVENT} ${log_status}
	
	return $ret_status
}

function update_count() {

	local new_value=$1
	shift
	local record_name=$@ 
	local listing_path=$(get_record_file)
	local ret_status=0
	local result_search_fun=0
	
		 
	if [[ "$#" -ne 2 ]]; then
	### validation - ask the user to insert 2 valid args
		
		read -p "insert record name: " record_name
		while [[ "$new_value" -lt 1 ]]; do
			### check if the new name is substantial			
    			read -p "insert number of copies: " new_value
   			if [[ "$new_value" -lt 1 ]]; then
   				echo "Error, the count should be a positive integer" >> /dev/stderr
      			fi 
       		done
	fi    
	
	search_record_get_single result_search_fun $record_name 
    
 	ret_status="$?"
    
	if [[ "$ret_status" -eq 0 ]]; then
		
		update_record_count $new_value $result_search_fun
		ret_status="$?"	
	fi
	
	return $ret_status

}




function main()
{
	### workaround to handle the pitfall of local declaration changing the return status ($?) - 'update_count_func_result' must be globaly unique
	update_count $@
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










