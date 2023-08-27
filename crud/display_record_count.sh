#!/bin/bash

source $(dirname "${BASH_SOURCE[0]}")/../logging/insert_log.sh


#display listing
function get_record_file()
{
	
	echo "$(dirname "${BASH_SOURCE[0]}")/../db/listing.csv"
	return 0
	
}


function series_sum()
{
	local num_arr=("$@")
	local ret_status=0
	
	for number in "${num_arr[@]}"; do
   	 	sum=$((sum + number))
	done
	
	echo "$sum"
	
	return $ret_status
}
function display_record_count()
{
	local LOG_EVENT="PrintAmount"
 	local record_sum=0
	local database_directory=$(get_record_file)
	local records_amount=$(`cut -d "," -f2  $database_directory`)	

	record_sum=$(series_sum "${records_amount[@]}")
	ret_status=$?

 	echo "The sum of records is: ${record_sum}"

	insert_log ${LOG_EVENT} ${LOG_EVENT} ${record_sum}

 	return $ret_status
}


function main()
{
	scan_listing_display_summary_of_listing "${@}"
	local ret_status="$?"

	exit "$ret_status"
}


# in case of running as a script
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "${@}"
fi

