$LC0:
        .ascii  "Numero em Hex: \000"
$LC1:
        .ascii  "%d\000"
decToHex:
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

$L6:
        lw      $2,28($fp)
        nop
        addiu   $2,$2,-1
        sw      $2,28($fp)
        lw      $3,24($fp)
        li      $2,-2147483648                  # 0xffffffff80000000
        ori     $2,$2,0xf
        and     $2,$3,$2
        bgez    $2,$L3
        nop

        addiu   $2,$2,-1
        li      $3,-16                  # 0xfffffffffffffff0
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
        bgez    $2,$L4
        nop

        addiu   $2,$2,15
$L4:
        sra     $2,$2,4
        sw      $2,24($fp)
$L2:
        lw      $2,24($fp)
        nop
        beq     $2,$0,$L5
        nop

        lw      $2,28($fp)
        nop
        bgez    $2,$L6
        nop

$L5:
        lui     $2,%hi($LC0)
        addiu   $4,$2,%lo($LC0)
        jal     printf
        nop

        lw      $2,28($fp)
        nop
        sw      $2,32($fp)
        b       $L7
        nop

$L19:
        lw      $2,32($fp)
        nop
        sll     $2,$2,2
        addiu   $3,$fp,24
        addu    $2,$3,$2
        lw      $2,12($2)
        nop
        slt     $2,$2,10
        bne     $2,$0,$L8
        nop

        lw      $2,32($fp)
        nop
        sll     $2,$2,2
        addiu   $3,$fp,24
        addu    $2,$3,$2
        lw      $2,12($2)
        nop
        addiu   $2,$2,-10
        sltu    $3,$2,6
        beq     $3,$0,$L20
        nop

        sll     $3,$2,2
        lui     $2,%hi($L11)
        addiu   $2,$2,%lo($L11)
        addu    $2,$3,$2
        lw      $2,0($2)
        nop
        j       $2
        nop

$L11:
        .word   $L10
        .word   $L12
        .word   $L13
        .word   $L14
        .word   $L15
        .word   $L16
$L10:
        li      $4,65                 # 0x41
        jal     putchar
        nop

        b       $L18
        nop

$L12:
        li      $4,66                 # 0x42
        jal     putchar
        nop

        b       $L18
        nop

$L13:
        li      $4,67                 # 0x43
        jal     putchar
        nop

        b       $L18
        nop

$L14:
        li      $4,68                 # 0x44
        jal     putchar
        nop

        b       $L18
        nop

$L15:
        li      $4,69                 # 0x45
        jal     putchar
        nop

        b       $L18
        nop

$L16:
        li      $4,70                 # 0x46
        jal     putchar
        nop

        b       $L18
        nop

$L8:
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

        b       $L18
        nop

$L20:
        nop
$L18:
        lw      $2,32($fp)
        nop
        addiu   $2,$2,1
        sw      $2,32($fp)
$L7:
        lw      $2,32($fp)
        nop
        slt     $2,$2,33
        bne     $2,$0,$L19
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