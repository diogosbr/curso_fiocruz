# carregando pacotes ------------------------------------------------------

library(rgbif)
library(dplyr)

# baixando os dados do gbif -----------------------------------------------

# é possível obter informações para baixar dados do gbif no link abaixo:
# https://www.gbif.org/pt/tool/81747/rgbif

# para baixar grande quantidade de dados veja no link abaixo:
# https://data-blog.gbif.org/post/downloading-long-species-lists-on-gbif/

# obtendo os dados
ocorrencias <- occ_data(scientificName = "Manilkara maxima", hasCoordinate = TRUE)

# selecionando apenas as colunas de interesse
ocorrencias <- select(ocorrencias$data, scientificName, decimalLongitude, decimalLatitude)

# removendo os registros com coordenadas duplicadas
ocorrencias <- distinct(ocorrencias)

# salvando registros no disco
write.csv(ocorrencias, "meus_registros.csv", row.names = FALSE)
