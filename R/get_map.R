library(sp)
library(broom)
library(rgdal)
library(maptools)
library(devtools)
library(tigris)

get_map <- function(projection = "mercator", year = 2015, resolution = "20m", lower48 = FALSE, reposition = TRUE,
                    sovereignty = FALSE, territory = FALSE, associated = FALSE){
    year = as.numeric(year); projection = as.character(projection); resolution = as.character(resolution)
    
    mapshape <- tigris::counties(cb = TRUE, resolution, year)
    
    if(projection = "mercator" | projection = tolower("M")){
        us.map <- spTransform(mapshape, CRS("+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0
                                 +x_0=0.0 +y_0=0 +k=1.0 +units=m +no_defs"))
    }
    
    us.map@data$id <- rownames(us.map@data)
    
    
    if(isTRUE(reposition)){
        # Rotate and shrink ak.
        ak <- us.map[us.map$STATEFP=="02",]
        ak <- elide(ak, rotate=-50)
        ak <- elide(ak, scale=max(apply(bbox(ak), 1, diff)) / 2.3)
        ak <- elide(ak, shift=c(-2100000, -2500000))
        proj4string(ak) <- proj4string(us.map)
        
        # Rotate and Shift hawi
        hawi <- us.map[us.map$STATEFP=="15",]
        hawi <- elide(hawi, rotate=-35)
        hawi <- elide(hawi, shift=c(5400000, -1600000))
        proj4string(hawi) <- proj4string(us.map)
    }
    
    
    if(!isTRUE(sovereignty)){
        # Remove Outlying area under U.S. sovereignty. These include, American Samoa (60), Guam (66),
        # Northern Mariana Islands (69), Puerto Rico (72), and Virgin Islands (78).
        us.map <- us.map[!us.map$STATEFP %in% c("60", "66", "69", "72", "78"),]
    }
    
    if(!isTRUE(associated)){
        # Remove Freely Associated States. These include, Federated States of Micronesia (64), Marshall Islands (68),
        # and Palau (70).
        us.map <- us.map[!us.map$STATEFP %in% c("64", "68", "70"),]
    }
    
    if(!isTRUE(territory)){
        # Remove Minor outlying island territory. These include, Baker Island (81), Howard Island (84), Harvis Island (86),
        # Johnston Atoll (67), Kingman Reed (89), Midway Islands (71), Navassa Island (76), Palmyra Atoll (95),
        # Wake Island (79), and Minor outlying island territories aggregated (74)
        us.map <- us.map[!us.map$STATEFP %in% c("81", "84", "86", "67", "89", "71", "76", "95", "79", "74"),]
    }
    
    # If Alaska and Hawaii were rotated, we need to rbind.
    ifelse(isTRUE(lower48), us.map = us.map, us.map = rbind(us.map, ak, hawi))
    
    # Projuce map
    tidymap <- broom::tidy(us.map, region="GEOID")
    
}