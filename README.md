# OS-Project-2

### Assembling the Combo.asm : 

To build combo.vmx, follow these steps : 
1) f-build combo.vmx kernel-stub.asm kernel.c (you will get an error saying the build failed)
2) Edit the combo.asm file : in the combo.asm file go to the section right after the .text section of our code and click enter before the .Code so that it is written in a new line. Save the new combo.asm
3) f-assemble combo.asm

The reason for failure : 
When we tried to f-build the combo.vmx file, the combo.asm file was not generated correctly. Specificly the kernel.asm code was added at the end of our kernel-stub.asm code without adding a new line. This led to the .Code section (the beginning of kernel.asm code) to not be interpreted correctly by the compiler and hence the entire kernel.asm file was interpreted as the continuation of the text section of our kernel-stub.asm. To fix this we manually changed the location of .Code by adding a new line.