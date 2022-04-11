## Práctico 1: Análisis de frecuencia

En este práctico realizaremos diversos análisis de frecuencias en R. Primero, empezaremos con algunos conceptos básicos de R que serán útiles a lo largo del curso. Luego, realizaremos una prueba de bondad de ajuste, luego una analizaremos una tabla de contigencia, para finalizar con análisis de riesgo (odd ratio).

---

## Contenido

1. Prueba de bondad de ajuste.
2. Tablas de contingencia.
3. Análisis de riesgo (odd ratio).

---
## 1. Prueba de bondad de ajuste.

Las pruebas de bondad de ajuste permiten evaluar si una variable categórica se distribuye de una manera específica o no.

### Ejemplo 1

   ![Ejemplo de bondad1](https://github.com/lecastaneda/Bioestadistica/blob/main/Ejemplo1.png)

¿La clínica veterinaria cercana a mi cada atiende el mismo número de gatos que de perros?

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



 
