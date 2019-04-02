#!/bin/bash

#
#  Archivo con el código asociado a la gestión de Usuarios
#


informacion_inicial_usuarios()
{    
    	
   clear
	echo "----------------------------------------------------------------"    
	echo "----------------------------------------------------------------" 	
   echo -e " \t Ha seleccionado la opción GESTIONAR USUARIOS"
   echo "----------------------------------------------------------------" 	 
   echo "----------------------------------------------------------------" 
    
}



gestionar_usuarios()
{    
u1="alumno"
u2="profesor"
u3="cole"
u4="cowsay"	

# Aquí se añade el código para crear usuarios y grupos
# [COMPLETAR]
useradd -m -s /bin/bash $u1 
useradd -m -s /bin/bash $u2
groupadd $3
usermod -G $u3 $u2

# Aquí se asigna una contraseña al usuario $2
# [COMPLETAR]
echo "$u2:$u2" | chpasswd

# Debajo actualizamos los paquetes sin mostrar nada por pantalla (el operador para hacerlo está en el comando para actualizar la contraseña)
# [COMPLETAR
apt-get -y -q update > /dev/null 

# Control de errores por si hay algún problema al actualizar los paquetes
if [ $? -gt 0 ]; then
   echo Error al actualizar los paquetes
   exit 3
fi

# El cuarto parámetro $4 es el nombre del software a instalar (en este caso se ha guardado en una variable)
# [COMPLETAR]
apt-get -y -q install $u4

# Control de errores por si algún problema al instalar el paquete que se recibe por parámetro
if [ $? -gt 0 ]; then
   echo Error al instalar el paquete $u4. Puede que no exista
   exit 4
fi

    
}



