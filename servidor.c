#include "servidor.h"


int cuenta_primos(int min, int max)
{
  int i, contador;
// long cuenta_primos(long min, long max)		//
// {							//
//   long i, contador;					//


  contador = 0;
  
  for (i = min; i <= max; i++)
    if (esprimo(i)) contador = contador + 1;

  return (contador);
}


int encuentra_primos(int min, int max, int vector[])
{
  int i, contador;
// long encuentra_primos(long min, long max, long vector[])	//
// {								//
//   long i, contador;						//

  contador = 0;

  for (i = min; i <= max; i++)
    if (esprimo(i)) vector[contador++] = i;

  return (contador);
}


int net_encuentra_primos(int min, int max, uint32_t vector[])
{
  int i, contador;
// long net_encuentra_primos(long min, long max, uint32_t vector[])	//
// {									//
//   long i, contador;							//

  contador = 0;

  for (i = min; i <= max; i++)
    if (esprimo(i)) vector[contador++] = htonl(i);

  return (contador);
}

int esprimo(int n)
{
  int i;
// int esprimo(long n)			//
// {					//
//   long i;				//

  for (i = 2; i*i <= n; i++)
    if ((n % i) == 0) return (0);

  return (1);
}

/* Escribe una lista de números primos entre 1 y 1000000 */
int main()
{
	int i, cuantos;
	int primos[10000];
	cuantos = cuenta_primos(MINIMO, MAXIMO);
	printf("\n El número de primos es: %d \n", cuantos);
	cuantos = encuentra_primos(MINIMO, MAXIMO, primos);
	for (i = 0; i < cuantos; i++)
		printf("\n %ld es primo \n", primos[i]);
	exit(0);
}