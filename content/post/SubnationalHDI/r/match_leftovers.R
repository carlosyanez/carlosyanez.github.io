

hdi_subnat_res <- hdi_subnat %>% 
  filter(!(source_id %in% processed_complete$source_id)) 

hdi_polygon_res <- hdi_subnat_polygon %>% filter(source_id %in% hdi_subnat_res$source_id) %>%
  select(source_id)

processed3 <-   hdi_polygon_res %>% inner_join(hdi_subnat_res,by="source_id")

hdi_subnat_leftout <- hdi_subnat_res %>% filter(!(source_id %in% processed3$source_id))
write.csv(hdi_subnat_leftout,"hdi_subnat_leftout.csv")

if(file.exists("manual_entries.csv")){
  manual_entries <- read_csv("manual_entries.csv")
  manual_entries <- manual_entries %>% select(level,source_id,shapeID)
  
  
  me_1 <- region_shapes %>% inner_join((manual_entries %>% filter(level %in% c("1","match"))),
                                       by="shapeID")
  
  me_2 <- region_shapes2 %>% inner_join((manual_entries %>% filter(level %in% c("2","match2"))),
                                        by="shapeID")
  
  me_1 <- gBuffer(me_1, byid=TRUE, width=0)
  raster::crs(me_1) <- "+proj=lcc +lat_1=48 +lat_2=33 +lon_0=-100 +datum=WGS84"
  
  me_2 <- gBuffer(me_2, byid=TRUE, width=0)
  raster::crs(me_2) <- "+proj=lcc +lat_1=48 +lat_2=33 +lon_0=-100 +datum=WGS84"
  
  sources <- me_1$source_id
  me_1 <- maptools::unionSpatialPolygons(me_1, sources)
  processed_ids <-unique(sources)
  processed_ids <- data.frame(source_id=processed_ids) %>% mutate(keep=TRUE)
  row.names(processed_ids) <- processed_ids$source_id
  me_1 <- SpatialPolygonsDataFrame(me_1, processed_ids)
  raster::crs(me_1) <- "+proj=lcc +lat_1=48 +lat_2=33 +lon_0=-100 +datum=WGS84"
  
  sources <- me_2$source_id
  me_2 <- maptools::unionSpatialPolygons(me_2, sources)
  processed_ids <-unique(sources)
  processed_ids <- data.frame(source_id=processed_ids) %>% mutate(keep=TRUE)
  row.names(processed_ids) <- processed_ids$source_id
  me_2 <- SpatialPolygonsDataFrame(me_2, processed_ids)
  raster::crs(me_2) <- "+proj=lcc +lat_1=48 +lat_2=33 +lon_0=-100 +datum=WGS84"
  
  me <- rbind(me_1,me_2)
  
  processed4 <- me %>% left_join(hdi_subnat_res,by="source_id") %>% select(-keep)
  
  raster::crs(processed3) <- "+proj=lcc +lat_1=48 +lat_2=33 +lon_0=-100 +datum=WGS84"
  raster::crs(processed4) <- "+proj=lcc +lat_1=48 +lat_2=33 +lon_0=-100 +datum=WGS84"
  processed5 <-rbind(processed3,processed4)
}else{
  raster::crs(processed3) <- "+proj=lcc +lat_1=48 +lat_2=33 +lon_0=-100 +datum=WGS84"
  processed5 <-processed3
  
}

processed5 <-  processed5 %>%select(-abs_diff,-perc_diff) %>%
  mutate(matching_method="leftovers")
raster::crs(processed5) <- "+proj=lcc +lat_1=48 +lat_2=33 +lon_0=-100 +datum=WGS84"

processed_complete <- rbind(processed_complete,processed5)