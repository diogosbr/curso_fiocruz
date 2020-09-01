# carregando pacotes ------------------------------------------------------
library(rgbif)
library(dplyr)
library(raster)

# obtendo os dados
dados_brutos <- occ_data(scientificName = "Euterpe edulis", hasCoordinate = TRUE)

# selecionando apenas as colunas de interesse
ocorrencias <-
  dados_brutos$data %>%
  select(scientificName, decimalLongitude, decimalLatitude) %>%
  rename(spp = scientificName, lon = decimalLongitude, lat = decimalLatitude)

# removendo os registros com coordenadas duplicadas
ocorrencias <- distinct(ocorrencias)

# convertendo em "Spatial object"
coordinates(ocorrencias) <- ~lon+lat

# obtendo shape do brasil
br <- getData("GADM", country = "bra", level = 0)

# plotando
plot(br, axes = TRUE)
plot(ocorrencias, add = TRUE)

# obtendo dados abioticos
bioclimaticas <- getData("worldclim", res = 10, var = "bio")

# recortando para o brasil
bioclimaticas_br <- bioclimaticas %>% crop(br) %>% mask(br)

# obtendo shape do brasil
aus <- getData("GADM", country = "australia", level = 0)

# recortando para a australia
bioclimaticas_aus <- bioclimaticas %>% crop(aus) %>% mask(aus)

# criando um diretorio para salvar
dir.create("data/env/proj")

# salvando em um diretorio
for(nome in names(bioclimaticas_aus)){
  writeRaster(bioclimaticas_aus, paste0("data/env/proj/", nome, ".tif"))
}

# configurando dados de entrada
setup_sdmdata(species_name = "Euterpe_edulis",
              occurrences = as.data.frame(ocorrencias),
              predictors = bioclimaticas_br,
              models_dir = "teste/proj",
              partition_type = c("crossvalidation"),
              cv_n = 1,
              cv_partitions = 3,
              #clean_dupl = T,
              clean_nas = T,
              #clean_uni = T,
              geo_filt_dist = 10,
              select_variables = F,
              sample_proportion = 0.005
)

do_any(species_name = "Euterpe_edulis",
       predictors = bioclimaticas_br,
       models_dir = "teste/proj",
       algorithm = "bioclim",
       project_model = TRUE,
       proj_data_folder = "./data/env/proj/")

final_model(species_name = "Euterpe_edulis",
            models_dir = "teste/proj")

final_model(species_name = "Euterpe_edulis",
            models_dir = "teste/proj",
            proj_dir = "proj")


