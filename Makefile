all: store.json
	jsonlint-php store.json
store.json: store/*.json douban/*.json
	bash build.sh
