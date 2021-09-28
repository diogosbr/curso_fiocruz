# Carregando os pacotes ---------------------------------------------------
library(raster)
library(dismo)
#source("funcoes/ver_mapa.R")

# Carregando as variaveis abioticas
lista <- list.files("dados/abioticos/selecionados/presente/", pattern = "tif$", full.names = TRUE)

lista

# Importando as variaveis abioticas
preditoras <- stack(lista)
preditoras

# Carregando as ocorrencias
occ <- read.csv("dados/ocorrencias/ocorrencias_modelagem.csv")

head(occ)
dim(occ)

# Avaliando o modelo ------------------------------------------------------

# Gerando pontos de pseudoausencia
ausencias <- randomPoints(mask = preditoras[[1]], n = 1000, p = occ)

# Número de pontos para treino
n_pres <- nrow(occ) * 0.8
n_aus <- nrow(ausencias) * 0.8

# Indice dos registros selecionados para treino
indices_pres <- sample(1:nrow(occ), n_pres)
indices_aus <- sample(1:nrow(ausencias), n_aus)

# Dividindo em treino e teste
occ_treino <- occ[indices_pres,]
occ_teste <- occ[-indices_pres,]
ausencias_treino <- ausencias[indices_aus,]
ausencias_teste <- ausencias[-indices_aus,]

# Gerando o modelo com algoritmo bioclim
modelo_bioclim <- bioclim(preditoras, occ_treino)

# Projetando o modelo
modelo_proj <- predict(preditoras, modelo_bioclim)

# Plotando
plot(modelo_proj)

# ver_pontos(occ_teste, lon = "decimalLongitude", lat = "decimalLatitude",
#            plot_raster = modelo_proj)

# Avaliando o modelo
aval <- evaluate(p = occ_teste, a = ausencias_teste,
                 model = modelo_bioclim, x = preditoras)

# Valor de AUC
aval@auc

# Valor de TSS
max((aval@TPR + aval@TNR) - 1) #TSS

# Plotando o mapa com o modelo
par(mar = c(0,0,0,0))
my.colors = colorRampPalette(c("#5E85B8","#EDF0C0","#C13127"))
plot(modelo_proj, col = my.colors(1000), axes = FALSE, box = FALSE)

# Adicionando os pontos de presença
points(occ, pch = 16, col = 'lightgreen', cex = 0.8)
# Adicionando os pontos de ausencia
points(ausencias, pch = ".", col = 'red', cex = 1.5)


# Salvando o modelo -------------------------------------------------------

# Salvando o geotiff do modelo no disco
writeRaster(modelo_bioclim_proj_presente, "resultados/modelo.tif")

# Salvando um PNG no disco
png("resultados/modelo.png", width = 900, height = 400)
par(mar = c(0,0,0,0))
my.colors = colorRampPalette(c("#5E85B8","#EDF0C0","#C13127"))
plot(modelo_proj, col = my.colors(1000), axes = FALSE, box = FALSE)
dev.off()

# Salvando um PNG no disco
png("resultados/modelo_com_pontos.png", width = 900, height = 400)
par(mar = c(0,0,0,0))
my.colors = colorRampPalette(c("#5E85B8","#EDF0C0","#C13127"))
plot(modelo_proj, col = my.colors(1000), axes = FALSE, box = FALSE)
points(occ, pch = 16, col = 'lightgreen', cex = 0.8)
points(ausencias, pch = ".", col = 'red', cex = 1.5)
dev.off()
