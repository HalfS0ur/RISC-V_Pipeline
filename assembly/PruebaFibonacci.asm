addi t1, zero, 0
addi t2, zero, 1

addi t3, zero, 11  #max iteraciones
addi t4, zero, 0  #contador

fibonacci:
	beq t4, t3, exit
	add t5, t1, t2
	add t1, zero, t2 # remplaza valor al anterior
	add t2, zero, t5 # pasa a ser el valor actual
	addi t4, t4, 1   # incrementar contador
	beq zero, zero, fibonacci
	
exit:
	add t2, zero, t2
	
	
