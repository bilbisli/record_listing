#! /bin/bash

function atleast_2_args_val() {

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
	
}
