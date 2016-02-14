rm -f *.o

C="$C -c -std=c99 -O3 -DNATIVE_LITTLE_ENDIAN -I."
${X}gcc $C -DSUFFIX= blake2-dispatch.c blake2sp.c blake2bp.c

for x in b s; do
	${X}gcc $C blake2${x}-ref.c -DSUFFIX=_ref   -o libblake2${x}_ref.o
	${X}gcc $C blake2${x}.c     -DSUFFIX=_sse2  -o libblake2${x}_sse2.o  -msse2
	${X}gcc $C blake2${x}.c     -DSUFFIX=_ssse3 -o libblake2${x}_ssse3.o -msse2 -mssse3
	${X}gcc $C blake2${x}.c     -DSUFFIX=_sse41 -o libblake2${x}_sse41.o -msse2 -mssse3 -msse4.1
	${X}gcc $C blake2${x}.c     -DSUFFIX=_avx   -o libblake2${x}_avx.o   -msse2 -mssse3 -msse4.1 -mavx
	${X}gcc $C blake2${x}.c     -DSUFFIX=_xop   -o libblake2${x}_xop.o   -msse2 -mssse3 -msse4.1 -mavx -mxop
done

${X}gcc *.o -shared -o ../../bin/$P/$D $L
${X}ar rcs ../../bin/$P/$A *.o
rm *.o
