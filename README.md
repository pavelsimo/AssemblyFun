AssemblyFun
===========
AssemblyFun is a collection of simple Assembly language examples.

About the code examples
-----------------------
All the code examples will be written in Linux Assembly (AT&amp;T Syntax). Initially, I will be focus in IA-32 examples. Later on, IA-64 examples will be included as well.

Why Assembly
------------
* Understad high-level components from a low-level perpective. 
* Learn how the computer run a program.
* Understand how compiler optimize my code.
* Understand software that still be written in Assembly such as Embedded Sytems.
* Feel badass :)

Compile the examples
--------------------
    as -gstabs example.s -o example.o
    ld example.o -o example
