# install.packages("raster")
# install.packages("dismo")
# install.packages("dplyr")
# install.packages("rgbif")
# install.packages("maps")
# install.packages("CoordinateCleaner")
# install.packages("leaflet")
# install.packages("leaflet.extras")
# install.packages("vroom")
# install.packages("rJava")

packages <- c("raster", "dismo", "dplyr", "rgbif", "maps", "CoordinateCleaner", "leaflet", "leaflet.extras", "vroom", "rJava")

to_install <- packages[!packages %in% rownames(installed.packages())]

if(length(to_install) != 0) {install.packages(to_install)}
