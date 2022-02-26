#Packages


packages.<-list("sf","raster","rnaturalearth","rnaturalearthdata")


#Load all packages

lapply(packages.,FUN=library, character.only=TRUE)

