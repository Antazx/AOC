	#Grupo 8: Guillermo Anta Alonso, Mario Gomez Fernandez
		.data

A: 	.word 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
B: 	.word	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
C: 	.word	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

Cadena: .asciiz "\n Introduzca una matriz 4x4 (16 elementos)\n"
Coma:	.asciiz " "
Salto: 	.asciiz "\n"
Resul:	.asciiz "\n La matriz traspuesta de la suma de las anteriores es:\n "

	.text
	.globl __main
	
__main:

	la $s3, Cadena 		#Direccion de la cadena a imprimir
	la $s4, Coma 		#Direccion de ", "
	la $s5, Salto 		#Direccion de "\n"
	
	li $t1, 0	
	
	li $v0, 4		#Imprimimos cadena para pedir primera matriz
	la $a0, Cadena
	syscall
		
	la $a1, A		#Llamamos a la funcion pedir pasandole direccion de inicio de A
	jal Pedir
		
	li $v0, 4		#Imprimimos cadena para pedir segunda matriz
	la $a0, Cadena
	syscall
	
	la $a1, B		#Llamamos a la funcion pedir pasandole direccion de inicio de B
	jal Pedir
	
	la $a0, A		#Llamamos a la funcion sumar (A+B=C) y le pasamos la direccion de las 3 matrices
	la $a1, B
	la $a2, C
	jal Sumar
	
	la $a1, C		#Llamamos a la funcion trasponer y le pasamos la matriz que queremos trasponer
	la $a2, A		#y donde se va a guardar
	jal Trasponer
	
	li $v0, 4		#Imprimimos cadena para pedir primera matriz
	la $a0, Resul
	syscall
	
	jal Imprimir		#Llamamos a imprimir que imprimira la matriz que haya en a2
	
	j Exit
	
Pedir:	
	 li $v0, 5		#Pedir int 
	 syscall 
	 
	 add $t0, $t1, $a1	#Calculamos la posicion en la que guardamos el dato recogido
	 sw $v0, 0($t0)
	 addi $t1, $t1, 4
	 
	 li $t2, 64		#64/4 = 16 iteraciones de bucle
	 
	 bne $t1, $t2, Pedir	
	 
	 li $t1, 0		#Ponemos temporales a 0
	 li $t2, 0		
	 jr $ra
	
Trasponer:

	mul $t1, $t3, 16	#4*m*i
	mul $t2, $t4, 4		#4*j
	add $t5, $t1, $t2	#[i][j]

	mul $t1, $t4, 16	#4*m*j
	mul $t2, $t3, 4		#4*i
	add $t6, $t1, $t2	#[j][i]

	add $t7, $t6, $a1
	lw  $t8, 0($t7)        #t8= A[j][i]

	add $t7, $t5, $a2
	sw $t8, 0($t7)		#cargamos en Bij-- Aji

	add $t7, $t5, $a1
	lw $t8, 0($t7)		#t8= aij
	
	add $t7, $t6, $a2
	sw $t8, 0($t7)		#bji = aij
	
	
	addi $t3, $t3, 1	# i++
	li  $t9, 4		
	
	bne  $t3, $t9, Trasponer #if(i < 3) otra vuelta
	
	li $t3, 0		#i = 0
	
	addi $t4, $t4, 1	#j++
	
	bne $t4, $t9, Trasponer #if(j < 3) otra vuelta
	
	li $t1, 0		#Ponemos temporales a 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $t8, 0
	li $t9 ,0
	
	jr $ra

Sumar:
	
	mul $t1, $t3, 16	#4*m*i
	mul $t2, $t4, 4		#4*j
	add $t5, $t1, $t2	#[i][j]
	
	add $t0, $t5, $a0       #aij
	lw $t0, 0($t0)
	
	add $t6, $t5, $a1 	#bij
	lw $t6, 0($t6)
	
	add $t0, $t0, $t6	#t0=aij+bij
	
	add $t6, $t5, $a2	#cij
	sw  $t0, 0($t6)


	addi $t3, $t3, 1
	li  $t9, 4
	
	bne  $t3, $t9, Sumar
	
	li $t3, 0
	
	addi $t4, $t4, 1
	
	bne $t4, $t9, Sumar
	
	li $t1 ,0		#Ponemos temporales a 0
	li $t2, 0
	li $t3 ,0
	li $t4 ,0
	li $t5 ,0
	li $t6 ,0
	li $t9 ,0
	
	jr $ra
	
Imprimir:
	
	add $t0, $t1, $a2	
	lw $a0, 0($t0)
	
	li $v0, 1
	syscall
	
	la $a0, Coma
	li $v0, 4
	syscall 
	
	addi $t1, $t1, 4
	addi $t3, $t3, 1
	
	li $t2, 64		#64/4 = 16 iteraciones de bucle
	li $t4, 4
	
	bne $t3, $t4, Imprimir
	
	la $a0, Salto
	li $v0, 4
	syscall
	
	li $t3, 0
	
	bne $t1, $t2, Imprimir
	
	li $t0, 0
	li $t1, 0
	li $t2, 0
	
	jr $ra

Exit:
	li $v0, 10
	syscall
	
