#include <netinet/in.h> //structure for storing address information
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h> //for socket APIs
#include <sys/types.h>
#include <errno.h>
#include "servidor.h"


int main(int argvc, char const* argv[])
{

	uint32_t parametros[4]; //Parametros de la solicitud
	uint32_t respuesta;
	uint32_t contarPrimos = 1;
  	uint32_t obtenerPrimos = 2;

	//Asignación de valores al mensaje de solicitud
	parametros[0] = htonl(atoi(argv[1]));	//NIP	
	parametros[1] = htonl(atoi(argv[2]));	//Servicio
	parametros[2] = htonl(atoi(argv[3]));	//Rango 0
	parametros[3] = htonl(atoi(argv[4]));	//Rango 1

	int sock = socket(AF_INET, SOCK_STREAM, 0);
	struct sockaddr_in sockDirecciones;

	sockDirecciones.sin_family = AF_INET;
	sockDirecciones.sin_addr.s_addr = INADDR_ANY;
	sockDirecciones.sin_port = htons(PUERTO);

	int estadoConexion = connect(sock, (struct sockaddr*)&sockDirecciones, sizeof(sockDirecciones));

	if (estadoConexion == -1){
		printf("Error en la conexion \n");
		printf("ERROR: %s\n", strerror(errno));
	}else{
		printf("Cliente conectado a servidor, escriba su mensaje: \n");
		char mensaje[255];
		recv(sock, mensaje, sizeof(mensaje), 0);
		printf("Mensaje: %s\n", mensaje);

		int n = write(sock, parametros, 4*sizeof(uint32_t));
		//int n = send(sock, parametros, sizeof(parametros), 0);

		if (n<0){
			printf("Error al escribir \n");
		}else{
			if (atoi(argv[2]) == contarPrimos){
				int nPrimos;
				read(sock, &nPrimos, sizeof(nPrimos));
				printf("Entre el intervalo %d y - %d se han encontrado %d numeros primos", atoi(argv[3]), atoi(argv[4]), nPrimos);
			}else if(atoi(argv[2]) == obtenerPrimos) {
				printf("a obtenerPrimos");
				uint32_t vectorPrimos[100];
				read(sock, vectorPrimos, sizeof(vectorPrimos));
				printf("a obtenerPrimos");
				for(int i=0; i <5; i++)
					printf("\t %u", ntohl(vectorPrimos[i]));
			}

		}
	}
	close(sock);
	return 0;
}
