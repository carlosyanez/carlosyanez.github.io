###########################################################################################
######### Data Load for Analysis of 2020 Constittuional Referendum in Chile ###############
###########################################################################################

library(tidyverse)
library(readxl)
library(rvest)

######download income data
#download.file("https://static.datachile.io/datasets/official_ids.zip","ids.zip")
#download.file("https://static.datachile.io/datasets/casen_income_clean_data.zip","casen.zip")

#unzip("casen.zip",files="5_final_tables/comuna_data_all.csv")
#datos_comuna <-read_csv("5_final_tables/comuna_data_all.csv")

#datos_comuna <- datos_comuna %>% group_by(geography_id) %>% filter(year==max(year)) %>% ungroup()

#unique(datos_comuna$geography_id)

source("servel_historic.R")

## Get Referendum data from Github Repo ##

plebiscito2020 <- read_csv("https://raw.githubusercontent.com/carlosyanez/Web-Scraping-Plebiscito/main/datos/DatosPlebiscito.csv")

## Get Historic Results from servel.cl

if(file.exists("elections2017.rds")){
  resultados2017 <- readRDS("elections2017.rds")
}else{
resultados2017 <- servel_historic(url="https://www.servel.cl/resultados-definitivos-elecciones-presidencial-parlamentaria-cores-2017/",
                                  categories=c("DIPUTADOS_Tricel"),
                                  filename = "elections2017.rds")
}
#categories=c("PRESIDENCIAL_Tricel_1v","PRESIDENCIAL_Tricel_2v",
#             "SENADORES_Tricel","DIPUTADOS_Tricel"),

###manually aggregate data
###############
### data from servel.cl does not follow a consistent data dictionary - thus instead of writing a function
### it, will be dealt on ad-hoc basis

resultados2017_analisis <- list()

  
###2017 - Diputados

resultados2017_analisis$partidos<- resultados2017$DIPUTADOS_Tricel %>%
  filter(!is.na(Candidato) & !grepl("TOTALES",Candidato)) %>%
  mutate(Partido=ifelse(is.na(Partido),Candidato,Partido)) %>% 
  group_by(Comuna,Partido) %>% summarise(Votos=sum(`Votos TRICEL`,na.rm=TRUE),
                                         .groups="drop")  %>%
  mutate(
      Comuna = case_when(
      Comuna=="AISEN"               ~  "AYSEN",
      Comuna=="CABO DE HORNOS"      ~ "CABO DE HORNOS(EX-NAVARINO)",
      Comuna=="LLAY-LLAY"            ~ "LLAILLAY",
      Comuna=="O'HIGGINS"           ~ "OHIGGINS",
      Comuna=="TREGUACO"            ~ "TREHUACO",
      TRUE                      ~  Comuna
    ))


resultados2017_analisis$participacion <- resultados2017$DIPUTADOS_Tricel %>%
  select(Comuna,Local,`Mesas Fusionadas`,Electores) %>%
  unique(.) %>%
  group_by(Comuna) %>%
  summarise(Electores=sum(Electores),.groups = "drop") %>%
  mutate(
    Comuna = case_when(
      Comuna=="AISEN"               ~  "AYSEN",
      Comuna=="CABO DE HORNOS"      ~ "CABO DE HORNOS(EX-NAVARINO)",
      Comuna=="LLAY-LLAY"            ~ "LLAILLAY",
      Comuna=="O'HIGGINS"           ~ "OHIGGINS",
      Comuna=="TREGUACO"            ~ "TREHUACO",
      TRUE                      ~  Comuna
    )) %>% left_join(resultados2017_analisis$partidos %>% 
                       group_by(Comuna) %>%
                       summarise(Votos=sum(Votos),.groups="drop"),
                                 by="Comuna") %>%
          mutate(participacion_2017=Votos/Electores)
  


#get list of presidents and party names for manual reconciliation

if(file.exists("partidos_reviewed.csv")){
  partidos <- read_csv("partidos_reviewed.csv")  
  }else{

  partidos2017 <- c(unique(resultados2017_analisis$Senadores$resultados$Partido),
        unique(resultados2017_analisis$Diputados$resultados$Partido))

partidos <- tibble(partido=unique(partidos2017))
partidos <- partidos %>% unique()

write_csv(partidos,"partidos.csv")
}

rm("resultados2017","servel_historic")


#donwload population counts from Censo 2017

#download.file("https://www.censo2017.cl/wp-content/uploads/2017/12/Cantidad-de-Personas-por-Sexo-y-Edad.xlsx",
#              "censo.xlsx")

#pop2017 <- read_xlsx("censo.xlsx",sheet = "COMUNAS",col_types=rep("text",11))
#pop2017<- pop2017 %>% filter(Edad=="Total Comunal") %>%
#          mutate(Comuna=str_remove(`NOMBRE COMUNA`," *"),
#                 Habitantes=as.numeric(TOTAL)) %>%
#         select(Comuna, Habitantes)


            
