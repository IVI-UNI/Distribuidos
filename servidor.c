#include "servidor.h"
#include <netinet/in.h> //structure for storing address information
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h> //for socket APIs
#include <sys/types.h>

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
  uint32_t parametrosNet[4];
  uint32_t NIP;
  uint32_t servicio;
  uint32_t min;
  uint32_t max;
  uint32_t contarPrimos = 1;
  uint32_t obtenerPrimos = 2;

  printf("Tamaño un uint32_t : %lu \n", 4*sizeof(uint32_t));
  int sock = socket(AF_INET, SOCK_STREAM, 0);
  struct sockaddr_in dirServ;
  dirServ.sin_family = AF_INET;
  dirServ.sin_port = htons(PUERTO);
  dirServ.sin_addr.s_addr = INADDR_ANY;

  char mensaje[255] = " Aquí está el mensaje que esperabas \n SURPRISE MADAFAKA";

  bind(sock, (struct sockaddr*)&dirServ, sizeof(dirServ));

  listen(sock, 1);

  int clienteSocket = accept(sock, NULL, NULL);

  send(clienteSocket, mensaje, sizeof(mensaje), 0);

  bzero(parametrosNet, 4*sizeof(uint32_t));
  int n = read(clienteSocket, parametrosNet, 4*sizeof(uint32_t));
  //int n = recv(clienteSocket, parametrosNet, sizeof(parametros), 0);
  NIP = htonl(parametrosNet[0]);
  servicio = htonl(parametrosNet[1]);
  min= htonl(parametrosNet[2]);
  max= htonl(parametrosNet[3]);

  if (n < 0){
    printf("Error leyendo los paramentros del cliente");
  }else{
    printf("Cliente NIP: %u \n", NIP);
    printf("Cliente servicio: %u \n", servicio);
    printf("Cliente min: %u \n", min);
    printf("Cliente max: %u \n", max);

    if (servicio == contarPrimos){
      int nPrimos = cuenta_primos(min, max);
      printf("Entre el intervalo %u y - %u se han encontrado %d numeros primos\n", min, max, nPrimos);
      write(clienteSocket, &nPrimos, sizeof(nPrimos));
    }else if( servicio == obtenerPrimos){
      uint32_t vectorPrimos[100];
      int nPrimos = net_encuentra_primos(min, max, vectorPrimos);
      //printf("Entre el intervalo %u - %u se han encontrado los siguientes numeros primos: %d \n", min, max. nPrimos);
      for (int i = nPrimos; i > 0; i--)
        printf("\t %u", ntohl(vectorPrimos[i]));
      write(clienteSocket, vectorPrimos, sizeof(vectorPrimos));
    }
    close(clienteSocket);
    close(sock);
    return 0;
  }
}