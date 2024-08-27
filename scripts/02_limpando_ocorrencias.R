# Carregando os pacotes ---------------------------------------------------
library(vroom)
library(dplyr)
library(CoordinateCleaner)
library(raster)
library(dismo)
#source("funcoes/ver_mapa.R")

# Importando os pontos de ocorrência --------------------------------------
occ_raw <- vroom("dados/ocorrencias/ocorrencias_bruta.csv") %>% as.data.frame()

# Verifica inicio ...
head(occ_raw)

# ... e final da tabela
tail(occ_raw)

# Número de ocorrências totais
nrow(occ_raw)

# Checando os dados de ocorrencia
occ_clean <- clean_coordinates(occ_raw, species = "species",
                               lon = 'decimalLongitude',
                               lat = 'decimalLatitude',
                               tests = c("equal", "outliers", "zeros", 'dupl'),
                               value = "clean")

# Número de ocorrências únicas
nrow(occ_clean)

# Selecionando as colunas longitude e latitude
occ_clean <- dplyr::select(occ_clean, decimalLongitude, decimalLatitude)

# Importando uma variável preditora
var1 <- raster('dados/abioticos/presente/bio_01.tif')

# Salvando o tabela com os registros únicos por pixel
occ_unique <- gridSample(occ_clean, var1, n = 1)

# Resetando os nomes das linhas
rownames(occ_unique) <- NULL

# Número de ocorrências únicas
nrow(occ_unique)

# Removendo dados com 'NA'
occ_modelagem <- occ_unique[!is.na(extract(var1, occ_unique)),]

# Número de ocorrências dentro do raster, com valores ambientais associados
# Número de ocorrências únicas por pixel, com valores e sem inconcistencias
nrow(occ_modelagem)

# Salvando no disco
write.csv(occ_modelagem, "dados/ocorrencias/ocorrencias_modelagem.csv",
          row.names = FALSE)
