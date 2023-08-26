source ./search_record.sh

	
var1=$(search_record $1)
echo $var1
search_record_get_single $var1
