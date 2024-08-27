library(leaflet)
library(leaflet.extras)
library(dplyr)

ver_pontos <- function(tabela, lon, lat, plot_raster = NULL){

  tabela <- rename(tabela, lon = decimalLongitude, lat = decimalLatitude)

  m_base <- leaflet() %>%
    addTiles() %>%
    setView(lng = -50, lat = -12 , zoom = 4) %>%
    addScaleBar(position = "bottomleft",
                options = scaleBarOptions(imperial = F)) %>%
    addProviderTiles(providers$Esri.WorldImagery, group = "Satelite") %>%
    addMiniMap(tiles = providers$Esri.WorldStreetMap,
               toggleDisplay = TRUE, position = "bottomright")

  m_points <-
    m_base %>%
    addMarkers(data = tabela, ~lon, ~lat,
               popup = paste("<i>", "Registro: ", rownames(tabela),"</i>","<br>","Longitude", tabela$lon,"<br>", "Latitude" , tabela$lat),
               popupOptions = popupOptions(closeButton = TRUE))

  if(is.null(plot_raster)) {
    m_points} else {
      pal <- colorNumeric(rev(terrain.colors(25)), values(plot_raster),
                          na.color = "transparent")

      m_raster <- m_points %>%
        addRasterImage(plot_raster, colors = pal,
                       opacity = 0.6) %>%
        addLegend(pal = pal, values = values(plot_raster), title = "Legend")

      m_raster
    }
}
