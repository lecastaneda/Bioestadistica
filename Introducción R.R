# Introducción a R (Juan Soto).

# En esta sección haremos una breve introducción al programa R. Aprenderemos a hacer operaciones matemáticas básicas, crear vectores, matrices, etc.

## Borrar todos los objetos previamente ingresados en la sesión de R
rm(list=ls()) 

## TIPOS DE DATOS: los tipos básicos de datos en R son: character, numeric, integer, logical

#character: siempre se denotan entre comillas " ":
"a"
"Gato"
"El gato botó el florero"
"12"
"#312"

# numeric:
2
2.5
19657.458

# integer: (numeros enteros. no contienen decimales, se indican con una L luego del numero)
10L
230L
10.5L #(indica warning, transforma el valor a numeric por tener decimal)

#logical: sólo dos posibles valores: TRUE o FALSE
TRUE
FALSE
T
F
10<5
10>5

## La función str() muestra el tipo del dato u objeto
class("gato")
class(2)
class(2.5)
class(10L)
class(10.5L)
class(T)

## TIPOS DE ESTRUCTURAS DE DATOS: los datos basicos vistos anteriormente pueden estar contenidos
## en estructuras más complejas
## Tipos: vectors, list, matrix, data frame and factors
## Estructuras que solo pueden contener un tipo de dato: vector y matrix
## Estructuras que pueden contener múltiples tipos de datos: list, data frame

# VECTOR: colección de elementos de un mismo tipo, para crearlos se usa la funcion concatenar: c()
c(1,5,10)
c("Gato", "Perro")
c(TRUE, FALSE, TRUE)
c(2,4,6,8,10,12) # vector de números enteros pares entre 2 y 10
seq(2,12, by=2)  # vector de números enteros pares entre 2 y 10
seq(2,200, by=2) # vector de números enteros pares entre 2 y 200

# si se mezclan diferentes tipos de elementos en un vector R transdormará todos los contenidos 
# al tipo más facil para trabajar
c(1, 10.5, 20 ,"gato") # transforma todos los contenidos a character
c(1, 10.5, 20, "30") # transforma todos los contenidos a character
c(10, TRUE, FALSE) # transforma todos los contenidos a numeric (a FALSE se le asigna el 0 y a TRUE el 1 siempre)

# se puede controlar o cambiar el tipo de los elementos con las funciones:
# as.numeric()
# as.character()
# as.logical()
as.numeric(c(1, 10.5, 20 ,"gato")) # intriduce un NA en ultima posicion ya que es imposible transformar "gato" a numeric
as.numeric(c(1, 10.5, 20, "30"))
as.logical(c(10, TRUE, FALSE)) # cualquier numero igual o mayor a 1 se interpreta como TRUE

# MATRIX: Las matrices son estructuras que poseen datos de un mismo tipo en dimensiones de NxC,
# con N numero de filas y C numero de columnas
matrix(1:4,2, byrow = F) # crea matriz con numeros del 1 al 4, distribuidos en 2 filas
matrix(1:4,2, byrow = T) # mismo que anterior, pero los numeros se llenan por fila en la matriz
matrix(,2,3) # crea matriz vacia con dos filas y 3 columnas
matrix(1:50,10,5,byrow = T)

# LIST: pueden contener multiples elementos de diversos tipos, inluso otras list
list(seq(2,200, by=2),matrix(1:50,10,5,byrow = T),c("Gato", "Perro"),c(TRUE, FALSE, TRUE))
# crea una lista con 4 elementos, un vector numerico, una matriz numerica, un vector de characters y un vector logico
# se puede acceder a cada elemento en particular con su índice, indicado dentro de un doble parentesis [[]]:
list(seq(2,200, by=2),matrix(1:50,10,5,byrow = T),c("Gato", "Perro"),c(TRUE, FALSE, TRUE))[[3]]

## DATA FRAME: la estructura más utilizada para el analisis de datos, al igual que las matrices contiene
## N cantidad de filas y C de columnas, pudiendo contener en cada una de ellas tipos diferentes de datos
data.frame(ID=c(1:4),Nombre=c("Alejandra","María","Juan","Ignacio"),Nota=c(6.5,6.4,6.0,6.4))

## Operaciones algebraícas básicas
4+7
5*3
12/4
3*(4+7)
3*(4-7)

## Operaciones logicas
10<5
10>5

##  CREAR OBJETOS: todos los elementos con los que hemos trabajado pueden estar contenidos dentro de un objeto,
## el cual tiene un nombre a elección del usuario con el que se puede acceder rapidamente al objeto
## Los objetos se pueden crer con los simbolos = o <-
N1 = 10
N2 <- 10.5
N3 = 3*(4+7)
N4 = 3*(4-7)  
N5 = N3+N4 #suma de objetos

## crear objeto basados en vectores
V1 = c(2,4,6,8,10,12) # vector de números enteros pares entre 2 y 10
V2 = seq(2,12, by=2)  # vector de números enteros pares entre 2 y 10
V3 = seq(2,200, by=2) # vector de números enteros pares entre 2 y 200

## Los objetos pueden contener cualquier tipo y estructra de dato
V6 = c("Gato","Perro")
V7 = c("Pato", "Caballo")
V7 = c(V6,V7)
V8 =c(TRUE, FALSE, TRUE)
matrix1 = matrix(1:50,10,5,byrow = T)
dataFrame1 = data.frame(ID=c(1:4),Nombre=c("Alejandra","María","Juan","Ignacio"),Nota=c(6.5,6.4,6.0,6.4))
Lista1 = list(V3,matrix1,V7,V8,dataFrame1)

## Seleccionar elementos particulares dentro de listas:
Lista1[[1]]
Lista1[[5]]

## Seleccionar elementos particulares dentro data frames: [filas,columnas]
dataFrame1
dataFrame1[1,] # todas las columnas de la fila 1
dataFrame1[,3] # todas las filas de la columna 3
dataFrame1[2:3,] # todas las columnas de las fila 2 a la 3
dataFrame1[4,2] # el contenido de la celda en la fila 4, columna 2
dim(dataFrame1) # Muestra las dimensiones del data frame en FilasxColumnas

## Los data frame tambien se pueden crear a partir de otros objetos creados anteriormente:
ID = c(1:10)
Ingreso = c(2021,2022,2023,2022,2023,2021,2023,2022,2023,2022)
Nombre = c("Alejandra","María","Juan","Ignacio", "Sebastian", "Catalina", "Terry", "Sandra", "Lucía", "Pedro")
Nota= c(6.5,6.4,6.0,6.4,5.8,6.7,6.1,6.2,5.5,6.0)
dataFrame2 = data.frame(ID,Ingreso, Nombre, Nota)
dataFrame2

# Con la funcion str() se puede obtener un resumen del tipo de dato contenido en cada columna o variable:
str(dataFrame2)
# La variable Ingreso está considerada como numerica, pero en realidad corresponde a una variable categorica
# que indica el año de ingreso del alumno. Para identificar variables categoricas en R se utilizan los llamados
# factores o factors, un tipo especial de estructura de dato que se utiliza para indicar variables categoricas.
dataFrame2$Ingreso = as.factor(dataFrame2$Ingreso) # se remplaza la variable ingreso por sigo misma pero como factor
str(dataFrame2) # Ingreso ahora es factor con 3 niveles (3 años diferentes)

## Operaciónes basadas en R
length(dataFrame2$Nota)
min(dataFrame2$Nota)
max(dataFrame2$Nota)
median(dataFrame2$Nota)
mean(dataFrame2$Nota)

## Graficos rapidos
hist(dataFrame2$Nota)
plot(dataFrame2$Nota)
plot(dataFrame2$Nota~dataFrame2$Ingreso)
