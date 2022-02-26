#Packages


packages.<-list("sf","raster","rnaturalearth","rnaturalearthdata","geosphere")


#Load all packages

lapply(packages.,FUN=library, character.only=TRUE)

