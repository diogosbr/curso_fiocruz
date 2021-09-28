# Carregando os pacotes ---------------------------------------------------
library(raster)
library(dismo)

# Carregando as variaveis abioticas
lista <- list.files("dados/abioticos/selecionados/presente/", pattern = "tif$", full.names = TRUE)
lista

# Importando as variaveis abioticas
preditoras <- stack(lista)
preditoras

# Carregando as ocorrencias
occ <- read.csv("dados/ocorrencias/ocorrencias_modelagem.csv")

# Verificando os dados
head(occ)
dim(occ)

# Criando a tabela com informacao ambiental associada
tabela <- extract(preditoras, occ)

# Verificando os dados
head(tabela)
dim(tabela)

# Gerando o modelo com algoritmo BIOCLIM
modelo_bioclim <- bioclim(preditoras, occ)

# Plotando o modelo bioclim
plot(modelo_bioclim)
density(modelo_bioclim)

# Fechando o parametro grafico
dev.off()

# Projetando o modelo
modelo_bioclim_proj <- predict(preditoras, modelo_bioclim)

# Plotando
plot(modelo_bioclim_proj)

# Gerando o modelo com algoritmo MAXENT
modelo_maxent <- maxent(preditoras, occ)

plot(modelo_maxent)
density(modelo_maxent)

# Fechando o parametro grafico
dev.off()

# Projetando o modelo
modelo_maxent_proj <- predict(preditoras, modelo_maxent)

# Plotando
plot(modelo_maxent_proj)
