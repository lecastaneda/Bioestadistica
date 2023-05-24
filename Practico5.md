# Práctico 5: Relación entre variables

## Contenido

1. [Comparación entre grupos](https://github.com/lecastaneda/Bioestadistica/blob/main/Practico5.md#1-comparaci%C3%B3n-entre-grupos)
2. [Análisis de correlación](https://github.com/lecastaneda/Bioestadistica/blob/main/Practico5.md#2-an%C3%A1lisis-de-correlaci%C3%B3n)
3. [Análisis de regresión simple](https://github.com/lecastaneda/Bioestadistica/blob/main/Practico5.md#3-an%C3%A1lisis-de-regresi%C3%B3n-simple)
4. [Análisis de regresión múltiple](https://github.com/lecastaneda/Bioestadistica/blob/main/Practico5.md#4-an%C3%A1lisis-de-regresi%C3%B3n-m%C3%BAliple)
5. [Análisis de regresión logística](https://github.com/lecastaneda/Bioestadistica/blob/main/Practico5.md#4-an%C3%A1lisis-de-regresi%C3%B3n-log%C3%ADstica)

---
### 1. Comparación entre grupos

Descargar los datos contenidos en el archivo txt [TAC_practico](https://github.com/lecastaneda/Bioestadistica/blob/main/TAC_practico.txt)

Este set datos corresponde a un estudio farmacocinético de un inmunosupresor (Tacrolimus) usado en pacientes sometidos a trasplante renal. Los pacientes están clasificados por sexo, fenotipo de expresión de un enzima detoxificadora y el tipo de tacrolimus administrado. A estos pacientes se les midió la concentración plasmática en sangre de tacrolimus a las 0 (C0), 1 (C1), 2 (C2), 4 (C4), 12 (C12), y 24 (C24) horas después de su administración. A partir de estos valores de calculó el área bajo la curva (AUC) de la concentración de tacrolimus en sangre. La AUC permite evaluar si el tacrolimus se encuentra dentro de los rangos terapeíticos o no.

Lo primero es cargar el set de datos y revisar su estructura.

```
# Cargar el set de datos y revisar su estructura
tac <- read.table("TAC_practico.txt", header=T)
head(tac)
str(tac)

# Definir las categorias como factores
tac$sex <- as.factor(tac$SEX)
tac$phenotype <- as.factor(tac$phenotype)
tac$brand <- as.factor(tac$phenotype)
```

Ahora graficamos los histogramas de frecuencia para cada valor plasmático de tacrolimus: C0, C1, C2, C4, C12, C24.
```
hist(tac$C0)
#
par(mfrow=c(3,2))
#par(mar=c(3,3,1,1))
hist(tac$C0)
hist(tac$C1)
hist(tac$C2)
hist(tac$C4)
hist(tac$C12)
hist(tac$C24)
par(mfrow=c(1,1))
```

Obtenemos los promedios, desviaciones estándares y número de muestras para grupo.
```
with(tac,tapply(AUC,list(sex),mean))
with(tac,tapply(AUC,list(sex),sd))
with(tac,tapply(AUC,list(sex),length))
```

Ahora lo que vamos a hacer es comparar los valores de AUC entre hombres y mujeres.
```
# Análisis de normalidad
shapiro.test(tac$AUC)
#
# Análisis de homocedasticidad
fligner.test(AUC ~ sex, data=tac)
#
# Ajustamos el modelo lineal
m1 <- lm(AUC ~ sex, data=tac)
#
# Revisamos los resultados
anova(m1)
summary(m1)
```
---
### 2. Análisis de correlación

Ahora vamos a analizar las correlaciones entre los distintos valores de tacrolimus plasmáticos y los valores calculados de AUC. 
Por ejemplo, primeros analizaremos al correlación entre C0 y AUC.
```
# Probamos al normalidad entre ambas variables
shapiro.test(tac$C0)
shapiro.test(tac$AUC)
#
# Analizamos la correlación
cor.test(tac$AUC,tac$C0)
#
# Grafiquemos ambas variables
plot(tac$C0,tac$AUC)
#
# Mejoremos el gráfico-
par(mar=c(5,5,1,1))
plot(tac$C0,tac$AUC, las=1, pch=21, bg= "purple", 
     xlab="TAC C0 (ng/ml)", ylab=("AUC (ng/ml/h)"),
     cex=1.2)
```

Ahora realizamos el mismo procedimientos con el resto de las variables.
```
cor.test(tac$AUC,tac$C1)
cor.test(tac$AUC,tac$C2)
cor.test(tac$AUC,tac$C4)
cor.test(tac$AUC,tac$C12)
cor.test(tac$AUC,tac$C24)
```

Existe una manera más rápida de realizar el mismo proceso, auqnue la información entregada en más limitada.
```
library(rstatix)
tac %>% cor_mat()
str(tac)
#
# Retenemos las variables numéricas para evitar el error anterios.
tac2 <- tac[,c(2:7,10)]
str(tac2)
cor.mat <- tac2 %>% cor_mat()
cor.mat
```

Veamos qué correlaciones son significativas.
```
cor.mat %>% cor_get_pval()
cor.mat %>% cor_mark_significant()
```

Grafiquemos la matriz de correlación
```
cor.mat %>% pull_lower_triangle() %>% cor_plot()
```

---
### 3. Análisis de regresión simple

Ahora vamos a analizar si los valores plasmáticos de tacrolimus permiten determinar los valores de AUC. Para esto analizaremos el mejor valor predctivo.
Primero analizaremos la relación entre C0 y AUC.
```
m2 <- lm(AUC ~ C0, data=tac)
anova(m2)
summary(m2)
```

Ahora analizaremos la relación entre C12 y AUC.
```
m3 <- lm(AUC ~ C12, data=tac)
summary(m3)
```

Grafiquemos la relación entre C12 y AUC.
```
plot(tac$C12,tac$AUC, las=1, pch=21, bg= "purple", 
     xlab="TAC C12 (ng/ml)", ylab=("AUC (ng/ml/h)"),
     cex=1.2)
abline(m3, lwd=2, col="blue")
```

---
### 4. Análisis de regresión múliple

Ahora vamos a realizar una regresión múltiple solo con las primeros cuatro muestras para determinar su relación con la AUC calculada. Esto tiene un efecto práctico, ya que buscaremos qué muestra temporal de tacrolimus permite predecir de mejor manera la AUC, evitando la permenencia de los paciente por más de 4 horas en el centro de salud.

```
m4 <- lm(AUC ~ C0+C1+C2+C4, data=tac)
summary(m4)
```

Ahora corremos otros modelos que tienen un tres muestras temporales.
```
# Primero corremos los modelos
m5 <- lm(AUC ~ C0+C1+C2, data=tac)
m6 <- lm(AUC ~ C0+C1+C4, data=tac)
m7 <- lm(AUC ~ C0+C2+C4, data=tac)
m8 <- lm(AUC ~ C1+C2+C4, data=tac)
```

Podemos comparar estos modelos estos modelos basándonos en los valores ajustados de r^2
```
summary(m4)$adj.r.squared
summary(m5)$adj.r.squared
summary(m7)$adj.r.squared
summary(m7)$adj.r.squared
summary(m8)$adj.r.squared
```

También podemos comparar estos modelos estos modelos basándonos en los valores de AIC.
```
AIC(m4)
AIC(m5)
AIC(m6)
AIC(m7)
AIC(m8)
```

Finalmente, podemos hacer una comparación global entre estos modelos, comparando sus desempeños estadísticos
```
library(performance)
comp <- compare_performance(m4,m5,m6,m7,m8, rank=TRUE)
comp
```

---
### 4. Análisis de regresión logística

Descargar los datos contenidos en el archivo csv [diabetes](https://github.com/lecastaneda/Bioestadistica/blob/main/diabetes.csv)

Este set de datos pertence al Instituto Nacional de Diabetes y Enfermedades Digestivas y Renales. El objetivo de este set de datos es predecir si un paciente tiene o no diabetes basándose en ciertas mediciones diagnósticas como por ejemplo: niveles de glucosa, presión sanguínea, grosor de la piel, número de embarazos, niveles de insulina, índice de masa corporal, historia familiar de diabetes y edad. Todas las pacientes son mujeres mayores de 21 años pertenecientes al grupo indígena Pima.

Nuevamente, lo primero es cargar el set de datos y revisar su estructura.
```
pima <- read.csv("diabetes.csv")
head(pima)
```

Revisamos la correlación entre todas las variables.
```
cor.pima <- pima %>% cor_mat()
cor.pima %>% pull_lower_triangle() %>% cor_plot()
```

Corremos una regresión logística simple entre el estado de diabetes y los niveles de glucosa.
```
m9 <- glm(Outcome ~ Glucose, data=pima, family=binomial)
summary(m9)
```

Grafiquemos esta regresión
```
plot(pima$Glucose, pima$Outcome, 
     xlab = "Glucosa (mg/dl)", ylab = "Diabetes (0= No diabetes, 1= Diabetes", pch = 20, col = "blue")
#
# Calcular las probabilidades predichas
probs <- predict(m9, newdata = pima, type = "response")

# Agregar las probabilidades predichas a la gráfica
lines(sort(pima$Glucose), probs[order(pima$Glucose)], col = "red", lwd = 2)
```

Ahora corremos una regresión logística múltiple incluyendo el número de embarazos.
```
m10 <- glm(Outcome ~ Glucose+Pregnancies, data=pima, family=binomial)
summary(m10)
```

Comparamos ambos modelos basándonos en el AIC. ¿Cuál es mejor modelo?
```
AIC(m9)
AIC(m10)
```

Ahora corremos una regresión logística con todas las posibles. variables predictoras de diabetes.
```
m11 <- glm(Outcome ~ ., data=pima, family=binomial)
summary(m11)
```





