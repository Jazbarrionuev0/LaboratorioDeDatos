### Diapo 7

# Instalamos el paquete tidyverse

# install.packages('tidyverse')

# y lo cargamos

library(tidyverse)
## Importar archivos .csv

# Leemos el archivo .csv y vemos la información que nos da y las opciones

experimento1 <- read_csv('Documents/LabDatos/experimento.csv')

# De esta forma eliminamos la información extra que nos da sobre los tipos de columnas

experimento1 <- read_csv('Documents/LabDatos/experimento.csv',show_col_types = FALSE)

# Si queremos ver las especificaciones de cada una de las columnas

spec(experimento1)

# Veamos que tiene el conjunto de datos, también podemos verlo en forma completa si clickeamos el objeto en la pestaña Environment

experimento1

# Veamos un mayor número de filas

print(experimento1,n=20)

## Algunas cuestiones prácticas

# Vemos que hay un dato que es N/A en Sexo al nacer y otro dato perdido (NA) en Edad en años cumplidos
# NA significa Not Available y es la forma que tiene R para indicarnos que ese dato no está disponible. La idea sería que N/A también esté 
# dispuesto de esa forma, lo hacemos con la opción na, indicando todo lo que nosotros queremos que sea considerado NA (probar que pasa si no indicamos "")

experimento1 <- read_csv('Documents/LabDatos/experimento.csv',na = c("N/A",""))

# Nombres de variables

# Vemos que los nombres de variables estan encerradas en comillas invertidas. Eso sucede porque hay espacios en blanco en los nombres. 
# Trabajar de esta forma puede resultar engorroso, con lo cual es conveniente renombrar las variables

# Primera forma

experimento1 %>%  
  rename(
    edad = `Edad en años cumplidos`,
    sexo = `Sexo al nacer`
  )

# que es %>% ? Se llama pipa, podemos ver que también está |>, para ver las diferencias entre ambas (https://www.tidyverse.org/blog/2023/04/base-vs-magrittr-pipe/#-vs)
# Lo que hace es aplicar lo que está a la derecha al objeto que está a la izquierda, o sea, x  %>% f(y) es equivalente a f(x, y)

# Segunda forma

experimento1 %>% janitor::clean_names()

### Diapo 8

## Importar archivos Excel

# Necesitamos cargar el paquete readxl, que se instala cuando instalamos tidyverse, pero que no lo carga cuando cargamos este último

library(readxl)

# Tenemos funciones para leer archivos xls (read_xls), xlsx (read_xlsx) o que detecte la versión que tenemos (read_excel)

experimento1 <- read_excel("Documents/LabDatos/experimento.xlsx")

# Vayamos a los problemas que vimos antes

# Dato N/A que queremos que lo lea como NA

experimento1 <- read_excel("Documents/LabDatos/experimento.xlsx",na = c("", "N/A"))

# Nombres de variables 

# Se los podemos indicar como opción dentro de la misma función, pero veamos que pasa (ver el objeto experimento1 una vez importado)

experimento1 <- read_excel("U2/Experimento 1 (respuestas).xlsx",
                           na = c("", "N/A"),
                           col_names = c('fecha','edad','sexo')) 

# Los nombres de las columnas que estaban en la primera fila los tomó como datos, para evitar esto usamos la opción skip y el número de fila

experimento1 <- read_excel("U2/Experimento 1 (respuestas).xlsx",
                           na = c("", "N/A"),
                           col_names = c('fecha','edad','sexo'),
                           skip = 1) 

# El archivo experimento.xlsx tiene 3 hojas de las cuales queremos importar los datos de los que dijeron ser masculinos

# Primer intento...funciona?

experimento <- read_excel("Documents/LabDatos/experimento.xlsx")

# Podemos usar una función para ver que hojas contiene el archivo

excel_sheets("Documents/LabDatos/experimento.xlsx")

# Segundo intento (dos variantes con el mismo resultado)

experimento <- read_excel("Documents/LabDatos/experimento.xlsx",sheet = "Varones")
experimento
experimento <- read_excel("Documents/LabDatos/experimento.xlsx",sheet = 3)

# Tercer intento 

experimento <- read_excel("Documents/LabDatos/experimento.xlsx",sheet = "Varones", range = "A1:C54")

### Diapo 9

# Necesitamos cargar el paquete googlesheets4, que se instala cuando instalamos tidyverse, pero que no lo carga cuando cargamos este último

library(googlesheets4)

### Diapo 10

# Vamos a trabajar con el objeto experimento que contiene sólo los varones

## Exportar a .csv

# Para escribir un tibble a un archivo .csv usamos la función write_csv donde especificamos cual es el objeto que queremos exportar
# Tengo que tener cuidado con el directorio donde quiero escribir el archivo, lo puedo especificar en la misma función

write_csv(experimento,"Documents/LabDatos/solovarones.csv")

## Exportar a Excel

# Para exportar a Excel debemos cargar el paquete writexl que nos permite realizar esa acción usando la función write_xlsx
# El paquete es bastante limitado y no permite por ejemplo, agregar hojas a una planilla ya existente u otras opciones de estilo
# Una solución alternativa es el uso del paquete openxlsx que posee más opciones

library(writexl)

write_xlsx(experimento,"U2/solo varores.xlsx")

## Exportar a Google Sheets

# Usando la función gs4_create del paquete googlesheets4 podemos crear un Google Sheets a partir del objeto experimento

ss <- gs4_create("solo varones",sheets = experimento)

# Podemos agregar una hoja a la planilla ya creada, por ejemplo, una que contenga todas las respuestas

sheet_write(experimento1, ss = ss, sheet = "todos")

# La siguiente función me permite ver qué hojas tengo en mi planilla

sheet_properties(ss)

# Y con la siguiente función puedo ver la planilla creada en un navegador

gs4_browse(ss)

# Y si lo quiero borrar?

gs4_find("solo varones") %>%
  googledrive::drive_trash()

### 13

# Paquete nycflights13: An R data package containing all out-bound flights from NYC in 2013 + useful metdata.

install.packages('nycflights13')
library(nycflights13)

flights %>%
  filter(dest == "MIA") %>% 
  group_by(year, month, day) %>%
  summarize(
    arr_delay = mean(arr_delay, na.rm = TRUE)
  )

# Probemos ahora sin group_by: me devuelve un valor, no la tabla

flights %>%
  filter(dest == "MIA") %>% 
  summarize(
    media_delay = mean(arr_delay, na.rm = TRUE) #calculo la media del delay en arribos
  )

# Y si quiero asignarlo a un objeto?

vuelos <- flights %>%
  filter(dest == "IAH") %>% 
  group_by(year, month, day) %>%
  summarize( 
    arr_delay = mean(arr_delay, na.rm = TRUE)
  )
view(vuelos)
#### 14

# Trabajemos con el conjunto de datos del experimento1

experimento1 <- read_csv('Documents/LabDatos/experimento.csv',na = c("N/A","")) 


experimento1 <- experimento1 %>%  
  rename(
    edad = `Edad en años cumplidos`,
    sexo = `Sexo al nacer`
  )

experimento1

### Filas

## filter: filtra filas basado en los valores de las columnas

# El primer argumento es el data frame, los siguientes son las condiciones que se deben cumplir para conservar la fila

# Por ejemplo, queremos todos los registros que correspondan a mujeres

experimento1 %>% filter(sexo=='Femenino')

# Para que sea distinto utilizamos !=

# Actividad 1

  # Como hacemos para seleccionar aquellos que tengan 40 años y más? Tengo que obtener un tibble de 7 registros
experimento1 %>% filter(edad >= 40)

# Si queremos seleccionar aquellos con edades 17 o 18, lo podemos hacer como hicieron la última actidad o con %in%

experimento1 %>% filter(edad %in% c(17,18))

# Actidad 2

# Y si quiero todos menos los que tienen 17 o 18? Tengo que obtener un tibble de 68 registros
experimento1 %>% filter(!(edad %in% c(17,18)))

# Si quiero modificar o guardar el resultado del filtro en ese u otro objeto, tengo que utilizar el operador asignación <-, por ejemplo

prueba <- experimento1 %>% filter(edad %in% c(17,18))


## arrange: ES UN SORT

# Por ejemplo, queremos ordenar el conjunto de acuerdo a la edad

experimento1 %>% arrange(edad) 
experimento1 %>% arrange(sexo,edad)

# Actividad 3

  # Usar la función arrange en dos oportunidades para ordenar experimento1 de tal manera que aparezca la mujer de mayor edad y el varon de mayor edad en el primer registro

## distinct: encuentra todas las filas únicas en un conjunto de datos

experimento1 %>% distinct(edad)

# Y si quisieramos sabe cuantas combinaciones de sexo y edad distintas existen?

experimento1 %>% distinct(sexo,edad)

# Si quiero mantener el resto de las variables utilizo la opción .keep_all=TRUE, si bien lo que hace es traer el dato del primer registro que encuentra, quizás no tenga mucho sentido

experimento1 %>% distinct(sexo,edad,.keep_all=TRUE)

# Y si quiero saber cuantos casos hay de cada combinación? Reemplazamos distinct por count

experimento1 %>% count(sexo,edad)  %>% rename(cuenta=n)

# Actividad 4

  # Hay más mujeres o varones? Usar la función count

  # Basándonos en la cantidad de casos que hay y sin hacer otro tipo de análisis, podrias decir que hay mas jovenes mujeres o varones?

### Columnas

## mutate: agrega columnas nuevas que se calculan de columnas existentes

# Definamos la edad en meses

experimento1 %>% mutate(edad_meses=edad*12)

# Definamos la edad en meses y en dias

experimento1 %>% mutate(edad_meses=edad*12,edad_dias=edad*365)

# Si bien aca no tenemos otra variable numerica, podemos hacer nuevas variables haciendo operaciones entre 2 o más variables

# Por otra parte, existen otros argumentos que me permiten indicar donde ubicar estas nuevas variables que por defecto las agrega a la derecha del data frame

# Estas funciones son: .before y .after, por ejemplo, si quiero que edad en meses la ubique a la derecha de edad

experimento1 %>% mutate(edad_meses=edad*12,.after=edad)

# También puedo indicar cual quiero que mantenga en el tibble usando la opción .keep con algunas de las opciones c("all", "used", "unused", "none")
# Por ejemplo, si quiero quedarme solamente con las utilizadas

experimento1 %>% mutate(edad_meses=edad*12,.keep='used')

# Podemos trabajar con otras variables, por ejemplo, creando una variable logica que nos indique cuando alquien es adulto (edad mayor o igual a 30)

experimento1 %>% mutate(adulto=edad>=30)

# Actividad 5

  # Una empresa desea otorgar becas a aquellas estudiantes adultas, para ello se debe saber cuantas podrían aplicar a la misma. Usar mutate y count


# Algo a tener en cuentas, todas estas variables fueron creadas pero no existen en experimento1, si las quiero mantener las tengo que asignar 
# a un objeto que sea el mismo o uno nuevo (recomendable)

## select: seleccionar columnas de un conjunto de datos

# Existen distintas formas de utilizar esta función, seleccionando directamente los nombres de las variables

experimento1 %>% select(edad, sexo)

# indicando un rango de variables (en este ejemplo no tiene mucho sentido)

experimento1 %>% select(edad:sexo)

# o seleccionando columnas excepto una o más

experimento1 %>% select(!sexo)

# También podemos elegir aquellas que cumplan con una condición, por ejemplo, todas las variables del tipo caracter

experimento1 %>% select(where(is.character))

# Tambien podemos renombrar una variable que seleccionamos

experimento1 %>% select(Sexo_al_nacer=sexo)

# Existen otras funciones que pueden ayudar 

# starts_with("abc"): nombres de variables que comienzan con “abc”.
# ends_with("xyz"): nombres de variables que terminan con “xyz”.
# contains("ijk"): nombres de variables que contienen “ijk”.
# num_range("x", 1:3): nombres iguales a x1, x2 and x3.

## rename: renombrar variables

# Ya vimos que podiamos renombrar una variable cuando la seleccionabamos, pero podemos renombrar sin necesidad de seleccionar

experimento1 %>% rename(Sexo_al_nacer=sexo)

## relocate: mover variables dentro del conjunto de datos

# Por ejemplo, mover la edad y sexo al principio

experimento1 %>% relocate(`Marca temporal`, edad,sexo)

# Existen otras posibilidades diciendo donde queremos ubicarlas utilizando el .before y .alter que usamos con el mutate()

experimento1 %>% relocate(edad,.after = sexo)

experimento1 %>% relocate(sexo,.after = edad)

# Actividad 6

  # Queremos un tibble en el cual nos quedemos con la variable sexo y edad (en ese orden), pero edad medida en meses y sexo renombrada como sexo_al_nacer

### Grupos

## group_by: divide el conjunto de datos en grupos significativos para el análisis

experimento1 %>% group_by(sexo)

# Podemos ver que los datos no cambiaron, pero si nos indica que estan agrupados por sexo (# Groups:   sexo [3]) 
# Esto implica que las funciones que apliquemos a continuación serán realizadas por grupo

## summarize: se utiliza para calcular estadísticas resumen reduciendo el conjunto de datos a una fila para cada grupo

# Esta función sirve para calcular estadísticas simples reduciendo el data frame a una fila por cada grupo
# Por ejemplo, vamos a calcular la edad promedio en cada grupo

experimento1 %>% group_by(sexo) %>% summarise(edad_prom=mean(edad))

# Por qué aparece NA en el promedio para masculino? Porque uno o más datos son NA.
# Una forma de solucionar esto es con una opción de la función mean que permite ignorar los casos NA

experimento1 %>% group_by(sexo) %>% summarise(edad_prom=mean(edad,na.rm=TRUE))

# Recordemos la Actividad 4, son más jóvenes las mujeres o los varones?

# Podemos crear cualquier número de estadísticas en un solo summarise, por ejemplo agreguemos la cantidad de casos

experimento1 %>% group_by(sexo) %>% summarise(edad_prom=mean(edad,na.rm=TRUE),
                                              casos=n())

# Por qué es importante saber la cantidad de casos?

## slice_func(n=1): permite extraer filas específicas dentro de cada grupo, donde func puede ser head, tail, min, max, sample

# Por ejemplo, nos podemos quedar con los 5 estudiantes más grandes

experimento1 %>% slice_max(edad,n=5)

# Por qué obtenemos 7 registros en lugar de 5?

# Si no queremos obtener exactamente 5, debemos utilizar la opción with_ties=FALSE, pero no nos da información de si existe algún otro con esa edad

experimento1 %>% slice_max(edad,n=5,with_ties = FALSE)

# Actividad 7

  # Ahora queremos quedarnos con los estudiantes más grandes de cada sexo

  # Calculemos la edad mínima de cada sexo utilizando la función summarise y la función slice correspondiente, comparando los resultados

## Agrupar por múltiples variables

# Podemos agrupar por más de una variable, volvamos a la Diapo 13 con el data frame flights

library(nycflights13)

flights %>%
  filter(dest == "IAH") %>% 
  group_by(year,month,day) %>%
  summarize(
    arr_delay = mean(arr_delay, na.rm = TRUE)
  )

# Observemos que nos da el siguiente mensaje

# `summarise()` has grouped output by 'year', 'month'. You can override using the `.groups` argument.

# Esto significa que el tibble quedo agrupado por las dos primeras variables, para solucionar esto puedo utilizar la opción .groups con la opción apropiada

prueba1 <- flights %>%
  filter(dest == "IAH") %>% 
  group_by(year,month,day) %>%
  summarize(
    arr_delay = mean(arr_delay, na.rm = TRUE),
    .groups = 'keep'
  )

prueba1

# Ahora vemos que el tibble prueba se encuentra agrupado con las 3 variables indicadas

prueba2 <- flights %>%
  filter(dest == "IAH") %>% 
  group_by(year,month,day) %>%
  summarize(
    arr_delay = mean(arr_delay, na.rm = TRUE),
    .groups = 'keep'
  ) %>% 
  ungroup()

prueba2

## ungroup: elimina un agrupamiento de un data frame

# Veamos esto con un ejemplo, tomemos el tibble prueba1, y queremos calcular el promedio de todas las demoras

prueba1 %>% summarise(mean(arr_delay))

# Que observan?

# Una forma de solucionar esto es eliminando el agrupamiento de este tibble

prueba1 <- prueba1 %>% ungroup()
         
prueba1 %>% summarise(mean(arr_delay))

# Ahora vemos que obtenemos la estadística que queríamos

## .by: permite resultados similares a group_by y ungroup

# Es una opción del summarise que permite agrupar evitando el group y ungroup

prueba3 <- prueba1 %>% summarise(mean(arr_delay),.by = month)

prueb3

# Que tiene de buena esta opción? Que no debemos agrupar (group_by) y desagrupar (ungroup) cuando creamos el tibble

# Y obviamente que podemos indicarle más de una variable utilizando la función c (concatenar)

prueba1 %>% summarise(mean(arr_delay),.by = c(month,day))

### Diapo 16

table1
table2
table3

### Diapo 18

# Actividad 8

  # Calcular la tasa de casos por 10000 usando la tabla 1
  
  # Calcular el total de casos por año
  
  # Ahora pensar como lo harían con table2 y table3


### Diapo 20

billboard

### Diapo 21

# Vamos a utilizar la función pivot_longer
# cols: le indicamos cuales son las columnas que queremos pivotear, o sea, cuales son las columnas que no son variables, usa la misma sintaxis que select()
# names_to: le damos el nombre de la variable donde pondemos las cols
# values_to: le damos el nombre de de la variable que contiene los valores de la celda

billboard %>% 
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week", 
    values_to = "rank"
  )

# Actividad 9

  # Obtener cual fue el mejor puesto de cada una de las canciones

### Diapo 22

# Podemos indicarle que no agregue aquellas filas que sin datos con la opción value_drop_na

billboard  %>%  
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week", 
    values_to = "rank",
    values_drop_na = TRUE
  )

# Actividad 10

  # Qué cambiaría respecto a la actividad 9?


### Diapo 23

# Para convertir los datos de semana a numérico, usamos la función parse_number() que extrae el primer número de una cadena de caracteres

billboard_longer <- billboard  %>%  
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week", 
    values_to = "rank",
    values_drop_na = TRUE
  )  %>%  
  mutate(
    week = parse_number(week)
  )

billboard_longer

# Veamos el siguiente gráfico (que más adelante veremos cómo hacerlo)

billboard_longer %>% 
  ggplot(aes(x = week, y = rank, group = track)) + 
  geom_line(alpha = 0.25) + 
  scale_y_reverse()

# Y ahora veamos que pasa si lo queremos hacer con el conjunto de datos original

billboard %>% 
  ggplot(aes(x = week, y = rank, group = track)) + 
  geom_line(alpha = 0.25) + 
  scale_y_reverse()

### Diapo 24

who2

?who2

### Diapo 25

who2 %>%  
  pivot_longer(
    cols = !(country:year),
    names_to = c("método", "genero", "edad"), 
    names_sep = "_",
    values_to = "casos"
  )

### Diapo 26

household

### Diapo 27

# Utiliza el argumento .value, que no es un nombre de variable, sino que le indica la función pivot_longer de hacer algo distinto
# Esto anula el argumento values_to habitual para utilizar el primer componente del nombre de la columna pivotada como nombre de variable en la salida.
# Cuando se utiliza .value en names_to, los nombres de las columnas en la entrada contribuyen tanto a los valores como a los nombres de las variables en la salida.

household %>%  
  pivot_longer(
    cols = !family, 
    names_to = c(".value", "child"), 
    names_sep = "_", 
    values_drop_na = TRUE
  )

### Diapo 28

cms_patient_experience

### Diapo 29

# pivot_wider() hace lo opuesto a pivot_longer(), en lugar de elegir nuevos nombres de columnas, debemos darle las columnas existentes que 
# definen los valores (values_from) y los nombres de las columnas (names_from)
# Además le indicamos en id_cols cual o cuales son las columnas que tienen valores que identifican de forma única cada fila

cms_patient_experience %>%  
  pivot_wider(
    id_cols = starts_with("org"),
    names_from = measure_cd,
    values_from = prf_rate
  )

# Veamos que pasa si no usamos el id_cols

cms_patient_experience %>%  
  pivot_wider(
    names_from = measure_cd,
    values_from = prf_rate
  )

