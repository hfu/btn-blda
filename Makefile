SRC_DIR = /Users/hfu/Downloads

DST_DIR = docs
OUTPUT_PMTILES = $(DST_DIR)/a.pmtiles
STYLE_PKL = style.pkl
STYLE_JSON = $(DST_DIR)/style.json
HOST_PORT = 8080
JQ_SCRIPT = filter.jq

NLCS = Building\ footprint/Building\ footprint.shp
DHS = buildlings/buildlings.shp

produce: $(JQ_SCRIPT) 
	(\
	ogr2ogr -of GeoJSONSeq /vsistdout/ $(SRC_DIR)/$(NLCS) | jq -c --arg layer "nlcs" -f $(JQ_SCRIPT) ; \
	ogr2ogr -of GeoJSONSeq /vsistdout/ $(SRC_DIR)/$(DHS) | jq -c --arg layer "dhs" -f $(JQ_SCRIPT) ; \
	) | tippecanoe -f -o $(OUTPUT_PMTILES) --maximum-zoom=14

$(STYLE_JSON): $(STYLE_PKL)
	pkl eval -f json $(STYLE_PKL) > $@

style: $(STYLE_JSON)
	@echo "Style file created: $@"

host: $(STYLE_JSON)
	budo -d $(DST_DIR) -p $(HOST_PORT)

.PHONY: produce style host
