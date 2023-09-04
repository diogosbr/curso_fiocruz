# Carregando os pacotes ---------------------------------------------------
library(rgbif)
library(dplyr)

# Obtendo os pontos de ocorrência -----------------------------------------
occ_raw <- occ_search(scientificName = "Euterpe edulis",
                      limit = 1e4, hasCoordinate = TRUE)

# Dados baixados
names(occ_raw$data)

# Selecionado os dados de interesse
occ <- occ_raw$data %>% select(species,
                               decimalLongitude,
                               decimalLatitude,
                               country)

# Número de registros baixados
nrow(occ)

# Visualizando os primeiros registros
occ

# Plotando os pontos
maps::map(fill = T, col = "gray80", border = F)
maps::map.axes()
distinct(occ) %>%
  select(decimalLongitude, decimalLatitude) %>%
  points(col = "darkred", pch = 16)

# Salvando a tabela no disco rígido
write.csv(occ, "dados/ocorrencias/ocorrencias_bruta.csv", row.names = FALSE)
