//#include <netinet/in.h> //structure for storing address information
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h> //for socket APIs
#include <sys/types.h>
#include <servidor.h>

int main(int argvc, const* char argv[]{
	int sock = socket(AF_INET, SOCK_STREAM, 0);
	sturct sockaddr_in sockDirecciones;

	sockDirecciones.sin_family = AF_INET;
	sockDirecciones.sin_addr.s_addr = INADDR_ANY;
	sockDirecciones.sin_port = PUERTO;

	int estadoConexion = connect(sock, (struct sockDirecciones*)&servAddr, sizeof(servAddr));

	if (estadoConexion == -1){}
		printf("Error en la conexion \n");
	}else{
		char mensaje[255];
		recv(sock, mensaje, sizeof(mensaje), 0)
		printf("Mensaje: %s\n", mensaje);
	}

	return 0;
})