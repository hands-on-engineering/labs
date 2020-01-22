# Video Transcript

## Intro
Hello and welcome to another Hands on Engineering video! In this video, we'll be
continuing our crash course on pointers and arrays.
 
In the last video, we covered some basics about pointers, like what they are and
how you can create and use them. We also covered how variables look in memory,
and how we can sketch out the behavior of a program visually.

If you haven't watched this video, we recommend you watch it before watching
this video since this video's content requires a good grasp of pointer basics.

## Main presentation
### Learning Objectives

In this video, you'll learn how to: design software that uses arrays, and debug
common errors with arrays and pointers.

### Terminology

We'll be throwing around the terms contiguous memory, primitive types, and
array.

Contiguous just means sequential, so contiguous memory refers to a block of
memory where addresses are one after another.

A primitive type is a basic type supported natively by the language we're using. You can think of it like a building block of data.

An array is a contiguous block of memory where we're just storing 1 type of
data. This means arrays are homogenous.

### Array Basics

Arrays are always a fixed size. As mentioned, they are also elements of the same
kind and are stored one after another in memory.

A really important concept that might save you some frustration down the road is
that primitive types are default initialized to undefined values. Arrays are
primitive, so if you don't explicitly set the contents somehow you'll wind up
with junk memory.

As a note on the first bullet point: you might
wonder about vectors or dynamic arrays if you've used them, since these
containers clearly are not fixed in the number of elements we can hold. The
specifics of this are beyond the scope of this short lesson, but in the end it
boils down to the container allocating a fixed size array and then making a new
and bigger one when it's full. If you want to learn more, you may be interested in
the EECS 280 course.

### Knowledge Check 1

Let's do a quick knowledge check. Try the following problems and we'll be back
shortly.

...

These questions are directly explained in the previous few slides, so be sure to
go back and review them if you got something wrong.

### Declaring and Accessing Arrays

Just to reiterate, since it's very important: implicit initialization of an
array will result in junk values.

To declare an array, you write the type, the name, and in square brackets the
size of the array. If you want to explicitly initialize it, you can use what's
called an initializer list. You write the elements you want in brackets like we
do on this slide.

Say you wanted to have your array filled with a sane value, like an array of 0s
instead of junk values. You can use an empty initializer list to accomplish
that.

To access an element at index n, write the name of the array and then in square
brackets put the number of the element you want to access.

### Arrays and Pointers

Data usually has a value associated with it. For example, the element in the
array to the right at index 2 does have a value with it: 2. But what would the
value of the entire array be?

The answer is that there is none, since it doesn't really make sense. The
language does the most reasonable thing it can when you try to get a value for
an array: it returns a pointer to the first element. This is called array decay.

In the code below, the first cout line reads: "Print the address of the first
element of the array", which is 0x1000. The line below it might be less obvious.
It actually does the same thing, and also prints 0x1000. Why is this?

Well, cout requires a value to be passed in, and when we give it `array`, it
can't resolve a value so it decays into a pointer, and printing this pointer
prints the value of the pointer which is the address it stores.

The next line uses the fact that array returns a pointer, and dereferences it to
change the value to -1. This updates the first element of the array to -1.

The final line prints out the value of the first element, which we just changed
to be -1.

### Consequences of Array Decay

Array decay actually has a lot of consequences that might not be obvious at
first. It's important to remember though, that the computers are dumb and do
exactly what you tell them to. Once you know how something is supposed to
behave, it'll always do that.

Okay, the first thing is array assignment. You might expect this code to assign
array 2 to equal array 1, but actually when you try assigning something it
requires a value (the thing you want to set it equal to). When you assign an
array, the program tries to get the value of the array which we just
demonstrated actually decays the array into a pointer. 

Now you have a compile error! The left side is an array, and you're trying to
set it equal to what has become a pointer.

-- 

An even less obvious consequence is when you try to pass an array to a function
as a parameter. By default, parameters are pass by value, so calling a function
with an array as a parameter will cause it to decay into a pointer.

In the code below, all of these function definitions are equivalent to func4,
the last one. No matter what you do, you'll wind up passing in a pointer which
has absolutely no information about the original array's size.

If you're ever in a situation where you want to pass a primitive array into a
function, you'll need to pass in the size of the array too as a separate
parameter. There actually is another way to handle this, which C-Strings do,
called a sentinel value, where the last value of your array represents the end
of it. We're not going to go in depth on sentinel values in this video.

### Knowledge Check 2

Let's do another knowledge check making sure you can use arrays in your code and
understand array decay.

...

Here are the answers. Again, this content is what we covered in the last few
slides so go back if you need to make sure you have a solid foundation on a
concept.

### Pointer Arithmetic

Now we'll cover the basics of pointer arithmetic. We left this concept out of
the first video because pointer arithmetic is most useful for dealing with
arrays. It's often helpful to have a pointer to elements in an array and move
the pointer forward and backwards through the elements.


Pointer arithmetic means that you can add and subtract integers and other
pointers to and from a pointer.

Something to note is that these operations are in terms of elements, not bytes.
This means that if I have a int pointer and I add 1 to it, it will move forward
in memory the size that 1 int occupies, not 1 byte.


Let's see a visual example of using pointers to move through arrays. On this
slide, we have some code that we've run up to where the white arrow points. The
right image is a memory diagram showing all the variables, addresses, and values
at this point in time.

The first line declared an array of size 4. You might notice that in some cases
we can actually omit the size of the array when the initializer list makes it
clear to the compiler.

The second line defines a pointer to an int called ptr1, and assigns it the
first element in the array by allowing it to decay.

The second line creates another pointer called ptr2, and gets the address of the
second element in the array. The third and fourth line do the same but using
different equivalent syntaxes that make use of pointer arithmetic. 

When we step forward one line in the program, we increment pointer by one. This
will move it forward 1 element in memory, causing it to point to the next
element in the array. You can see that ptr1's arrow has moved forward when this
line executes.

The final line shows that we can subtract pointers to get the number of elements
between them. We see that from the diagram this would be 2-1, or 1 element.

### Knowledge Check 3

Let's do a quick checkpoint on pointer arithmetic. Give these problems a try and
we'll show the answer in a few seconds.

...

The first three questions come directly from the previous slides, so go back and
review if you were confused. The last question is tricker and involves some of
the concepts we covered in the first video. The way this works is that the
variable go blue decays into a pointer when we try adding two to it, which
effectively moves the pointer forward 2 elements. Since the goblue pointer was
to the first element, and we advanced it forward twice, we now have a pointer to
the 3rd element. To actually access the value of this element, we dereference
our pointer using the asterisk.


### More on Common Pointer Errors

In the last video we covered some pointer mistakes that lead to undefined
behavior. These issues come up most frequently when dealing with pointers to
elements in arrays. For instance, if you increment your pointer past the end of
an array, or decrement it to before the first element of your array, then you
have a pointer that is dangerous to dereference. Having the pointer itself isn't
necessarily a bad thing, but the second you dereference it you will have
undefined behavior.

This mistake happens mostly when iterating through an array. The way to ensure
you never step out of bounds is to have a variable denoting the length of the
array, or store a sentinel value like C-strings do with their null character.

### Knowledge Check 4

This is an important knowledge check that shows very common issues you'll face.
Give them a try and we'll be back with the answers shortly.

...

The first question is safe behavior. We create a pointer to an integer by
advancing a pointer to the first element of goblue forward 5 times. Now, our
pointer points to an element past the end of the array goblue. This is actually
fine, we are allowed to have a pointer to a place in memory we don't control.

The issue is dereferencing this pointer, which is what we do in problem 2. This
behavior is unsafe.

## Outro / Summary Slide

That's all we have for you today. Hopefully you learned a little bit more about
pointers, and how they relate to arrays.

If you have any questions, leave a comment below and we'll try to get back to you. Be sure to subscribe for more Hands on Engineering videos in the future, and we'll see you next time!
