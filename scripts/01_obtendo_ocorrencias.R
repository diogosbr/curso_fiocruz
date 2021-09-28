# Instalando os pacotes ---------------------------------------------------
source("scripts/00_instalando_pacotes.R")

# Carregando os pacotes ---------------------------------------------------
library(rgbif)
library(dplyr)

# Obtendo os pontos de ocorrência -----------------------------------------
occ_raw <- occ_search(scientificName = "Pyropia spiralis",
                      limit = 1e4, hasCoordinate = TRUE)

# Verificando a estrutura do dado
names(occ_raw)

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

# Visualizando os dados selecionados
View(occ)

# Plotando os pontos
par(mar = c(0,0,0,0))
maps::map(fill = T, col = "gray80", border = F)
maps::map.axes()
distinct(occ) %>%
  select(decimalLongitude, decimalLatitude) %>%
  points(col = "darkred", pch = 16)

# Salvando a tabela no disco rígido
write.csv(occ, "dados/ocorrencias/ocorrencias_bruta.csv", row.names = FALSE)
