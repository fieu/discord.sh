#!/usr/bin/env make

.PHONY: all test lint notify

all:
	@bash -c 'if [ "$(uname -s)" == "Linux" ]; then make lint; fi'
	@make test

test:
	bats --print-output-on-failure tests/

lint: SHELLCHECK := $(shell command -v shellcheck 2> /dev/null)
lint: SHELLCHECK := $(if $(SHELLCHECK),$(SHELLCHECK),/tmp/shellcheck-latest/shellcheck)
lint:
	@$(SHELLCHECK) discord.sh

/tmp/shellcheck-latest/shellcheck:
	@wget -c 'https://github.com/koalaman/shellcheck/releases/download/latest/shellcheck-latest.linux.x86_64.tar.xz' -O - | tar -xvJ -C /tmp/ >/dev/null 2>&1
	@chmod +x $@

notify: send.sh
	@bash $< $(result) ${LOGS_WEBHOOK}

send.sh:
	@wget https://raw.githubusercontent.com/k3rn31p4nic/travis-ci-discord-webhook/master/send.sh
	@chmod +x $@