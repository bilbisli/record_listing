#! /bin/bash


function insert_record()
{
	local record_name=$1
	local record_amount_from_user=$2
#	local record_amount_from_user=$2
	local result=0
	local ret_status=0
	### serch function
	echo "$(cat ../db/listing.csv)"
	
	return $ret_status
}


function main()
{
 	### Check if database exists if not create it
 	local file_path="../db/listing.csv"
	local dir_path="/path/to/your/directory"
	### Create the directory if it doesn't exist and the file
	if [ -e "$file_path" ]; then
    			echo "File already exists."
    		### workaround to handle the pitfall of local declaration changing the return status ($?) - 'insert_record_func_result'    		must be globaly unique
    		insert_record_func_result=$(insert_record "$1" "$2")
		local ret_status="$?"
			###
			local result="$insert_record_func_result"
	
			if [[ "$ret_status" -eq 0 ]]; then
				echo "$result"
			fi
	
			exit "$ret_status"	
			else
    		# Create the directory if it doesn't exist
    		if [ ! -d "$dir_path" ]; then
        		mkdir -p "$dir_path"
        		echo "Directory created: $dir_path"
    		fi

    	# Create the file within the directory
    	touch "$file_path"
    	
	fi
	
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

