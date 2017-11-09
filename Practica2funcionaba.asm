	.data

A: 	.space 16
B: 	.space 16
C: 	.space 16
Cadena: .asciiz "\n Introduzca una matriz 4x4 (16 elementos)"
Coma:	.asciiz ", "
Salto: 	.asciiz "\n"
Resul:	.asciiz "\n La matriz traspuesta de la suma de las anteriores es: "

	.text
	.globl __main
	
__main:

	la $s3, Cadena 	#Direccion de la cadena a imprimir
	la $s4, Coma 	#Direccion de ", "
	la $s5, Salto 	#Direccion de "\n"
	
	li $t0, 0
	
	li $v0, 4
	la $a0, Cadena
	syscall
	
	la $a0, A
	jal Pedir
	
	li $v0, 4
	la $a0, Cadena
	syscall
	
	la $a0, B
	jal Pedir
	
	la $a1, B
	la $a2, C
	jal Sumar
	
	j Exit
	
Pedir:	
	 li $v0, 5	#Pedir int
	 syscall 
	 
	 add $t0, $a0, $t1
	 sw $v0, 0($t0)
	 
	 li $t2, 64
	 add $t1, $t1, 4
	 
	 bne $t1, $t2, Pedir
	 
	 jr $ra
	
Trasponer:

	mul $t1, $t3, 16	#4*m*i
	mul $t2, $t4, 4		#4*j
	add $t5, $t1, $t2	#[i][j]

	mul $t1, $t4, 16	#4*m*j
	mul $t2, $t3, 4		#4*i
	add $t6, $t1, $t2	#[j][i]

	add $t7, $t6, $s0
	lw  $t8, 0($t7)         #t8= A[j][i]

	add $t7, $t5, $s2
	sw $t8, 0($t7)		#cargamos en Bij-- Aji

	add $t7, $t5, $s0
	lw $t8, 0($t7)		#t8= aij
	
	add $t7, $t6, $s2
	sw $t8, 0($t7)		#bji = aij
	
	
	addi $t3, $t3, 1	# i++
	li  $t9, 4		
	
	bne  $t3, $t9, Trasponer #if(i < 3) otra vuelta
	
	li $t3, 0		#i = 0
	
	addi $t4, $t4, 1	#j++
	
	bne $t4, $t9, Trasponer #if(j < 3) otra vuelta
	
	
	jr $ra

Sumar:
	
	mul $t1, $t3, 16	#4*m*i
	mul $t2, $t4, 4		#4*j
	add $t5, $t1, $t2	#[i][j]
	
	add $t0, $t5, $s0       #aij
	lw $t0, 0($t0)
	
	add $t6, $t5, $s1 	#bij
	lw $t6, 0($t6)
	
	add $t0, $t0, $t6	#t0=aij+bij
	
	add $t6, $t5,$s2	#cij
	sw  $t0, 0($t6)


	addi $t3, $t3, 1
	li  $t9, 4
	
	bne  $t3, $t9, Sumar
	
	li $t3, 0
	
	addi $t4, $t4, 1
	
	bne $t4, $t9, Sumar
	
	
	jr $ra
		
	

Exit:
	li $v0, 10
	syscall
	
