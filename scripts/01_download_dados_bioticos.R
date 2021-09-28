# carregando pacotes ------------------------------------------------------

library(rgbif)
library(dplyr)

# baixando os dados do gbif -----------------------------------------------

# obtendo os dados
ocorrencias <- occ_data(scientificName = "Manilkara maxima", hasCoordinate = TRUE)

# selecionando apenas as colunas de interesse
ocorrencias <- select(ocorrencias$data, scientificName, decimalLongitude, decimalLatitude)

# removendo os registros com coordenadas duplicadas
ocorrencias <- distinct(ocorrencias)

# salvando registros no disco
write.csv(ocorrencias, "data/meus_registros.csv", row.names = FALSE)
