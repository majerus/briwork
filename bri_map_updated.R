# load r libraries
library(tidyverse)
library(fontawesome)
library(htmlwidgets)
library(leaflet)

# create icon list
# converting icon to text seems to be the trick to get these to render (not sure why)
# it looks like all the icons you are using are in the free list but may be worth confirming that before publishing
bri_icons <- awesomeIconList(
  Loon = makeAwesomeIcon(text = fa('feather-pointed'), library = 'fa',  markerColor = 'blue'),
  Mammal = makeAwesomeIcon(text = fa('paw'), library = 'fa', markerColor = 'red'),
  Mercury = makeAwesomeIcon(text = fa('atom'), library = 'fa', markerColor = 'darkblue'),
  Cosmetics = makeAwesomeIcon(text = fa('pills'), library ='fa', markerColor = 'pink'),
  Climate = makeAwesomeIcon(text = fa('temperature-half'), library = 'fa', markerColor = 'purple'),
  Wind = makeAwesomeIcon(text = fa('wind'), library = 'fa', markerColor = 'lightblue'))


# load data
# this reads the file you uploaded to github directly 
bri <- read_csv("https://raw.githubusercontent.com/AFoster105/briwork/main/BRIWorkPlaces.csv")


# create popup text with link
bri <-
  bri %>% 
  mutate(popup = paste("<b><a href='", link,"'>", Category,"</a></b>", "<br/>",
                       sep=''))

# create base map
m <- 
  leaflet() %>% 
  addTiles() 

# add markers to base map
names(bri_icons) %>%
  walk(function(x)
    m <<-
      m %>% addAwesomeMarkers(
        data = filter(bri, Category ==x),
        group = x,
        icon = bri_icons[[x]],
        popup = ~popup))



# add check box layers control to map
m <- 
  m %>%
  addLayersControl(
    overlayGroups = names(bri_icons),
    options = layersControlOptions(collapsed = TRUE)
  )

# print map 
m

# save map
saveWidget(m, file = "brimap.html")
