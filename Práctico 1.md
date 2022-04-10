## Práctico 1: Análisis de frecuencia

En este práctico realizaremos diversos análisis de frecuencias en R. Primero, empezaremos con algunos conceptos básicos de R que serán útiles a lo largo del curso. Luego, realizaremos una prueba de bondad de ajuste, luego una analizaremos una tabla de contigencia, para finalizar con análisis de riesgo (odd ratio).

---

## Contenido

1. Prueba de bondad de ajuste.
2. Tablas de contingencia.
3. Análisis de riesgo (odd ratio).

---
# 1. Prueba de bondad de ajuste.

Las pruebas de bondad de ajuste permiten evaluar si una variable categórica se distribuye de una manera específica o no.

   ![Ejemplo de bondad1](https://github.com/lecastaneda/Bioestadistica/blob/main/Ejemplo1.png)

¿La clínica veterinaria cercana a mi cada atiende el mismo número de gatos que de perros?

H0: el número de gatos que se atiende en la clínica es igual al número de perros.

H1: el número de gatos que se atiende en la clínica es distinto al número de perros.

```
## Crear un vector con los valores de perros y gatos
data1 = c(25,87)
chisq.test(data1)
```

¿Aceptamos o rechazamos la hipótesis nula?

 
