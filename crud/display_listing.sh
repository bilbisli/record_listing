#!/bin/bash


#display listing

function get_record_file()
{
	
	echo "../db/listing.csv"
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
function scan_listing_display_summary_of_listing()
{

	local database_directory=$(get_record_file)
	local records_amount=(`cut -d "," -f2  $database_directory`)	

	
	series_sum "${records_amount[@]}"
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

