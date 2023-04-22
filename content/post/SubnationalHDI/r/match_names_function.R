
match_names <- function(hdi_levelmatch,hdi_subnatmatch,max_dist_value,max_dist_value_iso){
  
  
  ## get ISO codes
  
  if(file.exists("iso_codes.RDS")){
    iso_codes <- readRDS("iso_codes.RDS")
  }else{
    filename<- "iso_multilingual"
    url <- "https://github.com/timshadel/subdivision-list/archive/master.zip"
    
    download.file(url,paste(filename,".zip",sep=""))
    unzip(paste(filename,".zip",sep=""),exdir=filename)
    
    source_files <- list.files(path = filename, pattern = "subdivisions.csv", all.files = FALSE,
                               full.names = FALSE, recursive = TRUE,
                               ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)
    
    
    iso_codes <-read_csv(paste(filename,"/",source_files[1],sep=""))
    iso_codes$lang <- substring(source_files[1],30,31)
    iso_codes <- iso_codes %>% select(id,name,level,lang)
    
    for(i in  2:length(source_files)){
      iso_codes_i <-read_csv(paste(filename,"/",source_files[i],sep=""))
      iso_codes_i$lang <- substring(source_files[i],30,31)
      iso_codes_i <- iso_codes_i %>% select(id,name,level,lang)
      
      iso_codes <- rbind(iso_codes,iso_codes_i)
    }
    
    
    two_to_three <- read_csv("https://gist.github.com/tadast/8827699/raw/3cd639fa34eec5067080a61c69e3ae25e3076abb/countries_codes_and_coordinates.csv") 
    
    two_to_three %>% select(cc=`Alpha-2 code`,shapeGroup=`Alpha-3 code`)
    
    iso_codes2 <- iso_codes %>% left_join(iso_codes %>% filter(lang=="en") %>% select(id,english_name=name),
                                          by="id") %>% mutate(cc=substr(id,1,2)) %>% select(-lang) %>% unique(.)
    
    iso_codes2 <-  iso_codes2 %>%
      left_join(two_to_three %>% select(cc=`Alpha-2 code`,shapeGroup=`Alpha-3 code`),
                by="cc") %>% select(-cc) %>% unique(.)
    
    
    iso_codes <- iso_codes2
    saveRDS(iso_codes,"iso_codes.RDS")
    
    unlink(filename)
    unlink(paste(filename,".zip",sep=""))
    rm(i,iso_codes_i,url,filename,source_files,two_to_three,iso_codes2)
  }  
  
  #### get iso names in English first
  
  regions_hdi_names <- hdi_subnatmatch %>% select(region,shapeGroup) %>%
    mutate(modSN=iconv(region, from = 'UTF-8', to = 'ASCII//TRANSLIT')) %>%
    mutate(modSN=gsub("region of ","",modSN)) %>%
    mutate(modSN=gsub("Región de ","",modSN)) %>%
    mutate(modSN=gsub(" region","",modSN)) %>%
    mutate(modSN=gsub("region","",modSN)) %>%
    mutate(modSN=gsub("Región","",modSN)) %>%
    mutate(modSN=gsub("Provincia de ","",modSN))  %>%
    mutate(modSN=gsub("Provincia","",modSN))  %>%
    mutate(modSN=gsub("Province","",modSN))  %>%
    mutate(modSN=gsub("Prov.","",modSN))  %>%
    mutate(modSN=gsub("Departamento de ","",modSN))  %>%
    mutate(modSN=gsub("Departamento","",modSN))  %>%
    mutate(modSN=gsub("Départament","",modSN))  %>%
    mutate(modSN=gsub("Departament","",modSN))  %>%
    mutate(modSN=gsub("Comarca","",modSN))  %>%
    mutate(modSN=gsub("Prefecture","",modSN))  %>%
    mutate(modSN=gsub("Governorate","",modSN))  %>%
    mutate(modSN=gsub("County","",modSN))  %>%
    mutate(modSN=gsub("District","",modSN))  %>%
    mutate(modSN=gsub("Raionul","",modSN))  %>%
    mutate(modSN=gsub("raionul","",modSN))  %>%  
    mutate(modSN=gsub("Rajon","",modSN))  %>%  
    mutate(modSN=gsub("Municipality","",modSN))  %>%
    mutate(modSN=gsub("maakond","",modSN))  %>%
    mutate(modSN=gsub("Oblast","",modSN))  %>%
    mutate(modSN=gsub("Parish","",modSN))  %>%
    mutate(modSN=gsub("Canton","",modSN))  %>%
    mutate(modSN=gsub("kraj","",modSN))  %>%
    mutate(modSN=gsub("Voivodeship","",modSN)) %>%
    mutate(modSN=gsub('\\"','',modSN)) %>%
    mutate(modSN=gsub("\\'","",modSN)) %>%
    mutate(modSN=gsub("\\~","",modSN)) %>%
    mutate(modSN=gsub('\\?','',modSN)) %>%
    mutate(modSN=gsub("`","",modSN)) %>%
    mutate(modSN=gsub("  "," ",modSN)) %>%
    mutate(modSN=gsub("-"," ",modSN)) %>%
    mutate(modSN=ifelse(str_detect(modSN, "^[:upper:]+$"),tools::toTitleCase(modSN),modSN)) %>%
    mutate(modSN=trimws(modSN, which = "both"))
  
  
  iso_names <-    iso_codes %>% select(shapeName=name,shapeGroup,english_name) %>%
    mutate(modSN=gsub("region of ","",shapeName)) %>%
    mutate(modSN=gsub("Región de ","",modSN)) %>%
    mutate(modSN=gsub(" region","",modSN)) %>%
    mutate(modSN=gsub("region","",modSN)) %>%
    mutate(modSN=gsub("Región","",modSN)) %>%
    mutate(modSN=gsub("Provincia de ","",modSN))  %>%
    mutate(modSN=gsub("Provincia","",modSN))  %>%
    mutate(modSN=gsub("Province","",modSN))  %>%
    mutate(modSN=gsub("Prov.","",modSN))  %>%
    mutate(modSN=gsub("Departamento de ","",modSN))  %>%
    mutate(modSN=gsub("Departamento","",modSN))  %>%
    mutate(modSN=gsub("Départament","",modSN))  %>%
    mutate(modSN=gsub("Departament","",modSN))  %>%
    mutate(modSN=gsub("Comarca","",modSN))  %>%
    mutate(modSN=gsub("Prefecture","",modSN))  %>%
    mutate(modSN=gsub("Governorate","",modSN))  %>%
    mutate(modSN=gsub("County","",modSN))  %>%
    mutate(modSN=gsub("District","",modSN))  %>%
    mutate(modSN=gsub("Raionul","",modSN))  %>%
    mutate(modSN=gsub("raionul","",modSN))  %>%  
    mutate(modSN=gsub("Rajon","",modSN))  %>%  
    mutate(modSN=gsub("Municipality","",modSN))  %>%
    mutate(modSN=gsub("maakond","",modSN))  %>%
    mutate(modSN=gsub("Oblast","",modSN))  %>%
    mutate(modSN=gsub("Parish","",modSN))  %>%
    mutate(modSN=gsub("Canton","",modSN))  %>%
    mutate(modSN=gsub("kraj","",modSN))  %>%
    mutate(modSN=gsub("Voivodeship","",modSN)) %>%
    mutate(modSN=gsub("-"," ",modSN)) %>%
    mutate(modSN=iconv(modSN, from = 'UTF-8', to = 'ASCII//TRANSLIT')) %>%
    mutate(modSN=gsub('\\"','',modSN)) %>%
    mutate(modSN=gsub("\\'","",modSN)) %>%
    mutate(modSN=gsub("\\~","",modSN)) %>%
    mutate(modSN=gsub('\\?','',modSN)) %>%
    mutate(modSN=gsub("`","",modSN)) %>%
    mutate(modSN=gsub("  "," ",modSN)) %>%
    mutate(modSN=ifelse(str_detect(modSN, "^[:upper:]+$"),tools::toTitleCase(modSN),modSN)) %>%
    mutate(modSN=trimws(modSN, which = "both"))  
  
  iso_names <- unique(iso_names) %>% mutate(isoshapeName=english_name) 
  region_names_c <- regions_hdi_names %>% pull(shapeGroup) %>% unique(.)
  
  region_dict <- tibble(shapeGroup=character(),shapeName=character(),isoshapeName=character())
  

  
    for(i in 1:length(region_names_c)){
      
      iso_names_i <- iso_names %>% filter(shapeGroup==region_names_c[i])
      regions_hdi_names_i <- regions_hdi_names %>% filter(shapeGroup==region_names_c[i])
      
      region_dict_i <-stringdist_join(iso_names_i, 
                                      regions_hdi_names_i, 
                                      by = "modSN",
                                      mode = "left",
                                      ignore_case = FALSE, 
                                      method = "jw", 
                                      max_dist = max_dist_value_iso, 
                                      distance_col = "dist") %>% select(shapeGroup=shapeGroup.x,
                                                                        shapeName=shapeName,isoshapeName,dist)
      
      if(nrow(region_dict_i %>% filter(!is.na(dist)))>0){
        
        region_dict_i <- region_dict_i %>%
          left_join(
            (region_dict_i %>% 
               # filter(!is.na(dist)) %>%
               group_by(shapeGroup,isoshapeName) %>%
               summarise(min_dist=min(dist,na.rm=TRUE)) %>% ungroup()),
            by=c("shapeGroup","isoshapeName")) %>%
          mutate(best_fit=(min_dist==dist)) %>% filter(best_fit) %>%
          select(shapeGroup,shapeName,isoshapeName)
        
        
        region_dict_i <- unique(region_dict_i)
        region_dict <- rbind(region_dict_i,region_dict)
      }
    }
    rm(region_dict_i,i)
 
  
  hdi_subnatmatch<-hdi_subnatmatch %>% left_join((region_dict %>% select(shapeGroup,
                                                                         region=shapeName,
                                                                         isoshapeName)),by=c("region","shapeGroup")) %>%
    mutate(region_orig=region,
           region = ifelse(is.na(isoshapeName),region,isoshapeName))
  
  
  
  ###match with iso
  
  region_names <- as.data.frame(hdi_levelmatch) %>% select(shapeName,shapeGroup) %>%
    mutate(modSN=gsub("region of ","",shapeName)) %>%
    mutate(modSN=gsub("Región de ","",modSN)) %>%
    mutate(modSN=gsub(" region","",modSN)) %>%
    mutate(modSN=gsub("region","",modSN)) %>%
    mutate(modSN=gsub("Región","",modSN)) %>%
    mutate(modSN=gsub("Provincia de ","",modSN))  %>%
    mutate(modSN=gsub("Provincia","",modSN))  %>%
    mutate(modSN=gsub("Province","",modSN))  %>%
    mutate(modSN=gsub("Prov.","",modSN))  %>%
    mutate(modSN=gsub("Departamento de ","",modSN))  %>%
    mutate(modSN=gsub("Departamento","",modSN))  %>%
    mutate(modSN=gsub("Départament","",modSN))  %>%
    mutate(modSN=gsub("Departament","",modSN))  %>%
    mutate(modSN=gsub("Comarca","",modSN))  %>%
    mutate(modSN=gsub("Prefecture","",modSN))  %>%
    mutate(modSN=gsub("Governorate","",modSN))  %>%
    mutate(modSN=gsub("County","",modSN))  %>%
    mutate(modSN=gsub("District","",modSN))  %>%
    mutate(modSN=gsub("Raionul","",modSN))  %>%
    mutate(modSN=gsub("raionul","",modSN))  %>%  
    mutate(modSN=gsub("Rajon","",modSN))  %>%  
    mutate(modSN=gsub("Municipality","",modSN))  %>%
    mutate(modSN=gsub("maakond","",modSN))  %>%
    mutate(modSN=gsub("Oblast","",modSN))  %>%
    mutate(modSN=gsub("Parish","",modSN))  %>%
    mutate(modSN=gsub("Canton","",modSN))  %>%
    mutate(modSN=gsub("kraj","",modSN))  %>%
    mutate(modSN=gsub("Voivodeship","",modSN)) %>%
    mutate(modSN=iconv(modSN, from = 'UTF-8', to = 'ASCII//TRANSLIT')) %>%
    mutate(modSN=gsub("-"," ",modSN)) %>%
    mutate(modSN=gsub('\\"','',modSN)) %>%
    mutate(modSN=gsub("\\'","",modSN)) %>%
    mutate(modSN=gsub("\\~","",modSN)) %>%
    mutate(modSN=gsub('\\?','',modSN)) %>%
    mutate(modSN=gsub("`","",modSN)) %>%
    mutate(modSN=gsub("  "," ",modSN)) %>%
    mutate(modSN=ifelse(str_detect(modSN, "^[:upper:]+$"),tools::toTitleCase(modSN),modSN)) %>%
    mutate(modSN=trimws(modSN, which = "both"))
  
  
  regions_hdi_names <- hdi_subnatmatch %>% select(region,shapeGroup) %>%
    mutate(modSN=iconv(region, from = 'UTF-8', to = 'ASCII//TRANSLIT')) %>%
    mutate(modSN=gsub("region of ","",modSN)) %>%
    mutate(modSN=gsub("Región de ","",modSN)) %>%
    mutate(modSN=gsub(" region","",modSN)) %>%
    mutate(modSN=gsub("region","",modSN)) %>%
    mutate(modSN=gsub("Región","",modSN)) %>%
    mutate(modSN=gsub("Provincia de ","",modSN))  %>%
    mutate(modSN=gsub("Provincia","",modSN))  %>%
    mutate(modSN=gsub("Province","",modSN))  %>%
    mutate(modSN=gsub("Prov.","",modSN))  %>%
    mutate(modSN=gsub("Departamento de ","",modSN))  %>%
    mutate(modSN=gsub("Departamento","",modSN))  %>%
    mutate(modSN=gsub("Départament","",modSN))  %>%
    mutate(modSN=gsub("Departament","",modSN))  %>%
    mutate(modSN=gsub("Comarca","",modSN))  %>%
    mutate(modSN=gsub("Prefecture","",modSN))  %>%
    mutate(modSN=gsub("Governorate","",modSN))  %>%
    mutate(modSN=gsub("County","",modSN))  %>%
    mutate(modSN=gsub("District","",modSN))  %>%
    mutate(modSN=gsub("Raionul","",modSN))  %>%
    mutate(modSN=gsub("raionul","",modSN))  %>%  
    mutate(modSN=gsub("Rajon","",modSN))  %>%  
    mutate(modSN=gsub("Municipality","",modSN))  %>%
    mutate(modSN=gsub("maakond","",modSN))  %>%
    mutate(modSN=gsub("Oblast","",modSN))  %>%
    mutate(modSN=gsub("Parish","",modSN))  %>%
    mutate(modSN=gsub("Canton","",modSN))  %>%
    mutate(modSN=gsub("kraj","",modSN))  %>%
    mutate(modSN=gsub("Voivodeship","",modSN)) %>%
    mutate(modSN=gsub("-"," ",modSN)) %>%
    mutate(modSN=gsub('\\"','',modSN)) %>%
    mutate(modSN=gsub("\\'","",modSN)) %>%
    mutate(modSN=gsub("\\~","",modSN)) %>%
    mutate(modSN=gsub('\\?','',modSN)) %>%
    mutate(modSN=gsub("`","",modSN)) %>%
    mutate(modSN=gsub("  "," ",modSN)) %>%
    mutate(modSN=ifelse(str_detect(modSN, "^[:upper:]+$"),tools::toTitleCase(modSN),modSN)) %>%
    mutate(modSN=trimws(modSN, which = "both"),
           modSN=modSN)
  
  
  region_names_c <- regions_hdi_names %>% pull(shapeGroup) %>% unique(.)
  
  region_dict <- tibble(shapeGroup=character(),shapeName=character(),region=character())
  

    for(i in 1:length(region_names_c)){
      
      region_names_i <- region_names %>% filter(shapeGroup==region_names_c[i])
      regions_hdi_names_i <- regions_hdi_names %>% filter(shapeGroup==region_names_c[i])
      
      region_dict_i <-stringdist_join(regions_hdi_names_i,
                                      region_names_i, 
                                      by = "modSN",
                                      mode = "left",
                                      ignore_case = FALSE, 
                                      method = "jw", 
                                      max_dist = max_dist_value, 
                                      distance_col = "dist") %>% select(shapeGroup=shapeGroup.x,shapeName,region,dist)
      
      region_dict_i <- region_dict_i %>%
        left_join(
          (region_dict_i %>% 
             #filter(!is.na(dist)) %>%
             group_by(shapeGroup,region) %>%
             summarise(min_dist=min(dist,na.rm=TRUE)) %>% ungroup()),
          by=c("shapeGroup","region")) %>%
        mutate(best_fit=(min_dist==dist)) %>% filter(best_fit) %>%
        select(shapeGroup,shapeName,region)
      
      region_dict <- rbind(region_dict_i,region_dict)
    }
    rm(i)

    region_dict <- region_dict %>% unique(.)
  hdi_subnatmatch <- hdi_subnatmatch %>% left_join(region_dict,by=c("region","shapeGroup"))
  
  hdi_subnatmatch <- hdi_subnatmatch %>% filter(!is.na(shapeName))
  
  if(nrow(hdi_subnatmatch)>0){
  processed <-  hdi_levelmatch %>% 
    inner_join(hdi_subnatmatch, by=c("shapeName","shapeGroup")) %>%
    filter(!is.na(hdi)) %>%
    mutate(level=level.x) %>%
    select(source_id,shapeName,shapeID,region,region_orig,shapeGroup,hdi,continent,healthindex,incindex,  
           edindex, lifexp, gnic, esch, msch, pop,level,Group,subnat_group) %>% 
    mutate(label=paste(shapeGroup," - " ,shapeName,": ",hdi,sep=""),
           label2=paste(shapeGroup, region_orig,sep=" - "),
           matching_method="name")
  
  raster::crs(processed) <- "+proj=lcc +lat_1=48 +lat_2=33 +lon_0=-100 +datum=WGS84"
  processed
  }
}