
FILES=generate pointless.awk

install:V:
	mkdir -p /rc/bin/pointless
	cp $FILES /rc/bin/pointless

uninstall:V:
	rm -f /rc/bin/pointless/^($FILES)
	rm -f /rc/bin/pointless
