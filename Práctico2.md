# Práctico 2: Comparación de múltiples grupos

En este práctico realizaremos diversos análisis de comparación de múltiples grupos en R. Primero, realizaremos análisis de un factor (ANOVA paramétrico y Kruskal-Wallis no paramétrico). Luego, realizaremos un diseño factorial de dos vías (ANOVA de dos vías). Para finalmente, mostrar algunos ejemplos de diseños anidados y de medidas repeticas

---

## Contenido

1. [Análisis paramétrico de una vía](https://github.com/lecastaneda/Bioestadistica/blob/main/Pr%C3%A1ctico2.md#1-an%C3%A1lisis-param%C3%A9trico-de-una-v%C3%ADa)
2. [Análisis no-paramétrico de una vía](https://github.com/lecastaneda/Bioestadistica/blob/main/Pr%C3%A1ctico2.md#2-an%C3%A1lisis-no-param%C3%A9trico-de-una-v%C3%ADa)
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
#
data1$Antibiotico <- as.factor(data1$Antibiotico)
str(data1)
```

Usando la librería [dplyr](https://dplyr.tidyverse.org/) podemos generar rápidamente tablas de resumen con distintos estadígrafos según lo indiquemos

```
library(dplyr)
#
## Creamos una tabla que nos entregue el tamaño muestreal, la media, la desviación estándar (DE),
## y el error estándar (EE) para cada uno de los antibióticos en estudio
#
tabla1 <- group_by(data1, Antibiotico) %>%
  summarise(muestras=n(),
            media=mean(Tiempo.h, na.rm=T),
            DE=sd(Tiempo.h, na.rm=T),
            EE=DE/sqrt(muestras))
tabla1
```

Usando la librería [ggplot2](https://ggplot2.tidyverse.org/) podemos generar un gráfico de caja-bigote de la variable respuesta en función de los niveles del factor Antibiótico

```
library(ggpubr)
ggboxplot(data1, x="Antibiotico", y="Tiempo.h", color="Antibiotico")
```

### Supuestos del análisis de una vía

**1. Normalidad**

Ponemos a prueba la normalidad de los datos con la prueba de Shapiro-Wilks. Además observamos la normalidad de los datos con un histograma y un qqplot.
```
shapiro.test(data1$Tiempo.h)
plot1 <- gghistogram(data1$Tiempo.h, bins=10, title="Histograma datos originales", fill="blue", add="mean")
plot1
plot2 <- ggqqplot(data1$Tiempo.h, col="blue", main="QQplot datos originales")
plot2
```
Observamos que la distribución de la variable respuesta está sesgada hacia la izquierda. Esto es ratificado por el resultado de la prueba de Shapiro-Wilks, la cual rechaza la hipótesis nula de normalidad. Sin embargo, los datos observados se distribuyen según lo esperado.

Probemos ahora transformando los datos a logaritmo de 10 (log10).
```
shapiro.test(log10(data1$Tiempo.h))
plot3 <- gghistogram(log10(data1$Tiempo.h), bins=10, title="Histograma datos transformados", fill="red", add="mean")
plot3
plot4 <- ggqqplot(log10(data1$Tiempo.h), col="red", main="Histograma datos transformados")
plot4

ggarrange(plot1, plot2, plot3, plot4, labels=c("A","B","C","D"), ncol=2, nrow=2)
```
**2. Homocedasticidad**

Pondremos a prueba la homocedasticidad de los dos pruebas: Fligner y Levene (para correr Levene se necesita el paquete car).
```
# Datos originales
fligner.test(Tiempo.h ~ Antibiotico, data=data1)
leveneTest(Tiempo.h ~ Antibiotico, data=data1)

fligner.test(log10(Tiempo.h) ~ Antibiotico, data=data1)
leveneTest(log10(Tiempo.h) ~ Antibiotico, data=data1)
```
**3. Análisis de una vía (ANOVA)**

Dado que nuestros datos cumplen con los supuestos de normalidad y homocedasticidad, podemos realizar un análisis de una vía. Para estos hay dos formas: utilizando el comando aov o el comando lm. Ambas opciones entregan el mismo resultado.
```
## Comando aov
test0 <- aov(log10(Tiempo.h) ~ Antibiotico, data=data1)
anova(test0)
#
## Comando lm
test1 <- lm(log10(Tiempo.h) ~ Antibiotico, data=data1)
anova(test1)
summary(test1)
#
## Graficar los residuales del modelo también nos permite saber si se cumple con el supusto de normalidad
plot5 <- ggqqplot(test1$residuals, col="red", main="Histograma residuales datos transformados")
plot5
```

¿Qué hubiese pasado si hubiesemo realizado el ANOVA si haber transformado los datos?
```
test2 <- lm(Tiempo.h ~ Antibiotico, data=data1)
anova(test2)
summary(test2)
plot6 <-  ggqqplot(test2$residuals, col="blue", main="Histograma residuales datos transformados")
plot6

ggarrange(plot5, plot6, labels=c("A","B"), ncol=2, nrow=1)
```

Independiente si analizamos los datos originles o transformados (log10), podemos concluir que hay diferencias significativas en el tiempo de respuesta de los antibióticos. Sin emabrgo, no podemos saber (aún) si todos los antibióticos tienen una respuesta distinta entre ellos o solo algunos de ellos difieren.

**4. Comparaciones múltiple**

Para esto, vamos a realizar dos pruebas a posterior: una comparación múltiple a través de la prueba de significancia honesta de Tukey (Tukey HSD), y varias pruebas pareadas corregidas por Bonferroni
```
library(rstatix)
test1 %>% tukey_hsd() # Prueba de Tukey para los datos transformados
test2 %>% tukey_hsd() # Prueba de Tukey para los datos originales
#
## Crearemos una nueva variable llamada "log10.tiempo"
data1$log10.tiempo <- log10(data1$Tiempo.h) 
data1 %>% t_test(log10.tiempo ~ Antibiotico) %>% adjust_pvalue(method="bonferroni")
```

**5. Grafiquemos!!**

A. Gráfico de caja-bigote (boxplot)
```
plot7<- ggboxplot(data1, x="Antibiotico", y="Tiempo.h", fill="Antibiotico", 
                  xlab="Antibióticos", ylab="Tiempo respuesta (h)",
                  legend="none")
plot7
```

B. Gráfico de violín
```
plot8<- ggviolin(data1, x="Antibiotico", y="Tiempo.h", fill="Antibiotico", 
                  add="jitter",
                  xlab="Antibióticos", ylab="Tiempo respuesta (h)",
                  legend="none")+
  stat_summary(fun=mean, show.legend=F, geom="crossbar", position=position_dodge(width=0.5), width=0.5) 
plot8
```

C. Gráfico de disperción unidimensional (stripchart)
```
plot9 <- data1 %>%
  ggplot(aes(y=Tiempo.h, x=Antibiotico, fill=Antibiotico)) +
  geom_jitter(show.legend=F, shape=21, color="black", size=4, 
              position=position_jitterdodge(jitter.width=0.3, dodge.width=0.8)) +
  stat_summary(fun=mean, show.legend=F, geom="crossbar", position=position_dodge(width=0.8), width=0.55) + 
  labs(x="Antibióticos", y="Tiempo de respuesta (h)")+
  theme_classic()+
  theme(axis.text = element_text(size=10, color="black"),
        axis.title = element_text(size=13))
plot9
```

Miremos ahora todos juntos
```
ggarrange(plot7, plot8, plot9, labels=c("A","B","C"), ncol=3, nrow=1)
```

De los tres gráficos, el gráfico de violín es el más informativo porque muestra las medias, el rango de datos, la disperción univariada de estos, y su distribución.

Ahora agreguemos los resultados de las comparaciones múltiples en el gráfico de violín
```
tukey.test1 <- data1 %>% tukey_hsd(log10.tiempo ~Antibiotico)
tukey.test1
#
## Opción con símbolos
plot8 + stat_pvalue_manual(tukey.test1,label="p.adj.signif",tip.length = 0.02, y.position=c(130,140,120))
#
## Opción con los valores exactos
plot8 + stat_pvalue_manual(tukey.test1,label="p.adj",tip.length = 0.02, y.position=c(130,140,120))
#
#
tabla1
plot8 + stat_pvalue_manual(tukey.test1,label="p.adj",tip.length = 0.02, y.position=c(130,140,120))+
```

**6. Análisis de poder**
```
## Miremos la tabla de ANOVA
anova(test1)
#
## Calcular el poder estadístico del diseño (probabilidad de aceptar H1 cuando es veradadera)
power.anova.test(groups=3,  n=9, between.var= 1204, within.var=268, sig.level=0.05)
#
## Calcular el número mñinimo de replicar para lograr un poder de 1
power.anova.test(groups=3, power=0.999, between.var=1204, within.var=268.4, sig.level=0.05)
```

---
## 2. Análisis no-paramétrico de una vía

Descargar los datos contenidos en el archivo Excel [Notas](https://github.com/lecastaneda/Bioestadistica/blob/main/notas_pregrado.txt)

Este set datos corresponde a las notas obtenidas durante cuatro años consecutivos para una asignatura de pregrado de la Facultad de Medicina. ¿Hay diferencias en las notas obtenidas para las distintas generaciones?

```
## Cargar los datos
data2 <- read.table("Notas_pregrado.txt", header=T)
data2 <- na.omit(data2)
head(data2)
View(data2)
str(data2)
#
## Asignar a la columna "year" (año) como factor
data2$year <- as.factor(data2$year)
str(data2)
```

Realizar un gráfico de caja-bigotes para ver de forma general los datos
```
library(ggpubr)
ggboxplot(data2, x="year", y="score", color="year")
#
## Se pueden observar outliers en algunos años. Estos tienen valores menores a 3, ¿quienes son?
which(data2$score<3)
#
## Procedemos a eliminarlos
data2a <- data2[-c(277,540),]
```

Creamos una tabla que nos entregue el tamaño muestreal, la media, la desviación estándar (DE), el error estándar (EE), y los valores míminos y máximos para cada uno de los años
```
tabla2 <- group_by(data2a, year) %>%
  summarise(muestras=n(),
            media=mean(score, na.rm=T),
            DE=sd(score, na.rm=T),
            EE=DE/sqrt(muestras),
            min=min(score),
            max=max(score))
tabla2
```

Probamos la normalidad para los datos con y sin outliers. Además probamos la homocedasticidad.
```
## Normalidad
shapiro.test(data2$score)
plot1 <- gghistogram(data2$score, bins=10, title="Histograma datos con outliers", fill="blue", add="mean")
plot1
plot2 <- ggqqplot(data2$score, col="blue", main="QQplot datos con outliers")
plot2
#
shapiro.test(data2a$score)
plot3 <- gghistogram(data2a$score, bins=10, title="Histograma datos sin outlier", fill="red", add="mean")
plot3
plot4 <- ggqqplot(data2a$score, col="red", main="Histograma datos sin outlier")
plot4
#
ggarrange(plot1, plot2, plot3, plot4, labels=c("A","B","C","D"), ncol=2, nrow=2)
#
## Homocedasticidad
fligner.test(score ~ year, data=data2a)
```

Claramente los datos no se adjustan a una distribución normal por lo que debemos utilizar un análisis no paramétrico, a pesar que el supuesto de homocedasticidad si se cumple.
```
kt <- kruskal.test(score~year, data=data2a)
```
Vamos a agregar una función con la cual si la prueba de Kruskal-Walis resulta significativa (p<0.05), automáticamente se prodecerá a realizar una prueba por parejas corregida por el método de la tasa de descubrimiento falsa (FDR)
```
if(kt$p.value < 0.05){
  pt.fdr <- pairwise.wilcox.test(data2a$score, g=data2a$year,
                             p.adjust.method="fdr")
}
kt;pt.BH;pt.fdr
```

Dado que los datos no son normales, la mejor opción de graficarlos es con un gráfico de caja-bigote.
```
plot10<- ggboxplot(data2a, x="year", y="score", fill="year", 
                  xlab="Año", ylab="Notas finales",
                  add="jitter", ylim=c(3.8,7.6), legend="none")
plot10 
```

Ahora incluiremos los resultados de las comparaciones múltiples en el gráfico
```
post.fdr <- data2a %>% wilcox_test(score ~ year) %>% adjust_pvalue(method="fdr")
post.fdr

plot10 + stat_pvalue_manual(post.fdr,label="p.adj.signif",tip.length = 0.02, 
                            y.position=c(6.7,7.5,7.7,7,7.2,6.8))
```
                       







