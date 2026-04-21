# Comparación
Los métodos de Lagrange, Newton y Matricial construyen un único polinomio de grado 49. Para grados n grandes, este polinomio presenta el Fenómeno de Runge: oscilaciones de gran amplitud entre nodos, especialmente en los extremos. 
El método Matricial agrava el problema debido al mal condicionamiento de la matriz de Vandermonde, con V > 10^18 para n=50, amplificando errores de redondeo. Estos tres métodos no son recomendados para este caso.

El spline cúbico utiliza 49 polinomios de grado 3, uno por tramo, con continuidad en los nodos. Al mantener bajo el grado local y ser un método local (trabaja por trozos), evita las oscilaciones y la inestabilidad numérica, por eso se aprecian trazos que se asemejan al grupo de puntos original.

## Referencias
- Trefethen, L. N. (2019). Approximation Theory and Approximation Practice. Extended Edition. SIAM.

Izquierdo Cabrel, Bryan Jair - 21190057 - L14 Métodos Numéricos
