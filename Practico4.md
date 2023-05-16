# Práctico 4: Diseños factoriales

## Contenido

1. [Diseño ortgonal](https://github.com/lecastaneda/Bioestadistica/blob/main/Practico4.md#1-an%C3%A1lisis-ortgonal)
2. [Diseño de medidas repetidas)

---
### 1. Análisis ortgonal

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

Estimar las media, desviación estándar. tamaño muestreal para ambos factore
```
with(data3,tapply(timeko,list(treat,sex),mean))
with(data3,tapply(timeko,list(treat,sex),sd))
with(data3,tapply(timeko,list(treat,sex),length))

## Cargar librería dplyr para confeccionar tablas
library(dplyr)

tabla1 <- data3 %>% group_by(treat, sex) %>%
  summarise(muestras=n(),
            media=mean(timeko, na.rm=T),
            DE=sd(timeko, na.rm=T),
            EE=DE/sqrt(muestras),
            min=min(timeko),
            max=max(timeko))
tabla1
```

Gráfico rápido para evaluar tendencias
```
library(ggpubr)
quartz(12,8)
ggboxplot(data3, x="sex", y="timeko", color="treat")
```

Probamos la normalidad
```
shapiro.test(data3$timeko)
plot1 <- gghistogram(data3$timeko, bins=10, title="Histograma datos originales", fill="blue", add="mean")
plot1
plot2 <- ggqqplot(data3$timeko, col="blue", main="QQplot datos originales")
plot12

ggarrange(plot1, plot2, labels=c("A","B"), ncol=2, nrow=1)
```

Probamos la homocedasticidad
```
library(car)
leveneTest(timeko ~ sex*treat, data=data3)
````

Dado que los datos son normales y homocedásticos, procedemos a analizar los datos con una ANOVA de dos vías
```
m1 <- lm(timeko ~ treat*sex, data=data3)
anova(m1)

m2 <- aov(timeko ~ treat*sex, data=data3)
summary(m2)
#
## Prueba a posteriori de Tukey
library(rstatix)
tukey.test2 <- data3 %>% tukey_hsd(timeko ~ treat*sex)
tukey.test2
```

Graficamos
```
plot3 <- ggboxplot(data3, x="treat", y="timeko", color="sex", ylim=c(0,65),
                    add="jitter", xlab="Treatment", ylab="Knockdown time (min)", 
                    legend="right", palette=c("blue","purple"))
plot3
```

Otra opción más definitiva
```
set.seed(08061980)
plot4 <- data3 %>%
  ggplot(aes(x=treat, y=timeko, fill=sex))+
  geom_jitter(show.legend=T, 
              position=position_jitterdodge(jitter.width=0.4, dodge.width=0.6),
              shape=21, color="black", size=3) +
  stat_summary(show.legend=F, fun=mean, geom="crossbar", size=0.4, 
               col="black", width=0.5, position=position_dodge(width=0.6)) + 
  scale_y_continuous(breaks=seq(0,50,10))+
  labs(x="Treatment",y="Knockdown tiem (min)")+
  scale_fill_discrete(name="Sex")+
  theme_classic()+
  theme(axis.text.x = element_text(size=10, colour = "black"),
        axis.text.y = element_text(size=10, colour = "black"),
        axis.title.x = element_text(size=12, colour = "black", vjust=-1),
        axis.title.y = element_text(size=12, colour = "black", vjust=2),
        legend.position = "right")
quartz(12,8)
plot4
``` 
Agregamos los símbolos de significancia
```
quartz(12,8)
plot4 + stat_pvalue_manual(tukey.test2,label="p.adj.signif",tip.length = 0.02, 
                              y.position=c(65,64,63,62,61,60,59,58))
```

Esta opción requiere ingresar los valores de todas las combinaciones, pero no es lo que queremos, así que lo haremos manualmente.
```
plot4 + geom_line(data=tibble(x=c(1, 2), y=c(63, 63)),
            aes(x=x, y=y),
            inherit.aes=FALSE)+
        geom_text(data=tibble(x=1.5, y=64),
            aes(x=x, y=y, label="****"), size=4,
            inherit.aes=FALSE)+
        geom_line(data=tibble(x=c(0.8, 1.2), y=c(40, 40)),
            aes(x=x, y=y),
            inherit.aes=FALSE)+
        geom_text(data=tibble(x=1, y=43),
            aes(x=x, y=y, label="ns"), size=4,
            inherit.aes=FALSE)+
        geom_line(data=tibble(x=c(1.8, 2.2), y=c(54,54)),
            aes(x=x, y=y),
            inherit.aes=FALSE)+
        geom_text(data=tibble(x=2, y=57),
            aes(x=x, y=y, label="ns"), size=4,
            inherit.aes=FALSE)
 ```
 
Opción para graficar las líneas de tendencia

1. Ejecutamos esta función para calcular medias y desviaciones estándares para cada combinación.
```
data_summary <- function(data, varname, groupnames){
  require(plyr)
  summary_func <- function(x, col){
    c(mean = mean(x[[col]], na.rm=TRUE),
      sd = sd(x[[col]], na.rm=TRUE))
  }
  data_sum<-ddply(data, groupnames, .fun=summary_func,
                  varname)
  data_sum <- rename(data_sum, c("mean" = varname))
  return(data_sum)
}
```

2. Luego ingresamos la información de nuestros datos.
```
df2 <- data_summary(data3, varname="timeko", 
                    groupnames=c("sex", "treat"))
```

3. Graficamos.
```
plot5 <- ggplot(df2, aes(x=treat, y=timeko, group=sex, color=sex)) + 
          geom_line(position=position_dodge(0.1)) +
          geom_point(position=position_dodge(0.1))+
          geom_errorbar(aes(ymin=timeko-sd, ymax=timeko+sd), width=.1,
                position=position_dodge(0.1))+
          labs(x="Treatment", y = "Knockdown time (min)")+
          theme_classic()
plot5
```
---
### 2. Diseño de medidas repetidas

```
data("ChickWeight")

ggplot(data = ChickWeight, aes(x = Time, y = weight, colour = Diet)) +
  geom_point() +
  geom_line(aes(group = Chick))
```

```
m3 <- aov(weight ~ Diet + Error(Chick/Time), data = ChickWeight)
summary(m3)

m4 <- aov(weight ~ Diet*Time, data = ChickWeight)
summary(m4)
```


