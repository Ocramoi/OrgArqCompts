$LC0:
        .ascii  "Numero em Bin: \000"
$LC1:
        .ascii  "%d\000"
decToBin:
        addiu   $sp,$sp,-176
        sw      $31,172($sp)
        sw      $fp,168($sp)
        move    $fp,$sp
        sw      $4,176($fp)
        lw      $2,176($fp)
        nop
        sw      $2,24($fp)
        li      $2,33                 # 0x21
        sw      $2,28($fp)
        b       $L2
        nop

$L5:
        lw      $2,28($fp)
        nop
        addiu   $2,$2,-1
        sw      $2,28($fp)
        lw      $3,24($fp)
        li      $2,-2147483648                  # 0xffffffff80000000
        ori     $2,$2,0x1
        and     $2,$3,$2
        bgez    $2,$L3
        nop

        addiu   $2,$2,-1
        li      $3,-2                 # 0xfffffffffffffffe
        or      $2,$2,$3
        addiu   $2,$2,1
$L3:
        move    $4,$2
        lw      $2,28($fp)
        nop
        sll     $2,$2,2
        addiu   $3,$fp,24
        addu    $2,$3,$2
        sw      $4,12($2)
        lw      $2,24($fp)
        nop
        srl     $3,$2,31
        addu    $2,$3,$2
        sra     $2,$2,1
        sw      $2,24($fp)
$L2:
        lw      $2,24($fp)
        nop
        beq     $2,$0,$L4
        nop

        lw      $2,28($fp)
        nop
        bgez    $2,$L5
        nop

$L4:
        lui     $2,%hi($LC0)
        addiu   $4,$2,%lo($LC0)
        jal     printf
        nop

        lw      $2,28($fp)
        nop
        sw      $2,32($fp)
        b       $L6
        nop

$L7:
        lw      $2,32($fp)
        nop
        sll     $2,$2,2
        addiu   $3,$fp,24
        addu    $2,$3,$2
        lw      $2,12($2)
        nop
        move    $5,$2
        lui     $2,%hi($LC1)
        addiu   $4,$2,%lo($LC1)
        jal     printf
        nop

        lw      $2,32($fp)
        nop
        addiu   $2,$2,1
        sw      $2,32($fp)
$L6:
        lw      $2,32($fp)
        nop
        slt     $2,$2,33
        bne     $2,$0,$L7
        nop

        li      $4,10                 # 0xa
        jal     putchar
        nop

        nop
        move    $sp,$fp
        lw      $31,172($sp)
        lw      $fp,168($sp)
        addiu   $sp,$sp,176
        j       $31
        nop