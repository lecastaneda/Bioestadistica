# Práctico 2: Comparación de múltiples grupos

En este práctico realizaremos diversos análisis multivariado en R. Primero, realizaremos una análisis de varianza multivariado (MANOVA) y luego, un análisis de componentes principales (PCA).
---

## Contenido

1. [Análisis de varianza múltivariado](https://github.com/lecastaneda/Bioestadistica/blob/main/Pr%C3%A1ctico2.md#1-an%C3%A1lisis-param%C3%A9trico-de-una-v%C3%ADa)
2. [Análisis de componentes principales](https://github.com/lecastaneda/Bioestadistica/blob/main/Pr%C3%A1ctico2.md#2-an%C3%A1lisis-no-param%C3%A9trico-de-una-v%C3%ADa)

---
## 1. Análisis de varianza multivariado (MANOVA)

Descargar los datos contenidos en el archivo de texto [Suelos](https://github.com/lecastaneda/Bioestadistica/blob/main/Suelos.txt)

Este set datos incluye diversas variabiles físico-químicas asociadas a muestras de suelos provenientes de 5 bosques de raulíes en la Región de Los Ríos.
```
## Cargar los siguientes paquetes
library(ggpubr)
library(rstatix)

## cargar los datos
data1 <- read.table("Suelos.txt", header=T)
head(data1)

## Estimar las correlaciones entre todas las variables físico-químicas.
cor(data1)
head(data1)

## Una matriz de correlaciones solo puede obtenerse a partir de variables númericas.
## Por lo tanto debemos excluir las variables agrupadoras
data2 <- data1[,-c(1,2)]
cor(data2)
round(cor(data2),2) # coeficientes de correlación con dos cifras significativas

## Ahora hagamos lo mismo, pero con el paquete rstatix
cor.mat <- data2 %>% cor_mat()
cor.mat
#
# Veamos qué correlaciones son significativas.
cor.mat %>% cor_get_pval()
cor.mat %>% cor_mark_significant()
#
# Grafiquemos la matriz de correlación
cor.mat %>% pull_lower_triangle() %>% cor_plot()
```


