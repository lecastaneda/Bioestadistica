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
Usando la librería [dplyr](https://dplyr.tidyverse.org/) podemos generar rápidamente tablas de resumen con distintos estadígrafos según lo indiquemos
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
Usando la librería [ggplot2](https://ggplot2.tidyverse.org/) podemos generar un gráfico de caja-bigote de la variable respuesta en función de los niveles del factor Antibiótico
```
library(ggpubr)
ggboxplot(data1, x="Antibiotico", y="Tiempo.h", color="Antibiotico")
```
### Supuestos del análisis de una vía
1. Normalidad
```
shapiro.test(data1$Tiempo.h)
plot1 <- gghistogram(data1$Tiempo.h, bins=10, title="Histograma datos crudos", fill="blue", add="mean")
plot1
plot2 <- ggqqplot(data1$Tiempo.h, col="blue", main="QQplot datos crudos")
plot2
```
Observamos que la distribución de la variable respuesta está sesgada hacia la izquierda. Esto es ratificado por el resultado de la prueba de Shapiro-Wilks, la cual rechaza la hipótesis nula de normalidad. Sin embargo, los datos observados se distribuyen según lo esperado.

Probemos ahora transformando los datos a logaritmo de 10 (log10).
```
shapiro.test(log10(data1$Tiempo.h))
plot3 <- gghistogram(log10(data1$Tiempo.h), bins=10, title="Histograma datos crudos", fill="red", add="mean")
plot3
plot4 <- ggqqplot(log10(data1$Tiempo.h), col="red", main="Histograma datos transformados")
plot4

ggarrange(plot1, plot2, plot3, plot4, labels=c("A","B","C","D"), ncol=2, nrow=2)
```
2. Homocedasticidad
Pondremos a prueba la homocedasticidad de los dos pruebas: Fligner y Levene (para correr Levene se necesita el paquete car).
```
fligner.test(Tiempo.h ~ Antibiotico, data=data1)
leveneTest(Tiempo.h ~ Antibiotico, data=data1)

fligner.test(log10(Tiempo.h) ~ Antibiotico, data=data1)
leveneTest(log10(Tiempo.h) ~ Antibiotico, data=data1)
```
3.





