max_dist_value1 <-0.001
max_dist_value_iso1 <-0.5
hdi_levelmatch1 <- region_shapes %>% filter(level=="match")
hdi_subnatmatch1 <- hdi_subnat %>% filter(level=="match")

processed <- match_names(hdi_levelmatch1,hdi_subnatmatch1,max_dist_value1,max_dist_value_iso1)

hdi_levelmatch <- region_shapes2 %>% filter(level=="match2")
hdi_subnatmatch <- hdi_subnat %>% filter(level=="match2")

processed2 <- match_names(hdi_levelmatch1,hdi_subnatmatch1,max_dist_value1,max_dist_value_iso1)

processed <- rbind(processed,processed2)

max_dist_value1 <-0.001
hdi_levelmatch1 <- region_shapes %>% filter(level=="1" & (abs_diff<=6 | perc_diff<=0.25))
hdi_subnatmatch1 <- hdi_subnat %>% filter(level=="1" & (abs_diff<=6 | perc_diff<=0.25))

processed2 <- match_names(hdi_levelmatch1,hdi_subnatmatch1,max_dist_value1,max_dist_value_iso1)
processed <- rbind(processed,processed2)

hdi_levelmatch1 <- region_shapes2 %>% filter(level=="2" & (abs_diff<=6 | perc_diff<=0.25))
hdi_subnatmatch1 <- hdi_subnat %>% filter(level=="2" & (abs_diff<=6 | perc_diff<=0.25))

processed2 <- match_names(hdi_levelmatch1,hdi_subnatmatch1,max_dist_value1,max_dist_value_iso1)

processed <- rbind(processed,processed2)

rm(max_dist_value1,hdi_levelmatch1,hdi_subnatmatch1,processed2)

raster::crs(processed) <- "+proj=lcc +lat_1=48 +lat_2=33 +lon_0=-100 +datum=WGS84"
