# Carregando pacotes ------------------------------------------------------

library(raster)

# Importando variáveis biocimáticas do Worldclim
#bioclimaticas <- getData("worldclim", res = 10, var = "bio")

# Dados de exemplo
# Presente
path_from <- "dados/abioticos/presente/"
path_to <- "dados/abioticos/presente/"

# Futuro
# path_from <- "dados/abioticos/futuro/2050_miroc_ssp245/"
# path_to <- "dados/abioticos/futuro/2050_miroc_ssp245/"

# path_from <- "dados/abioticos/futuro/2050_miroc_ssp585/"
# path_to <- "dados/abioticos/futuro/2050_miroc_ssp585/"

# path_from <- "dados/abioticos/futuro/2070_miroc_ssp245/"
# path_to <- "dados/abioticos/futuro/2070_miroc_ssp245/"

# path_from <- "dados/abioticos/futuro/2070_miroc_ssp585/"
# path_to <- "dados/abioticos/futuro/2070_miroc_ssp585/"


# Listando as variáveis do mundo
lista_abio <- list.files(path_from,
                         pattern = "tif$", full.names = TRUE)
bioclimaticas <- stack(lista_abio)

# Importando um shape do Brasil
br <- getData("GADM", country = "bra", level = 0)

# Recortando as variáveis para o Brasil
bioclimaticas_br <- mask(crop(bioclimaticas, br), br)

# Salvando cada variável bioclimática para o Brasil
for(nome in names(bioclimaticas_br)){
  writeRaster(bioclimaticas_br[[nome]], filename = paste0(path_to, nome, ".tif"), options = "COMPRESS=DEFLATE", overwrite = T)
}
