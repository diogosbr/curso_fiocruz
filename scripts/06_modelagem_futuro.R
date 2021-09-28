# Carregando os pacotes ---------------------------------------------------
library(raster)
library(dismo)

# Carregando as variaveis abioticas do presente
lista_presente <- list.files("dados/abioticos/selecionados/futuro/", pattern = "tif$", full.names = TRUE)

lista_presente

# Importando as variaveis abioticas do presente
preditoras_presente <- stack(lista_presente)
preditoras_presente

# Carregando as variaveis abioticas do futuro
lista_futuro <- list.files("dados/abioticos/futuro/RCP85_2100/", pattern = "tif$", full.names = TRUE)

lista_futuro

# Selecionando as mesmas variáveis do presente
ponteiro <- basename(lista_futuro) %in% basename(lista_presente)
lista_futuro <- lista_futuro[ponteiro]

lista_futuro

# Importando as variaveis abióticas do futuro
preditoras_futuro <- stack(lista_futuro)
preditoras_futuro

# Carregando as ocorrencias
occ <- read.csv("dados/ocorrencias/ocorrencias_modelagem.csv")

# Verificando a tabela
head(occ)
dim(occ)


# BIOCLIM -----------------------------------------------------------------

# Gerando o modelo com algoritmo BIOCLIM
modelo_bioclim <- bioclim(preditoras_presente, occ)

# Projetando o modelo
modelo_bioclim_proj_presente <- predict(preditoras_presente, modelo_bioclim)
modelo_bioclim_proj_futuro <- predict(preditoras_futuro, modelo_bioclim)

# Plotando
plot(modelo_bioclim_proj_presente)
plot(modelo_bioclim_proj_futuro)

# Plotando lado a lado
modelos_bioclim <- stack(modelo_bioclim_proj_presente, modelo_bioclim_proj_futuro)
names(modelos_bioclim) <- c("presente", "futuro")
plot(modelos_bioclim)


# MAXENT ------------------------------------------------------------------

# Gerando o modelo com algoritmo MAXENT
modelo_maxent <- maxent(preditoras_presente, occ)

# Projetando o modelo
modelo_maxent_proj_presente <- predict(preditoras_presente, modelo_maxent)
modelo_maxent_proj_futuro <- predict(preditoras_futuro, modelo_maxent)

# Plotando
modelos_maxent <- stack(modelo_maxent_proj_presente, modelo_maxent_proj_futuro)
names(modelos_maxent) <- c("presente", "futuro")
plot(modelos_maxent)

# Salvando o geotiff dos modelos no disco
writeRaster(modelo_bioclim_proj_presente, "resultados/bioclim_presente.tif")
writeRaster(modelo_bioclim_proj_futuro, "resultados/bioclim_futuro.tif")
writeRaster(modelo_maxent_proj_presente, "resultados/maxent_presente.tif")
writeRaster(modelo_maxent_proj_futuro, "resultados/maxent_futuro.tif")

# Salvando o PNG no disco
png("resultados/bioclim_presente.png", width = 900, height = 400)
par(mar = c(0,0,0,0))
my.colors = colorRampPalette(c("#5E85B8","#EDF0C0","#C13127"))
plot(modelo_bioclim_proj_presente, col = my.colors(1000), axes = FALSE, box = FALSE)
dev.off()

png("resultados/bioclim_futuro.png", width = 900, height = 400)
par(mar = c(0,0,0,0))
my.colors = colorRampPalette(c("#5E85B8","#EDF0C0","#C13127"))
plot(modelo_bioclim_proj_futuro, col = my.colors(1000), axes = FALSE, box = FALSE)
dev.off()

png("resultados/maxent_presente.png", width = 900, height = 400)
par(mar = c(0,0,0,0))
my.colors = colorRampPalette(c("#5E85B8","#EDF0C0","#C13127"))
plot(modelo_maxent_proj_presente, col = my.colors(1000), axes = FALSE, box = FALSE)
dev.off()

png("resultados/maxent_futuro.png", width = 900, height = 400)
par(mar = c(0,0,0,0))
my.colors = colorRampPalette(c("#5E85B8","#EDF0C0","#C13127"))
plot(modelo_maxent_proj_futuro, col = my.colors(1000), axes = FALSE, box = FALSE)
dev.off()
