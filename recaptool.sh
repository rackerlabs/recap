#!/bin/bash

ME=`basename $0`
RECAPPATH="/var/log/recap"
cmds=""

procs_mem() {
	PROCESS="$1"
	TMP=`mktemp`
	>$TMP
	for i in `ls $RECAPPATH/ps.log*`; do 
		head -n 1 $i | tr "\n" "\t" >> $TMP
		egrep "$PROCESS" $i -c | tr "\n" "\t" >> $TMP
		egrep "$PROCESS" $i | awk '{ SUM += $6 } END {print SUM/1024, "M"};' >> $TMP
	done
	sort $TMP
	rm -f $TMP
}

procs() {
	PROCESS="$1"
	TMP=`mktemp`
	>$TMP
	for i in `ls $RECAPPATH/ps.log*`; do 
		head -n 1 $i | tr "\n" "\t" >> $TMP
		egrep "$PROCESS" $i -c >> $TMP
	done
	sort $TMP
	rm -f $TMP
}

mem() {
	PROCESS="$1"
	TMP=`mktemp`
	>$TMP
	for i in `ls $RECAPPATH/ps.log*`; do
		head -n 1 $i | tr "\n" "\t" >> $TMP
		egrep "$PROCESS" $i | awk '{ SUM += $6 } END {print SUM/1024, "M"};' >> $TMP
	done
	sort $TMP
	rm -f $TMP
}


net() {
	PORT="$1"
	TMP=`mktemp`
	>$TMP
	for i in `ls $RECAPPATH/netstat.log*`; do
		head -n 1 $i | tr "\n" "\t" >> $TMP
		egrep ":$PORT " $i -c >> $TMP 
	done
	sort $TMP
	rm -f $TMP
}

netestab() {
	PORT="$1"
	TMP=`mktemp`
	>$TMP
	for i in `ls $RECAPPATH/netstat.log*`; do
		head -n 1 $i | tr "\n" "\t" >> $TMP
		egrep ":$PORT .*ESTAB" $i -c >> $TMP 
	done
	sort $TMP
	rm -f $TMP
}

querycount() {
	TMP=`mktemp`
	>$TMP
	for i in `ls $RECAPPATH/mysql.log*`; do
		head -n 1 $i | tr "\n" "\t" >> $TMP
		grep "Query" -c $i >> $TMP 
	done
	sort $TMP
	rm -f $TMP
}

usage() {
	echo -e "Usage:\t$ME {proc|mem|memproc} process_name"
	echo    "  $ME {net|netestab} port"
	echo    "  $ME querycount"
}

if [ $# -eq 0 ]; then
	usage
	exit 1
fi

while [ $# -gt 0 ]; do
	case "$1" in
		-d)
			if [ -d $2 ]; then
				RECAPPATH=$2
				shift 2
			else
				echo "Error: $2 is not a valid directory."
				usage
				exit 1
			fi
			;;
		memproc|proc|mem|net|netestab)
			cmds="${cmds}$1 $2 "
			#procs_mem $2
			shift 2
			;;
		#proc)
			#procs $2
			#shift 2
			#;;
		#mem)
			#mem $2
			#shift 2
			#;;
		#net)
			#net $2
			#shift 2
			#;;
		#netestab)
			#netestab $2
			#shift 2
			#;;
		querycount)
			cmds="${cmds}$1 "
			#querycount
			shift
			;;
		*)
			echo "Error: Invalid command $1"
			usage
			exit 1
			;;
	esac
done

echo "Information: Using $RECAPPATH as recap log path"
echo "Information: Executing $cmds"

$cmds

exit 0
