#! /bin/bash


function get_log_file()
{
	echo "listing_log"
	return 0
}

function insert_log()
{
	local event="$1"
	local msg="${@:2}"
	local result=0
	local ret_status=0
	
	echo "`date +%x' '%X` ${event} ${msg}" >> "`get_log_file`"
	
	return $ret_status
}


function main()
{
	local mock_event="$1"
	local msg="${@:2}"
	### workaround to handle the pitfall of local declaration changing the return status ($?) - 'insert_log_func_result' must be globaly unique
	insert_log ${mock_event} ${msg}
	local ret_status="$?"
	###
	local result="$insert_log_func_result"
	
	if [[ "$ret_status" -eq 0 ]]; then
		echo "$result"
	fi
	
	exit "$ret_status"
}


# in case of running as a script
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "${@}"
fi

