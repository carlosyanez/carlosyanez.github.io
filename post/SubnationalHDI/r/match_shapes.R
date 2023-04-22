processed <- processed %>% mutate(dedup_id=row_number())
dedup <- as.data.frame(processed) %>% group_by(source_id) %>%
  summarise(n=n(),min_id=min(dedup_id))  %>% ungroup()

processed <- processed %>% left_join(dedup,by="source_id") %>%
  mutate(keep=(dedup_id==min_id)) %>% filter(keep) 

hdi_subnat_res <- hdi_subnat %>% 
  mutate(label2=paste(shapeGroup, region,sep=" - ")) %>%
  filter(!(source_id %in% processed$source_id)) %>%
  mutate(label2=paste(shapeGroup," - ", region))


hdi_subnat_s_polygon <-hdi_subnat_polygon %>% filter(!(source_id %in% processed$source_id)) %>%
                           mutate(shapeGroup=ifelse(shapeGroup=="XKO","XKX",shapeGroup))

#first group
hdi_subnat1 <- hdi_subnat_res %>% filter(level %in% c("match"))
shapes_regions <- region_shapes %>% filter(!(shapeID %in% processed$shapeID))
processed2 <- match_shapes(hdi_subnat1,hdi_subnat_s_polygon,shapes_regions)

hdi_subnat1 <- hdi_subnat_res %>% filter(level %in% c("1"))
processed32 <- match_shapes(hdi_subnat1,hdi_subnat_s_polygon,shapes_regions)
processed2 <- rbind(processed2,processed32)

hdi_subnat1 <- hdi_subnat_res %>% filter(level %in% c("match2"))
shapes_regions <- region_shapes2 %>% filter(!(shapeID %in% processed$shapeID))
processed32 <- match_shapes(hdi_subnat1,hdi_subnat_s_polygon,shapes_regions)
processed2 <- rbind(processed2,processed32)

hdi_subnat1 <- hdi_subnat_res %>% filter(level %in% c("2"))
processed32 <- match_shapes(hdi_subnat1,hdi_subnat_s_polygon,shapes_regions)
processed2 <- rbind(processed2,processed32)

rm(hdi_subnat1,processed33)

processed <- processed %>% 
  select(-min_id,-keep,-label2,-label,-shapeName,-shapeID,-region_orig,-n,-dedup_id)
raster::crs(processed) <- "+proj=lcc +lat_1=48 +lat_2=33 +lon_0=-100 +datum=WGS84"


processed2 <- processed2 %>% select(-label2,-abs_diff,-perc_diff,-keep)
processed2_1 <-processed2
raster::crs(processed2) <- "+proj=lcc +lat_1=48 +lat_2=33 +lon_0=-100 +datum=WGS84"

processed_complete<- rbind(processed,processed2)