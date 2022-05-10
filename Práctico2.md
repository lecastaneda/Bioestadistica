# Práctico 2: Comparación de múltiples grupos

En este práctico realizaremos diversos análisis de comparación de múltiples grupos en R. Primero, realizaremos análisis de un factor (ANOVA paramétrico y Kruskal-Wallis no paramétrico). Luego, realizaremos un diseño factorial de dos vías (ANOVA de dos vías). Para finalmente, mostrar algunos ejemplos de diseños anidados y de medidas repeticas

---

## Contenido

1. [Análisis paramétrico de una vía]
2. [Tablas de contingencia]
3. [Razón de posibilidades (odds ratio)]

---
## 1. Análisis paramétrico de una vía

Descargar los datos contenidos en el archivo Excel [Antibióticos](https://github.com/lecastaneda/Bioestadistica/blob/main/Antibioticos.xlsx)

Este set datos corresponde a un set de datos revisado en clases, en el cual se mide el tiempo (en horas) que tarda en desaparecer un infección después de la administración de tres antibióticos. ¿Hay diferencias en el tiempo de respuesta entre los distintos antibióticos?

```
## cargar la librería readxl que nos permitirá leer archivos Excel
library(readxl)

data1 <- read_xlsx("Antibioticos.xlsx")
head(data1)
View(data1)
str(data1)
#
## Indicamos que la columna llama "Antibiotico" contiene los distinos niveles del factor Antibiótico
data1$Antibiotico <- as.factor(data1$Antibiotico)
str(data1)
```
Usando la librería dplyr podemos generar rápidamente tablas de resumen con distintos estadígrafos según lo indiquemos
```
library(dplyr)
#
## Creamos una tabla que nos entregue el tamaño muestreal, la media, la desviación estándar (DE) y el error estándar (EE) para cada uno de los antibióticos en estudio
group_by(data1, Antibiotico) %>%
  summarise(muestras=n(),
            media=mean(Tiempo.h, na.rm=T),
            DE=sd(Tiempo.h, na.rm=T),
            EE=DE/sqrt(muestras))
```
Usando la librería ggplot2 podemos generar un gráfico de caja-bigote de la variable respuesta en función de los niveles del factor Antibiótico
```
library(ggpubr)
ggboxplot(data1, x="Antibiotico", y="Tiempo.h", color="Antibiotico")
```




