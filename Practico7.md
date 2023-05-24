# Práctico 7: Análisis multivariado (parte II)

En este práctico veremos:

## Contenido

1. [Análisis de componentes principales (PCA)](https://github.com/lecastaneda/Bioestadistica/edit/main/Practico6.md#1-an%C3%A1lisis-de-componentes-principales-pca)
2. [Escalamiento multidimensional (MDS)](https://github.com/lecastaneda/Bioestadistica/edit/main/Practico6.md#2-escalamiento-multidimensional-mds)
3. [Análisis de conglomerados (Clusters)](https://github.com/lecastaneda/Bioestadistica/edit/main/Practico6.md#3-an%C3%A1lisis-de-conglomerados-clusters)

---
## 1. Análisis de componentes principales (PCA)

Descargar los datos contenidos en el archivo de texto [Phylum](https://github.com/lecastaneda/Bioestadistica/blob/main/DSdata_phylum.txt)

Este set de datos contiene las abundancias (realtivas y absolutas) de bacterias asociadas al intestito de <i>Drosophila subobscura</i> a nivel taxonómico de phylum.

1. Analizamos las correlaciones entre variables
```
library(ggpubr)
library(rstatix)


data1 <- read.table("DSdata_phylum.txt", header=T)
head(data1)
dim(data1)
#
## Seleccionamos las columnas con las abundancias absolutas
data2 <- data1[,c(11:15)]
cor.mat <- data2 %>% cor_mat()
cor.mat
cor.mat %>% cor_get_pval()
cor.mat %>% cor_mark_significant()
```

2. Realizamos el PCA
```
pca <- prcomp(data2, sacale=F)  # scale=F porque las variables están en las unidades
summary(pca)
plot(pca)   # Grafica la varianza explicada por cada PCs
biplot(pca) # Gráfico básico de los vectores asociados las variables respuesta y la ubicación espacial de las muestras
```

3. Obtenemos las coordenadas de cada muestra en términos de los componentes principales (PCs)
```
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
```

4. Graficar
```
## Opción 1
biplot(pca,col="purple",las=1,cex=1)
#
## Opción 2
biplot(pca,col=c("white","purple"),xlim=c(-0.5,0.5),ylim=c(-0.5,0.5),las=1,cex=1)
#
## Opción 3
otu$Sex
col <- c(rep("red",18),rep("blue",20))
biplot(pca,col=c("white","purple"),xlim=c(-0.5,0.5),ylim=c(-0.5,0.5),las=1,cex=1)
par(new=T)
plot(PC1,PC2,pch=21,bg=col,cex=1.5,bty="o")   # Valores de los ejes duplicados
#
## Opción 4
range(PC1)
range(PC2)
biplot(pca, col=c("white","purple"), cex=1,xlim=c(-0.4,0.4))
par(new=T)
plot(PC1, PC2, pch=21, bg=col, cex=1.5, bty="o", las=1, xlim=c(-26000,20000), ylim=c(-15000,21000),xaxt="n",yaxt="n")
```

---
## 2. Escalamiento multidimensional (MDS)

Descargar los datos contenidos en el archivo de texto [Otus](https://github.com/lecastaneda/Bioestadistica/blob/main/otu_table.txt)

Este set de datos contiene las abundancias absolutas de bacterias asociadas al intestito de <i>Drosophila subobscura</i> a nivel de OTU.

1. Cargamos y realizamos el MDS
```
library(vegan)
library(ggplot2)
library(ggpubr)
library(MASS)

otu <- read.table("otu_table.txt", header=T)
head(otu)
#
## Removemos las columnas categóricas
mat.otu <- otu[,-c(1:3),]
#
# Realizamos el MDS
distancia <- vegdist(mat.otu, method="bray")
mds <- metaMDS(distancia)
```

2. Graficamos
```
## Obtenemos las coordenadas del MDS
scores(mds, display="sites")
#
## Creamos un dataframe nuevo
data.scores <- as.data.frame(scores(mds, display="sites"))
data.scores$sex <- otu$Sex
data.scores$stress <- otu$Stress
#
ggscatter(data.scores, x="NMDS1", y="NMDS2", color="blue", size=3)
ggscatter(data.scores, x="NMDS1", y="NMDS2", color="sex", size=3)
ggscatter(data.scores, x="NMDS1", y="NMDS2", color="stress", size=3)
ggscatter(data.scores, x="NMDS1", y="NMDS2", color="sex", shape="stress", size=3)
```

3. Realizamos un análisis de PERMANOVA sobre las matrices de distancia entre las muestras
```
distancia <- vegdist(mat.otu, method="bray")
adonis2(distancia ~ otu$Sex)
adonis2(distancia ~ otu$Stress)
adonis2(distancia ~ otu$Sex*otu$Stress)
```

---
## 3. Análisis de conglomerados (Clusters)

Descargar los datos contenidos en el archivo de texto [Otus](https://github.com/lecastaneda/Bioestadistica/blob/main/otu_table.txt)

Este set de datos contiene las abundancias absolutas de bacterias asociadas al intestito de <i>Drosophila subobscura</i> a nivel de OTU.

1. Cargamos y realizamos el análisis
```
library(ape)
otu <- read.table("otu_table.txt", header=T)
head(otu)
#
## Removemos las columnas categóricas
mat.otu <- otu[,-c(1:3),]
#
## Calculamos las distancias entre muestras...
distancia <- dist(mat.otu, method="euclidean")
## ... y el método de jerarquización
clust <- hclust(distancia, method="average")
```

2. Graficamos
```
# Opción 1
plot(clust, hang=-1)
#
## Opción 2
plot(as.phylo(clust),type="phylogram",cex=0.8,tip.col=c(rep(c("blue","red"),18)),font=2,main="Similitud entre muestras")
legend(1000,30,pt.bg=c("blue","red"),c("Machos","Hembras"),pch=21,bty="n")
#
## Opción 3
t1 <- scale(mat.otu)
heatmap(t1, xlab="OTUs", ylab="Muestras", RowSideColors=rep(c("blue","red"),18))
```
