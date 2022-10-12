#include "servidor.h"
#include <netinet/in.h> //structure for storing address information
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h> //for socket APIs
#include <sys/types.h>

int cuenta_primos(int min, int max){
  int i, contador;
  contador = 0;
  
  for (i = min; i <= max; i++)
    if (esprimo(i)) contador = contador + 1;

  return (contador);
}


int encuentra_primos(int min, int max, int vector[]){
  int i, contador;

  contador = 0;

  for (i = min; i <= max; i++)
    if (esprimo(i)) vector[contador++] = i;

  return (contador);
}


int net_encuentra_primos(int min, int max, uint32_t *vector, int *tamanoVector){
  int i, contador;
  uint32_t *vectorAux;

  contador = 0;

  for (i = min; i <= max; i++)
    if (esprimo(i)){
      vector[contador++] = htonl(i);
      if (contador == *tamanoVector){
        printf("Se ha reservado espacio en memoria de forma dinámica \n");
        *tamanoVector += 10;
        printf("tamano vector = %d", *tamanoVector);
        vectorAux = (uint32_t*)realloc(vector, *tamanoVector*sizeof(uint32_t));
        vector = vectorAux;
      }
    }
  return (contador);
}

int esprimo(int n){
  int i;

  for (i = 2; i*i <= n; i++)
    if ((n % i) == 0) return (0);

  return (1);
}

/* Escribe una lista de números primos entre 1 y 1000000 */
int main()
{
  //variables 
  uint32_t parametrosNet[4];
  uint32_t NIP;
  uint32_t servicio;
  uint32_t min;
  uint32_t max;
  uint32_t contarPrimos = 1;
  uint32_t obtenerPrimos = 2;
  
  //creación del socket
  int sock = socket(AF_INET, SOCK_STREAM, 0);
  struct sockaddr_in dirServ;
  dirServ.sin_family = AF_INET;
  dirServ.sin_port = htons(PUERTO);
  dirServ.sin_addr.s_addr = INADDR_ANY;

  bind(sock, (struct sockaddr*)&dirServ, sizeof(dirServ));

  listen(sock, 10);
  while(1){

    int clienteSocket = accept(sock, NULL, NULL);
    if(fork() == 0){   
      //Lectura de los parametros de la solicitud de servicio
      bzero(parametrosNet, 4*sizeof(uint32_t));
      int n = read(clienteSocket, parametrosNet, 4*sizeof(uint32_t));
      NIP = parametrosNet[0];
      servicio = htonl(parametrosNet[1]);
      min= htonl(parametrosNet[2]);
      max= htonl(parametrosNet[3]);

      if (n < 0){
        printf("Error leyendo los paramentros del cliente");
      }else{
        printf("Cliente NIP: %u \n", NIP);
        printf("Servicio solicitado: %u \n", servicio);
        printf("Cliente min: %u \n", min);
        printf("Cliente max: %u \n", max);
        printf("Cliente PID: %d \n", getpid());

        if (servicio == contarPrimos){
          int nPrimos = cuenta_primos(min, max);
          printf("Entre el intervalo %u y - %u se han encontrado %d numeros primos\n", min, max, nPrimos);
          write(clienteSocket, &nPrimos, sizeof(nPrimos));
        
        }else if( servicio == obtenerPrimos){
          //Contar primos en el intervalo dado para saber el tamaño del vector
          int nPrimos = cuenta_primos(min, max);
          //Vector tipo int con los primos 
          int vectorPrimosI[nPrimos]; 
          //Vector de tipo uint_32t con los primos
          uint32_t vectorPrimosU[nPrimos];
          //Vector con los primos en formato red
          uint32_t vectorPrimos[nPrimos];

          encuentra_primos(min, max, vectorPrimosI);


          for (int i = 0; i < nPrimos; i++){
            vectorPrimosU[i] = vectorPrimosI[i];        //Convertir de unsigned a int
            vectorPrimos[i] = ntohl(vectorPrimosU[i]);  //Guardar el vector de tipo unsigned con formato red
          }

          printf("se ha ejecutado la funcion de encontrar primos \n");
          printf("Primos encontrados entre  %u  y  %u :  %d \n", min, max, nPrimos);
          int tamanoFinal = ntohl(nPrimos);
          write(clienteSocket, &tamanoFinal, sizeof(int));   //Enviar el tamaño del array
          int bytes_escritos = write(clienteSocket, &vectorPrimos, nPrimos*sizeof(uint32_t));
          for (int i = 0; i < nPrimos; i++){
            printf("\t %d ", htonl(vectorPrimos[i]));
          }
        }
        close(clienteSocket);
        exit(0);
      }
    }else{
      printf("Soy el proceso padre %d y voy a terminar", getpid());    
      close(sock);
      exit(0)
    }
  }
}
