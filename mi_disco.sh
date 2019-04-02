#!/bin/bash

#
#  Archivo con el código asociado a la gestión de Disco
#

informacion_inicial_discos()
{    
	clear
	echo "----------------------------------------------------------------"    
	echo "----------------------------------------------------------------" 	
   echo -e " \t Ha seleccionado la opción GESTIONAR DISCO"
   echo "----------------------------------------------------------------" 	 
   echo "----------------------------------------------------------------" 
}


gestionar_discos()
{    
    	
    fdisk -l | grep "/dev/sdb" > /dev/null 2>&1
if [ $? -gt 0 ]; then
   echo No existe el dispositivo a montar
   exit 2
fi

# Ejecuta un comando que devuelva el tamaño en GB del segundo disco duro
# El comando deberás incluirlo entre `` dentro de la variable denominada size
size=`fdisk -l | grep sdb | tr -s " " | cut -d " " -f 3`
if [ $size -le 5 ]; then
   echo El disco debe ser mayor que 5
   exit 3
fi

# Desmontamos la primera y segunda partición por si previamente existen
# Redirigimos la salida de error a /dev/null para que no nos muestre un error en el caso de que no existan
umount /dev/sdb1 > /dev/null 2>&1

umount /dev/sdb2 > /dev/null 2>&1


# Ahora en las líneas entre los dos EOF debes incluir todas las opciones necesarias para crear dos particiones
# La primera es de 5 GB y la segunda con la opción por defecto
# Puedes probar antes ejecutando el comando de forma interactiva 
fdisk /dev/sdb <<EOF
n
p
1

+5G
w
EOF
fdisk /dev/sdb <<EOF
n
p
2


w
EOF
# Comprobamos que se han creado las dos particiones 
fdisk -l | grep "/dev/sdb1"
if [ $? -ne 0 ]
then 
	echo "no se ha encontrado /dev/sdb1"
	exit 4
fi
fdisk -l | grep "/dev/sdb2"
if [ $? -ne 0 ]
then 
	echo "no se ha encontrado /dev/sdb2"
	exit 5
fi
# Ahora formateamos los discos duros y los montamos
echo "formateando particion1 a ext4"
mkfs.ext4 /dev/sdb1
echo "formateando particion2 a ext4"
mkfs.ext4 /dev/sdb2
# Cuando creamos la carpeta de montaje es recomendable redirigir la salida de error a /dev/null
# Esto se hace porque si se ejecuta el script varias veces y las carpetas existen, así ocultamos el error
echo "creando puntos de montaje"
mkdir -p ./mnt/disco_1 > /dev/null 2>&1
mkdir -p ./mnt/disco_2 > /dev/null 2>&1


echo "montando los discos"
mount -t ext4 /dev/sdb1 ./mnt/disco_1 > /dev/null 2>&1
mount -t ext4 /dev/sdb2 ./mnt/disco_2 > /dev/null 2>&1


# Añadimos los nuevos discos duros a /etc/fstab, aunque antes borramos la información que pueda haber antes en este fichero
# Para ello redirigimos a un fichero temporal todo el contenido de /etc/fstab excepto aquellas líneas que contienen sdb
# Sobreescribimos /etc/fstab con el contenido del fichero temporal y después borramos el temporal

grep -v sdb /etc/fstab > ./temporal
cat ./temporal > /etc/fstab
#borra - rm -r ./temporal

echo "/dev/sdb1 ./mnt/disco_1 ext4 defaults 2 1" >> /etc/fstab

echo "/dev/sdb2 ./mnt/disco_2 ext4 defaults 2 1" >> /etc/fstab


# La variable $actual almacena el primer usuario logueado en el sistema. Debes ejecutar un comando que devuelva solo el nombre de este usuario
actual=`who  | tr -s " " | cut -d " " -f 1`

# Ahora quedaría copiar el directorio personal del usuario a la carpeta donde está montada la primera partición del disco
# Para acceder a una carpeta utilizando una variable, se puede reemplazar en la ruta el texto de las carpetas por la variable
# Por ejemplo /home/$nombre_variable (o /home/$1 en caso de que fuera un parámetro)
echo "copiando directorio personal de $actual"
cp -R /home/$actual ./mnt/disco_1 > /dev/null 2>&1
    
}


