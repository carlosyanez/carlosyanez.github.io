###########################################################################################
######### Get data from Servel.cl                                           ###############
###########################################################################################

library(tidyverse)
library(readxl)
library(rvest)


#' Retrieve data from Servel's historic results by polling station (Excel files)
#' @param  url URL where elections results are stored (e.g. https://www.servel.cl/resultados-definitivos-elecciones-presidencial-parlamentaria-cores-2017/ )
#' @param categories List types of election, using name file e.g. c("PRESIDENCIAL_Tricel_1v","SENADORES_Tricel") )
#' @param (optional) name of RDS file to save results
#' @return list containing tibbles with each category of results - must be assigned to a variable (using invisible)
servel_historic <- function(url,categories,filename=1){
  
  # get webpage
  resultados.lista <- url %>% read_html() 
  
  #get all relevant xlsx files
  
  file.list <-  tibble(link=(resultados.lista %>% html_nodes("a") %>%
                               html_attr("href") %>%unlist())) %>%
    filter(grepl("xlsx",link))
  
  #download all files and save into list
  
  tempxlsx <-"temp.xlsx"
  results <-list()
  for (i in 1:length(categories)) {
    
    filtered.flist <- file.list %>% filter(grepl(categories[i],link)) %>% pull()
    
    download.file(filtered.flist[1],tempxlsx)
    data <- read_excel(tempxlsx)
    
    if(length(filtered.flist)>1){
      for(j in 2:length(filtered.flist)){
        download.file(filtered.flist[j],tempxlsx)
        data_j <- read_excel(tempxlsx)
        data <- rbind(data,data_j)
      }
    }
    results[[i]] <-data
  }
  names(results) <- categories
  
  #clean up
  rm(data,data_j)
  unlink(tempxlsx)
  
  #save into RDS file
  if(typeof(filename)=="character")
  saveRDS(results,filename) 
  
  invisible(results)
  
}