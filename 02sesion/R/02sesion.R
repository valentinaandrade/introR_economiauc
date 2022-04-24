# Sesión 2: Transformar y seleccionar variables ----------------------


# 0. Instalar paquetes ----------------------------------------------------

pacman::p_load(tidyverse, #Universo de librerías para manipular datos
               haven, #Para cargar datos
               dplyr,#Para manipular datos 
               sjmisc,#Para explorar datos
               magrittr, #Para el operador pipeline (%>%)
               forcats,  #para recodificación junto a car
               car) 

# 1. Importar datos -------------------------------------------------------

# En este práctico, se trabajó con la Encuesta Financiera de hogares del año 2017

datos <- read_dta("input/data/EFH2017_base_imputada.dta") 

# 2. Operadores relacionales -------------------------------------------------

# Se usan para hacer comparaciones. Cuando en la *Tabla 1* nos referimos a `un valor`, esto refiere tambien a `variables`
# 
#   | Símbolo  | Función |
#   |---------:|:--------|
#   | `<`      |  Un valor es menor que otro |
#   | `>`      |  Un valor es mayor que otro |
#   | `==`     |  Un valor es igual que otro [^1] |
#   | `<=`     |  Un valor es menor o igual que otro |
#   | `>=`     |  Un valor es mayor o igual que otro |
#   | `!=`     |  Un valor es distinto o diferente que otro|
#   | `%in%`   |  Un valor pertenece al conjunto designado [^2] |
#   | `is.na()`|  El valor es perdido o `NA` |
#   | `!is.na()`| El valor es distinto de  `NA` |


# 3. Operadores aritméticos -----------------------------------------------

# Realizan operaciones, como la suma, resta, división, entre otros.
# 
#   | Símbolo  | Función |
#   |---------:|:--------|
#   | `+`      |  Suma |
#   | `-`      |  Resta|
#   | `*`     |  Multiplicación |
#   | `/`     |  División |
#   | `^`     |  Elevado |

# 4. Operadores de asignación ---------------------------------------------


# Hay dos formas de asignar `objetoA <- objetoB` o `objetoA = objetoB`. Ambas 
# implican que lo que se este realizando en el *objetoB* implica que eso va a 
# producir o generar al *objetoA*


# 5. Operadores booleanos -------------------------------------------------

# Describen relaciones **lógicas** o **condicionales**
# 
# | Símbolo  | Función |
# |---------:|:--------|
# | `&`      |  Indica un *y* lógico |
# | `|`      |  Indica un *o* lógico |
# | `xor()`  |  Excluye la condición  |
# | `!`      |  Distinto de ... |
# | `any`    |  Ninguna de las condiciones serán utilizadas |
# | `all`    |  Todas las condiciones serán ocupadas |


# 6. Operador pipeline (%>%) ----------------------------------------------

# ¡Aquí mucha atención! Este operador `%>%` (llamado `pipe`) no es un operador que este contenido en las funciones base del lenguaje R. Este operador proviene de la función `magrittr` de `tidyverse`, y es de los operadores más útiles y utilizados en R.
# 
# ¿Para qué sirve? Para concatenar múltiples funciones y procesos. *Imagina que quieres filtrar una base de datos a partir de tramos etarios. Pero no tienes esa variable creada. ¿Que hacer? La respuesta: concatenar el proceso de creación de variables y luego filtrar.* Eso se puede hacer gracias a ` %>% ` (ya mostraremos como utilizar esta herramienta), que por lo demás es muy fácil de ejecutar.
# 
# - `Ctrl + shift + M` Para Windows
# - `⌘ + shift + M` Para Mac


# 7. Transformación de variables ---------------------------------------------

## 7.1. Seleccionar variables ------------------------------------

### Con dplyr ---------------------------------------------------------------

### Selección por nombre de columna

# select(datos, variable1, variable2, variable3) #Incluir variables
# select(datos, -variable1) 
# Para excluir una variable, anteponer un signo menos (-)

### Selección por indexación

select(datos, 1, 2) # la primera y la segunda columna

select(datos, 1:4) # la primera hasta la cuarta columna

select(datos, c(1, 4, 5)) # la primera, la cuarta y la quinta columna columna

### Selección renombrando

select(datos, edad_ent, neduc_ent, genero_ent, ocup_ent) 

select(datos, edad_ent, nivel_educacional=neduc_ent, genero_ent, ocup_ent)  #Renombrarmos

### Para reordenar variables
# Empleamos el argumento everything() para agregar todo el resto de variables.
# El data frame creado ordenará las variables según se asigne con select.

select(datos, id, genero_ent, edad_ent, everything())

### Con patrones de texto

# - `starts_with()`: prefijo 
# - `ends_with() `:  sufijo
# - `contains()` : contiene una cadena de texto literal
# - `matches()` : coincide con una expresión regular

select(datos, starts_with("a"), ends_with("otro"))

# También se pueden combinar con operadores logicos

select(datos, starts_with("f")&ends_with("ent")) 
select(datos, contains("a")|contains("ent"))
select(datos, matches("_a|_ent"))

### Con condiciones lógicas

select(datos, where(is.numeric))

## 7.2. Selección de variables para el ejercicio ---------------------------

# Seleccionamos las siguientes variables
# - `edad`
# - `sexo`
# - `prevision_ent`: tipo de prevision
# - `numh`: número de personas en el hogar
# - `ytoth`: ingresos totales del hogar
# - `ocup_ent`: ocupación
# - `habah_m`: Monto ahorrado
# - `d_toth`: Monto de la deuda total del hogar

datos_proc <- select(datos, id, edad_ent, genero_ent, prevision = 91, ocup_ent, numh,
                     starts_with("yt")& matches("total|hog"),
                     ytoth, ahorro=habah_m, d_toth, t_dtoth, factor)


## 7.3. Filtrar datos  -----------------------------------------

### Con dplyr ---------------------------------------------------------------

# filter(datos, condicion-para-filtrar)
# Esta condición para filtrar podría ser, por ejemplo
# variable1 >= 3

### a) Con números

filter(datos_proc, edad_ent >= 30)
filter(datos_proc, edad_ent >= 15 & numh < 5)


### b) Con caracteres

datos_proc$genero_ent <- as_factor(datos_proc$genero_ent)

filter(datos_proc, genero_ent == "Mujer")
filter(datos_proc, genero_ent != "Hombre")

#### Dos condiciones con caracter

datos_proc$prev <- as_factor(datos_proc$prevision)

filter(datos_proc, prev %in% c("IPS (ex INP), CANAEMPU, EMPART, SSS", "CAPREDENA, DIPRECA") & edad_ent >= 65)

# 8. Tratamiento de casos perdidos -------------------------------------------

## Revisar valores == NA

is.na(datos_proc) #Revisamos si hay casos perdidos en el total del set de datos 
is.na(datos_proc$ytoth) #Revisamos si hay casos perdidos en Ingresos per cápita

## Contar cuántos NA hay en df

sum(is.na(datos_proc)) #Contamos los valores nulos del set de datos en general, que suman un total de 180.148
sum(is.na(datos_proc$ytoth)) #Contaremos los valores nulos de la variable Ingresos per cápita, que alcanzan un total de 98


## Eliminar NA

nrow(datos_proc)
datos_proc <- na.omit(datos_proc) #Eliminamos las filas con casos perdidos
nrow(datos_proc) #La nueva base de datos tiene 5.387 filas y 4 columnas


# 9. Resumen de procesamiento ------------------------------------------------

datos_proc %>% 
  filter(edad_ent >= 20 & numh <7) %>%
  select(id, edad_ent, genero_ent, prevision, ocup_ent, numh,
         starts_with("yt")& matches("total|hog"),
         ytoth, ahorro, d_toth, t_dtoth, factor) %>% 
  na.omit()

datos_proc <- datos_proc %>% 
  filter(edad_ent >= 20 & numh <7) %>%
  select(id, edad_ent, genero_ent, prevision, ocup_ent, numh,
         starts_with("yt")& matches("total|hog"),
         ytoth, ahorro, d_toth, t_dtoth, factor) %>% 
  na.omit()

sjPlot::view_df(datos_proc)


# 10. Unir datos ----------------------------------------------------------

## Crear sets de prueba

proc_1 <- datos_proc %>% select(id, genero_ent, ocup_ent, ytoth)
proc_1 <- proc_1[1:67555,] #Seleccionamos la mitad de las filas
proc_2 <- datos_proc %>% select(id, genero_ent, ocup_ent, ytoth)
proc_2 <- proc_2[67555:135109,] #Seleccionamos la mitad de las filas

### merge() -----------------------------------------------------------------

merge <- merge(proc_1, proc_2, #Especificamos data frames a unificar
               by = c("id", "genero_ent"), #Especificamos la variable a partir de la cual se realiza la unificación (puede ser más de una, como folio y sexo)
               all = T) #Especificamos que queremos mantener total de filas, sumando las de x (proc_1) e y (proc_2)

head(merge)

### bind_cols() -------------------------------------------------------------

bind_columnas <- bind_cols(proc_1, proc_2)

head(bind_columnas)

### bind_rows() -------------------------------------------------------------

bind_filas <- bind_rows(proc_1, proc_2)

head(bind_filas)


# 11 Transformación de variables ---------------------------------------------


## a) Cálculo --------------------------------------------------------------

mutate(datos_proc, nueva_variable = 3+2)
mutate(datos_proc, nueva_variable = 3+2,
       ingreso_percapita = ytoth/numh)


## b) recode() ----------------------------------------------------------------------

## dplyr
datos_proc %>% 
  mutate(sexo = dplyr::recode(genero_ent, "Mujer" = "Femenino", "Hombre" = "Masculino"))

## car::recode()

datos_proc %$% 
  car::recode(.$prevision, '9=NA')

datos_proc %>% 
  mutate(sexo = car::recode(.$genero_ent, c('"Mujer"="Femenino";"Hombre"= "Masculino"'), 
                            as.factor = T, # Transformar en factor
                            levels = c("Masculino", "Femenino"))) #Ordenamos los niveles del factor


## c) ifelse() -----------------------------------------------------------

datos_proc %>% 
  mutate(prevision= ifelse(prevision == 1, 1, 0))

datos_proc %>% 
  mutate(prevision= ifelse(prevision == 1 & genero_ent == 'Mujer', 1, 0))

datos_proc %>% 
  mutate(validador_ingreso = ifelse(is.na(ytoth), FALSE, TRUE))

## d) case_when() --------------------------------------------------------

datos_proc %>% 
  mutate(edad_tramo = case_when(edad_ent <=39 ~  "Joven",
                                edad_ent > 39 & edad_ent <=59 ~ "Adulto",
                                edad_ent > 59 ~ "Adulto mayor",
                                TRUE ~ NA_character_)) %>% 
  select(edad_ent, edad_tramo)


datos_proc %>% 
  mutate(sexo_edad_tramo = case_when(genero_ent == "Hombre" & edad_ent <=39 ~  "Hombre joven",
                                     genero_ent == "Mujer" & edad_ent <=39 ~  "Mujer joven",
                                     genero_ent == 'Hombre' & (edad_ent > 39 & edad_ent <=59) ~ "Hombre adulto",
                                     genero_ent == 'Mujer' & (edad_ent > 39 & edad_ent <=59) ~ "Mujer adulta",
                                     genero_ent == 'Hombre' & edad_ent > 59 ~ "Adulto mayor",
                                     genero_ent == 'Mujer' & edad_ent > 59 ~ "Adulta mayor",
                                     TRUE ~ NA_character_)) %>% 
  select(genero_ent, edad_ent, sexo_edad_tramo)


## rowwise() para trabajar por filas ---------------------------------------

datos_proc %>% #Especificamos que trabajaremos con el dataframe datos
  rowwise() %>% #Especificamos que agruparemos por filas
  mutate(ing_pc = ytoth/numh) %>% #Creamos una nueva variable llamada ing_tot, sumando los valores de ss_t, svar_t y reg_t para cada fila 
  ungroup() # Desagrupamos (dejamos de trabajar en razón de filas)


# 12. mutate_at() -------------------------------------------------------------

## Con mutate()

datos_proc %>% 
  mutate(ocup_ent = as.numeric(.$ocup_ent),
         prevision = as.numeric(.$prevision)) %>% 
  mutate(ocup_ent = car::recode(.$ocup_ent, c("1 = 'Si'; 0 = 'No'"), as.factor = T),
         prevision = car::recode(.$prevision, c("c(1,2,3,4) = 'Si'; 5 = 'No'"), as.factor = T))

# Con mutate_at()

datos_proc %>% 
  mutate_at(vars(ocup_ent, t_dtoth), ~(as.numeric(.))) %>% 
  mutate_at(vars(ocup_ent, t_dtoth), ~(car::recode(., c("1 = 'Si'; 0 = 'No'"), as.factor = T)))

# 13. mutate_if() -------------------------------------------------------------

datos_proc %>% 
  mutate_if(is.labelled, ~(forcats::as_factor(.)))

# 14. mutate_all() ------------------------------------------------------------

datos_proc %>% 
  mutate_all(~(as.character(.)))

# 15. Resumen --------------------------------------------------------------

### Revisamos antes de modificar
datos_proc %>% 
  mutate(genero_ent = car::recode(.$genero_ent, c('"Mujer"="Femenino";"Hombre"= "Masculino"'), 
                            as.factor = T, # Transformar en factor
                            levels = c("Masculino", "Femenino")),
         deuda_d= ifelse(t_dtoth == 1 & genero_ent == 'Mujer', 1, 0),
         sexo_edad_tramo = case_when(genero_ent == "Masculino" & edad_ent <=39 ~  "Hombre joven",
                                     genero_ent == "Femenino" & edad_ent <=39 ~  "Mujer joven",
                                     genero_ent == 'Masculino' & (edad_ent > 39 & edad_ent <=59) ~ "Hombre adulto",
                                     genero_ent == 'Femenino' & (edad_ent > 39 & edad_ent <=59) ~ "Mujer adulta",
                                     genero_ent == 'Masculino' & edad_ent > 59 ~ "Adulto mayor",
                                     genero_ent == 'Femenino' & edad_ent > 59 ~ "Adulta mayor",
                                     TRUE ~ NA_character_)) %>% 
  mutate_if(is.labelled, ~(forcats::as_factor(.))) %>% 
  rowwise() %>% 
  mutate(ing_pc = ytoth/numh) %>%  
  ungroup() 

### Modificamos

datos_proc <- datos_proc %>% 
  mutate(genero_ent = car::recode(.$genero_ent, c('"Mujer"="Femenino";"Hombre"= "Masculino"'), 
                                  as.factor = T, # Transformar en factor
                                  levels = c("Masculino", "Femenino")),
         deuda_d= ifelse(t_dtoth == 1 & genero_ent == 'Mujer', 1, 0),
         sexo_edad_tramo = case_when(genero_ent == "Masculino" & edad_ent <=39 ~  "Hombre joven",
                                     genero_ent == "Femenino" & edad_ent <=39 ~  "Mujer joven",
                                     genero_ent == 'Masculino' & (edad_ent > 39 & edad_ent <=59) ~ "Hombre adulto",
                                     genero_ent == 'Femenino' & (edad_ent > 39 & edad_ent <=59) ~ "Mujer adulta",
                                     genero_ent == 'Masculino' & edad_ent > 59 ~ "Adulto mayor",
                                     genero_ent == 'Femenino' & edad_ent > 59 ~ "Adulta mayor",
                                     TRUE ~ NA_character_)) %>% 
  mutate_if(is.labelled, ~(forcats::as_factor(.))) %>% 
  rowwise() %>% 
  mutate(ing_pc = ytoth/numh) %>%  
  ungroup() 


# 16. Exportamos los datos ----------------------------------------------------

saveRDS(datos_proc, file = "output/data/datos_proc.rds")

