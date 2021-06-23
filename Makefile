#!/usr/bin/env make

.PHONY: all test lint notify site

all:
	@bash -c 'if [ "$(uname -s)" == "Linux" ]; then make lint; fi'
	@make test

test:
	@bash run_tests.sh

lint: /tmp/shellcheck-latest/shellcheck
	@$< discord.sh
	@$< run_tests.sh

/tmp/shellcheck-latest/shellcheck:
	@wget -c 'https://github.com/koalaman/shellcheck/releases/download/latest/shellcheck-latest.linux.x86_64.tar.xz' -O - | tar -xvJ -C /tmp/ >/dev/null 2>&1
	@chmod +x $@

notify: send.sh
	@bash $< $(result) ${LOGS_WEBHOOK}

send.sh:
	@wget https://raw.githubusercontent.com/k3rn31p4nic/travis-ci-discord-webhook/master/send.sh
	@chmod +x $@

site:
	@cp README.md docs/_includes/README.md
