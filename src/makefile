
#.ONESHELL

all:
		cd build && voc -s ../lists/Sys.Mod \
		../lists/strutils.Mod \
		../lists/List.Mod \
		../lists/StringList.Mod \
		../pipes/pipes.Mod \
		../postgres/postgres.Mod \
		../d2h.Mod -m
		cd build && voc ../tests.Mod -m
clean:
		cd build && rm *
