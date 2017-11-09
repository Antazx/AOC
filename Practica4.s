						#Guillermo Anta Alonso
						#Mario Gomez Fernandez
	
	.data
Hex: 	.space 100
Cadena:	.asciiz "\n Introduzca un numero decimal: "
Result:	.asciiz "\n El numero + 1 en hexadecimal es : "

	.globl __start
	.text

__start:
	
	la $a0, Cadena				#Pedimos por pantalla el numero decimal
	li $v0, 4
	syscall
	
	li $a0, 0				#Recogemos el numero decimal
	li $v0, 5
	syscall
	
	add $a0, $a0, $v0			#Guardamos numero en $a0
	la $a1, Hex				#Guardamos direccion en $a1
	
	jal Convertir				#Llamamos a la función
	
	li $v0, 10				#Terminamos
	syscall
	
Convertir:

	addi $a0, $a0, 1			#Incrementamos el numero en 1(enunciado práctica
	addi $s0, $zero, 0xf			#Cargamos mascara en $s0
	
	li $s1, 8				#Para condicion bucle
	li $s2, 0				#Contador
Bucle:
	
	beq $s2, $s1, Salir
	and $s4, $a0, $s0			#And para quedarnos con los primeros 4 bits
	
	ble $s4, 9, Suma			#Si < 9 vamos Suma
	addi $s4, $s4, 55			#Si > 9 sumamos 55
	
	j Guardar
	
Suma:
	addi $s4, $s4, 48			#Sumamos +48

Guardar:
	
	sb $s4, 0($a1)				#Guardamos byte en direccion de $a1
	li $s4, 0				#Vaciamos contenido $s4
	
	addi $a1, $a1, 1			#Incrementamos desplazamiento
	addi $s2, $s2, 1			#Incrementamos contador
	
	srl $a0, $a0, 4				#Desplazamos a la derecha $a0 para coger los siguientes 4 bits 
	
	j Bucle					#Volvemos
	
			
Salir:
	la $a0, Result				#Imprimimos cadena
	li $v0, 4
	syscall
	
	la $a0, Hex				#Imprimimos valor en Hexadecimal
	li $v0, 4
	syscall
	
	li $v0, 10				#Terminamos
	syscall
	
	
	