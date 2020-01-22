# Video Transcript

## Intro
Hello and welcome to another Hands on Engineering video! In this video, we'll be
giving a crash course on pointers and arrays.

This video is in a slightly different format than our other videos since it
isn't a physical lab you'll be building, and is geared toward our Engineering
100 Section 950 class. Even if you aren't in this class, hopefully you'll still
find our explanations useful!

Be sure to check out the slides linked in the description below.

Many of the examples and diagrams are taken from the EECS280 lecture notes which
are freely available online. The link for these notes is in the description
below, and goes in further depth than we will here if you are interested.

## Main Presentation

### Learning Objectives

At the end of this lesson, you'll be able to: sketch memory diagrams using a
model we introduce to help you visualize what your code does at runtime, create
and use pointers in your programs, and debug some issues you're likely to run
into.

### Why Do I Need to Know About Pointers?

So, why do you need to learn about pointers? Well, this video is obviously
geared mostly towards CS/CE/and EE majors, where exposure to these concepts will
likely help you in future courses and industry. However, CS is rapidly becoming
important in an ever-growing list of fields, and it never hurts to deepen your
understanding.

### Why Do Pointers Exist

Why do pointers even exist? To start, C is pretty old and back then the
programmer needed to work with hardware with very limited capabilities. However,
these hardware restrictions still exist in some places like when dealing with
embedded systems.

If you've ever used a higher level programming language like Java, you know that
pointers aren't really a feature of the language. This is because the actual
usage of pointers is abstracted away and hidden from you, but it's still there
under the hood.

The C language is missing things you might be used to, like strings, arrays, and
writable function parameters. So, we use pointers to jam this functionality back
in.

Careful usage of pointers can also help with performance gains.

### Disclaimer

In this course, you'll be writing in ArduinoC which in theory is just C++.
However, Arduino's variety of C++ has a lot of hardware abstractions and often
doesn't really feel like you're writing in C++.

In general, the vast majority of the time you'll be writing in C for
microcontrollers.


### Terminology

Let's introduce some basic terms. In a system, you can work with some fixed
amount of memory. 

Pieces of data in this memory are referred to as objects, and we refer to these
locations through addresses.

A declaration is how we introduce a name into our program. For instance, when
we make a variable we are "declaring" it.

Declarations live in your source code, and objects live in memory at runtime.

### A Simple Machine Model

A simple machine model lets us keep track of variables we've defined and watch
as they change as your program runs. To the right is an example of one such
machine model. We keep track of memory addresses, objects at runtime, and what
these objects are declared as in our source code.

In this example, the OS chose to put x at address 1, and y at address 3. There
is no particular order to how these addresses are chosen, which is emphasized by
making them not consecutive. 

When we run the program, the first line changes the value of x to be an integer,
3. The second line changes the value at y to be a double, 4.0. Then we reassign
   x to equal y. This copies the value that y has, converts the double 4 into an
integer, and then updates the value in memory.

### Try it!

The EECS department has developed a tool called lobster. The tool allows
students to step through source code and see how memory changes line by line.

If you are a student at UofM, you can access this tool.

The memory diagram the tool provides is shown to the right. It looks slightly
more intimidating than our model, but really it is the same idea. The column on
the left is the address as a hexadecimal number, the middle column is the value
of that object, and the last column shows the variable's declared name. 

This program is similar to our last one, except instead of reassigning a
variable we make a new variable z and copy the value of x into it.

### Knowledge Check

Let's do a quick knowledge check. Pause the video and answer these questions on
your own, and we'll go over the answers shortly. 

...

These questions are intended to make sure you understand the terminology before
we proceed.
Objects don't live in your source code, they are the actual data in memory at
runtime. We refer to them via addresses.

Declarations do live in your source code, and it just means to introduce a name.

### Querying for Addresses
Generally, we aren't able to tell the system where it should put an object in
memory. Once an object is put into memory, however, we can ask the system where
it is using what's called the address of operator, which is the ampersand. We
place this symbol to the left of a declared variable to get where it is in
memory.

The below program spits out a hexadecimal value representing where it is in
memory. This output will change between runs since this happens at runtime. 

### Storing Addresses

So how does having an address help us if it changes all the time? Well, we can
store these addresses using a special variable type called a pointer. The power
of pointers comes with the fact that we can actually follow a pointer back to
the value it points to.

To make a pointer, we put an asterisk to the left of a variable name when we're
declaring it. To dereference a pointer, we put an asterisk in front of an
already declared variable.

In the example below, we declare a variable that points to an integer called
ptr. We set its value equal to the address of x, using the address of operator.

Then, we dereference the pointer with an asterisk to print out what value the
pointer points to.

As expected, the value is 0.

It can get very hard to visualize pointers very quickly, and that's why we
introduced our simple machine model. Let's go over a more complicated example
while using our model to follow our program's behavior at runtime.

### Visually Understanding Pointers

So below is a sample program. I've let the program run for 2 lines, so that x
and y have the values of 3 and 4 respectively set. The next line creates a
pointer called ptr which points to integer types, and we set its address to that
of x. So if we look at our model, we see that x's address is 0x1000. 

Now we can see that our pointer's value is 0x1000 and the diagram shows that the
pointer points to x.

Now, the next line dereferences pointer. First we fixure out what the value of
pointer is, which the address of x, 0x1000. Then we dereference it, which gets
the value at that address, 3.

Then, the next line changes what ptr points to. We first figure out what the
address of y is in the model, which is 0x1004. Then, we store this into ptr. You
can see the arrow has changed what it points to in the diagram.

Then we repeat the process of dereferencing and get the value of y now.

### Knowledge Check

Let's do a quick knowledge check again. Pause the video and give these questions
a try and we'll go over them shortly.

...

So, to declare a pointer we put an asterisk to the left of the name when
declaring the variable. To get the address of an object already in memory, you
place an ampersand to the left of the variable name.

To dereference a pointer you've already declared, place an asterisk to the left
of the variable name.

###  Common Pointer Errors

Here are some common errors you might run into when dealing with pointers.
Atomic means that we're dealing with a type that can't be subdivided any
further. Default initialization of atomic objects, like pointers, results in the
variable taking on an undefined value. In the case of pointers, a default
initialized pointer will point to some arbitrary address in memory. If you
dereference this kind of pointer, your program will have undefined behavior. It
might crash, or it might just work incorrectly. These are really hard issues to
debug, so be careful about initializing your variables!

A special value in memory is 0x00. A null pointer is one that points to this
address, and we can use the string literal nullptr in C++ or NULL in C to get a
pointer to this address. Dereferencing a null pointer is also undefined
behavior, but most implementations will cause a crash.


### Knowledge Check
Here is one last knowledge check on pointer errors. Give it a try, and we'll be
right back with the answers.

...

Dereferencing default initialized pointers and null pointers are indeed
dangerous undefined behaviors, and the null pointer is special in that it points
to 0x00.

## Outro / Summary Slide

That's all we have for you today. Hopefully you learned a little bit about
pointers and how we can use memory diagrams to visualize our program's behavior. 

If you have any questions, leave a comment below and we'll try to get back to
you. Be sure to subscribe for more Hands on Engineering videos in the future,
and we'll see you next time!

