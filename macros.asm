.macro print_int (%x)
	li $v0, 1
	add $a0, $zero, %x
	syscall
.end_macro


.macro showImage (%image_pointer, %size)
	move $t3, %size
	sll $t3,$t3,2
	move $t1, %image_pointer #come�o
	add $t3,%image_pointer,$t3 #fim
	move $t2,%image_pointer

loop: #vira de cabe�a pra cima
	lw $t6,0($t1)
	lw $t7,0($t3)
	add $t4,$t6,$zero
	add $t6,$t7,$zero
	add $t7,$t4,$zero
	sw $t6, 0($t1)
	sw $t7 ,0($t3)
	addi $t1, $t1,4
	addi $t3,$t3,-4
	bne $t3,$t1,loop			
	
	move $t1,%image_pointer
	addi $t8,$zero,512 #n�mero de linhas que o loop dever� passar 
	
loopespelho:#loop das linas
	add $t3,$t1,2048
	addi $t9,$zero,256 #n�mero de repeti��es da troca de colunas 
loopinterno:#loop das colunas
	lw $t6,0($t1)
	lw $t7,0($t3)
	add $t4,$t6,$zero
	add $t6,$t7,$zero
	add $t7,$t4,$zero
	sw $t6, 0($t1)
	sw $t7 ,0($t3)
	addi $t1, $t1,4
	addi $t3,$t3,-4
	addi $t9,$t9,-1
	bne $t9,0,loopinterno
	
	add $t1,$t1,1024
	addi $t8,$t8,-1
	bne $t8,0,loopespelho

	move $t3,%size
	sll $t3,$t3,2
	add $t3,%image_pointer,$t3 
loop2:#loop de impress�o
  	lw $t4, ($t2) # move from space to register
	sw $t4, ($gp)
	addi $gp, $gp, 4
	addi $t2,$t2,4
	#bne $t2,%image_pointer,loop
	bne $t2, $t3, loop2

.end_macro

.macro showBlackWhite (%image_pointer, %size) 
	move $t3, %size
	sll $t3,$t3,2
	move $t1, %image_pointer #come�o
	add $t3,%image_pointer,$t3 #fim
	move $t2,%image_pointer
	addi $t7,$zero,0x007f7f7f #Filtro de cor
	addi $t9,$zero,1000
loop2:
  	lw $t4, ($t2) # move from space to register

	lb $t0 0($t4) 
	mul $t0,$t0,299    #  
	divu $t0,$t9       # R -> Grayscale
	sb $t0, 0($t4)     #   
	
	lb $t0 1($t4)     
	mul $t0,$t0,587   #
	divu $t0,$t9      # G -> Grayscale
	sb $t0, 1($t4)    #
	
	lb $t0 2($t4)     
	mul $t0,$t0,114   #
	divu $t0,$t9      # B -> Grayscale
	sb $t0, 2($t4)    #
	
# 	slt $t5,$t4,$t7 #compara a cor de t4 com o tom m�dio de cinza 
# 	beq $t5,1,preto 
# branco: addi $t4,$zero,0xffffffff	
#	 j continua
# preto:
# 	addi $t4,$zero,0
# continua:	
	
	sw $t4, ($gp)
	addi $gp, $gp, 4
	addi $t2,$t2,4
	bne $t2, $t3, loop2
.end_macro
