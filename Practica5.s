		#Guillermo Anta Alonso
		#Mario Gomez Fernandez
	
		.data
P: 		.asciiz "Introduzca un número hexadecimal (8 caracteres [0-F]): "
Resultado:	.asciiz "\nEl resultado es: "
Err: 		.asciiz "\nLa cadena introducida contiene un caracter no valido (correctos:[0-9],[a-f],[A-F])"
Opuesto: 	.asciiz "\nY su opuesto es: "
Cadena: 	.asciiz ""
Hex: 		.space 100
Mascara: 	.word 0xf0000000
	
	.text
	.globl __main
	
__main:	
	la $a0, P
	li $v0, 4
	syscall
	
	la $a0, Cadena			#Cargamos en a0 la direccion de la cadena
	li $a1, 9 			#Maximo numero de caracteres contando con /0

	jal Pedir			#Pedimos la cadena por pantalla
	jal ConvertirDEC		#Llamamos a la funcion convertir
	
	add $t0, $zero, $v0		#Recogemos el valor en decimal
	
	la $a0, Resultado		#Imprimimos cadena resultado
	li $v0, 4
	syscall
	
	
	add $a0, $zero, $t0		#Guardamos el valor en a0 para imprimir
	li $v0, 1
	syscall
	
	la $a0, Opuesto			#Imprimimos cadena Opuesto
	li $v0, 4
	syscall
	
	sub $a0, $zero, $t0		#Calculamos el opuesto y lo imprimimoss
	la $a1, Hex
	la $a2, Mascara
	jal ConvertirHEX
	
	la $a0, Hex			#Imprimimos en hex
	li $v0, 4
	syscall
	
	li $v0, 10			#Terminamos
	syscall

Pedir: 
	li $v0, 8			#Pedimos una cadena de longitud 9 por pantalla
	syscall
	j Salir
	
ConvertirDEC:
	
	li $v0, 0			#Resultado
	li $v1, 0			#Codigo Error
	li $s0, 0 			#Direccion 
	li $s1, 0			#Desplazamiento
	li $s2, 0 			#Elemento actual
	
	
Inicio: 
	
	add $s0, $a0, $s1		#Direccion a cargar	
	lbu $s2, 0($s0)			#Cargamos elemento
	
	beqz $s2, Salir			#Si es 0 salimos (final de cadena)
	beq $s2, 10, Salir		#Si es Salto de linea
	
	blt $s2, 48, Error		#Si el caracter es < 48
	bgt $s2, 70, Minuscula		#Si el caracter es > 70
	ble $s2, 57, Restar		#Si es < 57 vamos a restar
	blt $s2, 65, Error		#Si es >57 y <65 Erorr
	
	subi $s2, $s2, 55		#Si no restamos 55
	j Bucle
	
Restar:
	subi $s2, $s2, 48		#Restamos 48
	j Bucle

Minuscula:
	
	bge $s2, 103, Error		#Si es >102 caracter no valido
	blt $s2, 97, Error		#Si es <97 caracter no valido
	subi $s2, $s2, 87		#Si 70< X < 103

Bucle:
	sll $v0, $v0, 4			#Desplazaamos a la iquierda para dejar hueco al byte
	or $v0, $v0, $s2		#Juntamos el contenido de v0 con el de s2
	addi $s1, $s1, 1
	
	j Inicio

Error:	
	li $v1, 1			#Si se ha producido un error guardamos 1 en $v1
	
	la $a0, Err			#Imprimimos mensaje de erorr
	li $v0, 4
	syscall
	
	li $v0, 10			#Terminamos
	syscall
	
ConvertirHEX:
	
	add $s0, $a0, $zero 	
	
	li $s2, 8			#condicion bucle
	li $s3, 0  			#contador
	lw $s1, 0($a2)			

Bucle1:

	beq $s3, $s2, Salir
	and $s4, $s0, $s1
	srl $s4, $s4, 28

	ble $s4, 9, Suma 		#si es <9 +48

	addi $s4, $s4, 55  		#si no +55

	j Guardar

Suma:
	addi $s4, $s4, 48		

Guardar:

	sb $s4, 0($a1)			#Guardamos
	sll $s0, $s0, 4			#Desplazamos para coger siguiente
	addi $s3, $s3, 1		
	addi $a1, $a1, 1
	j Bucle1
Salir: 	
	jr $ra
	
