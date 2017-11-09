			#Guillermo Anta Alonso
			#Mario Gomez Fernandez
			
			.data

Bienvenida:		.asciiz "CALCULADORA MIPS v1.0!\n"
Instrucciones:		.asciiz "\nOperaciones permitidas: (   ), *, +, -, /, '0'-'9', para terminar introduzca 'q'\n"
PCadena:		.asciiz "\nIntroduzca una operación: "
Salir:			.asciiz "\nHasta pronto!"

Cadena:			.space 100

CValidos:		.word 40, 41, 42, 43, 45, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 32
			#cara  (   )   *   +   -   /   0   1   2   3   4   5   6   7   8   9  espacio
			
			.text
			.globl __main
		
__main:
			la $a0, Bienvenida		#Imprimimos mensaje de bienvenida
			li $v0, 4
			syscall
			
			la $a0, Instrucciones		#Imprimimos instrucciones
			syscall

principio:			
			li $v0, 4
			la $a0, PCadena			#Imprimimos cadena para pedir operacion
			syscall
			
			la $a0, Cadena			#Direccion donde recogeremos la cadena
			li $a1, 24			#Temporalmente
			jal recogerCadena		
			
			la $t0, Cadena
			lb $t1, 0($t0)			#Cargamos en t1 el primer caracter de la cadena
			
			beq $t1, 113, salir		
			beq $t1, 81, salir		#Si encontramos una 'q' o 'Q' salimos.
			
			beq $t1, 0, principio		#Si no hay nada volvemos a pedir
			beq $t1, 10, principio		#Si encontramos un salto de linea volvemos a pedir
			
			jal comprobarCadena		
			
			j terminar
			
recogerCadena:						#Recogemos cadena
			li $v0, 8
			syscall
			jr $ra

comprobarCadena:	
					
			
			
			
salir:
			la $a0, Salir
			li $v0, 4
			syscall	
terminar:
			li $v0, 10
			syscall