#! /bin/bash


function update_record_name.sh()
{
	local result=0
	local ret_status=0

    local old_name=$1
    local new_name=$2

    echo $old_name
    echo $new_name

	result="`grep "${search_phrase[@]}" "${RECORD_FILE}" | sort -k 1`"
	record_names="`echo "${result}" | cut -d "," -f 1 `"
	
	if [[ "${#result}" -eq 0 ]]; then
		echo "Search failed - no such record" >> /dev/stderr
		ret_status=1
	else
		echo "${result}"
	fi






	return $ret_status
}







function main()
{
	### workaround to handle the pitfall of local declaration changing the return status ($?) - 'insert_record_func_result' must be globaly unique
	insert_record_func_result=$(update_record_name.sh "$1" "$2")
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

