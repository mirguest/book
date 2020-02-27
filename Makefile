all: store.json
	jsonlint-php store.json
store.json: store/*.json
	bash build.sh
