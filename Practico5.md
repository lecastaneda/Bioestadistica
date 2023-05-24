# Práctico 5: Relación entre variables

## Contenido

1. [Comparación entre grupos]
2. [Análisis de correlación]
3. [Análisis de regresión simple]
4. [Análisis de regresión múltiple]
5. [Análisis de regresión logística]

---
### 1. Comparación entre grupos

Descargar los datos contenidos en el archivo Excel [Resistencia](https://github.com/lecastaneda/Bioestadistica/blob/main/Resistencia.xlsx)

Este set datos corresponde a un experimento para evaluar el efecto de la microbiota intestinal y el sexo sobre la resistencia térmica en *Drosophila melanogaster*. ¿Hay efectos de la microbiota y/o el sexo sobre la resistencia térmica? ¿Estos factores interactúan entre sí?

```
## Cargar la librería para abrir archivos Excel
library(readxl)

## Cargar los datos
data3 <- read_xlsx("Resistencia.xlsx")
head(data3)
str(data3)
#
## Asginar columnas como factores
data3$sex <- as.factor(data3$sex)
data3$treat <- as.factor(data3$treat)
```
