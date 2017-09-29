#!/bin/bash

ORIGINAL_COUNTERS=()
PASSED=()
DIVIDERS=()

input="./input.txt"
while IFS= read -r var
do
	re="Disc #. has ([0-9]+) positions; at time=0, it is at position ([0-9]+)."
	if [[ $var =~ $re ]]; then
		ORIGINAL_COUNTERS+=(${BASH_REMATCH[1]})
		DIVIDERS+=(${BASH_REMATCH[2]})
		PASSED+=(false)
	fi
done < "$input"


# EXTRA ROW: Disc #7 has 11 positions; at time=0, it is at position 0.

verbose=false

starting_time=0
SIZE=${#ORIGINAL_COUNTERS[@]}
echo $SIZE

for start_tick in {0..1000000}
do
tick=$start_tick
	if [ $verbose = true ] ; then echo "Round $tick"; fi

	if [ $start_tick = 10000 ] ; then echo "$start_tick"; fi
	
	for (( i=0; i<$SIZE; i++ ))
	do
		PASSED[$i]=false
	done

	for (( i=0; i<$SIZE; i++ )) # counters loop
	do
		((tick++))
		index=$i
		for (( j=0; j<$SIZE; j++ ))
		do
			(( COUNTERS[$j]=ORIGINAL_COUNTERS[$j]+$tick ))
		done

		if [ ! "${PASSED[$index]}" = true ] && [ $((${COUNTERS[$index]} % ${DIVIDERS[$index]})) = 0 ]; then
			PASSED[$index]=true
		fi

		if [ "${PASSED[$index]}" = true ] ; then
			a="a"
		else
			break
		fi
	done

	if [ $verbose = true ] ; then
		echo "  Counters: ${COUNTERS[*]}"
		echo "  passed: ${PASSED[*]}"
	fi

	success=true
	for (( i=0; i<$SIZE; i++ )) # check loop
	do
		if [ ! "${PASSED[$i]}" = true ]; then success=false; fi
	done

	if [ "$success" = true ]; then
		star1=$start_tick
		break
	fi
done

echo $star1

# CORRECT ANSWER: 148737, 2353212
