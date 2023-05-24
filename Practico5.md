# Práctico 5: Relación entre variables

## Contenido

1. [Comparación entre grupos]
2. [Análisis de correlación]
3. [Análisis de regresión simple]
4. [Análisis de regresión múltiple]
5. [Análisis de regresión logística]

---
### 1. Comparación entre grupos

Descargar los datos contenidos en el archivo txt [TAC_practico](https://github.com/lecastaneda/Bioestadistica/blob/main/TAC_practico.txt)

Este set datos corresponde a un estudio farmacocinético de un inmunosupresor (Tacrolimus) usado en pacientes sometidos a trasplante renal. Los pacientes están clasificados por sexo, fenotipo de expresión de un enzima detoxificadora y el tipo de tacrolimus administrado. A estos pacientes se les midió la concentración plasmática en sangre de tacrolimus a las 0 (C0), 1 (C1), 2 (C2), 4 (C4), 12 (C12), y 24 (C24) horas después de su administración. A partir de estos valores de calculó el área bajo la curva (AUC) de la concentración de tacrolimus en sangre. La AUC permite evaluar si el tacrolimus se encuentra dentro de los rangos terapeíticos o no.

Lo primero que vamos a hacer es comparar los valores de AUC entre hombres y mujeres.

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

