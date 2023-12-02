.global _start
.text
.include "utils.asm"
_start:
    ### local stack variables ###
    # 0x00 = sum
    # 0x08 = current val
    # 0x10 = fd
    # 0x18 = tmp
    # 0x20 = part2_first
    # 0x28 = part2_second
    # 0x30 = cur_index
    # 0x38 = x19
    # 0x40 = x20
    # 0x48 = saved_x0
    # 0x50 = saved_x1
    .set STACK_SIZE, 0x48
    sub sp, sp, STACK_SIZE
    eor x0, x0, x0
    str x0, [sp]
    str x0, [sp, 0x8]
    str x19, [sp, 0x10]
    str x0, [sp, 0x18]
    str x19, [sp, 0x38]
    str x20, [sp, 0x40]


    # open file
    ldr x0, =file_name
    mov x1, _O_RDONLY
    mov x2, 0
    bl _open
    cmp x0, -1
    b.eq fail

    # save the fd
    mov x19, x0

    parse_input_file_and_sum:
        mov x0, x19
        bl _read_line_to_string
        cmp x0, -1
        b.eq done_reading_file
        cmp x0, 0
        b.eq parse_input_file_and_sum
        
        # val
        mov x8, 0
        # index
        mov x1, 0
        mov x2, 0

        loop_and_find_first_dec:
            ldrb w2, [x0, x1]
            cmp w2, 0
            b.eq done_reading_file
            cmp x2, 0x30
            b.lt jump_over_1
            cmp x2, 0x39
            b.gt jump_over_1
            sub x8, x2, 0x30
            b found_first_str

            jump_over_1:
                add x1, x1, 1
                b loop_and_find_first_dec
        
        found_first_str:
        mov x3, 0xa
        mul x8, x8, x3

        find_end_of_string:
            ldrb w2, [x0, x1]
            cmp x2, 0
            b.eq loop_and_find_second_dec
            add x1, x1, 1
            b find_end_of_string

        loop_and_find_second_dec:
            ldrb w2, [x0, x1]
            cmp x2, 0x30
            b.lt jump_over_2
            cmp x2, 0x39
            b.gt jump_over_2
            sub x2, x2, 0x30
            b found_second_dec

            jump_over_2:
                sub x1, x1, 1
                b loop_and_find_second_dec

        found_second_dec:

        # save x0, x1
        str x0, [sp, 0x48]
        str x1, [sp, 0x50]
        add x8, x8, x2

        # print out num
        str x8, [sp, 0x18]
        mov x0, x8
        # bl _print_dec_n

        # update the overal total
        ldr x0, [sp]
        ldr x1, [sp, 0x18]
        add x0, x0, x1
        str x0, [sp]

        b parse_input_file_and_sum
  
    done_reading_file:
        # print out the overal sum and exit
        ldr x0, =sum_msg1
        bl _puts_no_newline

        ldr x0, [sp]
        mov x1, 1
        bl _print_dec_n

    mov x0, x19
    bl _close
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
    mov x0, 0
    str x0, [sp]
    # open file for part 2
    ldr x0, =file_name
    mov x1, _O_RDONLY
    mov x2, 0
    bl _open
    cmp x0, -1
    b.eq fail

    # save the fd
    mov x19, x0

    parse_input_file_and_sum_part2:
        mov x0, x19
        bl _read_line_to_string
        cmp x0, -1
        b.eq parse_input_file_and_sum2
        cmp x0, 0
        b.eq parse_input_file_and_sum2
        mov x20, x0

        # bl _puts_no_newline

        mov x0, x20
        mov x1, xzr

        loop_and_find_first_dec_2:
            ldrb w2, [x0, x1]
            cmp w2, 0
            b.eq done_reading_file_2
            cmp x2, 0x30
            b.lt jump_over_1_2
            cmp x2, 0x39
            b.gt jump_over_1_2
            sub x8, x2, 0x30
            b found_first_str_2

            jump_over_1_2:
                add x1, x1, 1
                b loop_and_find_first_dec_2
        
        found_first_str_2:
        str x8, [sp, 0x20]
        str x1, [sp, 0x30]

        # find left side word
        # 0x20 = part2_first
        # 0x30 = cur_index
        zero:
            mov x0, x20
            ldr x1, =zero_s
            bl _find
            movq x1, 0xffffffffffffffff
            cmp x0, x1
            b.eq skip_zero

            # we found a number, lets see if it arrived before the last
            ldr x2, [sp, 0x30] // cur_index
            movq x1, 0xffffffffffffffff
            cmp x1, x2
            b.eq zero_uninitialized
            cmp x0, x2
            b.gt skip_zero
            # replace with us
            zero_uninitialized:
            str x0, [sp, 0x30]
            mov x1, 0 // zero
            str x1, [sp, 0x20]
            skip_zero:
        
        one:
            mov x0, x20
            ldr x1, =one_s
            bl _find
            movq x1, 0xffffffffffffffff
            cmp x0, x1
            b.eq skip_one

            # we found a number, lets see if it arrived before the last
            ldr x2, [sp, 0x30] // cur_index
            movq x1, 0xffffffffffffffff
            cmp x1, x2
            b.eq one_uninitialized
            cmp x0, x2
            b.gt skip_one
            # replace with us
            one_uninitialized:
            str x0, [sp, 0x30]
            mov x1, 1 // one
            str x1, [sp, 0x20]
            skip_one:

        two:
            mov x0, x20
            ldr x1, =two_s
            bl _find
            movq x1, 0xffffffffffffffff
            cmp x0, x1
            b.eq skip_two

            # we found a number, lets see if it arrived before the last
            ldr x2, [sp, 0x30] // cur_index
            movq x1, 0xffffffffffffffff
            cmp x1, x2
            b.eq two_uninitialized
            cmp x0, x2
            b.gt skip_two
            # replace with us
            two_uninitialized:
            str x0, [sp, 0x30]
            mov x1, 2 // two
            str x1, [sp, 0x20]
            skip_two:
        
        three:
            mov x0, x20
            ldr x1, =three_s
            bl _find
            movq x1, 0xffffffffffffffff
            cmp x0, x1
            b.eq skip_three

            # we found a number, lets see if it arrived before the last
            ldr x2, [sp, 0x30] // cur_index
            movq x1, 0xffffffffffffffff
            cmp x1, x2
            b.eq three_uninitialized
            cmp x0, x2
            b.gt skip_three
            # replace with us
            three_uninitialized:
            str x0, [sp, 0x30]
            mov x1, 3 // three
            str x1, [sp, 0x20]
            skip_three:
        
        four:
            mov x0, x20
            ldr x1, =four_s
            bl _find
            movq x1, 0xffffffffffffffff
            cmp x0, x1
            b.eq skip_four

            # we found a number, lets see if it arrived before the last
            ldr x2, [sp, 0x30] // cur_index
            movq x1, 0xffffffffffffffff
            cmp x1, x2
            b.eq four_uninitialized
            cmp x0, x2
            b.gt skip_four
            # replace with us
            four_uninitialized:
            str x0, [sp, 0x30]
            mov x1, 4 // four
            str x1, [sp, 0x20]
            skip_four:
        
        five:
            mov x0, x20
            ldr x1, =five_s
            bl _find
            movq x1, 0xffffffffffffffff
            cmp x0, x1
            b.eq skip_five

            # we found a number, lets see if it arrived before the last
            ldr x2, [sp, 0x30] // cur_index
            movq x1, 0xffffffffffffffff
            cmp x1, x2
            b.eq five_uninitialized
            cmp x0, x2
            b.gt skip_five
            # replace with us
            five_uninitialized:
            str x0, [sp, 0x30]
            mov x1, 5 // five
            str x1, [sp, 0x20]
            skip_five:
        
        six:
            mov x0, x20
            ldr x1, =six_s
            bl _find
            movq x1, 0xffffffffffffffff
            cmp x0, x1
            b.eq skip_six

            # we found a number, lets see if it arrived before the last
            ldr x2, [sp, 0x30] // cur_index
            movq x1, 0xffffffffffffffff
            cmp x1, x2
            b.eq six_uninitialized
            cmp x0, x2
            b.gt skip_six
            # replace with us
            six_uninitialized:
            str x0, [sp, 0x30]
            mov x1, 6 // six
            str x1, [sp, 0x20]
            skip_six:

        seven:
            mov x0, x20
            ldr x1, =seven_s
            bl _find
            movq x1, 0xffffffffffffffff
            cmp x0, x1
            b.eq skip_seven

            # we found a number, lets see if it arrived before the last
            ldr x2, [sp, 0x30] // cur_index
            movq x1, 0xffffffffffffffff
            cmp x1, x2
            b.eq seven_uninitialized
            cmp x0, x2
            b.gt skip_seven
            # replace with us
            seven_uninitialized:
            str x0, [sp, 0x30]
            mov x1, 7 // seven
            str x1, [sp, 0x20]
            skip_seven:
        
        eight:
            mov x0, x20
            ldr x1, =eight_s
            bl _find
            movq x1, 0xffffffffffffffff
            cmp x0, x1
            b.eq skip_eight

            # we found a number, lets see if it arrived before the last
            ldr x2, [sp, 0x30] // cur_index
            movq x1, 0xffffffffffffffff
            cmp x1, x2
            b.eq eight_uninitialized
            cmp x0, x2
            b.gt skip_eight
            # replace with us
            eight_uninitialized:
            str x0, [sp, 0x30]
            mov x1, 8 // eight
            str x1, [sp, 0x20]
            skip_eight:
        
        nine:
            mov x0, x20
            ldr x1, =nine_s
            bl _find
            movq x1, 0xffffffffffffffff
            cmp x0, x1
            b.eq skip_nine

            # we found a number, lets see if it arrived before the last
            ldr x2, [sp, 0x30] // cur_index
            movq x1, 0xffffffffffffffff
            cmp x1, x2
            b.eq nine_uninitialized
            cmp x0, x2
            b.gt skip_nine
            # replace with us
            nine_uninitialized:
            str x0, [sp, 0x30]
            mov x1, 9 // nine
            str x1, [sp, 0x20]
            skip_nine:

        # 0x20 = part2_first
        # 0x30 = cur_index
        ldr x1, [sp, 0x20]
        mov x2, 0xa
        mul x1, x1, x2
        # store into val
        str x1, [sp, 8]

        # find right side
        # 0x28 = part2_second
        # 0x30 = cur_index
        mov x0, 0
        str x0, [sp, 0x28]
        str x0, [sp, 0x30]

        mov x0, x20
        mov x1, 0

        find_end_of_string_2:
            ldrb w2, [x0, x1]
            add x1, x1, 1
            cmp x2, 0
            b.eq loop_and_find_second_dec_2
            b find_end_of_string_2

        loop_and_find_second_dec_2:
            ldrb w2, [x0, x1]
            cmp x2, 0x30
            b.lt jump_over_2_2
            cmp x2, 0x39
            b.gt jump_over_2_2
            sub x2, x2, 0x30
            b found_second_dec_2

            jump_over_2_2:
                sub x1, x1, 1
                b loop_and_find_second_dec_2

        found_second_dec_2:

        # x1 has the offset of the found number
        # x2 has the number
        str x2, [sp, 0x28]
        str x1, [sp, 0x30]

        r_zero:
            mov x0, x20
            ldr x1, =zero_s
            bl _rfind
            movq x1, 0xffffffffffffffff
            cmp x0, x1
            b.eq r_skip_zero

            # we found a number, lets see if it arrived after the last
            ldr x2, [sp, 0x30] // cur_index
            movq x1, 0xffffffffffffffff
            cmp x1, x2
            b.eq r_zero_uninitialized
            cmp x0, x2
            b.lt r_skip_zero
            # replace with us
            r_zero_uninitialized:
            str x0, [sp, 0x30]
            mov x1, 0 // zero
            str x1, [sp, 0x28]
            r_skip_zero:

        r_one:
            mov x0, x20
            ldr x1, =one_s
            bl _rfind
            movq x1, 0xffffffffffffffff
            cmp x0, x1
            b.eq r_skip_one

            # we found a number, lets see if it arrived after the last
            ldr x2, [sp, 0x30] // cur_index
            movq x1, 0xffffffffffffffff
            cmp x1, x2
            b.eq r_one_uninitialized
            cmp x0, x2
            b.lt r_skip_one
            # replace with us
            r_one_uninitialized:
            str x0, [sp, 0x30]
            mov x1, 1 // one
            str x1, [sp, 0x28]
            r_skip_one:

        r_two:
            mov x0, x20
            ldr x1, =two_s
            bl _rfind
            movq x1, 0xffffffffffffffff
            cmp x0, x1
            b.eq r_skip_two

            # we found a number, lets see if it arrived after the last
            ldr x2, [sp, 0x30] // cur_index
            movq x1, 0xffffffffffffffff
            cmp x1, x2
            b.eq r_two_uninitialized
            cmp x0, x2
            b.lt r_skip_two
            # replace with us
            r_two_uninitialized:
            str x0, [sp, 0x30]
            mov x1, 2 // two
            str x1, [sp, 0x28]
            r_skip_two:

        r_three:
            mov x0, x20
            ldr x1, =three_s
            bl _rfind
            movq x1, 0xffffffffffffffff
            cmp x0, x1
            b.eq r_skip_three

            # we found a number, lets see if it arrived after the last
            ldr x2, [sp, 0x30] // cur_index
            movq x1, 0xffffffffffffffff
            cmp x1, x2
            b.eq r_three_uninitialized
            cmp x0, x2
            b.lt r_skip_three
            # replace with us
            r_three_uninitialized:
            str x0, [sp, 0x30]
            mov x1, 3 // three
            str x1, [sp, 0x28]
            r_skip_three:

        r_four:
            mov x0, x20
            ldr x1, =four_s
            bl _rfind
            movq x1, 0xffffffffffffffff
            cmp x0, x1
            b.eq r_skip_four

            # we found a number, lets see if it arrived after the last
            ldr x2, [sp, 0x30] // cur_index
            movq x1, 0xffffffffffffffff
            cmp x1, x2
            b.eq r_four_uninitialized
            cmp x0, x2
            b.lt r_skip_four
            # replace with us
            r_four_uninitialized:
            str x0, [sp, 0x30]
            mov x1, 4 // four
            str x1, [sp, 0x28]
            r_skip_four:

        r_five:
            mov x0, x20
            ldr x1, =five_s
            bl _rfind
            movq x1, 0xffffffffffffffff
            cmp x0, x1
            b.eq r_skip_five

            # we found a number, lets see if it arrived after the last
            ldr x2, [sp, 0x30] // cur_index
            movq x1, 0xffffffffffffffff
            cmp x1, x2
            b.eq r_five_uninitialized
            cmp x0, x2
            b.lt r_skip_five
            # replace with us
            r_five_uninitialized:
            str x0, [sp, 0x30]
            mov x1, 5 // five
            str x1, [sp, 0x28]
            r_skip_five:

        r_six:
            mov x0, x20
            ldr x1, =six_s
            bl _rfind
            movq x1, 0xffffffffffffffff
            cmp x0, x1
            b.eq r_skip_six

            # we found a number, lets see if it arrived after the last
            ldr x2, [sp, 0x30] // cur_index
            movq x1, 0xffffffffffffffff
            cmp x1, x2
            b.eq r_six_uninitialized
            cmp x0, x2
            b.lt r_skip_six
            # replace with us
            r_six_uninitialized:
            str x0, [sp, 0x30]
            mov x1, 6 // six
            str x1, [sp, 0x28]
            r_skip_six:

        r_seven:
            mov x0, x20
            ldr x1, =seven_s
            bl _rfind
            movq x1, 0xffffffffffffffff
            cmp x0, x1
            b.eq r_skip_seven

            # we found a number, lets see if it arrived after the last
            ldr x2, [sp, 0x30] // cur_index
            movq x1, 0xffffffffffffffff
            cmp x1, x2
            b.eq r_seven_uninitialized
            cmp x0, x2
            b.lt r_skip_seven
            # replace with us
            r_seven_uninitialized:
            str x0, [sp, 0x30]
            mov x1, 7 // seven
            str x1, [sp, 0x28]
            r_skip_seven:

        r_eight:
            mov x0, x20
            ldr x1, =eight_s
            bl _rfind
            movq x1, 0xffffffffffffffff
            cmp x0, x1
            b.eq r_skip_eight

            # we found a number, lets see if it arrived after the last
            ldr x2, [sp, 0x30] // cur_index
            movq x1, 0xffffffffffffffff
            cmp x1, x2
            b.eq r_eight_uninitialized
            cmp x0, x2
            b.lt r_skip_eight
            # replace with us
            r_eight_uninitialized:
            str x0, [sp, 0x30]
            mov x1, 8 // eight
            str x1, [sp, 0x28]
            r_skip_eight:

        r_nine:
            mov x0, x20
            ldr x1, =nine_s
            bl _rfind
            movq x1, 0xffffffffffffffff
            cmp x0, x1
            b.eq r_skip_nine

            # we found a number, lets see if it arrived after the last
            ldr x2, [sp, 0x30] // cur_index
            movq x1, 0xffffffffffffffff
            cmp x1, x2
            b.eq r_nine_uninitialized
            cmp x0, x2
            b.lt r_skip_nine
            # replace with us
            r_nine_uninitialized:
            str x0, [sp, 0x30]
            mov x1, 9 // nine
            str x1, [sp, 0x28]
            r_skip_nine:


        # lets pull from val and 
        ldr x8, [sp, 8]
        ldr x0, [sp, 0x28]
        add x8, x8, x0
        str x8, [sp, 8]


        // ldr x0, =_space
        // bl _puts_no_newline
        // ldr x0, [sp, 8]
        // bl _print_dec_n

        # add to current sum
        ldr x0, [sp, 8]
        ldr x1, [sp]
        add x0, x0, x1
        str x0, [sp]

        b parse_input_file_and_sum_part2

    # finalize it
    done_reading_file_2:
    parse_input_file_and_sum2:
    ldr x0, =sum_msg2
    bl _puts_no_newline

    ldr x0, [sp]
    bl _print_dec_n
    

    b b_over_fail
    fail:
    ldr x0, =fail_msg
    bl _puts
    b_over_fail:


    ### local stack variables ###
    ldr x19, [sp, 0x38]
    ldr x20, [sp, 0x40]
    add sp, sp, STACK_SIZE

    mov x0, 0
    b _exit

.data
sum_msg1: .ascii "p1: sum of calibration values: \0"
.align 4
sum_msg2: .ascii "p2: sum of calibration values: \0"
.align 4
file_name: .ascii "day_1_input"
.align 4
fail_msg: .ascii "Unable to open file!\0"
.align 4
zero_s: .ascii "zero"
.align 4
one_s: .ascii "one"
.align 4
two_s: .ascii "two"
.align 4
three_s: .ascii "three"
.align 4
four_s: .ascii "four"
.align 4
five_s: .ascii "five"
.align 4
six_s: .ascii "six"
.align 4
seven_s: .ascii "seven"
.align 4
eight_s: .ascii "eight"
.align 4
nine_s: .ascii "nine"
