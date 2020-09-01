# carregando pacotes ------------------------------------------------------

library(raster)

bioclimaticas <- getData("worldclim", res = 10, var = "bio")

br <- getData("GADM", country = "bra", level = 0)

bioclimaticas_br <- mask(crop(bioclimaticas, br), br)

for(nome in names(bioclimaticas_br)){
  writeRaster(bioclimaticas_br[[nome]], filename = paste0("./data/env/", nome, ".tif"))
}
