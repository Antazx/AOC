					#Guillermo Anta Alonso
					#Mario Gomez Fernandez

		.data

A: 				.asciiz "\nIntroduzca fecha(dd/mm/aaaa): \n"
B: 				.asciiz "\n"
Efma:				.asciiz "\nFormato de fecha incorrecto.\n"
Emes:				.asciiz "\nEl mes introducido es incorrecto.\n"
Edia:				.asciiz "\nEl dia introducido es incorrecto.\n"
Eano:				.asciiz "\nEl anyo introducido es incorrecto.\n"
Eca:				.asciiz "\nSe ha encontrado un caracter incorrecto\n"
Err1: 				.asciiz "\nAlgo ha salido regular\n"
Ealg:  				.asciiz "\nHa habido un problema tecnico con el Algoritmo. Estamos trabajando en ello\n"

cadena: 			.space 11 #Fecha leido

D: 				.space 2
M:				.space 2
Y:				.space 4

Semana:
				.asciiz "Domingo "
				.space 2
				.asciiz "Lunes "
				.space 4
				.asciiz "Martes "
				.space 3
				.asciiz "Miercoles "
				.asciiz "Jueves "
				.space 3
				.asciiz "Viernes "
				.space 2
				.asciiz "Sabado "
				.space 3

Meses: 		
				.asciiz "de Enero, de"
				.space 5
				.asciiz "de Febrero, de"
				.space 3
				.asciiz "de Marzo, de"
				.space 5
				.asciiz "de Abril, de"
				.space 5
				.asciiz "de Mayo, de"
				.space 6
				.asciiz "de Junio, de"
				.space 5
				.asciiz "de Julio, de"
				.space 5
				.asciiz "de Agosto, de"
				.space 4
				.asciiz "de Septiembre, de"
				.asciiz "de Octubre, de"
				.space 3
				.asciiz "de Noviembre, de"
				.space 1
				.asciiz "de Diciembre, de"
				.space 1

	.text
	.globl __main

__main:
				
				la $a0, A			#Pedimos la fecha por teclado
				li $v0, 4
				
				syscall
				
				li $v0, 8			#Leemos la fecha por teclado
				li $a1, 11			#Longitud maxima de la cadena	
				la $a0,cadena			#Guardamos el valor leido en $a0
				syscall

				la $s0, cadena			#Inicializamos puntero a la cadena


				jal Leer			#Llamamos a la funcion para leer la cadena

				beq $v0, -1, ErrM		#Error Mes
				beq $v0, -2, ErrD		#Error Dia
				beq $v0, -3, ErrA		#Error anyo
				beq $v0, -4, ErrC		#Error Caracter
				beq $v0, -5  ErrF		#Error Formato

				bltz $v0, ErrAlg
				bgt  $v0, 7, Erraaaa
					
				la $a0, B			#Imprimimos salto de linea
				li $v0, 4
				syscall 
						
				la $a0, Semana			#Imprimimos dia de la semana
				mul $t4, $v0, 11
				add $a0, $a0, $t4

				li $v0, 4
				syscall

				li $a0, 0
				add $a0, $a0, $t1
				li $v0, 1
				syscall

				la $a0, Mes
				#addi $t2, $t2, -1
				#mul $t2, $t2, 18
				#add $a0, $a0, $t2

				li $v0, 4
				syscall
						
				li $a0, 0
				add $a0, $a0, $t3

				li $v0, 1
				syscall

				li $v0, 10			#Terminamos
				syscall

Imprimir:


Erraaaa:
				la $a0, Err1
				li $v0,4
				syscall
				j __main

ErrAlg:
				la $a0, Ealg
				li $v0,4
				syscall
				j __main

ErrF:
				la $a0, Efma
				li $v0, 4
				syscall
				j __main

ErrM:
				la $a0, Emes			#Imprimimos mensaje de error
				li $v0, 4
				syscall
				j __main
ErrD:
				la $a0, Edia			#Imprimimos mensaje de error
				li $v0, 4
				syscall
				j __main
ErrA:
				la $a0, Eano			#Imprimimos mensaje de error
				li $v0, 4
				syscall
				j __main
ErrC:
				la $a0, Eca			#Imprimimos mensaje de error
				li $v0, 4
				syscall
				j __main

Leer:					
				li $t1, 0
				li $t2, 0
				li $t3, 0
Dia:
				addi $t4, $t4, 1
				lb $t0, 0($s0)			#Cargamos el caracter de la cadena
				beq $t0, 47, Mes		#Si encontramos un / pasamos a leer el mes
				bge $t4, 3, ErrorFormato
				addi $t0, $t0, -48		#Restamos 48 para obtener el numero del ascii
				bltz $t0, ErrorCaracter
				bgt $t0, 9, ErrorCaracter
				mul $t1, $t1, 10		# x10 para ir calculando las decenas
				add $t1, $t1, $t0
				addi $s0, $s0, 1		#Sumamos 1 a la direccion de la cadena para leer el siguiente byte
				j Dia			#Repetimos el bucle

Mes:
				addi $t6 $t6, 1
				addi $s0, $s0, 1		#Sumamos 1 a la direccion de la cadena para leer el siguiente byte
				lb $t0, 0($s0)			#Cargamos el caracter de la cadena
				beq $t0, 47, Year		#Si encontramos un / pasamos a leer el anyo
				bge $t6, 3, ErrorFormato
				addi $t0, $t0, -48		#Restamos 48 para obtener el numero del ascii
				bltz $t0, ErrorCaracter
				bgt $t0, 9, ErrorCaracter
				mul $t2, $t2, 10		# x10 para ir calculando las decenas
				add $t2, $t2, $t0
				j Mes				#Repetimpos el bucle

Year:
				addi $s0, $s0, 1		#Sumamos 1 a la direccion de la cadena para leer el siguiente byte
				lb $t0, 0($s0)			#Cargamos el caracter de la cadena
				beq $t0, 0, Comprobar		#Si encontramos fin de cadena, terminamos de leer
				addi $t0, $t0, -48		#Restamos 48 para obtener el numero del ascii
				bltz $t0, ErrorCaracter
				bgt $t0, 9, ErrorCaracter
				mul $t3, $t3, 10		# x10 para ir calculando las decenas las centenas y los millares
				add $t3, $t3, $t0
				j Year				#Repetimos el bucle

Comprobar:

				bgt $t2, 12, ErrorMes

				beq $t2, 1, Mes31 #Enero
				beq $t2, 2, Febrero #Febrero
				beq $t2, 3, Mes31 #Marzo
				beq $t2, 4, Mes30 #Abril
				beq $t2, 5, Mes31 #Mayo
				beq $t2, 6, Mes30 #Junio
				beq $t2, 7, Mes31 #Julio
				beq $t2, 8, Mes31 #Agosto
				beq $t2, 9, Mes30 #Septiembre
				beq $t2, 10, Mes31 #Octubre
				beq $t2, 11, Mes30 #Noviembre
				beq $t2, 12, Mes31 #Diciembre
				
Mes31:
				addi $t5, $zero, 32
				blt $t1, $t5, Algoritmo
				j ErrorDia

Mes30:
				addi $t5, $zero, 31
				blt $t1, $t5, Algoritmo
				j ErrorDia

Febrero:
				addi $t5, $zero, 29
				beq $t1, 29, Bisiesto
				blt $t1,$t5, Algoritmo
				j ErrorDia

Bisiesto:
				#Entre 4 pero no entre 100
				#entre 400
				addi $t5, $zero, 400
				div $t3, $t5
				mfhi $t5 #guardamos el resto en t5
				beq $t5, 0, Algoritmo

				addi $t5, $zero, 4
				div $t3, $t5
				mfhi $t5 #guardamos el resto en t5
				bne $t5, 0, ErrorDia

				addi $t5, $zero, 100
				div $t3, $t5
				mfhi $t5 #guardamos el resto en t5
				beq $t5, 0, ErrorDia

				j Algoritmo

Algoritmo:
				#aplicamos la congruencia de zeller
				ble $t2, 2, Ajuste

				li $t6, 12

				addi $t7, $t2, -14
				div $t7, $t6

				mflo $t7		# a = (14 -mes) / 12

				sub $t8, $t3, $t7 	# y = anyo -a

				mul $t7, $t7, 12 	# a = 12 *a
				add $t7, $t2, $t7	# a = a +mes
				addi $t7, $t7, -2	# m= mes +12*a-2


				mul $t7, $t7 31
				div $t7, $t6
				mflo $t7		# m = 31*m /12

				li $t6, 4

				div $t8, $t6
				mflo $t9		# resultado = y/4

				add $t9, $t1, $t9	# resultado = y/4 + dia
				add $t9, $t8, $t9	# resultado = y/4 + dia + y

				add $t9, $t9, $t7	# resultado = y/4 + dia + y + 31*m /12

				li $t6, 100

				div $t8, $t6
				mflo $t7

				sub $t9, $t9, $t7

				li $t6, 400

				div $t8, $t6
				mflo $t7

				add $t9, $t9, $t7	# resultado = y/4 + dia + y + 31*m /12 - y/100 + y/400

				li $t6, 7
				div $t9, $t6
				mfhi $t9

				li $v0, 0
				add $v0, $v0, $t9

				j Salir

Ajuste:
				addi $t2, $t2, 12	#mes +12
				addi $t3, $t3, -1	#anyo -1
				j Algoritmo

ErrorMes:
				li $v0, -1
				j Salir

ErrorDia:
				li $v0, -2
				j Salir

Erroranyo:
				li $v0, -3
				j Salir

ErrorCaracter:
				li $v0, -4
				j Salir

ErrorFormato:
				li $v0, -5
				j Salir

Salir:								
				li $t4, 0
				li $t5, 0
				li $t6, 0
				jr $ra
