#! /bin/bash

source ./search_record.sh  

function get_record_file()
{
	echo "../db/listing.csv"
	return 0
}


function update_record_count()
{

    local name=$1
    local new_value=$2
    local listing_path=$(get_record_file)
    local ret_status=0
    local result_search_fun=0
    

    search_record_get_single result_search_fun $name 
    
    ret_status="$?"
    
    if [[ "$ret_status" -eq 0 ]]; then
        if [[  "${new_value}" -lt 1 ]]; then
            echo "Error, the count is unreal " >> /dev/stderr
            ret_status=1
        else    
            sed -i "s/^${result_search_fun},[1-9][0-9]*/${result_search_fun},${new_value}/" "${listing_path}"
            echo "amount updated"
        fi         
    
	fi

	return $ret_status

}




function main()
{
	### workaround to handle the pitfall of local declaration changing the return status ($?) - 'update_count_func_result' must be globaly unique
	update_record_count "$1" "$2"
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










