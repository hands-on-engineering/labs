# Lesson Plan

## Learning Objectives

At the end of the lesson, students will be able to:

1. Sketch memory diagrams for simple C/C++ code
2. Create and use pointers in their programs

## Classroom Assessments

Closed Ended Questions:
1. How do you declare a pointer of some type?
  - Answer: Place a `*` symbol to the left of the variable name
2. How do you get the memory address of an object in memory?
  - Answer: Using the `&` operator
3. How do you dereference a pointer type?
  - Answer: Using the `*` operator
4. What is an object?
  - Answer: A piece of data in memory
5. What is an address?
  - Answer: The location of an object in memory
6. What is a declaration?
  - Answer: Introduces a name into the program and begins its scope

## Connections

- Connections to students' prior knowledge:
  - In Engineering 101 and previous labs in Engineering 100 Section 950, students have been exposed to basic C++ programming concepts and pointers are an extension to their knowledge

- Connections to the big picture:
  - Pointers are an important aspect of programming and are used under the hood
    even in langauges that hide them
  - Pointers will be used in the next lab to write efficient GPS code

- Connections to students interests and values:
  - CS majors: Pointers will become an important part of any CS major's
    courseload, and early exposure will make EECS 280/281 easier
  - CE majors: Many low level libraries for embedded systems often use pointers
    extensively throughout their code; learning pointers will help students
understand how a seemingly complex program works
  - CLaSP majors: Electronics for space measurement require software to
    interface with them, and thus pointers become useful for the same reason CE
majors should be familiar with them
  - Other majors: CS is becoming increasingly used throughout all fields!
    Expanding your understanding of the basics is always helpful.

## Learning Activities

- Lesson
  * To understand a program, we should use a simple machine model to help us
    reason about what memory looks like during runtime of a program
    - Example:
        *  ```
            int main() {
              int x = 3;
              double y = 4;
              x = y;
            }
           ```
      * Draw a few boxes, call it the "stack"*
        - Emphasize that the memory locations at runtime are chosen somewhat
          arbitrarily, it doesn't need to go to the first place available
  * The programmer doesn't have control over the address at which an object is
    located, but we can query for it!
    - We use the address of operator, `&`
    - Example:
      * ```
        int x = 3;
        cout << &x << endl;
        ```
      * Example output: `0x7ffee0659a2c`
  * What if we want to store this address? That's what pointers are for!
    Pointers are a category of objects that can store addresses.
    - We declare a pointer by putting a `*` to the left of the variable name
    - Example: `int *ptr = &x`
  * A pointer "points to an object". What if we want to get the value that it
      points to? 
    - We use the `*` operator, called "dereferencing".
  * How can we represent a pointer in our machine memory model?
    - Example:
      * ```
        int x = 3;
        int y = 4;
        int *ptr = &x;
        cout << *ptr << endl; // prints 3
        ptr = &y;
        cout << *ptr << endl; // prints 4
        ```
      * *Draw a few boxes, assign 3 to x and 4 to y. Then, have a pointer box
        that stores the index of the x value, show "following the pointer" to
print 3, and then reassign it to y and show "following the pointer" to print 4*

- Engagement
  * Questions during lecture
    - Asking students to sketch the memory model for a small C program
    - Asking students questions 4-6 from *Classroom Assessments* verbally
  * Exit ticket
    - Asking students to answer questions 1-3 on a 1 minute exit ticket

## Summary

In this lesson, students learned how to create basic sketches of memory for C/C++ programs and how pointers fit into this model. Students additionally learned syntax for creating and using pointers in their programs.

Next, students will learn about some pitfalls for pointers and how they can spot these errors and detect them in their programs (using tools like Valgrind). Additionally, students will learn about the relation between pointers and arrays.
