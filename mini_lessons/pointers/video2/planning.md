# Lesson Plan

## Learning Objectives

At the end of the lesson, students will be able to:

1. Design software to allocate contiguous blocks of memory using arrays
2. Access contiguous memory using arrays and pointer arithmetic
3. Debug and avoid pointer errors involving arrays

## Classroom Assessments

1. T/F: An array can hold elements of different types
  - Answer: F
2. T/F: An array may store elements in different parts of memory (out of sequential order)
  - Answer: F
3. T/F: An implicitly initialized integer array will be filled will junk values (not 0s)
  - Answer: T
4. T/F: Arrays have a value associated with them as a whole
  - Answer: F
5. Write the declaration of an array called “goblue” that holds 5 integers 
  - Answer: `int goblue[5];`
6. Write code to access the 3rd element of “goblue” using square bracket syntax
  - Answer: `goblue[3];`
7. What is meant by “the tendency of arrays to decay into pointers”?
  - Answer: When a value of an array is needed in a program, the compiler will
    convert it to an array pointing to the first value of the array (since
arrays don't have a value associated with them as a whole)
8. Why can a function with an array parameter not guarantee the size of that array?
  - Answer: The array will decay to a pointer, which contains no size
    information
9. T/F: You can add/subtract integers to/from from a pointer
  - Answer: T
10. T/F: Pointers can be added and subtracted from other pointers
  - Answer: T
11. T/F: Pointer arithmetic is in terms of bytes
  - Answer: T
12. Given the array declaration below, write code to access the 3rd element using pointer arithmetic 
  - Answer:  `int goblue[5] = { 1, 2, 3, 4, 5 };`

## Connections

Provided in video1

## Learning Activities

None provided in video. Students will get to practice with pointer arithmetic in
the GPS lab.

## Summary
In this lesson, students learned the following key points:
- Arrays store a fixed size of homogeneous elements contiguously in memory
- Arrays and pointers are strongly related
- Pointers past the end of your array are fine to declare, but not safe to dereference

