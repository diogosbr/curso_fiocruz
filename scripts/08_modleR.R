
# o tutorial do pacote modelR pode ser acessado no link abaixo:
# https://model-r.github.io/modleR/articles/modleR.html

# link para o preprint do manuscrito:
# https://www.biorxiv.org/content/10.1101/2020.04.01.021105v1

# instalando pacote modleR ------------------------------------------------
remotes::install_github("Model-R/modleR", build = TRUE)

# carregando os pacotes ---------------------------------------------------
library(modleR)
library(raster)

# lendo os dados de ocorrencias -------------------------------------------
ocorrencias <- read.csv("./data/occ.csv", stringsAsFactors = FALSE)
especie <- unique(ocorrencias$spp)

# conferindo
head(ocorrencias)
especie

# lendo os dados abioticos ------------------------------------------------
abio <- stack(list.files("./data/env/", pattern = "tif$", full.names = TRUE))

# configurando os dados ---------------------------------------------------
sdmdata <- setup_sdmdata(species_name = especie,
                             occurrences = ocorrencias,
                             predictors = abio,
                             models_dir = "./resultados/",
                             partition_type = "crossvalidation",
                             cv_partitions = 3,
                             cv_n = 1,
                             buffer_type = "maximum",
                             n_back = 500,
                             clean_dupl = FALSE,
                             clean_uni = TRUE,
                             clean_nas = TRUE,
                             geo_filt = FALSE,
                             geo_filt_dist = 10,
                             select_variables = TRUE,
                             sample_proportion = 0.005,
                             cutoff = 0.7)

# conferindo
head(sdmdata)

# gerando os modelos ------------------------------------------------------
do_many(species_name = especie,
                predictors = abio,
                models_dir = "./resultados/",
                png_partitions = TRUE,
                write_bin_cut = TRUE,
                write_rda = TRUE,
                bioclim = TRUE,
                glm = TRUE,
                svmk = TRUE,
                maxnet = TRUE,
                rf = TRUE,
                equalize = TRUE)

# juntando os modelos por algoritmo ---------------------------------------
final_model(species_name = especie,
            models_dir = "./resultados/",
            which_models = c("raw_mean",
                             "bin_consensus"),
            consensus_level = 0.5,
            uncertainty = TRUE,
            overwrite = TRUE)

# juntando os modelos de cada algoritmo -----------------------------------

ens <- ensemble_model(species_name = especie,
                      occurrences = ocorrencias,
                      performance_metric = "pROC",
                      which_ensemble = c("average", "consensus"),
                      consensus_level = 0.5,
                      which_final = "raw_mean",
                      models_dir = "./resultados/",
                      overwrite = TRUE)

