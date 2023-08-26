#! /bin/bash


source $(dirname "${BASH_SOURCE[0]}")/search_record.sh  


# the script will input 2 argument, old and new name.
# if there arn't args, the function ask the use them.


# the ralative path of csv file
function get_record_file()
{
	echo "$(dirname "${BASH_SOURCE[0]}")/../db/listing.csv"
	return 0
}



# the function check if the use inset 2 args.
function update_record_name()
{
	local listing_path=$(get_record_file)
	local ret_status=0
	local result_search_fun=0
	local old_name=0
	local new_name=""
		 
		 
	if [[ "$#" -ne 2 ]]; then
		
		read -p "inset record name: " old_name
		while [[ "$new_name" == "" ]]; do
			# check if the new name is substantial			
    			read -p "insert new name: " new_name
    			if [[ "$new_name" == "" ]]; then
    				echo invalid name >> /dev/stderr
    			fi 
       		done
	fi



	search_record_get_single result_search_fun $old_name 

	ret_status="$?"
	# after we found the uniq name of the file, we use sed command in order to change old one to new.  
	if [[ "$ret_status" -eq 0 ]]; then
	    sed -i "s/^${result_search_fun},/${new_name},/" "${listing_path}"
	    echo "name updated"
	fi  

	return $ret_status
}

function main()
{
	### workaround to handle the pitfall of local declaration changing the return status ($?) - 'update_record_name_func_result' must be globaly unique
	update_record_name $@
	local ret_status="$?"
	###
	local result="$update_record_name_func_result"
	
	if [[ "$ret_status" -eq 0 ]]; then
		echo "$result"
	fi
	
	exit "$ret_status"
}


# in case of running as a script
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "${@}"
fi

