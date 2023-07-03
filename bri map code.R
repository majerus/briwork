library(googlesheets4)
library(tidyverse)
library(ggmap)
library(fontawesome)
library(icons)
library(leaflet)
library(htmlwidgets)
bri = read.csv(file.choose())

bri_icons <- awesomeIconList(
  Loon = makeAwesomeIcon(icon = 'feather-pointed', library = 'fa',  markerColor = 'blue'),
  Mammal = makeAwesomeIcon(icon = 'paw', library = 'fa', markerColor = 'red'),
  Mercury = makeAwesomeIcon(icon = 'atom', library = 'fa', markerColor = 'darkblue'),
  Cosmetics = makeAwesomeIcon(icon = 'pills', library ='fa', markerColor = 'pink'),
  Climate = makeAwesomeIcon(icon = 'temperature-half', library = 'fa', markerColor = 'purple'),
  Wind = makeAwesomeIcon(icon = 'wind', library = 'fa', markerColor = 'lightblue'))

bri <-
  bri %>% 
  mutate(popup = paste("<b><a href='", link,"'>", Category,"</a></b>", "<br/>",
                       sep=''))

m <- 
  leaflet() %>% 
  addTiles() 

names(bri_icons) %>%
  walk(function(x)
    m <<-
      m %>% addAwesomeMarkers(
        data = filter(bri, Category ==x),
        group = x,
        icon = bri_icons[[x]],
        popup = ~popup))

m <- 
  m %>%
  addLayersControl(
    overlayGroups = names(bri_icons),
    options = layersControlOptions(collapsed = TRUE)
  )

saveWidget(m, file = "brimap.html")
