

#load from source

if(file.exists("country_shapes.RDS")){
  country_shapes <- readRDS("country_shapes.RDS")
  
}else{
  country_shapes<- readOGR("https://www.geoboundaries.org/data/geoBoundariesCGAZ-3_0_0/ADM0/simplifyRatio_10/geoBoundariesCGAZ_ADM0.topojson",p4s="WS84")
  
  saveRDS(country_shapes,"country_shapes.RDS")
  
}

if(file.exists("region_shapes.RDS") & file.exists("region_shapes2.RDS")){
  region_shapes <- readRDS("region_shapes.RDS")
  region_shapes2 <- readRDS("region_shapes2.RDS")
  
  
}else{
  region_shapes<- readOGR("https://www.geoboundaries.org/data/geoBoundariesCGAZ-3_0_0/ADM1/simplifyRatio_10/geoBoundariesCGAZ_ADM1.topojson",p4s="WS84")
  
  region_shapes2<- readOGR("https://www.geoboundaries.org/data/geoBoundariesCGAZ-3_0_0/ADM2/simplifyRatio_10/geoBoundariesCGAZ_ADM2.topojson",p4s="WS84")
  

  saveRDS(region_shapes,"region_shapes.RDS")
  saveRDS(region_shapes2,"region_shapes2.RDS")
}

if(file.exists("hdi_subnat_polygon.RDS")){
  hdi_subnat_polygon <- readRDS("hdi_subnat_polygon.RDS")
}else{
  
  filename <- "GDL Shapefiles V4"
  
  download.file("https://globaldatalab.org/assets/2020/03/GDL%20Shapefiles%20V4.zip",
                paste(filename,".zip",sep=""))
  unzip(paste(filename,".zip",sep=""),exdir=filename)
  hdi_subnat_polygon <- readOGR( 
    dsn= paste("./",filename,"/",sep=""), 
    layer=filename,
    verbose=FALSE,
    p4s="WS84"
  )
  
  hdi_subnat_polygon <-  hdi_subnat_polygon %>% 
    filter(!(region=="Total")) %>%
    mutate(shapeName=region,shapeGroup=iso_code) %>% 
    select(shapeName,shapeGroup) %>% 
    mutate(shapeGroup=ifelse(shapeGroup=="XKO","XKX",shapeGroup))
  
  
  
  saveRDS(hdi_subnat_polygon,"hdi_subnat_polygon.RDS")
  
  unlink(filename, recursive = TRUE)
  unlink(paste(filename,".zip",sep=""))
  rm(filename)
}

filename <- "GDL-Sub-national-HDI-data2.csv"
url <- "https://globaldatalab.org/assets/2020/03/SHDI%20Complete%204.0%20%281%29.csv"
if(!file.exists(filename)){
  download.file(url,filename)
}
eu_oecd <- read_csv("eu_oecd.csv") %>% mutate(EU_OECD=TRUE)
group_corections <- read_csv("group_corrections.csv") 

hdi_all_historic <- read.csv(filename) %>%
                     mutate(shapeGroup=trimws(iso_code),hdi=shdi) %>% 
                     mutate(source_id = row_number()) %>%
                     select(-iso_code,-GDLCODE,-shdi) %>%
                     mutate(shapeGroup=ifelse(grepl("Taiwan",shapeGroup),"TWN",shapeGroup),
                            country=ifelse(shapeGroup=="TWN","Taiwan",country),
                            continent=ifelse(shapeGroup=="TWN","Taiwan",continent)) %>%
                     mutate(shapeGroup=ifelse(shapeGroup=="XKX","XKO",shapeGroup)) %>%
                    filter(!(shapeGroup=="ATA")) %>%
                    left_join(eu_oecd,by="country") %>%
                    mutate(Group=if_else(EU_OECD,"EU+OECD",continent,missing=continent),
                           hdi_group=cut(hdi, bins,labels=hdi_labels)) %>%
                    left_join(group_corections,by="shapeGroup") %>%
                    mutate(Group=ifelse(is.na(Group_corr),Group,Group_corr),
                           continent=ifelse(is.na(continent_corr),continent,continent_corr),
                           continent=ifelse(continent=="America","Americas",continent),
                           Group=ifelse(Group=="America","Americas",Group),
                           country=ifelse(is.na(country_corr),country,country_corr)) %>%
                    select(-EU_OECD,-Group_corr,-continent_corr,-country_corr) 
  
saveRDS(hdi_all_historic,"hdi_all_historic.RDS")
hdi_all <- hdi_all_historic %>% filter(year==2018) %>%
           select(-year) 

rm(filename,url)

##classify shapes

hdi_nat <- hdi_all %>% filter(level=="National") %>% 
           mutate(nat_group=hdi_group) %>%
           select(-level,-region,-hdi_group)

hdi_nat <-country_shapes %>%
  left_join(hdi_nat, by="shapeGroup") %>% 
  mutate(label=paste(country,hdi,sep=" :"),
         region=country)

hdi_subnat <- hdi_all %>% filter(level=="Subnat") %>%
              mutate(subnat_group=hdi_group) %>%
              select(-level,-country,-hdi_group)

levels <- as.data.frame(hdi_subnat) %>%
  group_by(shapeGroup) %>% summarise(polygon=n())  %>% ungroup()

level1 <- as.data.frame(region_shapes) %>% 
  group_by(shapeGroup) %>%  summarise(polygon1=n())  %>% ungroup() 

level2 <- as.data.frame(region_shapes2) %>% 
  group_by(shapeGroup)  %>%  summarise(polygon2=n())  %>% ungroup() 

levels <-levels %>% left_join(level1,by="shapeGroup") %>%
  left_join(level2,by="shapeGroup") %>%
  mutate(level=ifelse(polygon==1,"0",
                      ifelse(polygon==polygon1,"match",
                             ifelse(polygon<polygon1,"1",
                                    ifelse(polygon==polygon2,"match2","2")
                             ))
  ),
  abs_diff=ifelse(
    level=="1",(polygon1-polygon),
    ifelse(level=="2",(polygon2-polygon),0)
  ),
  perc_diff=ifelse(level %in% c("1","2"),(abs_diff/polygon),0)
  )


rm(level1,level2)

region_shapes <- region_shapes %>% left_join((levels %>% select(shapeGroup,level,abs_diff,perc_diff)),
                                             by="shapeGroup")

region_shapes2 <- region_shapes2 %>% left_join((levels %>% select(shapeGroup,level,abs_diff,perc_diff)),
                                               by="shapeGroup")

hdi_subnat <- hdi_subnat %>% 
  left_join((levels %>% select(shapeGroup,level,abs_diff,perc_diff)),
             by="shapeGroup") 

hdi_subnat_polygon <- hdi_subnat_polygon %>% mutate(label4=paste(gsub("[[:space:]]", "", shapeGroup),
                                                                 "-",
                                                                 gsub("[[:space:]]", "", shapeName)),sep="")
hdi_subnat_match <- hdi_subnat %>% mutate(label4=paste(gsub("[[:space:]]", "", shapeGroup),
                                                       "-",
                                                       gsub("[[:space:]]", "", region)),sep="") %>%
  select(label4,source_id)

hdi_subnat_polygon<- hdi_subnat_polygon %>% left_join(hdi_subnat_match,by="label4") %>% select(-label4)
rm(hdi_subnat_match)
