# Sesión 1: Importar, seleccionar y exportar datos ----------------------

# 0. Instalar paquetes ----------------------------------------------------

pacman::p_load(sjmisc, #utilizado para la exploración de datos
               sjPlot, #para la visualización
               tidyverse, #colección de paquetes, del cuál utilizaremos `dplyr` y `haven`
               haven, #cargar y exportar bases de datos en formatos .sav y .dta
               readxl, #para cargar y exportar bases de datos en formato .xlsx y .xls
               writexl)#para cargar y exportar bases de datos en formato .xlsx y .xls


# 1. Importar datos -------------------------------------------------------

# En esta sesión, se trabajará con los datos del la Encuesta nacional de empleo de Diciembre - Enero y Febrero del 2022.

datos <- read_sav("input/data/ENE DEF 2022 SPSS.sav")

## 1.1. Importar datos en diversos formatos --------------------------------

## a) .RData y .rds

load(file = "input/data/ENE.RData")

readRDS(file = "input/data/ENE.rds")

datos <- readRDS(file = "input/data/ENE.rds")


## b) .dta

datos <- read_dta("input/data/ENE DEF 2022 STATA.dta") #¡Hay un error! ¿por qué se da? 

# repasemos los tres elementos en la importación de datos 
# 1. Extesion --> funcion voy a ocupar
# 2. Nombre del archivo
# 3. Ruta

## c) .csv

datos <- read.csv("input/data/ene-2022-01-def.csv", 
                  sep=",",  #Nuevamente hay un error. Veamos porqué usemos el "Help"
                  encoding = "UTF-8", 
                  stringsAsFactors = F)

datos <- read.csv("input/data/ene-2022-01-def.csv",
                  sep=";", #separador de variables
                  encoding = "Latin-1", 
                  stringsAsFactors = F, 
                  na.strings = c("No sabe", NA)) #argumento que designa los valores que deben interpretarse como valores perdidos

## d) .xlsx

datos <- readxl::read_excel(path = "input/data/ENE.xlsx")

datos <- readxl::read_excel(path = "input/data/ENE.xlsx", 
                            sheet = "Hoja2",  #especificamos que hoja debe leer
                            skip = 1) #especificamos qué celda debe saltarse

datos <- readxl::read_excel(path = "input/data/ENE.xlsx", 
                            sheet = "Hoja2", skip = 1, 
                            na = "No sabe")

##BONUS

#Formas de importación

## Mediante URL

# Para esto debemos ir a la página del INE 
# https://www.ine.cl/estadisticas/sociales/mercado-laboral/ocupacion-y-desocupacion

# Podemos hacerlo con el argumento 'url()', copiando la dirección de enlace 
# de los datos a descargar. Es necesario recordar la función según el tipo 
# de formato a descargar

# csv

datos_csv <- read.csv(url("https://www.ine.cl/docs/default-source/ocupacion-y-desocupacion/bbdd/2022/csv/ene-2022-01-def.csv?sfvrsn=b3f59312_4&download=true"), 
                      sep=";") 

# .dta

datos_stata <- read_dta(url("https://www.ine.cl/docs/default-source/ocupacion-y-desocupacion/bbdd/2022/stata/ene-2022-01-def.dta?sfvrsn=54a26f0d_5&download=true"))

# .sav
datos_spss <- read_sav(url("https://www.ine.cl/docs/default-source/ocupacion-y-desocupacion/bbdd/2022/spss/ene-2022-01-def.sav?sfvrsn=57e83ef8_4&download=true"))

## GitHub

# Para la descarga de datos desde GitHub hay que tener en consideración un 
# argumento del link. En la sección donde diga "blob", este siempre debe ser 
# cambiado a "raw"

# Para este ejercicio utilizaremos los datos obtenidos del 
# Ministerio de Ciencia y producidos por el Ministerio de Salud 
# https://github.com/MinCiencia/Datos-COVID19 

# .csv
minsal_csv <- read.csv(url("https://github.com/MinCiencia/Datos-COVID19/raw/master/output/producto1/Covid-19.csv"), 
                      sep=",", encoding =  "UTF-8") 

# 2. Explorar datos ------------------------------------------------

#Para la exploración de datos volveremos a cargar los datos en formato .sav
datos <- read_sav("input/data/ENE DEF 2022 SPSS.sav")

View(datos) # Ver datos
names(datos) # Nombre de columnas
dim(datos) # Dimensiones
head(datos, 5) #un tibble con las observaciones
str(datos) # Estructura de los datos (las clases y categorías de repuesta)

sjPlot::view_df(datos)

find_var(datos, "ocupacion")
find_var(datos, "horas")

frq(datos$categoria_ocupacion)
frq(datos$c2_1_3) #¡Qué feo!

descr(datos$c2_1_3)

#### Sobre las clases de las variables

class(datos$categoria_ocupacion)

# 3. Selección de datos ----------------------------------------------------

datos_proc <- select(datos, id_identificacion, region, sexo, categoria_ocupacion, cine, a6_otro, c2_1_3)

# 4. Guardar y exportar datos ---------------------------------------------

save(datos_proc, file = "output/data/datos_proc.RData") #Guardamos el objeto datos_proc en la ruta de trabajo actual, bajo el nombre de datos_proc.RData. 

saveRDS(datos_proc, file= "output/data/datos_proc.rds") #Guardamos el objeto datos_proc en la ruta de trabajo actual, bajo el nombre de datos_proc.rds. 

write_sav(datos_proc, "output/data/datos_proc.sav") #Guardamos el objeto datos_proc en la ruta de trabajo actual, bajo el nombre de datos_proc.sav.

write_dta(datos_proc, "output/data/datos_proc.dta") #Guardamos el objeto datos_proc en la ruta de trabajo actual, bajo el nombre de datos_proc.dta.

write.csv(datos_proc, "output/data/datos_proc.csv") #Guardamos el objeto datos_proc en la ruta de trabajo actual, bajo el nombre de datos_proc.csv. 

writexl::write_xlsx(datos_proc, "output/data/datos_proc.xlsx") #Guardamos el objeto datos_proc en la ruta de trabajo actual, bajo el nombre de datos_proc.xlsx. 


