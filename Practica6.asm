		
		#Guillermo Anta Alonso
		#Mario Gomez Fernandez
		
		.data
		
Numero1: 	.asciiz ""
Numero2:	.asciiz ""
P:		.asciiz "Introduzca un numero decimal: "
P2:		.asciiz "\nIntroduzaca otro numero decimal: "
S:		.asciiz "\nLa suma de los dos numeros es: "
E1:		.asciiz "\nLa cadena es demasiado larga."
E2: 		.asciiz "\nSe ha encontrado un caracter incorrecto. (correctos: [0-9])"
	
		.globl __main
		.text
		
__main:		
		la $a0, P			#Cargamos direccion cadena
		li $v0, 4			#Imprimimos por pantalla
		syscall
	
		la $a0, Numero1			#Direccion donde guardaremos la cadena
		li $a1, 11			#Numero maximo de cadena (10 caracteres + salto de linea)
		li $v0, 8
		syscall
		
		jal ConvertirBin		#Rango maximo en un registro (−2.147.483.648, 2.147.483.647)
		
		beq $v0, 1, Error1		#Comprovamos el codigo de error
		beq $v0, 2, Error2
		
		add $s0, $zero, $v1		#Recogemos valor de v1
	
		li $v0, 4			#Imprimimos por pantalla
		la $a0, P2			#Cargamos direccion cadena
		syscall
	
		la $a0, Numero2			#Direccion donde guardaremos la cadena
		li $v0, 8
		syscall
		
		jal ConvertirBin		#Rango maximo en un registro (−2.147.483.648, 2.147.483.647)
		
		beq $v0, 1, Error1		#Comprobamos codigo error
		beq $v0, 2, Error2
		
		add $s0, $s0, $v1		#Guardamos suma en s0
		
		li $v0, 4			#Imprimimos por pantalla
		la $a0, S			#Cargamos direccion cadena
		syscall
		
		add $a0, $zero, $s0		
		li $v0, 1			#Imprimimos
		syscall
		
		j Terminar
		
ConvertirBin:
		add $t0, $zero, $a0 		#Direccion cadena
		li $t1, 0			#Caracter actual
		li $t2, 9			#Contador longitud
		li $v1, 0			#Resultado
		li $v0, 0 			#Codigo de error
		
Bucle:		
		beqz $t2, CLarga		#Si $t2 == 0 cadena demasiado larga
		
		lb $t1, 0($t0)			#Cargamos primer caracter
		
		beqz $t1, Volver 		#Si llegamos al final de la cadena terminamos
		beq $t1, 10, Volver 
		
		#Si encontramos "-" (45) hacer cosas
		
		blt $t1, 48, CIncorrecto	#Si es <48 caracter incorrecto
		bgt $t1, 57, CIncorrecto	#Si es >57 caracter incorrecto
		
		addi $t1, $t1, -48		#Calculamos el numero restando 48
		mul $v1, $v1, 10		#Multiplicamos por 10 para ir calculando resultado
		add $v1, $v1, $t1		#Añadimos el caracter que acabamos de cargar
		
		addi $t0, $t0, 1		#Sumamos uno al desplazamiento
		addi $t2, $t2, -1		#Decrementamos contador longitud
	
		j Bucle				#Volvemos
CLarga:
		li $v0,1			#Cadena demasiado larga
		j Volver
CIncorrecto:	
		li $v0, 2			#Encontrado caracter incorrecto
	
Volver:		
		jr $ra				#Volvemos al main

Error1:	
		la $a0, E1			#Imprimimos Error1
		li $v0, 4
		syscall
		j Terminar
Error2: 	
		la $a0, E2			#Imprimimos Error2
		li $v0, 4
		syscall										
Terminar: 	
		li $v0, 10 			#Terminamos
		syscall											
																		
																						
																														
