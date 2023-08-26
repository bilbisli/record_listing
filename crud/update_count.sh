#! /bin/bash


source $(dirname "${BASH_SOURCE[0]}")/search_record.sh  

function get_record_file()
{
	echo "$(dirname "${BASH_SOURCE[0]}")/../db/listing.csv"
	return 0
}

function update_record_count() {

	local new_value=$1
	shift
	local record_name=$@ 
	local listing_path=$(get_record_file)

	if [[  "${new_value}" -lt 1 ]]; then
		echo "Error, the count should be a positive integer" >> /dev/stderr
  		ret_status=1
	else    
		sed -i "s/^${record_name},[1-9][0-9]*/${record_name},${new_value}/" "${listing_path}"
		echo "amount updated"
	fi      

}

function update_count() {

	local new_value=$1
	shift
	local record_name=$@ 
	local listing_path=$(get_record_file)
	local ret_status=0
	local result_search_fun=0

		 
	if [[ "$#" -ne 2 ]]; then
		
		read -p "insert record name: " record_name
		while [[ "$new_value" -lt 1 ]]; do
			# check if the new name is substantial			
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










