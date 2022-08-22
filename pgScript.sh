
#!/bin/sh

export PGPASSWORD='lol'

#Se obtienen los csv con las notas de corte
echo "Comienza el script de postgres"
echo "Descargando las notas de corte:"
rm -r -f /etc/postgresql/Practica1
mkdir -p /etc/postgresql/Practica1

wget -q -O /etc/postgresql/Practica1/notasCorte2021.csv 'https://zaguan.unizar.es/record/98173/files/CSV.csv'
sed -i -e 's/Grado: //g' /etc/postgresql/Practica1/notasCorte2021.csv
wget -q -O /etc/postgresql/Practica1/notasCorte2020.csv 'https://zaguan.unizar.es/record/87663/files/CSV.csv'
sed -i -e 's/Grado: //g' /etc/postgresql/Practica1/notasCorte2020.csv
wget -q -O /etc/postgresql/Practica1/notasCorte2019.csv 'https://zaguan.unizar.es/record/76876/files/CSV.csv'
sed -i -e 's/Grado: //g' /etc/postgresql/Practica1/notasCorte2019.csv

echo "Notas de corte descargadas"
#Obtención de datos de  los datos de movilidad de los últimos 3 años
echo "Obteniendo ficheros de Movilidad SICUE y ERASMUS de los 3 ultimos años..."
wget -q -O /etc/postgresql/Practica1/movilidad2021.csv 'https://zaguan.unizar.es/record/107373/files/CSV.csv'
sed -i '/Máster/d; /Doctorado/d' /etc/postgresql/Practica1/movilidad2021.csv
wget -q -O /etc/postgresql/Practica1/movilidad2020.csv 'https://zaguan.unizar.es/record/95648/files/CSV.csv'
sed -i '/Máster/d; /Doctorado/d' /etc/postgresql/Practica1/movilidad2020.csv
wget -q -O /etc/postgresql/Practica1/movilidad2019.csv 'https://zaguan.unizar.es/record/83980/files/CSV.csv'
sed -i '/Máster/d; /Doctorado/d' /etc/postgresql/Practica1/movilidad2019.csv
echo "Oteniendo datos de oferta y ocupación..."
#Obtención de datos de Oferta y Ocupación de los últimos 3 años

wget -q -O /etc/postgresql/Practica1/Oferta2021.csv 'https://zaguan.unizar.es/record/108270/files/CSV.csv'
sed -i -e 's/Grado: //g' /etc/postgresql/Practica1/Oferta2021.csv
sed -i '/Máster/d; /Doctorado/d' /etc/postgresql/Practica1/Oferta2021.csv
wget -q -O /etc/postgresql/Practica1/Oferta2020.csv 'https://zaguan.unizar.es/record/96835/files/CSV.csv'
sed -i -e 's/Grado: //g' /etc/postgresql/Practica1/Oferta2020.csv
sed -i '/Máster/d; /Doctorado/d' /etc/postgresql/Practica1/Oferta2020.csv
wget -q -O /etc/postgresql/Practica1/Oferta2019.csv 'https://zaguan.unizar.es/record/87665/files/CSV.csv'
sed -i -e 's/Grado: //g' /etc/postgresql/Practica1/Oferta2019.csv
sed -i '/Máster/d; /Doctorado/d' /etc/postgresql/Practica1/Oferta2019.csv

echo "Datos obtenidos exitosamente"

echo "Obteniendo datos de resultados y titulaciones"
#Obtención de datos de Resultados de los últimos 3 años
wget -q -O /etc/postgresql/Practica1/Resultados2021.csv 'https://zaguan.unizar.es/record/107369/files/CSV.csv'
sed -i '/Grado/!d' /etc/postgresql/Practica1/Resultados2021.csv
sed -i 's/1-//g' /etc/postgresql/Practica1/Resultados2021.csv
wget -q -O /etc/postgresql/Practica1/Resultados2020.csv 'https://zaguan.unizar.es/record/95644/files/CSV.csv'
sed -i '/Grado/!d' /etc/postgresql/Practica1/Resultados2020.csv
sed -i 's/1-//g' /etc/postgresql/Practica1/Resultados2020.csv
wget -q -O /etc/postgresql/Practica1/Resultados2019.csv 'https://zaguan.unizar.es/record/76879/files/CSV.csv'
sed -i '/Grado/!d' /etc/postgresql/Practica1/Resultados2019.csv
sed -i 's/1-//g' /etc/postgresql/Practica1/Resultados2019.csv

#Obtención de datos de Egresados de los últimos 3 años
echo "Obteniendo datos de Egresados"
wget -q -O /etc/postgresql/Practica1/Egresados2021.csv 'https://zaguan.unizar.es/record/107371/files/CSV.csv'
sed -i '/Grado/!d' /etc/postgresql/Practica1/Egresados2021.csv
sed -i -e 's/Grado: //g' /etc/postgresql/Practica1/Egresados2021.csv
wget -q -O /etc/postgresql/Practica1/Egresados2020.csv 'https://zaguan.unizar.es/record/98173/files/CSV.csv'
sed -i '/Grado/!d' /etc/postgresql/Practica1/Egresados2020.csv
sed -i -e 's/Grado: //g' /etc/postgresql/Practica1/Egresados2020.csv
wget -q -O /etc/postgresql/Practica1/Egresados2019.csv 'https://zaguan.unizar.es/record/76879/files/CSV.csv'
sed -i '/Grado/!d' /etc/postgresql/Practica1/Egresados2019.csv
sed -i -e 's/Grado: //g' /etc/postgresql/Practica1/Egresados2019.csv

echo " Cargando datos en la base de datos..."
#Creación de la base de datos resultadosofertaacademica 

psql -U postgres  -c"DROP DATABASE IF EXISTS resultadosofertaacademica;"
psql -U postgres  -c"CREATE DATABASE  resultadosofertaacademica OWNER postgres;"
#Creación de 3 tablas para los años 2019, 2020 y 2021 y se añaden los datos de sus correspondientes CSV
psql -U postgres resultadosofertaacademica -c "CREATE TABLE NotasCorte2019(CURSO_ACADEMICO SMALLINT, ESTUDIO VARCHAR(100), LOCALIDAD VARCHAR(30), CENTRO VARCHAR(100), PRELA_CONVO_NOTA_DEF CHAR(2), NOTA_CORTE_DEFINITIVA_JULIO  float(3), NOTA_CORTE_DEFINITIVA_SEPTIEMBRE float(3), FECHA_ACTUALIZACION DATE);"
psql -U postgres resultadosofertaacademica -c "COPY NotasCorte2019 FROM '/etc/postgresql/Practica1/notasCorte2019.csv' DELIMITER ';'CSV HEADER;"

psql -U postgres resultadosofertaacademica -c "CREATE TABLE NotasCorte2020(CURSO_ACADEMICO SMALLINT, ESTUDIO VARCHAR(100), LOCALIDAD VARCHAR(30), CENTRO VARCHAR(100), PRELA_CONVO_NOTA_DEF CHAR(2), NOTA_CORTE_DEFINITIVA_JULIO  float(3), NOTA_CORTE_DEFINITIVA_SEPTIEMBRE float(3), FECHA_ACTUALIZACION DATE);"
psql -U postgres resultadosofertaacademica -c "COPY NotasCorte2020 FROM '/etc/postgresql/Practica1/notasCorte2020.csv' DELIMITER ';'CSV HEADER;"

psql -U postgres resultadosofertaacademica -c "CREATE TABLE NotasCorte2021(CURSO_ACADEMICO SMALLINT, ESTUDIO VARCHAR(100), LOCALIDAD VARCHAR(30), CENTRO VARCHAR(100), PRELA_CONVO_NOTA_DEF CHAR(2), NOTA_CORTE_DEFINITIVA_JULIO  float(3), NOTA_CORTE_DEFINITIVA_SEPTIEMBRE float(3), FECHA_ACTUALIZACION DATE);"
psql -U postgres resultadosofertaacademica -c "COPY NotasCorte2021 FROM '/etc/postgresql/Practica1/notasCorte2021.csv' DELIMITER ';'CSV HEADER;"

echo " Datos cargados exitosamente"


#Carga de datos de movilidad a la base de datos resultadosofertaacademica
psql -U postgres resultadosofertaacademica -c "CREATE TABLE movilidad2019(CURSO_ACADEMICO SMALLINT, NOMBRE_PROGRAMA_MOVILIDAD VARCHAR(8), NOMBRE_AREA_ESTUDIOS_MOV VARCHAR, CENTRO VARCHAR(100), IN_OUT VARCHAR(4), NOMBRE_IDIOMA_NIVEL_MOVILIDAD VARCHAR(40), PAIS_UNIVERSIDAD_ACUERDO VARCHAR(30), UNIVERSIDAD_ACUERDO VARCHAR, PLAZAS_OFERTADAS_ALUMNOS INT, PLAZAS_ASIGNADAS_ALUMNO_OUT SMALLINT, FECHA_ACTUALIZACION DATE);"
psql -U postgres resultadosofertaacademica -c "COPY movilidad2019 FROM '/etc/postgresql/Practica1/movilidad2019.csv' DELIMITER ';' CSV HEADER;"

psql -U postgres resultadosofertaacademica -c "CREATE TABLE movilidad2020(CURSO_ACADEMICO SMALLINT, NOMBRE_PROGRAMA_MOVILIDAD VARCHAR(8), NOMBRE_AREA_ESTUDIOS_MOV VARCHAR, CENTRO VARCHAR(100), IN_OUT VARCHAR(4), NOMBRE_IDIOMA_NIVEL_MOVILIDAD VARCHAR(40), PAIS_UNIVERSIDAD_ACUERDO VARCHAR(30), UNIVERSIDAD_ACUERDO VARCHAR, PLAZAS_OFERTADAS_ALUMNOS INT, PLAZAS_ASIGNADAS_ALUMNO_OUT SMALLINT, FECHA_ACTUALIZACION DATE);"
psql -U postgres resultadosofertaacademica -c "COPY movilidad2020 FROM '/etc/postgresql/Practica1/movilidad2020.csv' DELIMITER ';' CSV HEADER;"

psql -U postgres resultadosofertaacademica -c "CREATE TABLE movilidad2021(CURSO_ACADEMICO SMALLINT, NOMBRE_PROGRAMA_MOVILIDAD VARCHAR(8), NOMBRE_AREA_ESTUDIOS_MOV VARCHAR, CENTRO VARCHAR(100), IN_OUT VARCHAR(4), NOMBRE_IDIOMA_NIVEL_MOVILIDAD VARCHAR(40), PAIS_UNIVERSIDAD_ACUERDO VARCHAR(30), UNIVERSIDAD_ACUERDO VARCHAR, PLAZAS_OFERTADAS_ALUMNOS INT, PLAZAS_ASIGNADAS_ALUMNO_OUT SMALLINT, FECHA_ACTUALIZACION DATE);"
psql -U postgres resultadosofertaacademica -c "COPY movilidad2021 FROM '/etc/postgresql/Practica1/movilidad2021.csv' DELIMITER ';' CSV HEADER;"

echo "Datos de movilidad cargados exitosamente en la base de datos"




echo " se van a cargar los datos de Oferta y ocupación a la base de datos"
#Carga de datos de oferta y ocypación el a base de datos resultadosofertaacademica
psql -U postgres  resultadosofertaacademica -c "CREATE TABLE Oferta_Ocupacion2019(CURSO_ACADEMICO SMALLINT, ESTUDIO VARCHAR(150), LOCALIDAD VARCHAR(30), CENTRO VARCHAR(100),TIPO_CENTRO VARCHAR(25), TIPO_ESTUDIO VARCHAR(15), PLAZAS SMALLINT, PLAZAS_MATRICULADAS SMALLINT, PLAZAS_SOLICITADAS INT, INDICE_OCUPACION FLOAT, FECHA_ACTUALIZACION DATE);"
psql -U postgres resultadosofertaacademica -c "COPY Oferta_Ocupacion2019 FROM '/etc/postgresql/Practica1/Oferta2019.csv' DELIMITER ';'CSV HEADER;"

psql -U postgres  resultadosofertaacademica -c "CREATE TABLE Oferta_Ocupacion2020(CURSO_ACADEMICO SMALLINT, ESTUDIO VARCHAR(150), LOCALIDAD VARCHAR(30), CENTRO VARCHAR(100),TIPO_CENTRO VARCHAR(25), TIPO_ESTUDIO VARCHAR(15), PLAZAS SMALLINT, PLAZAS_MATRICULADAS SMALLINT, PLAZAS_SOLICITADAS INT, INDICE_OCUPACION FLOAT, FECHA_ACTUALIZACION DATE);"
psql -U postgres resultadosofertaacademica -c "COPY Oferta_Ocupacion2020 FROM '/etc/postgresql/Practica1/Oferta2020.csv' DELIMITER ';'CSV HEADER;"

psql -U postgres  resultadosofertaacademica -c "CREATE TABLE Oferta_Ocupacion2021(CURSO_ACADEMICO SMALLINT, ESTUDIO VARCHAR(150), LOCALIDAD VARCHAR(30), CENTRO VARCHAR(100),TIPO_CENTRO VARCHAR(25), TIPO_ESTUDIO VARCHAR(15), PLAZAS SMALLINT, PLAZAS_MATRICULADAS SMALLINT, PLAZAS_SOLICITADAS INT, INDICE_OCUPACION FLOAT, FECHA_ACTUALIZACION DATE);"
psql -U postgres resultadosofertaacademica -c "COPY Oferta_Ocupacion2021 FROM '/etc/postgresql/Practica1/Oferta2021.csv' DELIMITER ';'CSV HEADER;"

echo "datos de oferta y ocupación cargados en la base de datos"


#Carga de datos resltados a la base de datos resultadosofertaacademica
echo "Cargando datos a la base de datos..."
psql -U postgres  resultadosofertaacademica -c "CREATE TABLE Resultados2021(CURSO_ACADEMICO SMALLINT,CENTRO VARCHAR(100), ESTUDIO VARCHAR(150),TIPO_ESTUDIO VARCHAR(50), ALUMNOS_MATRICULADOS SMALLINT, ALUMNOS_NUEVO_INGRESO SMALLINT, PLAZAS_OFERTADAS SMALLINT, ALUMNOS_GRADUADOS INT,ALUMNOS_ADAPTA_GRADO_MATRI INT, ALUMNOS_ADAPTA_GRADO_MATRI_NI INT, ALUMNOS_ADAPTA_GRADO_TITULADO INT, ALUMNOS_CON_RECONOCIMIENTO INT, ALUMNOS_MOVILIDAD_ENTRADA INT, ALUMNOS_MOVILIDAD_SALIDA INT, CREDITOS_MATRICULADOS FLOAT, CREDITOS_RECONOCIDOS FLOAT, DURACION_MEDIA_GRADUADOS FLOAT, TASA_EXITO FLOAT, TASA_RENDIMIENTO FLOAT, TASA_EFICIENCIA FLOAT, TASA_ABANDONO FLOAT, TASA_GRADUACION INT, FECHA_ACTUALIZACION DATE);"
psql -U postgres resultadosofertaacademica -c "COPY Resultados2021 FROM '/etc/postgresql/Practica1/Resultados2021.csv' DELIMITER ';'CSV HEADER;"
psql -U postgres  resultadosofertaacademica -c "CREATE TABLE Resultados2020(CURSO_ACADEMICO SMALLINT,CENTRO VARCHAR(100), ESTUDIO VARCHAR(150),TIPO_ESTUDIO VARCHAR(50), ALUMNOS_MATRICULADOS SMALLINT, ALUMNOS_NUEVO_INGRESO SMALLINT, PLAZAS_OFERTADAS SMALLINT, ALUMNOS_GRADUADOS INT,ALUMNOS_ADAPTA_GRADO_MATRI INT, ALUMNOS_ADAPTA_GRADO_MATRI_NI INT, ALUMNOS_ADAPTA_GRADO_TITULADO INT, ALUMNOS_CON_RECONOCIMIENTO INT, ALUMNOS_MOVILIDAD_ENTRADA INT, ALUMNOS_MOVILIDAD_SALIDA INT, CREDITOS_MATRICULADOS FLOAT, CREDITOS_RECONOCIDOS FLOAT, DURACION_MEDIA_GRADUADOS FLOAT, TASA_EXITO FLOAT, TASA_RENDIMIENTO FLOAT, TASA_EFICIENCIA FLOAT, TASA_ABANDONO FLOAT, TASA_GRADUACION INT, FECHA_ACTUALIZACION DATE);"
psql -U postgres resultadosofertaacademica -c "COPY Resultados2020 FROM '/etc/postgresql/Practica1/Resultados2020.csv' DELIMITER ';'CSV HEADER;"
psql -U postgres  resultadosofertaacademica -c "CREATE TABLE Resultados2019(CURSO_ACADEMICO SMALLINT,CENTRO VARCHAR(100), ESTUDIO VARCHAR(150),TIPO_ESTUDIO VARCHAR(50), ALUMNOS_MATRICULADOS SMALLINT, ALUMNOS_NUEVO_INGRESO SMALLINT, PLAZAS_OFERTADAS SMALLINT, ALUMNOS_GRADUADOS INT,ALUMNOS_ADAPTA_GRADO_MATRI INT, ALUMNOS_ADAPTA_GRADO_MATRI_NI INT, ALUMNOS_ADAPTA_GRADO_TITULADO INT, ALUMNOS_CON_RECONOCIMIENTO INT, ALUMNOS_MOVILIDAD_ENTRADA INT, ALUMNOS_MOVILIDAD_SALIDA INT, CREDITOS_MATRICULADOS FLOAT, CREDITOS_RECONOCIDOS FLOAT, DURACION_MEDIA_GRADUADOS FLOAT, TASA_EXITO FLOAT, TASA_RENDIMIENTO FLOAT, TASA_EFICIENCIA FLOAT, TASA_ABANDONO FLOAT, TASA_GRADUACION FLOAT, FECHA_ACTUALIZACION DATE);"
psql -U postgres resultadosofertaacademica -c "COPY Resultados2019 FROM '/etc/postgresql/Practica1/Resultados2019.csv' DELIMITER ';'CSV HEADER;"


#Carga de datos resltados a la base de datos resultadosofertaacademica
echo "Cargando datos a la base de datos..."
psql -U postgres  resultadosofertaacademica -c "CREATE TABLE Egresados2021(CURSO_ACADEMICO SMALLINT,LOCALIDAD VARCHAR(100), ESTUDIO VARCHAR(150),TIPO_ESTUDIO VARCHAR(50), TIPO_EGRESO VARCHAR(70), SEXO VARCHAR(10), ALUMNOS_GRADUADOS SMALLINT, ALUMNOS_INTERRUMPEN_ESTUDIOS INT, ALUMNOS_INTERRUMPEN_EST_ANO1 INT, ALUMNOS_TRASLADAN_OTRA_UNIV INT , DURACION_mEDIA_GRADUADOS FLOAT, TASA_EFIENCIA FLOAT, FECHA_ACTUALIZACION DATE);"
psql -U postgres resultadosofertaacademica -c "COPY Egresados2021 FROM '/etc/postgresql/Practica1/Egresados2021.csv' DELIMITER ';'CSV HEADER;"

psql -U postgres  resultadosofertaacademica -c "CREATE TABLE Egresados2020(CURSO_ACADEMICO SMALLINT,LOCALIDAD VARCHAR(100), ESTUDIO VARCHAR(150),TIPO_ESTUDIO VARCHAR(50), TIPO_EGRESO VARCHAR(70), SEXO VARCHAR(10), ALUMNOS_GRADUADOS SMALLINT, ALUMNOS_INTERRUMPEN_ESTUDIOS INT, ALUMNOS_INTERRUMPEN_EST_ANO1 INT, ALUMNOS_TRASLADAN_OTRA_UNIV INT , DURACION_mEDIA_GRADUADOS FLOAT, TASA_EFIENCIA FLOAT, FECHA_ACTUALIZACION DATE);"
psql -U postgres resultadosofertaacademica -c "COPY Egresados2020 FROM '/etc/postgresql/Practica1/Egresados2021.csv' DELIMITER ';'CSV HEADER;"

psql -U postgres  resultadosofertaacademica -c "CREATE TABLE Egresados2019(CURSO_ACADEMICO SMALLINT,LOCALIDAD VARCHAR(100), ESTUDIO VARCHAR(150),TIPO_ESTUDIO VARCHAR(50), TIPO_EGRESO VARCHAR(70), SEXO VARCHAR(10), ALUMNOS_GRADUADOS SMALLINT, ALUMNOS_INTERRUMPEN_ESTUDIOS INT, ALUMNOS_INTERRUMPEN_EST_ANO1 INT, ALUMNOS_TRASLADAN_OTRA_UNIV INT , DURACION_mEDIA_GRADUADOS FLOAT, TASA_EFIENCIA FLOAT, FECHA_ACTUALIZACION DATE);"
psql -U postgres resultadosofertaacademica -c "COPY Egresados2019 FROM '/etc/postgresql/Practica1/Egresados2021.csv' DELIMITER ';'CSV HEADER;"


psql resultadosofertaacademica -c "CREATE TABLE Estudio (
    nombre_estudio varchar(100) NULL,
    PRIMARY KEY(nombre_estudio)
);"

echo "Cargando datos en la tabla ESTUDIO"
psql resultadosofertaacademica -c "INSERT INTO estudio(nombre_estudio) SELECT distinct ESTUDIO FROM oferta_ocupacion2021;"
psql resultadosofertaacademica -c "INSERT INTO estudio(nombre_estudio) SELECT distinct ESTUDIO FROM oferta_ocupacion2020 WHERE ESTUDIO NOT IN(SELECT nombre_estudio FROM ESTUDIO);"
psql resultadosofertaacademica -c "INSERT INTO estudio(nombre_estudio) SELECT distinct ESTUDIO FROM oferta_ocupacion2019 WHERE ESTUDIO NOT IN(SELECT nombre_estudio FROM ESTUDIO);"
echo "Datos cargados en la tabla ESTUDIO"
echo "\n"

psql resultadosofertaacademica -c "CREATE TABLE Centro (
    nombre_centro varchar(100) NULL,
    tipo_centro varchar(50) NULL,
    localidad varchar(50) NULL,
    PRIMARY KEY(nombre_centro)
);"
psql resultadosofertaacademica -c "INSERT INTO Centro(nombre_centro, tipo_centro, localidad) SELECT distinct CENTRO, TIPO_CENTRO, LOCALIDAD FROM oferta_ocupacion2021;"

psql resultadosofertaacademica -c "CREATE TABLE Impartido (
    id_impartido SERIAL,
    curso smallint,
    nombre_estudio varchar(100)  ,    
    nombre_centro varchar(100) ,
    plazas_ofertadas smallint NULL,
    plazas_matriculadas smallint NULL,
    plazas_solicitadas int NULL,
    alumnos_nuevo_ingreso smallint NULL,
    nota_corte_julio float NULL,
    nota_corte_septiembre float NULL,
    alumnos_graduados smallint NULL,
    alumnos_adapta_grado_matri smallint NULL,
    alumnos_adapta_grado_matri_ni smallint NULL,
    alumnos_adapta_grado_titulado smallint NULL,
    alumnos_con_reconocimiento smallint NULL,  
    alumnos_movilidad_entrada smallint NULL,
    alumnos_movilidad_salida smallint NULL,
    creditos_matriculados float NULL,
    creditos_reconocidos float NULL,
    duracion_media_graduados float NULL,
    egresados_voluntarios smallint NULL,
    indice_ocupacion float NULL,
    tasa_exito float NULL,
    tasa_rendimiento float NULL,
    tasa_abandono float NULL,
    tasa_graduacion float NULL,
    localidad varchar(30) NULL,
    PRIMARY KEY (id_impartido),
    FOREIGN KEY (nombre_centro) REFERENCES Centro(nombre_centro)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (nombre_estudio) REFERENCES Estudio(nombre_estudio)
    ON DELETE CASCADE ON UPDATE CASCADE
    
);"

#Copiar los datos de las tablas temporales a las definitivas

#Curso 2021
echo " Cargando datos en la relancion IMPARTIDO"
psql resultadosofertaacademica -c " WITH temporal(localidad, estudio, abandonos) AS(
                                        SELECT localidad, estudio, SUM(ALUMNOS_INTERRUMPEN_eSTUDIOS) 
                                        FROM Egresados2021
                                        WHERE TIPO_EGRESO='Abandono Voluntario'
                                        GROUP BY (Localidad,ESTUDIO)),
                                    temporalB(estudio, localidad, Centro, abandonos) as  
                                        (SELECT distinct temporal.estudio, temporal.localidad, Centro, abandonos
                                        FROM temporal INNER JOIN oferta_ocupacion2021 ON temporal.localidad = oferta_ocupacion2021.localidad AND 
                                        temporal.estudio=oferta_ocupacion2021.estudio)
                                    INSERT INTO Impartido  (curso, nombre_estudio, nombre_centro, plazas_matriculadas,alumnos_nuevo_ingreso, 
                                    creditos_matriculados,creditos_reconocidos, alumnos_graduados, alumnos_adapta_grado_matri, 
                                    alumnos_adapta_grado_matri_ni, alumnos_adapta_grado_titulado, alumnos_movilidad_entrada, 
                                    alumnos_movilidad_salida, duracion_media_graduados, tasa_exito, tasa_rendimiento, tasa_abandono, tasa_graduacion,
                                    plazas_ofertadas, plazas_solicitadas, indice_ocupacion, nota_corte_julio, nota_corte_septiembre, egresados_voluntarios, localidad)
                                    SELECT Resultados2021.CURSO_ACADEMICO, Resultados2021.ESTUDIO, Resultados2021.CENTRO, ALUMNOS_MATRICULADOS, ALUMNOS_NUEVO_INGRESO,CREDITOS_MATRICULADOS ,
                                            CREDITOS_RECONOCIDOS, Resultados2021.ALUMNOS_GRADUADOS, ALUMNOS_ADAPTA_GRADO_MATRI, ALUMNOS_ADAPTA_GRADO_MATRI_NI, ALUMNOS_ADAPTA_GRADO_TITULADO,
                                            ALUMNOS_MOVILIDAD_ENTRADA, ALUMNOS_MOVILIDAD_SALIDA, DURACION_MEDIA_GRADUADOS, TASA_EXITO, TASA_RENDIMIENTO, TASA_ABANDONO, TASA_GRADUACION,
                                            PLAZAS, PLAZAS_SOLICITADAS, INDICE_OCUPACION, notas.NOTA_CORTE_DEFINITIVA_JULIO, notas.NOTA_CORTE_DEFINITIVA_SEPTIEMBRE, abandonos, oferta.localidad
                                    FROM Resultados2021 INNER JOIN oferta_ocupacion2021 oferta ON 
                                         Resultados2021.ESTUDIO = oferta.ESTUDIO AND Resultados2021.CENTRO=oferta.CENTRO INNER JOIN notasCorte2021 notas ON
                                         oferta.ESTUDIO = notas.ESTUDIO AND oferta.CENTRO = notas.CENTRO INNER JOIN temporalB ON 
                                         temporalB.ESTUDIO = notas.ESTUDIO AND temporalB.Centro = notas.Centro 
                                    WHERE ALUMNOS_MATRICULADOS IS NOT NULL; "


#Curso 2020
psql resultadosofertaacademica -c " WITH temporal(localidad, estudio, abandonos) AS(
                                        SELECT localidad, estudio, SUM(ALUMNOS_INTERRUMPEN_eSTUDIOS) 
                                        FROM Egresados2020
                                        WHERE TIPO_EGRESO='Abandono Voluntario'
                                        GROUP BY (Localidad,ESTUDIO)),
                                    temporalB(estudio, localidad, Centro, abandonos) as  
                                        (SELECT distinct temporal.estudio, temporal.localidad, Centro, abandonos
                                        FROM temporal INNER JOIN oferta_ocupacion2020 ON temporal.localidad = oferta_ocupacion2020.localidad AND 
                                        temporal.estudio=oferta_ocupacion2020.estudio)
                                    INSERT INTO Impartido  (curso, nombre_estudio, nombre_centro, plazas_matriculadas,alumnos_nuevo_ingreso, 
                                    creditos_matriculados,creditos_reconocidos, alumnos_graduados, alumnos_adapta_grado_matri, 
                                    alumnos_adapta_grado_matri_ni, alumnos_adapta_grado_titulado, alumnos_movilidad_entrada, 
                                    alumnos_movilidad_salida, duracion_media_graduados, tasa_exito, tasa_rendimiento, tasa_abandono, tasa_graduacion,
                                    plazas_ofertadas, plazas_solicitadas, indice_ocupacion, nota_corte_julio, nota_corte_septiembre, egresados_voluntarios, localidad)
                                    SELECT Resultados2020.CURSO_ACADEMICO, Resultados2020.ESTUDIO, Resultados2020.CENTRO, ALUMNOS_MATRICULADOS, ALUMNOS_NUEVO_INGRESO,CREDITOS_MATRICULADOS ,
                                            CREDITOS_RECONOCIDOS, Resultados2020.ALUMNOS_GRADUADOS, ALUMNOS_ADAPTA_GRADO_MATRI, ALUMNOS_ADAPTA_GRADO_MATRI_NI, ALUMNOS_ADAPTA_GRADO_TITULADO,
                                            ALUMNOS_MOVILIDAD_ENTRADA, ALUMNOS_MOVILIDAD_SALIDA, DURACION_MEDIA_GRADUADOS, TASA_EXITO, TASA_RENDIMIENTO, TASA_ABANDONO, TASA_GRADUACION,
                                            PLAZAS, PLAZAS_SOLICITADAS, INDICE_OCUPACION, notas.NOTA_CORTE_DEFINITIVA_JULIO, notas.NOTA_CORTE_DEFINITIVA_SEPTIEMBRE, abandonos, oferta.localidad
                                    FROM Resultados2020 INNER JOIN oferta_ocupacion2020 oferta ON 
                                         Resultados2020.ESTUDIO = oferta.ESTUDIO AND Resultados2020.CENTRO=oferta.CENTRO INNER JOIN notasCorte2020 notas ON
                                         oferta.ESTUDIO = notas.ESTUDIO AND oferta.CENTRO = notas.CENTRO INNER JOIN temporalB ON 
                                         temporalB.ESTUDIO = notas.ESTUDIO AND temporalB.Centro = notas.Centro 
                                    WHERE ALUMNOS_MATRICULADOS IS NOT NULL; "

#Curso 2019
psql resultadosofertaacademica -c " WITH temporal(localidad, estudio, abandonos) AS(
                                        SELECT localidad, estudio, SUM(ALUMNOS_INTERRUMPEN_eSTUDIOS) 
                                        FROM Egresados2019
                                        WHERE TIPO_EGRESO='Abandono Voluntario'
                                        GROUP BY (Localidad,ESTUDIO)),
                                    temporalB(estudio, localidad, Centro, abandonos) as  
                                        (SELECT distinct temporal.estudio, temporal.localidad, Centro, abandonos
                                        FROM temporal INNER JOIN oferta_ocupacion2019 ON temporal.localidad = oferta_ocupacion2019.localidad AND 
                                        temporal.estudio=oferta_ocupacion2019.estudio)
                                    INSERT INTO Impartido  (curso, nombre_estudio, nombre_centro, plazas_matriculadas,alumnos_nuevo_ingreso, 
                                    creditos_matriculados,creditos_reconocidos, alumnos_graduados, alumnos_adapta_grado_matri, 
                                    alumnos_adapta_grado_matri_ni, alumnos_adapta_grado_titulado, alumnos_movilidad_entrada, 
                                    alumnos_movilidad_salida, duracion_media_graduados, tasa_exito, tasa_rendimiento, tasa_abandono, tasa_graduacion,
                                    plazas_ofertadas, plazas_solicitadas, indice_ocupacion, nota_corte_julio, nota_corte_septiembre, egresados_voluntarios, localidad)
                                    SELECT Resultados2019.CURSO_ACADEMICO, Resultados2019.ESTUDIO, Resultados2019.CENTRO, ALUMNOS_MATRICULADOS, ALUMNOS_NUEVO_INGRESO,CREDITOS_MATRICULADOS ,
                                            CREDITOS_RECONOCIDOS, Resultados2019.ALUMNOS_GRADUADOS, ALUMNOS_ADAPTA_GRADO_MATRI, ALUMNOS_ADAPTA_GRADO_MATRI_NI, ALUMNOS_ADAPTA_GRADO_TITULADO,
                                            ALUMNOS_MOVILIDAD_ENTRADA, ALUMNOS_MOVILIDAD_SALIDA, DURACION_MEDIA_GRADUADOS, TASA_EXITO, TASA_RENDIMIENTO, TASA_ABANDONO, TASA_GRADUACION,
                                            PLAZAS, PLAZAS_SOLICITADAS, INDICE_OCUPACION, notas.NOTA_CORTE_DEFINITIVA_JULIO, notas.NOTA_CORTE_DEFINITIVA_SEPTIEMBRE, abandonos, oferta.localidad
                                    FROM Resultados2019 INNER JOIN oferta_ocupacion2019 oferta ON 
                                         Resultados2019.ESTUDIO = oferta.ESTUDIO AND Resultados2019.CENTRO=oferta.CENTRO INNER JOIN notasCorte2019 notas ON
                                         oferta.ESTUDIO = notas.ESTUDIO AND oferta.CENTRO = notas.CENTRO INNER JOIN temporalB ON 
                                         temporalB.ESTUDIO = notas.ESTUDIO AND temporalB.Centro = notas.Centro 
                                    WHERE ALUMNOS_MATRICULADOS IS NOT NULL; "

echo " Datos cargados en la relancion IMPARTIDO"
echo "\n"


psql resultadosofertaacademica -c " CREATE TABLE Localidad (
    nombre_localidad varchar(100),
    PRIMARY KEY(nombre_localidad) 
);"
echo "Cargando datos en la tabla LOCALIDAD"
psql resultadosofertaacademica -c "INSERT INTO Localidad (nombre_localidad) SELECT distinct Localidad FROM oferta_ocupacion2021;"
echo "Datos cargados en la tabla LOCALIDAD"
echo "\n"

psql resultadosofertaacademica -c " CREATE TABLE Pais (
    nombre_pais varchar(100),
    PRIMARY KEY(nombre_pais) 
);"

echo "Cargando datos en la tabla PAIS" 
psql resultadosofertaacademica -c "INSERT INTO Pais (nombre_pais) SELECT distinct PAIS_UNIVERSIDAD_ACUERDO FROM Movilidad2021;"
echo "Datos cargados en la tabla PAIS"
echo "\n"

psql resultadosofertaacademica -c " CREATE TABLE Movilidad (
    nombre_movilidad varchar(50),
    PRIMARY KEY(nombre_movilidad)
);"
echo "Cargando datos en la tabla MOVILIDAD" 
psql resultadosofertaacademica -c "INSERT INTO Movilidad (nombre_movilidad) SELECT distinct NOMBRE_PROGRAMA_MOVILIDAD FROM Movilidad2021;"
echo "Datos cargados en la tabla MOVILIDAD"
echo "\n"

psql resultadosofertaacademica -c " CREATE TABLE Realiza (
    id_realizar INT SERIAL,
    curso smallint,
    nombre_movilidad varchar(100),
    nombre_centro varchar(100),
    nombre_pais varchar(100) ,
    area_estudios varchar(100) NULL,
    in_out varchar(4) NULL,
    nombre_idioma varchar(50),
    universidad_destino varchar(100),
    plazas_ofertadas smallint,
    plazas_asignadas smallint,
    FOREIGN KEY (nombre_movilidad) REFERENCES Movilidad(nombre_movilidad)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (nombre_pais) REFERENCES Pais(nombre_pais)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (nombre_centro) REFERENCES Centro(nombre_centro)
    ON DELETE CASCADE ON UPDATE CASCADE
  );"

echo "Cargando datos en la relacion REALIZA" 
psql resultadosofertaacademica -c "INSERT INTO Realiza (curso, nombre_movilidad, nombre_centro, nombre_pais, area_estudios,
                                                 in_out, nombre_idioma, universidad_destino, plazas_ofertadas, plazas_asignadas)
                                    SELECT CURSO_ACADEMICO, NOMBRE_PROGRAMA_MOVILIDAD, CENTRO, PAIS_UNIVERSIDAD_ACUERDO, NOMBRE_AREA_ESTUDIOS_MOV,
                                             IN_OUT, NOMBRE_IDIOMA_NIVEL_MOVILIDAD, UNIVERSIDAD_ACUERDO, PLAZAS_OFERTADAS_ALUMNOS, PLAZAS_ASIGNADAS_ALUMNO_OUT
                                    FROM Movilidad2021;"
psql resultadosofertaacademica -c "INSERT INTO Realiza (curso, nombre_movilidad, nombre_centro, nombre_pais, area_estudios,
                                                 in_out, nombre_idioma, universidad_destino, plazas_ofertadas, plazas_asignadas)
                                    SELECT CURSO_ACADEMICO, NOMBRE_PROGRAMA_MOVILIDAD, CENTRO, PAIS_UNIVERSIDAD_ACUERDO, NOMBRE_AREA_ESTUDIOS_MOV,
                                             IN_OUT, NOMBRE_IDIOMA_NIVEL_MOVILIDAD, UNIVERSIDAD_ACUERDO, PLAZAS_OFERTADAS_ALUMNOS, PLAZAS_ASIGNADAS_ALUMNO_OUT
                                    FROM Movilidad2020;"
psql resultadosofertaacademica -c "INSERT INTO Realiza (curso, nombre_movilidad, nombre_centro, nombre_pais, area_estudios,
                                                 in_out, nombre_idioma, universidad_destino, plazas_ofertadas, plazas_asignadas)
                                    SELECT CURSO_ACADEMICO, NOMBRE_PROGRAMA_MOVILIDAD, CENTRO, PAIS_UNIVERSIDAD_ACUERDO, NOMBRE_AREA_ESTUDIOS_MOV,
                                             IN_OUT, NOMBRE_IDIOMA_NIVEL_MOVILIDAD, UNIVERSIDAD_ACUERDO, PLAZAS_OFERTADAS_ALUMNOS, PLAZAS_ASIGNADAS_ALUMNO_OUT
                                    FROM Movilidad2019;"

#Eliminar las tablas con las notas de corte
psql resultadosofertaacademica -c "DROP TABLE notasCorte2019;"
psql resultadosofertaacademica -c "DROP TABLE notasCorte2020;"
psql resultadosofertaacademica -c "DROP TABLE notasCorte2021;"
#Elminar las tablas Resultados de las titulaciones
psql resultadosofertaacademica -c "DROP TABLE Resultados2019;"
psql resultadosofertaacademica -c "DROP TABLE Resultados2020;"
psql resultadosofertaacademica -c "DROP TABLE Resultados2021;"
#Elminar las tablas de Movilidad de estudiantes
psql resultadosofertaacademica -c "DROP TABLE Movilidad2019;"
psql resultadosofertaacademica -c "DROP TABLE Movilidad2020;"
psql resultadosofertaacademica -c "DROP TABLE Movilidad2021;"
#Eliminar las tablas de egresados
psql resultadosofertaacademica -c "DROP TABLE Egresados2019;"
psql resultadosofertaacademica -c "DROP TABLE Egresados2020;"
psql resultadosofertaacademica -c "DROP TABLE Egresados2021;"
#elminar las tablas de oferta y ocupacion
psql resultadosofertaacademica -c "DROP TABLE oferta_ocupacion2019;"
psql resultadosofertaacademica -c "DROP TABLE oferta_ocupacion2020;"
psql resultadosofertaacademica -c "DROP TABLE oferta_ocupacion2021;"

psql resultadosofertaacademica -c "CREATE TABLE filas_modificadas (
                                        Id_modificacion SERIAL,
                                        CP_afectada Varchar(100),
                                        operacion Varchar(50),
                                        usuario varchar(50),
                                        fecha DATE,
                                        PRIMARY KEY (Id_modificacion));"
psql resultadosofertaacademica -c "CREATE OR REPLACE FUNCTION cambio_tabla_impartido() RETURNS TRIGGER
                                    AS $\$

                                    BEGIN
                                        INSERT INTO filas_modificadas(CP_afectada, operacion, usuario, fecha) 
                                                VALUES (OLD.id_impartido, TG_OP , Session_USER,  current_timestamp);                    
                                        RETURN NEW;
                                    END;
                                    $\$ LANGUAGE plpgsql;"

 psql resultadosofertaacademica -c " CREATE TRIGGER registrar_operaciones 
                                        AFTER UPDATE OR DELETE 
                                        ON Impartido
                                        FOR EACH ROW
                                        EXECUTE FUNCTION cambio_tabla_impartido();"
psql resultadosofertaacademica -c " CREATE USER profesor WITH ENCRYPTED PASSWORD 'lol';"
psql resultadosofertaacademica -c "  GRANT CONNECT ON DATABASE resultadosofertaacademica TO profesor;"
psql resultadosofertaacademica -c " GRANT SELECT ON ALL TABLES IN SCHEMA public TO profesor;"


#SELECT Indice_ocupacion,  Localidad, nombre_estudio 
#FROM ( select *, ROW_NUMBER() OVER (PARTITION BY Localidad, curso ORDER BY INDICE_OCUPACION DESC) AS aux 
#       FROM Impartido) AS temporal 
#WHERE aux<3 order by localidad;

#SELECT nombre_centro, universidad_destino, plazas_asignadas 
#FROM  (SELECT nombre_centro, universidad_destino, plazas_asignadas, ROW_NUMBER() OVER(PARTITION BY nombre_centro ORDER BY plazas_asignadas DESC)ranking
#        FROM Realiza 
#        WHERE curso='2021' AND in_out LIKE 'IN')aux 
#WHERE ranking = 1;
