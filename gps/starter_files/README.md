# Lab 5: GPS

In this lab, you'll be implementing code to read, parse, and store GPS data using your Arduino Nano.

The GPS outputs a variety of different strings according to the [NMEA protocol](https://www.gpsinformation.org/dale/nmea.htm). Because we are interested in latitude, longitude, and altitude measurements, we will extract GPGGA strings from the GPS's output. It is important to check that theses strings are valid before writing them to storage. 

We've split your responsibilities into five tasks, which are covered in detail below. To successfully complete these tasks, you'll be required to use more advanced features of the C language, like `cstr` operations and pointer arithmetic, and work with more advanced data structures, like buffers. These features and structures (and how to correctly use them) are also detailed below.

Before looking through the details of this readme, watch the videos provided for this lab so you have a concrete understanding of the overarching goals of this code and how it interacts with the GPS, Arduino,and OpenLog hardware.

**Important notes**. The starter code we've provided is not functional code. Therefore it has a `.starter` extension. You will be writing functional adruino code and should alter the file extension accordingly. It is also important NOT to alter the order of and `.begin()` or `.listen()` statements. For reasons that are beyond the scope of this lab, the `SoftwareSerial` objects tend not to play nicely with one another and can change behavior drastically depending on inintalization ordering.

___

## `TASKS OVERVIEW`

[`TASK 1`](#task-1): &nbsp;&nbsp;&nbsp;Initialize global variables and constants to support the data buffer

`TASK 2`: &nbsp;&nbsp;&nbsp;Reset buffer to null and buffer index to zero

`TASK 3`: &nbsp;&nbsp;&nbsp;Implement functions to support GPGGA isolation

`TASK 4`: &nbsp;&nbsp;&nbsp;Read GPS data in to buffer

`TASK 5`: &nbsp;&nbsp;&nbsp;Isolate GPGGA string from buffer and send to OpenLog
___

___

## `TASK 1`

### Initalize global constants

___

`TASK 1`: Initialize global variables and constants to support the data buffer

**What is a buffer?**

A buffer is a data structure used to *temporarily* store data as it is moved from one location or process to another.

In this code, we implement a buffer using a `char` array. In C, arrays are a fixed size, contiguous collection of elements of a single type. That means, at declaration time, we need to assign a type, variable name, and vairable size. After delcaration, sufficient memory is allocated and the variable name then refers to the starting position of the array in memory (these are called pointers and are covered in more detail below). It is important to note that the variable name now only holds a memory address and does not contain any information about the size of the array. If we ever want to loop through this array without getting a segmentation fault error (or undefined behavior), it is important to store the size using another variable.

```c
int size = 5;
type varName[size];
```

**Why use a buffer?**

This code is designed to take data output by our GPS sensor, extract relevant information, and store that information in our OpenLog. Becuase the GPS sensor *spews*, or continuously outputs, data, we cannot synchronously recieve, process, and store that data. A buffer allows us to artificially halt the spewing behavior of the GPS, and not have to worry about syncronyzing processes on different pieces of hardware.

We can now control the frequency at which we recieve GPS data by controlling the speed at which our read/process/write loop operates. (But there is a theoretical upper limit to our recieving frequency. Can you find where we've hidden it in the starter file?)

**What we need to use a buffer in C.**

Our code relies heavily on functions to keep it managable, organize, and debuggable. Because most functions will need to have access to our buffer, we need to be slightly careful with where we declare it. Declaring it in `.loop()` would make the buffer local to `.loop()` and require us to pass it to each function. Having each function require the same or similar arguments is repetitive and not good style. It is instead much more convenient to instead declare it as a *global variable*, where all functions have access to it. (In 101, you should have learn global variables are bad practice and unnecessarily complicate code. While that is true for C++, globals are much more common in C).

<span style="color:red">**TODO**</span>

We have already initalized a `char` array for you to act as a buffer. Now you need to declare and initalize variables to store information about the buffer size and the buffer index. We use both variables in other locations in the starter code, make sure your variable name is the same or that you rewrite each line with a new variable name you decide to use. Set the buffer size to be 256. This number is somewhat arbitary, but come talk to an IA is you want more information on how we chose it.

You will also need to intialize your `SoftwareSerial` objects to establish RX and TX pins required for UART communication.

___

## `TASK 2`

### `void reset_GPSDataBuffer_and_index()`

___

`TASK 2`: reset buffer to null characters and buffer index to zero

Before we get in to why it is necessary to reset the buffer, we need to consider the difference between *how* we are treating the buffer and *what* the buffer actually is in memory.

**How are we using the buffer?**

Above, we mention that the buffer is being used to store GPS output, which is really just a series of NMEA strings. Well if we are storing strings, why is our buffer a `char[]` instead of a `string`? It's becuase, unlike C++, C doesn't have a `string` data type. This may seem strange, but you have to remember that C was developed in the early 1970s to build utilities running on Unix. See an IA if you want more details about why a language may choose to include or exclude a data type such as `string`.

To work around the lack of a `string` data type, computer sciencists developed a protocol to model strings using `char[]` called `cstr` (or `c_str`). A `cstr` is simply an array of characters terminated by a *terminating character*, `'\0'`(spoken as "null characer"). This allows users a clear starting and ending location, from which they can construct the string, character by character, by iterating through the array. We've included a number of functional examples below. It is important to note that the terminating character takes a nonzero amount of space to store. That means, to store a string of size n, we require a `char[]` with size greater than or equal to n+1.

```c
#include <string.h>

char str1[] = "balloon";    // ['b', 'a', 'l', 'l', 'o', 'o', 'n', '\0']
char str2[4];               // ['\0', '\0', '\0', '\0'] str2 == ""
str2[0] = 'c';              // ['c', '\0', '\0', '\0']  str2 == "c"
str2[1] = 'a';              // ['c', 'a', '\0', '\0']   str2 == "ca"
str2[2] = 't';              // ['c', 'a', 't', '\0']    str2 == "cat"
char str3[] = "cat";        // ['c', 'a', 't', '\0']    str3 == "cat"
char str4[6] = "cat"        // ['c', 'a', 't', '\0', '\0', '\0']
                            // str2 == str3 == str4 == "cat"
strcpy(str3, "tiger");      // ERROR, "tiger" requires char[] size > 5
strcpy(str4, "tiger")       // ['t', 'i', 'g', 'e', 'r', '\0']
```

the `cstr` protocol is widely used and has great resources for string manipulation. Read more about the [`string.h` library](https://www.tutorialspoint.com/c_standard_library/string_h.htm) to see what you can use them for.

**Why is it necessary to reset the buffer?**

When parsing the data buffer, we treat it as a `cstr`. It is important that the `cstr` has a `'\0'` terminating character. The garuentee this, we set each element in the buffer `char[]` to `'\0'`, or *reset* the buffer, before overwriting from the GPS each loop.

___

## `TASK 3`

### `char* ptr_to_first_gpgga()`

### `int distance_to_first_gpgga(const char* gpgga)`

### `int distance_to_first_newline_after_gpgga(const char* gpgga)`

___

`TASK 3`: Implement functions to support GPGGA isolation

To (easily) implement functions to isolate GPGGA strings from your buffer, you'll have to use **pointers** and **pointer arithmetic**. We will use the above functions to find the start and end indicies of a GPGGA string in our buffer, and write all characters between those two indicies to our OpenLog.

As mentioned above, pointers are simply variables that represent addresses in physical memory. These addresses are used to "point to" other locations in memory, where other variables are stored. Every variable is stored at some location in memory and every location has a specific address associated with it.

In C, pointers are *typed*, so a pointer to a `char` behaves differently than a pointer to an `int`. These types are specificed using the name of a data type followed by an asterisk. So `char*` refers to a char pointer and `int*` refers to an int pointer.

One important operation when working with pointers is **dereferencing**. It lets us access the data stored at a memory address instead of just accessing the memory address itself. We won't use this operation, but it's a core feature of pointers and you can learn more about them [here](https://www.i-programmer.info/programming/cc/8801-c-pointer-declaration-and-dereferencing-.html). You should read about [aliasing](https://en.wikipedia.org/wiki/Pointer_aliasing) too.

The main feature of pointers that we'll be using is **pointer arithmetic**. In brief, if the pointer **P** points at an element of an array with index **I**, and **N** is an `int`, then

* **P+N** and **N+P** are pointers that point at an element of the same array with index **I+N**

* **P-N** is a pointer that points at an element of the same array with index **I-N**

If the pointer **P1** points at an element of an array with index **I** and **P2** points at an element with index **J**

* **P1-P2** is an `int` with value **J-I**

These operations work because arrays are *contiguous* structures in memory. Find more information about pointer aritmetic and other operator arithmetic [here](https://en.cppreference.com/w/c/language/operator_arithmetic). Be careful when using pointer arithmetic to access arrays, as it is easy to over or underindex an array if you don't carefully track it's size and which index your pointer points to.

Pointer arithmetic underlies a lot of common array operations. For example, for any array `arr`, `arr[i]` and `*(arr+i)` are equivilent, where `*` denotes the dereferencing operation.


<span style="color:red">**TODO**</span>

Implement the functions above according to their respective RMEs (see starter code).

Use the following functions from the C string library to help you in your computations. Because we designed out buffer to adhere to the `cstr` protocol, we can take advantage of resources that other developers have already created, like the C string library. You can find detailed specifications for both functions on [cppreference.com](https://en.cppreference.com/w/) or many other places online.

```c
char* strstr( const char* str, const char* substr );
char* strchr( const char* str, int ch );
```

___

## `TASK 4`

### Read in GPS data

___

`TASK 4`: Read GPS data in to our buffer

You will be working with the following block of code for task 4.

```c
// This loop will hang for enough time to fill our GPS buffer
  //    We assume that the buffer can be read at ~1 Hz
  long startTime = millis();  
  // TASK 4: Replace the XXX in the below while loop (and inside the while loop) with your code for Task 4
  while( (XXX < startTime + GPS_DATA_BUFFER_SIZE + 2) && (GPSDataBufferIndex != GPS_DATA_BUFFER_SIZE - 1)) {
    if(GPS.available()) {
      GPSDataBuffer[GPSDataBufferIndex] = XXX;
      GPSDataBufferIndex++;
    }
  }
```

We use this `while` loop to fill our buffer and decide when we want to end the recieving phase of `loop()` and begin tparsing data.

At this point in `.loop()`, we've reset the buffer. Fill it in the `while` loop accordingly.

Use the `while` loop's control logic to determine when we're done recieving data. Consider both time and space constraints when working with the buffer. Theoretically, how long would our buffer take to fill up assuming GPS data at 1 Hz? What would happen if the GPS is not transmitting data the entire time we're attempting to read it? Would we ever be at risk of overindexing our buffer (array) if we only rely on theory?

The arduino [millis()](https://www.arduino.cc/reference/en/language/functions/time/millis/) function will be helpful to you. (We've also added an ancillary `+ 2` in the `while` loop's control logic. It causes the loop's behavior to differ slightly from theory but protects us from messy, undefined behavior that sometimes occurs when working with timing functions).

<span style="color:red">**TODO**</span>

Finish the `while` loop used to fill the data buffer and control RX/TX flow.

___

## `TASK 5`

### Transfer data to OpenLog

___

`TASK 5`: Isolate GPGGA string from buffer and send to OpenLog

At this point, we've filled our buffer with data from the GPS. We now need to look for a valid GPGGA string in our buffer, isolate it, and send it to our OpenLog.

Recall a GPGGA string will always begin `$GPGGA` and requires a terminating `'\n'` to be valid.

Above, you've implemented functions that will help you isolate a GPGGA string and determine its validity. Use them to help you find a start and end index for a valid string.

Use the `SoftwareSerial` object representing your OpenLog to transmit a valid string, if one is found. If no valid GPGGA string is found, do nothing.

<span style="color:red">**TODO**</span>

Isolate GPGGA string from buffer and send to OpenLog if valid.
