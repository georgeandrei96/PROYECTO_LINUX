#!/bin/bash

#
#  Archivo con el código asociado a la gestión de procesos
#

informacion_inicial_procesos()
{    
opcion_proceso=""
while !([ "$opcion_proceso" = 's' ])
do
clear
	echo "----------------------------------------------------------------"    
	echo "----------------------------------------------------------------" 	
   	echo -e " \t Ha seleccionado la opción GESTIONAR PROCESOS"
  	echo "----------------------------------------------------------------" 	 
  	echo "----------------------------------------------------------------" 

        echo -e "\n \n"
        echo "*************** SELECIONA UNA OPCION *******************************"
        echo -e "\n \n"
        echo -e "\t [1] ---> Gestionar señal procesos"
        echo -e "\t [2] ---> Gestionar prioridad procesos"
        echo -e "\n"
        echo "[s]----------------------> Salir del script"
        echo "********************************************************************"  
	echo -e "\n"
	echo "seleccionar una opcion"	
	
	read opcion_proceso

	case $opcion_proceso in
      			1) 
    			gestionar_senal_procesos 
				
			;;	
	
			2) 
    			gestionar_prioridad_procesos 
				
			;;
	

			s) 
				echo "Has seleccionado salir,volviendo a menu principal"
								
				
			;;
	
			*) 
				echo "Opción incorrecta"		
				read fin_incorrecto
				clear
			;;
			esac
done
}



gestionar_senal_procesos()
{    
    	
    echo "Buscando procesos"
		ps -aux
    echo "Indica el identificador de proceso"		
		read PID_senal
   echo "Listando señales"
		kill -l
   echo "Indica señal numerica"
		read senal
   echo "Procedemos a realizar el comando"
		kill -$senal $PID_senal 
   echo "Comando realizado"

}

gestionar_prioridad_procesos()
{    
    	
    echo "Buscando procesos"
		ps -la
    echo "Indica el identificador de proceso"
		read PID_prioridad
    echo "Indica prioridad"
		read prioridad
    echo "Cambiando prioridad"
		renice $prioridad $PID_prioridad 
    echo "Comando realizado"

}





