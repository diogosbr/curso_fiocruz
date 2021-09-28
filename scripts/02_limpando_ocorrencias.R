# Carregando os pacotes ---------------------------------------------------
library(raster)
library(dismo)
library(dplyr)
library(CoordinateCleaner)
library(vroom)
source("funcoes/ver_mapa.R")

# Importando os pontos de ocorrência --------------------------------------
occ_raw <- vroom("dados/ocorrencias/ocorrencias_bruta.csv") %>% as.data.frame()

# Verifica inicio ...
head(occ_raw)

# ... e final da tabela
tail(occ_raw)

# Número de ocorrências totais
nrow(occ_raw)

# Visualizando os pontos no mapa interativo
ver_pontos(occ_raw, lon = 'decimalLongitude', lat = 'decimalLatitude')

# Checando os dados de ocorrencia
occ_clean <- clean_coordinates(occ_raw, species = "species",
                               lon = 'decimalLongitude', lat = 'decimalLatitude',
                               tests = c("equal", "outliers", "zeros", 'dupl'),
                               value = "clean")

# Número de ocorrências únicas
nrow(occ_clean)

# Selecionando as colunas longitude e latitude
occ_clean <- select(occ_clean, decimalLongitude, decimalLatitude)

# Importando uma variável preditora
var1 <- raster('dados/abioticos/presente/Phosphate.Range.tif')

# Salvando o tabela com os registros únicos
occ_unique <- gridSample(occ_clean, var1, n = 1)

# Resetando os nomes das linhas
rownames(occ_unique) <- NULL

# Visualizando os pontos no mapa interativo
ver_pontos(occ_unique, lon = 'decimalLongitude', lat = 'decimalLatitude',
           plot_raster = var1)

# Removendo dados com 'NA'
occ_unique_with_values <- occ_unique[!is.na(extract(var1, occ_unique)),]

# Resetando os nomes das linhas
rownames(occ_unique_with_values) <- NULL

# Visualizando os pontos no mapa interativo
ver_pontos(occ_unique_with_values,
           lon = 'decimalLongitude', lat = 'decimalLatitude')

# Removendo dados inconsistentes
occ_modelagem <- occ_unique_with_values[-c(16, 17, 18),]

# Visualizando os pontos no mapa interativo
ver_pontos(occ_modelagem, lon = 'decimalLongitude', lat = 'decimalLatitude')

# Número de ocorrências únicas por pixel, com valores e sem inconcistencias
nrow(occ_modelagem)

# Salvando no disco
write.csv(occ_modelagem, "dados/ocorrencias/ocorrencias_modelagem.csv",
          row.names = FALSE)
