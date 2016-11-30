.data

A: .asciiz "Introduzca fecha(dd/mm/aaaa): \n"
B: .asciiz "\n"
Err: .asciiz "Algo ha salido regular"
Ok: "Todo va bien"

cadena: .space 11 #Fecha leido
	
Semana:	.asciiz "Domingo"
		.space 2
		.asciiz "Lunes"
		.space 4
		.asciiz "Martes"
		.space 3
		.asciiz "Miercoles"
		.asciiz "Jueves"
		.space 3
		.asciiz "Viernes"
		.space 2
		.asciiz "Sabado"
		.space 3
		

Meses: 	.asciiz "de Enero, de"
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
	li $a1, 11
	li $a0,cadena
	syscall

	la $s0, cadena #inicializamos puntero a la cadena


	jal Dia



	li $v0, 10			#Terminamos
	syscall	


Dia:
	lb $t0, 0($s0)
	#errores branch
	beq $t0, 47, Mes
	addi $t0, $t0, -48
	mul $t1, $t1, 10
	add $t1, $t1, $t0
	addi $s0, $s0, 1
	j Dia


Mes:
	addi $s0, $s0, 1
	lb $t0, 0($s0)
	#errores branch
	beq $t0, 47, Year
	addi $t0, $t0, -48
	mul $t2, $t2, 10
	add $t2, $t2, $t0
	j Mes

Year:
	addi $s0, $s0, 1
	lb $t0, 0($s0)
	#errores branch
	beq $t0, 10, Comprobar
	addi $t0, $t0, -48
	mul $t3, $t3, 10
	add $t3, $t3, $t0
	
	j Year

Comprobar:

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
	blt $t1, $t5, Algorimo
	jal Error

Mes30:
	addi $t5, $zero, 31
	blt $t1, $t5, Algorimo
	jal Error

Febrero:
	addi $t5, $zero, 29
	beq $t1, 29, Bisiesto
	blt $t1,$t5, Algoritmo
	Jal Error

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
	bne $t5, 0, Error

	addi $t5, $zero, 100
	div $t3, $t5
	mfhi $t5 #guardamos el resto en t5
	beq $t5, 0, Error

	jal Algoritmo


Error:

	
	la $a0, Err			
	li $v0, 4
	syscall

	Jal Salir

Algoritmo:

	
	la $a0, Ok			
	li $v0, 4
	syscall

	Jal Salir

Salir:
	jr $ra 














