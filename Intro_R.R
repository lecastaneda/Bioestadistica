# Introducción a R.

# En esta sección haremos una breve introducción al programa R. Aprenderemos a hacer operaciones matemáticas básicas, crear vectores, matrices, etc.

## Borrar todos los objetos previamente ingresados en la sesión de R
rm(list=ls()) 

## Operaciones algebraícas básicas
4+7
5*3
12/4
3*(4+7)
3*(4-7)

## Crear objetos 
V1 = 3*(4+7)
V2 = 3*(4-7)  
V1+V2 #suma de objetos

## crear objeto basados en vectores
V3 = c(2,4,6,8,10,12) # vector de números enteros pares entre 2 y 10
V4 = seq(2,12, by=2)  # vector de números enteros pares entre 2 y 10
V5 = seq(2,200, by=2) # vector de números enteros pares entre 2 y 200

## Operaciónes basadas en R
sum(V3)
length(V3)
min(V3)
max(V3)

## matrices
matrix1 = matrix(,2,3, nrow=3)
matrix2 = matrix(V3,2,3)
matrix3 = matrix(V3,2,3, byrow=2)
matrix4 = matrix(V3,3,2)
matrix5 = matrix(V3,3,2, byrow=2)

## Data frames (estructuctura de datos tabulados en filas y columnas)
data1 = data.frame(matrix3)
colnames(data1) = c("columna 1","columna 2")
rownames(data1) = c("fila 1","fila 2","fila 3")
data1
dim(data1)
