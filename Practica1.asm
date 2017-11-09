	.data

A: .word 0x20, 0x40, 0x10, 0x01, 0x03, 0x22, 0x08
B: .word 10, 24, 55, 67, 89, 90, 110
C: .space 100
Coma: .asciiz ", "

	.text
	.globl __main
	
__main:
	
	la $s0, A	#Cargamos posicion de memoria de A
	la $s1, B	#Cargamos posicion de memoria de B
	la $s2, C	#Cargamos posicion de memoria de C
	la $s3, Coma	#Cargamos la posicion de la cadena
	
	li $t0, 0	#Contador de vueltas del bucle
	
	li $t1, 0	#Temporal de vector A
	li $t2, 0	#Temporal de vector B
	li $t3, 0	#Temporal de vector C
	
	li $t4, 0 	#Desplazamiento vectores
	li $t5, 28	#FinBucle (4*7)
	li $t6, 0	#Temporal sw en C
	
	jal Bucle
	jal Imprimir
	
	j Exit
	
Bucle:	
	
	add $t1, $s0, $t4	#A[i]
	lw $t1, 0($t1)
	
	add $t2, $s1, $t4	#B[i]
	lw $t2, 0($t2)
	
	add $t3, $t2, $t1	#C[i]=A[i]+B[i]
	
	add $t6, $s2, $t4
	sw $t3, 0($t6)	
	
	addi $t4, $t4, 4	#Incrementamos el desplazamiento
	
	blt $t4, $t5, Bucle
	
	li $t4, 0
	jr $ra
	
Imprimir:
	
	
	add $t6, $s2, $t4	#C[i]
	lw $a0, 0($t6)
	
	li $v0, 1		#Imprimimos C[i]
	syscall
	
	add $a0, $s3, $zero
	
	li $v0, 4		#Imprimimos ", "
	syscall	
	
	addi $t4, $t4, 4	#Incrementamos el contador en 4
	
	blt $t4, $t5, Imprimir
	
	jr $ra
	

Exit:
	li $v0, 10
	syscall
	
	
	
	
	
