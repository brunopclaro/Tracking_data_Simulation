#Tracking simulation data


##Starting point

#Create coastal map
coast_sp<- ne_coastline(scale="medium")
plot(coast_sp, col="red")


#Create extent
extent<- drawExtent(show=TRUE, col="black")



#number of vessels
vess<- 1:10
n_vess<-10

#starting point
lon<-runif(n_vess,min=extent@xmin, max=extent@xmax)
lat<- runif(n_vess, min=extent@ymin,max=extent@ymax)

start<-data.frame(lon, lat)


#set max points from start point
n_set= 100
n_set_seq= 1:101



#Set distance from previous point: in meters
dist= 100000


#pre-allocate list for generated poitns
L<-vector(mode = "list", length= n_vess)


##With loop
for (i in 1:n_vess){
  L[[i]]<- vector(mode="list", length=1+n_vess)
}



    ##Or Recursive function
La<-vector(mode = "list")


points_list.gen<- function(n){
  
  if(length(n)==1){
    
    La[[1]]<-vector(mode="list", length= n_vess+1)
    return(La)
  }else{
    Lb<-points_list.gen(n[1])
    Lc<-points_list.gen(n[-1])
    
    Ld<-c(Lb,Lc)
    
    return(Ld)
  }
}



L1<-points_list.gen(vess)





#introduce start point

for (i in 1:n_vess) {
  L1[[i]][[1]]<-start[i,]
  print(L1[[i]][[1]])
  }




#Generate tracking points

for (n in 1:n_vess){
  for (i in 2:(n_set+1)) {
    L1[[n]][[i]]<- destPoint(p= L1[[n]][[i-1]],
                            b= runif(1,0,270),
                            d= runif(1,0,dist)
    )
  }
}


    #Or recursive function - in this case it seems not practical."It’s hard to convert a for loop into a functional when the relationship between elements is not independent, or is defined recursively."http://adv-r.had.co.nz/Functionals.html#functionals-loop










#Add tracking points to dataframe
tracks<-vector(mode= "list",length=n_vess)

for (n in 1:n_vess){
    
    tracks[[n]]<-do.call(rbind,L1[[n]])
  }



#Create spatial points
coords_sp<- vector(mode="list", length=n_vess)

for (n in 1:n_vess){
  
  coords_sp[[n]] <- SpatialPointsDataFrame(coords=tracks[[n]][,1:2],data=tracks[[n]],proj4string = CRS(" +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
}



#Create lines from spatial points
lines_sp<- vector(mode="list", length=n_vess)

for (n in 1:n_vess){
  
  lines_sp[[n]]<- as(coords_sp[[n]], "SpatialLines")
  }




#Check created tracks in selected extent

plot.new()
plot(extent)
plot(coast_sp,add=TRUE)


for (n in 1:n_vess){
  plot(lines_sp[[n]],add=TRUE)
  print(paste0("Vessel number ",n))
}
  
  

