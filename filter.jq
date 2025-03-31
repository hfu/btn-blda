def tippecanoe_config(layer_name):
  . + {
    tippecanoe: {
      minzoom: 12,
      maxzoom: 14,
      layer: layer_name
    }
  };

def process(layer_name):
  tippecanoe_config(layer_name) | . + { properties: {} };

. | process($layer)

