APPNAME = edfs
ERL = $(shell which erl)
ERLFLAGS= -pa $(CURDIR)/.eunit -pa $(CURDIR)/apps/*/ebin -pa $(CURDIR)/deps/*/ebin
DIALYZER = dialyzer

# Verify that Erlang is available on this system
ifeq ($(ERL),)
$(error "Warning: No Erlang found in your path. Please ensure you have a working Erlang(R14B02 or later) installation on this system")
endif

# Erlang Rebar downloading
# see: https://groups.google.com/forum/?fromgroups=#!topic/erlang-programming/U0JJ3SeUv5Y
REBAR := $(shell (type rebar 2>/dev/null || echo ./rebar) | tail -1 | awk '{ print $$NF }')
REBAR_DEPS := $(shell which rebar || echo ../../rebar)
REBAR_URL := https://github.com/rebar/rebar/wiki/rebar

./rebar:
	$(ERL) -noshell -s inets -s ssl \
	-eval '{ok, saved_to_file} = httpc:request(get, {"$(REBAR_URL)", []}, [], [{stream, "./rebar"}])' \
	-s init stop
	chmod +x ./rebar

# relx
RELX ?= $(CURDIR)/relx
RELX_CONFIG ?= $(CURDIR)/relx.config
RELX_URL ?= https://github.com/erlware/relx/releases/download/v0.6.0/relx
RELX_OPTS ?=

export RELX

.PHONY: all compile docs clean tests build-plt dialyze shell distclean pdf \
update-deps rebuild rel


all: app

# ==============================================================
# Make build rules
# ==============================================================
app: deps
	@$(REBAR) compile

deps:
	@$(REBAR) get-deps
	$(REBAR) compile

update-deps:
	$(REBAR) update-deps
	$(RENDER) compile

compile:
	$(REBAR) skip_deps=true compile

clean:
	- rm -rf $(CURDIR)/test/*.beam
	- rm -rf $(CURDIR)/ebin
	- rm -rf $(CURDIR)/*.dump
	$(REBAR) skip_deps=true clean

distclean: clean
	- rm -rvf $(CURDIR)/deps
	- rm -rf $(CURDIR)/doc/*

tests: clean app eunit ct

eunit: compile clean
	@$(REBAR) -C rebar.test.config eunit skip_deps=true

ct:
	@$(REBAR) -C rebar.test.config ct skip_deps=true

build-plt:
	@$(DIALYZER) --build_plt --output_plt .$(APPNAME)_dialyzer.plt \
		--apps kernel stdlib sasl inets crypto public_key ssl

dialyze:
	@$(DIALYZER) --src src --plt .$(APPNAME)_dialyzer.plt --no_native \
		-Werror_handling -Wrace_conditions -Wunmatched_returns # -Wunderspecs

docs:
	@$(REBAR) doc skip_deps=true

pdf:
	pandoc README.md -o README.pdf

# Releases
define download_relx
	wget -O $(RELX) $(RELX_URL) || rm $(RELX)
	chmod +x $(RELX)
endef

rel: clean-rel all $(RELX)
	@$(RELX) -c $(RELX_CONFIG) $(RELX_OPTS)

$(RELX):
	@$(call download_relx)

clean-rel:
	@rm -rf _rel

# runs tests and starts an Erlang shell
shell: deps compile
	- @$(REBAR) skip-deps=true eunit
	@$(ERL) $(ERLFLAGS)
