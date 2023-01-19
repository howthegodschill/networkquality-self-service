#!/bin/zsh

filpth='/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources'

/usr/bin/osascript -e "display dialog \"Test in progress...\n\" buttons {\"Cancel\"} with icon POSIX file \"$filpth/GenericNetworkIcon.icns\" with Title \"Network Quality Test\"" &
prgpid=$!

/usr/bin/networkquality -sv | /usr/bin/sed '/SUMMARY/d' > /private/tmp/summary.txt &
while true
do
	if [ -n "$(/bin/cat /private/tmp/summary.txt)" ]
	then
		break
	fi
	if /bin/kill -s 0 "$prgpid"
	then
		>&2 echo "waiting for networkquality..."
		/bin/sleep 3
	else
		exit
	fi
done

>&2 echo "$(/bin/cat /private/tmp/summary.txt)"
/usr/bin/osascript -e "display dialog \"$(/bin/cat /private/tmp/summary.txt)\" buttons {\"Ok\"} default button 1 with icon POSIX file \"$filpth/GenericNetworkIcon.icns\" with Title \"Network Quality Test\""
/bin/rm -rf /private/tmp/summary.txt 
/bin/kill -9 "$prgpid"
