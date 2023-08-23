#!/bin/bash


function menu()
{
	local keep_running_flag=true
	local exit_option="Exit"
	local ret_status=1							# successful return status (0) only when exit option is chosen from menu
	local result=0
	local function_parameters=()
	
	# options displayed to user
	local options=("option_1" "option_2")
	local options+=("$exit_option")
	# parallel operations (functions) to each option displayed to user
	local operations=("function_1" "function_2")
	local operations+=('exit')
	# parallel result message (if different messages are needed)
	local operation_result=("option 1 result is: " "our result for option 2: ")
	
	# TODO: get initial input / sent parameters
	local sent_parameters=${@}
	
	while [[ "$keep_running_flag" == true ]]; do
		# menu presentation
		echo "Choose an item:"
		for (( i=0 ; i < ${#operations[@]} ; i++ )) do
			echo -e "\t$(($i + 1))) ${options[i]}"
		done
		
		# menu choice
		read -p "Choice: " choice
		if [[ "$choice" == [1-${#operations[@]}] ]]; then
			echo "Option chosen: ${options[choice - 1]}"

			if [[ "${options[choice - 1]}" == "$exit_option" ]]; then	# exit condition
				keep_running_flag=false
				ret_status=0						# successful return status (0)
			else								# operations
				# operands validation
				${operations[choice - 1]} ${function_parameters[@]}
			fi
		else
			echo "Error - no such option."  >> /dev/stderr
		fi
		echo -e "\n#################################################\n"
	done
	
	return $ret_status
}


function main()
{
	menu "${@}"
	local ret_status="$?"

	exit "$ret_status"
}


# in case of running as a script
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "${@}"
fi

