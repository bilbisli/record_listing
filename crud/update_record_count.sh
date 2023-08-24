#! /bin/bash


function update_record_count.sh()
{

    



	local result=0
	local ret_status=0
	
	return $ret_status
}







function main()
{
	### workaround to handle the pitfall of local declaration changing the return status ($?) - 'insert_record_func_result' must be globaly unique
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

