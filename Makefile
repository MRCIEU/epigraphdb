URL := "https://api.epigraphdb.org"
ifdef EPIGRAPHDB_API_URL
URL := $(EPIGRAPHDB_API_URL)
endif

## format notebooks
fmt:
	nbqa black general-examples/ --nbqa-mutate
	nbqa black paper-case-studies/ --nbqa-mutate

## build notebooks (Use `EPIGRAPHDB_API=xxx make build` to change API url)
build:
	echo $(URL)
	mkdir -p output
	papermill \
		general-examples/getting-started-with-epigraphdb.ipynb \
		output/getting-started-with-epigraphdb.ipynb \
		-p API_URL $(URL)
	papermill \
		general-examples/platform-meta-functionalities.ipynb \
		output/platform-meta-functionalities.ipynb \
		-p API_URL $(URL)
	papermill \
		paper-case-studies/case-1-pleiotropy.ipynb \
		output/case-1-pleiotropy.ipynb \
		-p API_URL $(URL)
	papermill \
		paper-case-studies/case-2-alt-drug-target.ipynb \
		output/case-2-alt-drug-target.ipynb \
		-p API_URL $(URL)
	papermill \
		paper-case-studies/case-3-literature-triangulation.ipynb \
		output/case-3-literature-triangulation.ipynb \
		-p API_URL $(URL)

## build notebooks, in place (Use `EPIGRAPHDB_API=xxx make build` to change API url)
build-inplace:
	echo $(URL)
	papermill \
		general-examples/getting-started-with-epigraphdb.ipynb \
		general-examples/getting-started-with-epigraphdb.ipynb \
		-p API_URL $(URL)
	papermill \
		general-examples/platform-meta-functionalities.ipynb \
		general-examples/platform-meta-functionalities.ipynb \
		-p API_URL $(URL)
	papermill \
		paper-case-studies/case-1-pleiotropy.ipynb \
		paper-case-studies/case-1-pleiotropy.ipynb \
		-p API_URL $(URL)
	papermill \
		paper-case-studies/case-2-alt-drug-target.ipynb \
		paper-case-studies/case-2-alt-drug-target.ipynb \
		-p API_URL $(URL)
	papermill \
		paper-case-studies/case-3-literature-triangulation.ipynb \
		paper-case-studies/case-3-literature-triangulation.ipynb \
		-p API_URL $(URL)


#################################################################################
# Self Documenting Commands                                                     #
#################################################################################

.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo "$$(tput bold)Available rules:$$(tput sgr0)"
	@echo
	@sed -n -e "/^## / { \
		h; \
		s/.*//; \
		:doc" \
		-e "H; \
		n; \
		s/^## //; \
		t doc" \
		-e "s/:.*//; \
		G; \
		s/\\n## /---/; \
		s/\\n/ /g; \
		p; \
	}" ${MAKEFILE_LIST} \
	| awk -F '---' \
		-v ncol=$$(tput cols) \
		-v indent=19 \
		-v col_on="$$(tput setaf 6)" \
		-v col_off="$$(tput sgr0)" \
	'{ \
		printf "%s%*s%s ", col_on, -indent, $$1, col_off; \
		n = split($$2, words, " "); \
		line_length = ncol - indent; \
		for (i = 1; i <= n; i++) { \
			line_length -= length(words[i]) + 1; \
			if (line_length <= 0) { \
				line_length = ncol - indent - length(words[i]) - 1; \
				printf "\n%*s ", -indent, " "; \
			} \
			printf "%s ", words[i]; \
		} \
		printf "\n"; \
	}'
