#!/bin/bash                                                                                                                                                                                                                            

runThread() {
	ts=$1
	size=$2
	thread=$3
	start=$4
	end=$5
	for ((idx=$start;idx<$end;idx++)); do 
		str="tR4ZbqdQFcGi3SZ1TRMNyf2TVtefQ3rPeUUJNryQIEYQxws2yG3ow3i5T10nM3moG+0HfiOTO4Hblqhg2JPO4hJVzpuin+jnWM7CfGpjXrWfhSi8kPrd279x4Q1OB595PXZaGLyS/fCjdY5U4sMhZGLvPMOeIgyeJa7F97sEvINAglghTsuHH+aWge0IIzIRCW7mBSsoWBQTF0TOEgf/t+SB31ZJy2EwCxrK8IK/P2PPl2iuOE9KApI2ZlJXZhMrGbLAv/nrIWXOrxcktL23aetzUX/wqqANWbe/8pEap7E2pVwKqTp9c23PkMKBvdi+8PGqxAhbilMvHLXLbLSpxnDdleZOXtJ1cYImLF1ZSvOt5SFnf3BpkSlxdiIfof9fh2s9aPRMVuFDgQznBQnmS5kOWrPj4RjvJNjmjkywrP/V+SgLuZ8G/B/fkTFfDhU3SZoCB7IhuwAPJC0Q4+ya2NHvRAsb7aM4e1bHrKDV1aygP4cI+w1vUHAHQdORgTOr0WZ9NF2TEtqCaGGUEdzCRlOywUOVfS755K3veH8AriiBCZOH6O9LLjna3mC35h6tj5vMijg4oIkts6MsktqAZXiBx6gK0v7poQkmTKkTPmpgPoM5AjTiweeOAsRhIE74uaMJxZx4K2lwRoBwI9n74IKLXH7+CCmNTg2WGuZyQAyAgl2eztb1WvEFCi2MLsnBQvefie1Ic3gVbzVnF45753cuG5aV1qFdMVN/mnnCXTrd6Yth/lZOFTc1xqbSRjkXf83Cnmc1lizZuD0gIuEiIyqcteerJOoO/P3KOglRuwKp041xkrumk1/TqbH4sRIJCAeu1/ThRDDl0nMVy9w4c/VIyVniXIAwCRexNH+tp2BZdNE4MRUEIwYxJ1kdc6K14sW6W1MBfMzPfaO+1N1WPnxpblnU10R3wIntBmMwS2BJZqu1Ep3Dge5wmIu5a+f9bfH2wogozguT7IaQlDlTvYpIYNM0QFuQM/GffOpoMrPf0VmtfFl14JhBMX4feYOe"
		echo "ts=$ts, thread=$thread, item=$idx, $str"
	done
}

runOnce(){
	ts=$(date +%s)
	count=$LOG_COUNT
	threads=$LOG_THREADS
	size=$LOG_SIZE
	echo "ts=$ts, threads=$threads, count=$count, start"
	for ((thread=0;thread<$threads;thread++)); do
		start=$thread*$count
		end=($thread+1)*$count
		runThread $ts $size $thread $start $end &
	done
	echo "ts=$ts, threads=$threads, count=$count, stop"
}

main(){
	interval=$LOG_INTERVAL
	for ((i=0;i<10000000;i++)); do
		runOnce
		sleep $interval
	done
}

main
