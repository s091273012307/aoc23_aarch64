all: abi_test heap_impl day_1 day_1.sym

abi_test: abi_test.c
	aarch64-linux-gnu-gcc abi_test.c -o abi_test

heap_impl: heap_impl.c
	gcc heap_impl.c -o heap_impl

day_1: day_1.asm utils.asm
	aarch64-linux-gnu-as -L -g day_1.asm -o day_1.o
	aarch64-linux-gnu-ld day_1.o -o day_1

day_1.sym: day_1
	aarch64-linux-gnu-objcopy --only-keep-debug day_1 day_1.sym

clean:
	-rm -f abi_test heap_impl day_1.o day_1 day_1.sym
