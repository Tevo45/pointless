#!/bin/awk -f

BEGIN {
	inexec = 0
}

/<exec.*>/ {
	execline = NR
	inexec = 1
	delete args
	prog = ""
	# is there a better way to represent whitespace?
	gsub("^.*<exec[ 	]*", "")
	gsub("[ 	]*>.*$", "")
	shell = $1
	if(length(shell) == 0)
		shell = "/bin/rc"
	for(c = 2; c <= NF; c++)
 		args[c-2] = $c
}

/<\/exec>/ {
	if(!inexec) {
		print "error: </exec> without opening at " FILENAME ":" NR >"/fd/2"
		exit "noopening"
	}
	system("{" shell "} <<'__POINTLESS_EOF__'\n" prog "\n__POINTLESS_EOF__")
	inexec = 0
	lastexec = NR
}

{
	if(inexec)
	{
		if(execline != NR)
			prog = prog "\n" $0
	}
	else
		if(lastexec != NR)
			print
}

END {
	if(inexec) {
		print "error: dangling exec at " FILENAME ":" execline >"/fd/2"
		exit "nofinish"
	}
}
