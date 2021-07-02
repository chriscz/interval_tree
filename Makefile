WATCH=src/**/*.cr spec/**/*.cr
VERBOSE=SPEC_VERBOSE=1

test:
	crystal spec

watch:
	bash -c "shopt -s globstar; while true; do inotifywait -e close_write $(WATCH); $(VERBOSE) make test; done"
