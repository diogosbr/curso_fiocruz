# Carregando pacotes ------------------------------------------------------

library(raster)

# Importando variáveis biocimáticas do Worldclim
bioclimaticas <- getData("worldclim", res = 10, var = "bio")

# Importando um shape do Brasil
br <- getData("GADM", country = "bra", level = 0)

# Recortando as variáveis para o Brasil
bioclimaticas_br <- mask(crop(bioclimaticas, br), br)

# Salvando cada variável bioclimática para o Brasil
for(nome in names(bioclimaticas_br)){
  writeRaster(bioclimaticas_br[[nome]], filename = paste0("./data/env/", nome, ".tif"))
}
