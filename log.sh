#!/bin/bash                                                                                                                                                                                                                            

get_total(){
	total=$(( total + 1 ))
	echo $total
}

rand_str(){ 
	cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-1024} | head -n 1 
}

prt_str(){
	ts=$1
	thread=$2
	idx=$3
	str=$(rand_str)
	echo "ts=$ts, thread=$thread, item=$idx, $str"
}

run() {
	ts=$1
	thread=$2
	start=$3
	end=$4
	for ((idx=$start;idx<$end;idx++)); do 
		prt_str $ts $thread $idx
	done
}

main(){
	ts=$(date +%s)
	items=$LOG_ITEMS
	threads=$LOG_THREADS
	count=$items/$threads
	echo "ts=$ts, threads=$threads, items=$items, start"
	for ((thread=0;thread<$threads;thread++)); do
		start=$thread*$count
		end=($thread+1)*$count
		run $ts $thread $start $end &
	done
	echo "ts=$ts, threads=$thread, items=$num, stop"
	for ((i=0;i<10000000;i++)); do
		sleep 60
		echo "$ts is still alive.."
	done
}

main
