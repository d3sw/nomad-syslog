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
	echo "log_$ts[$idx/$_sum]: $str"
}
main(){
	ts=$(date +%s)
	for ((i=0;i<5000;i++)); do 
		prt_str $ts $i &
	done
	sleep infinity
}
main
