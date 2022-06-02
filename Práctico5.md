# Práctico 5: Análisis multivariado (parte I)

En este realizaremos diversos análisis multivariados en R. Primero realizaremos un análisis multivariado de varianza (MANOVA) y luego un análisis de componentes principales (PCA):

---

## Contenido

1. [Análisis de varianza múltivariado](https://github.com/lecastaneda/Bioestadistica/edit/main/Pr%C3%A1ctico5.md#1-an%C3%A1lisis-de-varianza-multivariado-manova)
2. [Análisis de componentes principales](https://github.com/lecastaneda/Bioestadistica/blob/main/Pr%C3%A1ctico5.md#2-an%C3%A1lisis-de-componentes-principales)

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
str(data1)
data1$site <- as.factor(data1$site)

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
aggregate(data1[,c(3,4,5,8,9)],list(data1$site),mean)
aggregate(data1[,c(3,4,5,8,9)],list(data1$site),sd)
aggregate(data1[,c(3,4,5,8,9)],list(data1$site),length)
#
## Evaluar la normalidad multivariada
library(MVN)
mvn(data1[,c(3,4,5,8,9)],mvnTest="hz")
#
## Evaluar la homogeneidad de varianzas
library(car)
leveneTest(data1$pH ~data1$site)
leveneTest(data1$C ~data1$site)
leveneTest(data1$N ~data1$site)
leveneTest(data1$P ~data1$site)
leveneTest(data1$K ~data1$site)
#
## Evaluar presencia de outliers
mahalanobis_distance(data = data1[, c("pH","C","N","P","K")])$is.outlier
#
## Realizar el MANOVA
m0 <- manova(cbind(pH,C,N,P,K) ~ site, data=data1)
anova(m0, test="Wilks")
#
## Cálcular el tamaño del efecto
library(effectsize)
eta_squared(m0)
#
## Revisar los resultados del ANOVA para cada variable
summary.aov(m0)
# ó
m1 <- aov(data1$pH ~data1$site); anova(m1)
m2 <- aov(data1$C ~data1$site); anova(m2)
m3 <- aov(data1$N ~data1$site); anova(m3)
m4 <- aov(data1$P ~data1$site); anova(m4)
m5 <- aov(data1$K ~data1$site); anova(m5)
#
## Realizar las pruebas a posteriori
post.m1 <- TukeyHSD(m1); plot(post.m1)
post.m2 <- TukeyHSD(m1); plot(post.m2)
post.m3 <- TukeyHSD(m1); plot(post.m3)
post.m5 <- TukeyHSD(m1); plot(post.m5)
```

Gráfiquemos una de las variables: pH
```
plot1 <- ggboxplot(data1, x="site", y="pH", col="black", ylab="pH", xlab="Sitios", add="jitter")
plot1
#

## Establecer posiciones de las líneas
## Pero primero ordenaremos los sitios de mayor a menor para
## favorecer la estética del gráfico
data1$site <- factor(data1$site, levels=c("Neltume","Huillilemu","Catanli","LasPalmas","Pelchuquin"))
#
## Volvemos a gráficas
plot1 <- ggboxplot(data1, x="site", y="pH", col="black", ylab="pH", xlab="Sitios", add="jitter")
plot1
#
## Realizamos la prueba a posteriori
test1 <- data1 %>% t_test(pH~site) %>% add_significance() %>% adjust_pvalue(method="fdr")
test1
## Agragamos las posiciones en el y donde queremos que vayan las líneas de significancia
test1a <- test1 %>% add_xy_position(x="site",dodge=0.8) %>% 
  mutate(y.position=c(7.1,6.95,6.8,6.65,6.5,6.35,6.2,6.05,5.9,5.6))
test1a
#
## Gráfico final
plot1 + stat_pvalue_manual(test1a,label="p.adj.signif",tip.length = 0.01)
# 
## Este gráfico tiene todas las significancias entre pares de sitios,
## pero se ve muy saturado, así que dejaremos solo las comparaciones significativas
## Para esto, reemplazamos las líneas que no queremos cono NAs
test1b <- test1 %>% add_xy_position(x="site",dodge=0.8) %>% 
  mutate(y.position=c(NA,NA,6.8,6.65,NA,NA,NA,NA,NA,NA))
test1b
#
## Gráfico final v2
plot1+stat_pvalue_manual(test1b,label="p.adj.signif",tip.length = 0.01)

```

---
## 2. Análisis de componentes principales

Usaremos el mismo set de datos deascargado anteriormente.

```
data1 <- read.table("Suelos.txt", header=T)
head(data1)
data2 <- data1[,-c(1,2)]
cor.mat <- data2 %>% cor_mat()
cor.mat
cor.mat %>% cor_get_pval()
cor.mat %>% cor_mark_significant()

## Realizar el PCA
pca <- prcomp(data1, scale=T)  # scale=T porque las variables están en distintas unidades
summary(pca)
plot(pca)   # Grafica la varianza explicada por cada PCs
biplot(pca) # Gráfico básico de los vectores asociados las variables respuesta y la ubicación espacial de las muestras

## Obtener información del PCA
names(pca)
pca$sdev # sd (varianza) explicada por cada PC
pca$rotation  # contribución de cada variable a cada PC
pca$center   # valor usado para centrar (media)
pca$scale  # valor usado para escalar (sd)
pca$x   # coordenadas para cada muestra
#
## Crear dos variables (PC1 y PC2) para graficar las muestras en el gráfico del PCA
PC1 <- pca$x[,1]
PC2 <- pca$x[,2]

## Grafiquemos nuevamente, pero ahora solo los vectores
biplot(pca,col="purple",xlim=c(-0.5,0.5),ylim=c(-0.5,0.5),las=1,cex=1)  ### ????
biplot(pca,col=c("white","purple"),xlim=c(-0.5,0.5),ylim=c(-0.5,0.5),las=1,cex=1)
#
## Agreguemos las muestras sobre el mismo gráfico, pero en vez de números graficaremos puntos de colores
col <- c(rep("red",3),rep("blue",3),rep("black",3),rep("green",3),rep("orange",3))
par(new=T)
plot(PC1,PC2,pch=21,bg=col,cex=1.5,bty="o")   # Valores de los ejes duplicados
#
plot(PC1, PC2, pch=21, bg=col, cex=1.5, bty="o", las=1, xlim=c(-5,5), ylim=c(-3,3))
par(new=T)
biplot(pca, col=c("white","purple"), cex=1,xaxt="n",yaxt="n")
legend(2.5,-2, c("Catanli","Huillilemu","LasPalmas","Neltume","Pelchuquín"), bty="n", pch=21, cex=1, pt.bg=c("red","blue","black","green","orange"), y.intersp=0.2)
```

Análicemos cómo varía PC1 entre los distintos sitios

```
data$PC1 <- PC1   # Agregar la variable PC1 al dataset "data"
shapiro.test(data$PC1)  # Prubea de normalidad
ggqqplot(data$PC1)
leveneTest(data$PC1 ~ data$site)  # Prueba de homocedasticidad
#
## ANOVA usando el PC1
test3 <- aov(PC1 ~ site, data=data)
anova(test3)    # Resultado
TukeyHSD(test3) # Comparación a posteriori
```

Grafiquemos!

```
ggboxplot(data, x="site", y="PC1", col="black", ylab="PC1", xlab="Sitios", add="jitter")
#
## Reordenar grupos, graficar y agregar símbolos de significancia
data$site <- factor(data$site, levels=c("LasPalmas","Pelchuquin","Neltume","Catanli","Huillilemu"))
plot2 <- ggboxplot(data, x="site", y="PC1", col="black", ylab="PC1", xlab="Sitios", add="jitter")
plot2
plot2 + stat_pvalue_manual(tukey.test,label="p.adj.signif",tip.length = 0.02, 
                            y.position=c(NA,NA,4.8,5.4,NA,3.6,4.2,NA,NA,NA))
```
