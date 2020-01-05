# GPS Lab

## Introduction

Hello and welcome to another Hands on Engineering video! In the last video, we
saw how to wire up our GPS module and verify that we were receiving data. In
this lab, we'll learn more about the kind of data we were getting and how to
write software to extract the data we want. Make sure to check out the pdf for
this lab, which is linked in the description below.

We are assuming that your circuit is wired up from the last video for this code
to run. Additionally, some of the code we write today will use pointers. If you
aren't already familiar with pointers or need a refresher, be sure to take a
look at our video on them! 

## Outline

- NMEA Strings 
- Code Goals
- The Starter Code

## NMEA Strings

The National Marine Electrons Association (NMEA) has developed a standard for
communication between various marine electrons (like GPS receivers). The strings
you saw appearing on your screen from the last video were formatted according to
this specification. For our purposes, we just want the `$GPGGA` strings because
they contain the latitude, longitude, altitude and time information relevant for our weather baloon payload.

All NMEA sentences start with a `$` and end with a `\n`, and fields are
separated by commas. Some other characters are also reserved by the
specification, but this is enough information for us to begin parsing positional
data.

## Code Goals
Our code has 3 main goals: to retrieve data from the GPS, to extract the GPGGA string, and to parse and store desired information to the OpenLog.

### Storing the Spewed Data in a Buffer

The GPS uses information it gets from satellites to generate packets that it
continuously outputs. This kind of continuous output is called spewing.

Since data is just thrown at us by the GPS module, we need to be clever about
how we try to find our GPGGA string. 

The way we can do this is to use a buffer data structure (which in our case will
just be a simple array and an int pointing to where we are in the buffer, which
we'll refer to as the buffer index). In
our loop, we can spend some time filling up our buffer for later processing. 

*DIAGRAM:* Show a char array of what our buffer could look like at a particular
state. Emphasize that data could be shifted in a way that doesn't make much
sense, for ex: `N|*|4|4|\n|$|G|P|G|G|A|\0|\0|\0`.

Initially our buffer will be completely filled with null characters. A null
character will denote the end of the filled portion of the buffer. When a byte
of gps data is read in, we'll fill the slot in our array that our buffer index
points to and increment the index. 

### Finding the GPGGA string in the Buffer
As seen in the last section, our data buffer correctly stores incoming
information sequentially. However, there's no guarantee about where the
information we want is, or even if it's complete. The GPS could have just begun
spewing out a GPGGA string, but the buffer filled up before we could store the
whole thing; in this case, we've lost that data and will need to grab the next
GPGGA string.  

This is why we need to process the buffer every so often and look for `$GPGGA`
and a following `\n`. If we can find these, then we must have a complete GPGGA
string in our buffer and it's ready to be written to the output.

### Writing it to the OpenLog

Once we have the index of where the `$GPGGA` string starts and we know where it
ends (the first `\n` after the `$`), we can simply use a for loop to go through
our buffer starting at the `$` and ending at the `\n`.

## The Starter Code

The GPS code is nuanced and if improperly designed will lead to headaches. To
try and alleviate this, we've provided you with a starter file.

To successfully do this lab, you will need to complete a set of tasks described
in the README. These tasks will ask you to implement code where the comments in
the starter file direct you to. 

The starter file we provide has a `.starter` extension. Be sure to change this
into a `.ino` Arduino sketch so you can open it in the Arduino IDE.

In this portion of the video, we'll cover some ideas to help you complete these
tasks. 

### Overview of the Starter File

Besides for what a blank Arduino sketch contains (setup() and loop()), we have
added a few helper methods that you will implement. 

In setup, we prepare the Serial, GPS, and logger. The SoftwareSerial Library
gives us an easy way to communicate with these UART devices. DO NOT ALTER THE
ORDER OF THESE STATEMENTS. For reasons beyond what we expect you to deal with in
this course, Arduino Serial doesn't play nicely with multiple peripherals on the
same UART lines.

In loop, again we have some statements that force begin and end the GPS
SoftwareSerial. Do not remove or re-order these statements either, they are
needed to ensure the GPS and logger play nicely.

This loop where we fill up the buffer is meant to give the program some time to
fill up the buffer. We make use of the `millis()` function, which returns the
number of milliseconds elapsed since the Arduino program started running.

This number here, `startTime + GPS_DATA_BUFFER_SIZE + 2` is
not something you need to worry about too much. Just know that it is a number
and represents how long we spend per loop filling our buffer. We chose this
number to try and minimize how long the program spends filling up your buffer.
In theory, we could've arbitrarily chosen a large enough time—say, 2 seconds (or
2000 ms). 

### Task 1: Define Variables

For this task, you'll need to define some global variables for your program.

Like in the last video, you'll want to use a SoftwareSerial object to manage
communication with the sensor. 

Secondly, you are going to need a variable for your buffer index (call it
GPSDataBufferIndex). 

Finally, you also need a constant to define the size of your buffer, which
should be called GPS_DATA_BUFFER_SIZE. 

We've already provided you with the GPS data buffer implemented as a character
array. We explicitly initialize every element to `0x00`, or null. This isn't
strictly necessary for global variables, but we recommend you ALWAYS make sure
your variables (especially array values) are initialized before you use them.
This is because local variables, like in functions, will have garbage values by
default and using these values will lead to nasty undefined behavior. 

### Task 2: Write a Reset Function

As mentioned, we denote unfilled slots with the null character, `\0`. In order
to reset your buffer, iterate through every slot and set it to this null
character. Additionally, you have invalidated your buffer so your index no
longer makes sense; you should set it back to 0 so that new data gets put right
at the start.

As an optimization technique, consider whether you really need to fill every
single character in the buffer with null. What if the character you are looking
at is already null (i.e. reset was called when the buffer was only partially
filled). Do you need to set anything past a null character to null?

### Task 3: Implement Helper Functions for GPGGA Scanning
Three functions are left incomplete for you: `ptr_to_first_gpgga()`,
`distance_to_first_gpgga(const char*)`, and
`distance_to_first_newline_after_gpgga(const char* gpgga)`.

You are to implement these functions according to the RME documentation. 
#### ptr_to_first_gpgga
For the first of these functions, `ptr_to_first_gpgga()`, use the C-helper function `strstr`. 

*DIAGRAM:* man page of `strchr`:
```
NAME
     strstr, strcasestr, strnstr -- locate a substring in a string
...
SYNOPSIS
...
     char *
     strstr(const char *haystack, const char *needle);
...

DESCRIPTION
     The strstr() function locates the first occurrence of the null-terminated
     string needle in the null-terminated string haystack.

...

RETURN VALUES
     If needle is an empty string, haystack is returned; if needle occurs
     nowhere in haystack, NULL is returned; otherwise a pointer to the first
     character of the first occurrence of needle is returned.
```

`strstr` can take in two parameters: the string we are searching, haystack, and
the substring we are searching for, the needle.

Recall that a C-string is just an array of characters, and the end is denoted by
a null character ('\0'). 

Which variable in our program could be treated as a C-string resembling a haystack? What substring, or needle, is our `ptr_to_first_gpgga()` looking for?

#### distance_to_first_gpgga(const char*)
Given a pointer to the `$` of a GPGGA string, get the distance from this pointer
to the beginning of the array as an integer.

If the pointer passed in is null, then return -1.

How can we do this? Well, first let's investigate arrays for a second.

*DIAGRAM: basic array*

A pointer can point to any block in memory, including any of
these slots in the array. If our `ptr_to_gpgga()` returns a pointer at, say, the
3rd element, then it turns out we can subtract pointers to get how many blocks
of memory are in between two pointers. So if we take a pointer to slot at index
3 and subtract it from a pointer at slot 0, we'll get `3` as our answer.

How do we get a pointer to slot 0? Well, we could write something like
`&GPSDataBuffer[0]`, or just `GPSDataBuffer`. The reason that referring to an array by name returns a pointer is that, under the hood, arrays
are really just a pointer to the first index in memory of the array. When you
try to access the nth element of an array, the program actually first goes to
the first element of the array, goes forward n elements and then dereferences
the pointer.

The syntax `&GPSDataBuffer[0]` is semantically the same as `&*(GPSDataBuffer +
0)`, which reads "the address of the value that dereferencing the GPSDataBuffer
pointer at an offset of 0 yields".


So, to complete this task, get the number of slots between the pointer passed
into the function and the first slot of the GPSDataBuffer.

#### distance_to_first_newline_after_gpgga(const char*)

Given a pointer to the `$` of a GPGGA string, find the distance (from the
beginning of the buffer) to the first newline after the GPGGA string. 

If the pointer passed in is null, or there is no newline after the `$`, return
-1.

In order to accomplish this, you'll combine what you learned in
implementing the first two functions. Similar to `strstr`, there is a function
`strchr` which takes in a string s, and a character c. Use this function by
treating the gpgga pointer as a string, and `\n` as the character you are
searching for.

Once you get this pointer, get the number of slots between it and the first slot
of the GPSDataBuffer.


### Task 4: Loop!

As mentioned when we were going over the general starter file code structure,
this while loop is meant to give the program dedicated time to fill up the
buffer. The `millis()` function returns the time in milliseconds since the
Arduino program started. If we wanted to write a while loop that ran for 3
seconds, how would we accomplish this with `millis()`? If you are still
confused, consider that we can store the value of `millis()` into a variable
prior to our loop, and then compare the current time to some point in time past
our stored value.


When we are setting a slot in the buffer equal to data from the GPS, how do we
read from the GPS? Hint: take a look at the last video!

Finally, iterate through the buffer using your two distances and write out only
that portion of the buffer to your logger output.


## Outro

That's all we have for you today. Hopefully you learned something about NMEA
strings and how to handle spewing data with a buffer. We hope you enjoyed the
video, please leave a comment below if you have any questions and we'll try to
get back to you.
