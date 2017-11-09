	#Guillermo Anta Alonso
	#Mario Gomez Fernandez
	
	#Practica 3, ejercicio 2, apartado D:

	.data

F:	.word 0, -1, -2, -3, -16, -15, -14, -13, 32, 31, 30, 29, -48, -47, -46, -45	#Declaracion por filas
C:      .word 0, -16, 32, -48, -1, -15, 31, -47, -2, -14, 30, -46, -3, -13, 29, -45	#Declaracion por columnas

	.globl __start
	.text

__start:
	
	la $t0, F		#Direccion matriz
	li $t1, 0		#Desplazamiento
	li $t2, 0		#Desplazamiento + Dir
	li $t3, 0 		#Suma total
	li $t4,0		
	li $t5, 64

Bucle:
	add $t2, $t1, $t0	#Direccion + Desplazamiento
	lw $t4, 0($t2)		#Cargamos en $t4 el elemento
	
	add $t3, $t3, $t4	#Añadimos el valor a la suma total
	
	addi $t1, $t1, 4	#Incrementamos el desplazamiento en 4

	bne $t1, $t5, Bucle	#Mientras $t1 != $t5, Bucle
	
	add $a0, $a0, $t3	#Guardamos en $a0 la suma total
	
	li $v0, 1		#Imprimimos el valor por pantalla
	syscall
	
	li $v0, 10	
	syscall
