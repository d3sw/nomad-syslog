#!/bin/bash                                                                                                                                                                                                                            
declare -i _sum=0
get_total(){
	total=$(( total + 1 ))
	echo $total
}
rand_str(){ 
	cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1 
}
prt_str(){
	let _sum++

	ts=$1
	idx=$2
	str=$(rand_str)
	echo "logID=$ts log[$idx/$_sum] $str"
}
main(){
	ts=$(date +%s)
	num=$LOG_ITEMS
	echo "testing log $num items"
	for ((i=0;i<$num;i++)); do 
		prt_str $ts $i &
	done
	sleep infinity
}
main
