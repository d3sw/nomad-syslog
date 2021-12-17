#!/bin/bash                                                                                                                                                                                                                            

get_total(){
	total=$(( total + 1 ))
	echo $total
}

rand_str(){ 
	cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1 
}

prt_str(){
	ts=$1
	idx=$2
	str=$(rand_str)
	echo "group=$ts, item=$idx, $str"
}

main(){
	ts=$(date +%s)
	num=$LOG_ITEMS
	echo "log $num items start"
	for ((i=0;i<$num;i++)); do 
		prt_str $ts $i
	done
	echo "log $num items stop"
	sleep infinity
}

main
