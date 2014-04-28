# Makefile for Tuenti Contest 4th Challenge
#
# (C) 2014 Guillermo Gutierrez
#
SHELL = /bin/bash
MAIN_EXE ?= main.rb

ifndef FOLDER
define FOLDER
$(shell ls -l1d *.challenge | tail -n1)
endef
endif

define TOKEN
$(shell cat $(FOLDER)/.token)
endef

TGZ_FILE := tuenti-contest-4-xiterrex.tar.gz

run: $(FOLDER)
	$(FOLDER)/$(MAIN_EXE)

$(FOLDER)/.token:
	@read -p'token for $(FOLDER)? ' TOKEN; echo $$TOKEN > $@

test: $(FOLDER) $(FOLDER)/.token
	./test_challenge $(TOKEN) $(FOLDER)/$(MAIN_EXE)

$(TGZ_FILE): .git/refs/heads/master
	git archive master -o $@ $(FOLDER) Makefile README.md

submit: $(TGZ_FILE) $(FOLDER) $(FOLDER)/.token
	./submit_challenge $(TOKEN) $(TGZ_FILE) $(FOLDER)/$(MAIN_EXE)

clean:
	$(RM) $(TGZ_FILE)
	find . '(' -name '._*' -or -name '*.~' ')' -delete

.PHONY: run test submit clean