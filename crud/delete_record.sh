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

# delete_record(record_amonut,record_name...)
# This function uses search function to find and make a list of options if the search cant find the record it make a new listing in the database
# value output: value output (return) is done by the echo method
# @return ret_status: 0 for succesful delleting or updating the record listing , 1 otherwise

function delete_record()
{
	local arg_count=$#	
	local record_amount=$1
	shift
	local record_name="$@"
	local ret_status=0
	local RECORD_FILE=$(get_record_file)
	local search_function_result=0
	local LOG_EVENT="Delete"
	local log_status="Success"
	
	if [[ $arg_count -ne 2 ]]; then
		
		read -p "Inset record name: " record_name
		while [[ "$record_amount" == "" ]]; do
    			
    			read -p "Insert record amount: " record_amount
    			
    			if [[ "$record_amount" == "" ]]; then
    				echo invalid amount >> /dev/stderr
    			fi 
       		done
	fi	
	
	search_record_get_single "search_function_result" "$record_name"
	search_status="$?"
	

	if [[ search_status -eq 0 ]];then
		local string_of_option=$(echo $search_function_result)
		#updating record amount 
		local line_after_grep=$(grep "^${string_of_option}," $RECORD_FILE )
		if [[ -n "$line_after_grep" ]]; then
    			# Extract the number of record using cat after grep and puting it to a veriable
    			local number=$(echo "$line_after_grep" | cut -d',' -f2)
			local sum_of_record=$(( number-record_amount ))
			echo $sum_of_record
			if [[ $sum_of_record -eq 0 ]];then
				sed -i "/$line_after_grep/d" $RECORD_FILE
				echo "The $record_name was deleted from the database"
			else			
				update_record_count "$sum_of_record" "$string_of_option"
				ret_status=$?

			fi
		else
    			echo "couldn't delete the record" >> /dev/stderr
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

	delete_record  "${@}"
	local ret_status="$?"
	
	exit "$ret_status"
}


# in case of running as a script
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "${@}"
fi

