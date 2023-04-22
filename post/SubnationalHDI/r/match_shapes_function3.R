

match_shapes <- function(hdi_subnat_s,hdi_subnat_s_polygon,shapes_regions){
  
  hdi_subnat_s_countries <- hdi_subnat_s %>% pull(shapeGroup) %>% unique(.) 
  level <- hdi_subnat_s[1,]$level
  
  shape1 <- shapes_regions %>% filter(shapeGroup %in% hdi_subnat_s_countries)

    hdi_subnat1 <- hdi_subnat_s # %>% mutate(source_id=row_number(),old_source_id=source_id) 

  for(i in 1:length(hdi_subnat_s_countries)){
    message(paste(hdi_subnat_s[1,]$level,hdi_subnat_s_countries[i],sep="-"))   
 
    hdi_subnat1_s_i <- hdi_subnat1 %>% filter(shapeGroup==hdi_subnat_s_countries[i]) %>% 
                                      mutate(shapeName=gsub("[[:space:]]", "", region)) %>%
                                      select(source_id,shapeName)
    
    hdi_subnat_s_i <-  hdi_subnat_s_polygon %>% mutate(shapeName=gsub("[[:space:]]", "", shapeName)) %>%
                      filter(shapeGroup==hdi_subnat_s_countries[i])  
    
    if(nrow(as.data.frame(hdi_subnat_s_i))>0){
      
      hdi_subnat_s_i <- hdi_subnat_s_i %>% inner_join(hdi_subnat1_s_i,by="source_id")  %>% select(source_id) 

      #  select(source_id) 
      raster::crs(hdi_subnat_s_i) <- "+proj=lcc +lat_1=48 +lat_2=33 +lon_0=-100 +datum=WGS84"
      hdi_subnat_s_i$area1 <- raster::area(hdi_subnat_s_i)
      
      
      shape1_i <- shape1 %>% filter(shapeGroup==hdi_subnat_s_countries[i]) %>% 
         select(shapeID)
      raster::crs(shape1_i) <- "+proj=lcc +lat_1=48 +lat_2=33 +lon_0=-100 +datum=WGS84"
      shape1_i$area2 <- raster::area(shape1_i)
      
      
      hdi_subnat_s_i <- gBuffer(hdi_subnat_s_i, byid=TRUE, width=0)
      shape1_i <- gBuffer(shape1_i, byid=TRUE, width=0)
      raster::crs(hdi_subnat_s_i) <- "+proj=lcc +lat_1=48 +lat_2=33 +lon_0=-100 +datum=WGS84"
      raster::crs(shape1_i) <- "+proj=lcc +lat_1=48 +lat_2=33 +lon_0=-100 +datum=WGS84"
      
      intersect_res <- raster::intersect(shape1_i,hdi_subnat_s_i)
      
      raster::crs(intersect_res) <- "+proj=lcc +lat_1=48 +lat_2=33 +lon_0=-100 +datum=WGS84"
      intersect_res$area_common <- raster::area(intersect_res)
      #intersect_res_2 <-intersect_res
     # intersect_res <- intersect_res %>% mutate(id=row_number())
      
      intersect_res_df <- as.data.frame(intersect_res) #%>% mutate(area_ratio=area_common/area2)
      

      if(level %in% c("match","match2")){
        intersect_res_dedup <- intersect_res_df %>% group_by(source_id) %>% 
          summarise(count=n(),max_area=max(area_common)) %>% ungroup()
        
        intersect_res_df<- intersect_res_df %>% left_join(intersect_res_dedup, by=c("source_id")) %>%  
          mutate(keep=(area_common==max_area)) %>%
          filter(keep) %>% unique(.) %>% select(shapeID,source_id,area_common)
        
      }else{
        intersect_res_dedup <- intersect_res_df %>% group_by(shapeID) %>% 
          summarise(count=n(),max_area=max(area_common)) %>% ungroup()
        
        intersect_res_df<- intersect_res_df %>% left_join(intersect_res_dedup, by=c("shapeID")) %>%  
          mutate(keep=(area_common==max_area)) %>%
          filter(keep) %>% unique(.) %>% select(shapeID,source_id,area_common)
        
      }
      
      intersect_res_2 <- shape1_i %>% left_join(intersect_res_df,by="shapeID") %>% 
                          select(source_id) %>% filter(!is.na(source_id))                                            
      
  #   as.data.frame(intersect_res_2) %>% select(source_id) %>% unique(.)
      
      if(nrow(intersect_res_2)>0){
        

        sources <- intersect_res_2$source_id
        
        processed_res_ii <- maptools::unionSpatialPolygons(intersect_res_2, sources)
        processed_ids <-unique(sources)
        processed_ids <- data.frame(source_id=processed_ids) %>% mutate(keep=TRUE)
        row.names(processed_ids) <- processed_ids$source_id
        
        processed_res_i <- SpatialPolygonsDataFrame(processed_res_ii, processed_ids)
        #processed_res_i <- ms_simplify(processed_res_i,keep = 0.08)
        
      
        processed_res_i <- processed_res_i %>% inner_join(hdi_subnat1,by="source_id") 
                          

        raster::crs(processed_res_i) <- "+proj=lcc +lat_1=48 +lat_2=33 +lon_0=-100 +datum=WGS84"
        
        if(exists("processed_res")){
              processed_res <- rbind(processed_res,processed_res_i)
        }else{
          processed_res <- processed_res_i
        }
      }
      
    } 
  }
  
  processed_res <- processed_res %>% mutate(matching_method="shape") 
  raster::crs(processed_res) <- "+proj=lcc +lat_1=48 +lat_2=33 +lon_0=-100 +datum=WGS84"
  processed_res
  
  
}