# Práctico 1: Análisis de frecuencia

En este práctico realizaremos diversos análisis de frecuencias en R. Primero, empezaremos con algunos conceptos básicos de R que serán útiles a lo largo del curso. Luego, realizaremos una prueba de bondad de ajuste, luego una analizaremos una tabla de contigencia, para finalizar con análisis de riesgo (odd ratio).

---

## Contenido

1. [Prueba de bondad de ajuste](https://github.com/lecastaneda/Bioestadistica/blob/main/Pr%C3%A1ctico%201.md#1-prueba-de-bondad-de-ajuste)
2. [Tablas de contingencia](https://github.com/lecastaneda/Bioestadistica/blob/main/Pr%C3%A1ctico%201.md#2-tablas-de-contingencia)
3. [Razón de posibilidades (odds ratio)](https://github.com/lecastaneda/Bioestadistica/blob/main/Pr%C3%A1ctico%201.md#3-raz%C3%B3n-de-posibilidades-odds-ratio)

---
## 1. Prueba de bondad de ajuste.

Las pruebas de bondad de ajuste permiten evaluar si una variable categórica se distribuye de una manera específica o no.

### Ejemplo 1

   ![Ejemplo de bondad1](https://github.com/lecastaneda/Bioestadistica/blob/main/Ejemplo1.png)

¿La clínica veterinaria cercana a mi casa atiende el mismo número de gatos que de perros?

H0: el número de gatos que se atiende en la clínica es igual al número de perros.

H1: el número de gatos que se atiende en la clínica es distinto al número de perros.

```
## Crear un vector con los valores de perros y gatos
data1 = c(25,87)
data1
chisq.test(data1) # Realizar la prueba de chi cuadrado
chisq.test(data1)$expected # Calcular las frecuencias esperadas
```

¿Aceptamos o rechazamos la hipótesis nula?

```
## Grafiquemos los datos
nombres = c("perros","gatos")
pie(data1, labels=nombres)
#
## Agregemos los porcentajes
pct <- round(data1/sum(data1)*100)  # Calculamos los porcentajes
nombres = paste(nombres,pct,"%",sep=" ")  # Creamos un texto
pie(data1, labels=nombres)
```
   ![Pie1](https://github.com/lecastaneda/Bioestadistica/blob/main/Pie1)

--
### Ejemplo 2

   ![Ejemplo de bondad2](https://github.com/lecastaneda/Bioestadistica/blob/main/Ejemplo2.png)

¿Los genes asociados al color y textura de las arvejas se heredan de forma independiente?

H0: Si los genes se heredan de forma independiente, las proporciones fenotípicas deberían seguir las proporciones enunciadas en el Segundo Principio Medeliana.

H1: Si los genes no se heredan de forma independiente, las proporciones fenotípicas deberían ser distintas a las proporciones enunciadas en el Segundo Principio Medeliana.

```
## Crear un vector con los valores para las cuatro clases fenotípicas
data2 = c(315,108,101,32)
sum(data2)
#
## Realizar la prueba de chi cuadrado con las proporciones espereradas y reescalando las frecuencias para que sumen 1
test1 = chisq.test(data2, p=c(9,3,3,1), rescale=T)
test1
test1$expected   # Calcular las frecuencias esperadas
```

¿Aceptamos o rechazamos la hipótesis nula?

```
## Grafiquemos los datos
arvejas = c("amarillas-lisas","verdes-lisas","amarillas-rugosas","verdes-rugosas")
pct <- round(data2/sum(data2)*100)  # Calculamos los porcentajes
pie(data2, labels=arvejas, col=rainbow(length(arvejas)))
```

   ![Pie2](https://github.com/lecastaneda/Bioestadistica/blob/main/Pie2)

--
### Ejemplo 3

Vamos a simular una población de 100 individuos que se distribuyen de forma aleatoria en 3 genotipos: AA, Aa y aa. 

Paso 1: Para esto primero vamos a crear 100 individuos con genotipo AA, 100 individuos con genotipo Aa, y 100 individuos con genotipo aa. 
Paso 2: Luego muestreareamos 100 individuos de manera aleatoria para crear nuestra población.


```
n <- 100
genotipos <- c(rep("AA",n),rep("Aa",n),rep("aa",n))   # Paso 1
muestra <- sample(genotipos,100) # Paso 2
frec.geno <- table(muestra)   # Calcular las frecuencias genotípicas
```

Paso 3: Crear un objeto con las frecuencias genotípicas de cada genotipo

Paso 4: Calcular las frecuencias del alelo A (frecuencia p) y del alelo a (frecuencias q)

```
aa <- frec.geno[1]
Aa <- frec.geno[2]
AA <- frec.geno[3]
p <- (2*aa+Aa)/(2*n) # frecuencia alelo a
q <- (2*AA+Aa)/(2*n) # frecuencia alelo A
```

Paso 5: Calcular las frecuencias genotípicas esperadas según el Equilibrio de Hardy-Weinberg (p<sup>2</sup> + 2pq + q<sup>2</sup> = 1).

```
p2 <- p^2
pq2 <- 2*p*q
q2 <- q^2
p2+pq2+q2    # Chequeo que debe sumar 1
```

Paso 6: Realizar la prueba de chi cuadrado con las proporciones esperadas según HWE.

```
test2 <- chisq.test(c(AA,Aa,aa), p=c(p2,pq2,q2))
test2
test2$expected
```

---
## 2. Tablas de contingencia

Las tablas de contingenciapermiten evaluar si la distribución de frecuencias en múltiples categorías se distribuyen de forma independientre entre las distintas categorías. Por ejemplo, si tenemos una tabla de contingencia de i columnas y j filas, las tablas de contingencia permiten evaluar si los valores de frecuencias son independientes entre filas y columnas.

--
### Ejemplo 1

   ![Ejemplo3](https://github.com/lecastaneda/Bioestadistica/blob/main/Ejemplo3.png)
   
H0: Las frencuencias en las filas se distribuyen independiente respecto a las columas.

H1: Las frencuencias en las filas se distribuyen se asocian a las columas.

Descargar los datos contenidos en el archivo de texto [data3.txt](https://github.com/lecastaneda/Bioestadistica/blob/main/data3.txt)

```
## Cargar data3.txt
data3 = read.table("data3.txt", header=T)
head(data3)
#
## Mostrar las frecuencias de cada celda
table(data3)
#
## Calcular las proporciones
prop.table(table(data3))
#
## Calcular los porcentajes
prop.table(table(data3))*100
#
## Realizar la prueba de chi cuadrado (sin la corrección para bajas frecuencias de Yates)
chisq.test(data3$Condicion, data3$Glicemia, correct=F)
#
## Calcular las frecuencias esperadas
chisq.test(data3$Condicion, data3$Glicemia, correct=F)$expected
```

Grafiquemos!!!

```
## Renombrar variables como factores
data3$Condicion <- factor(data3$Condicion)
data3$Glicemia <- factor(data3$Glicemia)
#
## Realizar un gráfico de barras
install.packages("ggplot2")
library(ggplot2)
ggplot(data=data3, aes(x=Glicemia, fill=Condicion))+ geom_bar(position="dodge") + ylab("Pacientes")
```

   ![Barra1](https://github.com/lecastaneda/Bioestadistica/blob/main/Bar1.png)

R por defecto ordena las variables categóricas en orden alfabético. En este caso, "Hiperglicemia" primero que "Normoglicemia" y "Diabéticos" primero que "No diabéticos". Para ordenar los grupos en un orden específico es necesario indicarlo de la siguiente manera.

```
## Cambiar orden de grupos
data3$Condicion <- factor(data3$Condicion, levels=c("No diabéticos","Diabéticos"))
data3$Glicemia <- factor(data3$Glicemia, levels=c("Normoglicemia","Hiperglicemia"))
#
ggplot(data=data3, aes(x=Glicemia, fill=Condicion))+ geom_bar(position="dodge") + ylab("Pacientes")
```
   ![Barra2]<img src="ttps://github.com/lecastaneda/Bioestadistica/blob/main/Bar2.png" width="400" height="600">)
   
---
## 3. Razón de posibilidades (odds ratio)

Los odds ratio permiten evaluar la posibilidad de que un evento ocurra respecto a que ese evento no ocurra en una población dada una condición en particular.

--
### Ejemplo 1

   ![Tabla1](https://github.com/lecastaneda/Bioestadistica/blob/main/Tabla1.png)

¿Cuál es la posibilidad de sufrir una trombosis venosa en mujeres que consumen anticonceptivos orales respecto a las que no los consumen?

```
## Instalar el paquete epitools
install.packages("epitools")
library(epitools)
#
## Crear nombres para las columnas y filas
coln <- c("Casos","Controles")
rown <- c("Genotipo normal; ACO(-)","Genotipo normal; ACO(+)")
#
## Ingresar valores de frecuencias desde la tabla 1
data4 <- matrix(c(35,127,52,41),2,2, byrow=T)
#
## Agregar nombres de columnas y filas a la matriz
dimnames(data4) <- list("Condición"=rown, "Caso-control"=coln) 
#
## Realizar el análisis de odds ratio
oddsratio(data4, rev="c")  # Dado que nuestra matriz contiene en la columna 1 los casos y en la columna 2 los controles, la función *oddsratio*
                           # por defecto comparará la la columna 2 versus la columna 1. Pero como queremos comparar casos versus controles,
                           # debemos incluir el argumento *rev="c"* que permitirá invertir las columnas.
#
# Otra opción es desde un principio crear una matriz con los controles en la columna 1 y los casos en la columna 2
data5 <- matrix(c(127,35,41,52),2,2, byrow=T)
coln <- c("Controles","Casos")
dimnames(data5) <- list("Condición"=rown, "Control-caso"=coln) 
oddsratio(data5)
```

