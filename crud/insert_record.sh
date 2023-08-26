#! /bin/bash
source $(dirname "${BASH_SOURCE[0]}")/../logging/insert_log.sh
source $(dirname "${BASH_SOURCE[0]}")/search_record.sh
source $(dirname "${BASH_SOURCE[0]}")/update_count.sh


# get_record_file()
# This function returns the database file relative path
# value output: value output (return) is done by the echo method
# usage: local listing_path=$(get_record_file)
function get_record_file()
{
	echo "$(dirname "${BASH_SOURCE[0]}")/../db/listing.csv"
	return 0
}

# insert_record(record_amonut,record_name...)
# This function uses search function to find and make a list of options if the search cant find the record it make a new listing in the database
# value output: value output (return) is done by the echo method
# @return ret_status: 0 for succesful inserting or updating the record listing , 1 otherwise
# @param --add: will give an option to create a new listing
function insert_record()
{

	local arg_count=$#
	local record_amount=$1
	shift
	local record_name="$@"
	local ret_status=0
	local RECORD_FILE=$(get_record_file)
	local search_function_result=0
	local LOG_EVENT="Insert"
	local log_status="Success"
	
	
	if [[ $arg_count -ne 2 ]]; then
		
		read -p "insert record name: " record_name
		while [[ "$record_amount" -lt 1 ]]; do
			# check if the new name is substantial			
    			read -p "insert number of copies: " record_amount
   			if [[ "$record_amount" -lt 1 ]]; then
   				echo "Error, the count should be a positive integer" >> /dev/stderr
    			fi 
       		done
	fi   	
	
	search_record_get_single "search_function_result" "--add" "$record_name"
	search_status="$?"
	
	if [[ $search_status -eq 2 ]];then
		echo "$record_name,$record_amount" >> $RECORD_FILE
		echo "Added the record '$search_function_result' successfully"
	else [[ search_status -eq 0 ]]
		local string_of_option=$(echo $search_function_result)
		#updating record amount 
		local line_after_grep=$(grep "^${string_of_option}," $RECORD_FILE )
		if [[ -n "$line_after_grep" ]]; then
    			# Extract the number of record using cat after grep and puting it to a veriable
    			local number=$(echo "$line_after_grep" | cut -d',' -f2)
			sum_of_record=$(( number+record_amount ))
#			echo $sum_of_record
			update_record_count "$sum_of_record" "$string_of_option" 
			ret_status=$?			
		else
    			echo "No matching line found." >> /dev/stderr
    			ret_status=1
		fi
	fi
	if [[ ret_status -ne 0 ]];then
		log_status="Failure"
	fi 	
	
	insert_log ${LOG_EVENT} ${log_status}		
	return $ret_status
	
	

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

