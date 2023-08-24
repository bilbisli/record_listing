#! /bin/bash

source ./search_record.sh  


function update_record_count()
{

    local name=$1
    local num=$2
    local search_status=0
    
    local result_search_fun=0
    

    search_record_get_single result_search_fun $name
    
    search_status="$?"
    
    if [[ "$search_status" -eq 0 ]]; then
        echo $result_search_fun

    fi

    





	local result=0
	local ret_status=0
	
	return $ret_status

}


function main()
{
	### workaround to handle the pitfall of local declaration changing the return status ($?) - 'update_count_func_result' must be globaly unique
	update_count_func_result=$(update_record_count "$1" "$2")
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










