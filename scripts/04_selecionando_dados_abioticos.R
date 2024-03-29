# Carregando os pacotes ---------------------------------------------------
library(raster)
library(corrplot)
library(dplyr)
library(caret)

# Listando os arquivos
lista_abio <- list.files("dados/abioticos/presente/",
                         pattern = "tif$", full.names = TRUE)
lista_abio

# Importando as variáveis preditoras
preditoras <- stack(lista_abio)

# Plotando a primeira variável
plot(preditoras[[1]])

# Criando uma tabela com os valores por pixel
tabela_preditoras <- na.omit(preditoras[])

head(tabela_preditoras)
dim(tabela_preditoras)

# Matriz de correlação
cor_mat <- cor(tabela_preditoras)

# Plot da matriz de correlação (exemplo1)
corrplot(cor_mat, method = "color",
         type = "upper", order = "hclust",
         addCoef.col = "black",
         tl.col = "black", tl.srt = 45,
         diag = FALSE)

# Selecionando automaticamente
variaveis_remover <- findCorrelation(x = cor_mat, cutoff = 0.7)

# Variáveis selecionadas
names(preditoras)[-variaveis_remover]

# Selecionando as variáveis
preditoras_selecionadas <- preditoras[[-variaveis_remover]]

# Nova matriz de correlação
cor_mat_sel <- preditoras_selecionadas %>% values() %>% na.omit() %>% cor()

# Plotando a nova matriz de correlção
corrplot(cor_mat_sel, method = "color",
         type = "upper", order = "hclust",
         addCoef.col = "black",
         tl.col = "black", tl.srt = 45,
         diag = FALSE)

# Criando a pasta para receber as variaveis selecionadas
if(!dir.exists("dados/abioticos/selecionados/presente/")){dir.create("dados/abioticos/selecionados/presente/", recursive = TRUE)}

# Salvando as variáveis no disco
for(i in 1:nlayers(preditoras_selecionadas)){
  writeRaster(preditoras_selecionadas[[i]],
              filename = paste0("dados/abioticos/selecionados/presente/",
                                names(preditoras_selecionadas)[i], ".tif"),
              options = "COMPRESS=DEFLATE",
              overwrite = TRUE)
}
