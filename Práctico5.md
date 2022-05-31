# Práctico 5: Análisis multivariado (parte I)

En este realizaremos diversos análisis multivariados en R. Primero realizaremos un análisis multivariado de varianza (MANOVA) y luego un análisis de componentes principales (PCA):

---

## Contenido

1. [Análisis de varianza múltivariado](https://github.com/lecastaneda/Bioestadistica/edit/main/Pr%C3%A1ctico5.md#1-an%C3%A1lisis-de-varianza-multivariado-manova)
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

En el siguiente paso realizaremos un MANOVA, pero solo con un subset de datos. Basándonos en la matriz de correlación, seleccionares las variables pH, cárbono (C), nitrógeno (N), fósforo (P) y potasio (K).

```
head(data)
#
## pH (columna 3), cárbono (columna 4), nitrógeno (columna 5), fósforo (columna 8) y potasio (columna 9).
## Cálculemos el promedio, desviación estándar y número de muestras para cada localidad
round(aggregate(data[,c(3,4,5,8,9)],list(data$site),mean),2)
round(aggregate(data[,c(3,4,5,8,9)],list(data$site),sd),2)
ggregate(data[,c(3,4,5,8,9)],list(data$site),length)
#
## Evaluar la normalidad multivariada
library(MVN)
mvn(data[,c(3,4,5,8,9)],mvnTest="hz")
#
## Evaluar la homogeneidad de varianzas
library(car)
leveneTest(data$pH ~data$site)
leveneTest(data$C ~data$site)
leveneTest(data$N ~data$site)
leveneTest(data$P ~data$site)
leveneTest(data$K ~data$site)
#
## Evaluar presencia de outliers
mahalanobis_distance(data = data[, c("pH","C","N","P","K")])$is.outlier
#
## Realizar el MANOVA
m0 <- manova(cbind(pH,C,N,P,K) ~ site, data=data)
anova(m0, test="Wilks")
#
## Cálcular el tamaño del efecto
library(effectsize)
eta_squared(m0)
#
## Revisar los resultados del ANOVA para cada variable
summary.aov(m0)
# ó
m1 <- aov(data$pH ~data$site); anova(m1)
m2 <- aov(data$C ~data$site); anova(m2)
m3 <- aov(data$N ~data$site); anova(m3)
m4 <- aov(data$P ~data$site); anova(m4)
m5 <- aov(data$K ~data$site); anova(m5)
#
## Realizar las pruebas a posteriori
post.m1 <- TukeyHSD(m1); plot(post.m1)
post.m2 <- TukeyHSD(m1); plot(post.m2)
post.m3 <- TukeyHSD(m1); plot(post.m3)
post.m5 <- TukeyHSD(m1); plot(post.m5)
```

Gráfiquemos una de las variables: pH
```
plot1 <- ggboxplot(data, x="site", y="pH", col="black", ylab="pH", xlab="Sitios", add="jitter")
plot1
#
## Agregar símbolos de la prueba a posteriori
test1 <- data %>% t_test(pH~site) %>% add_significance() %>% adjust_pvalue(method="fdr")
test1
#
## Establecer posiciones de las líneas
test1a <- test1 %>% add_xy_position(x="site",dodge=0.8) %>% 
  mutate(y.position=c(7.1,6.95,6.8,6.65,6.5,6.35,6.2,6.05,5.9,5.6))
test1a
#
## Gráfico final
plot1 + stat_pvalue_manual(test2.2,label="p.adj.signif",tip.length = 0.01)
#
## Gráfico fibal v2
test1b <- test1 %>% add_xy_position(x="site",dodge=0.8) %>% mutate(y.position=c(NA,NA,6.2,6.1,NA,NA,NA,NA,NA,NA))
plot1+stat_pvalue_manual(test1b,label="p.adj.signif",tip.length = 0.01)
```




