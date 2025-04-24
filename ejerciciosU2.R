# ejercicio 1
# Descargar los 4 archivos referentes a la venta de cómics en una sucursal de la ciudad de
# Buenos Aires: venta_comics_Q{n}. Importar los archivos en R y generar un único conjunto 
# de datos con todos los registros, que contenga como primera columna el trimestre (Q1, Q2, Q3, Q4) 
# y luego las columnas originales. Exportarlo en formato CSV.

library(tidyverse)

setwd("")

comic1 <- read_csv('Documents/LabDatos/unidad2/ventas_comics_Q1.csv') 
# %>%
#   mutate(Trimestre = "Q1")
comic2 <- read.csv('Documents/LabDatos/unidad2/ventas_comics_Q2.csv', sep="\t", dec = ",")

library(readxl)
comic3 <- read_excel("Documents/LabDatos/unidad2/ventas_comics_Q3.xlsx", range = "C4:E19")
comic4 <- read_csv('Documents/LabDatos/unidad2/ventas_comics_Q4.csv')

# renombramos las columnas de comic4 con los de las columnas comic1
colnames(comic4) <- colnames(comic1)

#juntamos todos los datasets en uno
comics <- rbind(comic1, comic2, comic3, comic4)

# con peso le creo una nueva columna, hago un range de un vector con los valores "q1", repito 15 veces cada uno
comics$trimestre <- rep(c("q1", "q2", "q3", "q4"), each = 15)

# mover primera la columna trimestre
comics <- comics %>% relocate(trimestre,.before = mes)

# 
# ####
# prueba <- paste0("a", 1:4)
# prueba


view(comics)

