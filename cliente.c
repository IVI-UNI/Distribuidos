#include <netinet/in.h> //structure for storing address information
#include <stdio.h>
#include <limits.h>
#include <stdlib.h>
#include <sys/socket.h> //for socket APIs
#include <sys/types.h>
#include <errno.h>
#include "servidor.h"


int main(int argvc, char const* argv[])
{

	uint32_t parametros[4]; //Parametros de la solicitud
	char * respuesta ;
	uint32_t contarPrimos = 1;
  	uint32_t obtenerPrimos = 2;
  	int bytes_leidos=0;
  	int bytes_leidos_total=0;
  	int tamanoVector;

	//Asignación de valores al mensaje de solicitud
	parametros[0] = (uint32_t)getpid();				//htonl(atoi(argv[1]));	//NIP	
	parametros[1] = htonl(atoi(argv[2]));	//Servicio
	parametros[2] = htonl(atoi(argv[3]));	//Rango 0
	parametros[3] = htonl(atoi(argv[4]));	//Rango 1
	
	//Creación del socket 
	int sock = socket(AF_INET, SOCK_STREAM, 0);
	struct sockaddr_in sockDirecciones;
	sockDirecciones.sin_family = AF_INET;
	sockDirecciones.sin_addr.s_addr = INADDR_ANY;
	sockDirecciones.sin_port = htons(PUERTO);

	//Conexión con el servidor
	int estadoConexion = connect(sock, (struct sockaddr*)&sockDirecciones, sizeof(sockDirecciones));

	if (estadoConexion == -1){
		printf("Error en la conexion \n");
		printf("ERROR: %s\n", strerror(errno));
	}else{
		//enviar parametros al servidor
		int n = write(sock, parametros, 4*sizeof(uint32_t));

		if (n<0){
			printf("Error al escribir \n");
		}else{
			if (atoi(argv[2]) == contarPrimos){			//solicita al servidor cuantos nº primos hay en el intervalo
				int nPrimos;
				read(sock, &nPrimos, sizeof(nPrimos));
				printf("Entre el intervalo %d y - %d se han encontrado %d numeros primos \n", atoi(argv[3]), atoi(argv[4]), nPrimos);

			}else if(atoi(argv[2]) == obtenerPrimos) {	//solicita al servidor los nº primos en el intervalo

				//primero se obtiene cuantos nºprimos hay en el intervalo para saber el tamaño del vector 
				read(sock, &tamanoVector, sizeof(int));
				tamanoVector = ntohl(tamanoVector);
				uint32_t vectorPrimos[tamanoVector];

				respuesta = (char *)vectorPrimos;
				//se lee del socket hasta que no quden bytes por leer
				while(bytes_leidos_total < tamanoVector*4){
					bytes_leidos = read(sock, respuesta + bytes_leidos_total, tamanoVector*sizeof(int)-bytes_leidos_total);
					bytes_leidos_total = bytes_leidos_total + bytes_leidos; 
					printf("Leyendo...\n");
				}
					printf("Primos obtenidos \n");
				for(int i=0; i <tamanoVector; i++)
					printf("\t %u", ntohl(vectorPrimos[i]));
				printf("\n");
				printf("Se ha creado un array de %d posiciones \n", tamanoVector);
				printf("Bytes a leer: %lu \n", tamanoVector*sizeof(int));
				printf("Bytes a leidos: %d \n", bytes_leidos_total);
			}

		}
	}
	close(sock);
	return 0;
}
