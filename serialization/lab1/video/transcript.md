# Serialization Lab 1 Video Transcript

# Goal
The goal of this video is to briefly introduce serialization and subconcepts
like streams and computer files. We want to explain when serialization is used,
show examples of serialization, and discuss how we plan to use it in microcontrollers.

Since Hands on Engineering videos are typically meant to be more practical and
building oriented, we will restrict content covered to the bare minimum needed
to follow the following implementation labs. This will be a relatively short intro
video.

# Content Organization
## Introduction

- Explain how these labs are split up (theory and implementation)
- Draw attention to PDF
- Recommend prerequisites for implementation labs
    * Lab 2 to be able to have some data to work with
    * Lab 4 for OpenLog

## What is serialization?

- Definition
- Explain why we would need serialization 
- List various formats 
    * Show examples of serialization here
    * Show Ruby example

## Background for the implementation labs

- Explain what streams and computer files are
- Discuss where these concepts come into play for serialization
- Discuss microcontroller constraints

# Transcript

## Introduction
Hello and welcome to another Hands on Engineering tutorial. In this lab we'll be briefly introducing serialization and some related concepts. Make sure to check out the pdf for this lab, which is linked in the description below. It goes over additional information that might be helpful while learning about serialization.

This lab is split up so that this video will be focused on theory, while the following labs will emphasize how to actually implement serialization into your Arduino project. While this video doesn't have any pre-requisites, we recommend watching or being familiar with the content covered in Aduino Labs 2 and 4 before moving onto the implementation videos.

## What is serialization?
### Ruby Example
Here is a very simple example of serialization in Ruby. We used Ruby in this example because it is easy to read without knowledge of the language.

First we define a class to hold some sensor reading value. `attr_reader` just creates a getter for the `sensor_reading` variable. `initialize` is the constructor for this object.

Next, we define a variable `my_datapoint` which is an instance of Datapoint. This instance holds a sensor reading with a string GPGGA. 

Then, we serialize the contents of this object. As mentioned, 'marshalling' is synonymous with 'serializing'. Because of this, Ruby wraps serialization methods into a module called 'Marshal'. `Marshal#dump` serializes the `my_datapoint` object, and we store this into a variable `serialized_string`.

Finally, we try to recreate the object using only the serialized string. `Marshal#load` is able to create the Datapoint object with exactly the same contents. We know this is a new object in memory because the object id (the hex after the colon) is different from when we first serialized the object. 

While this particular example may seem redundant, it becomes useful when we transmit the serialized string across the internet and recreate the object on another computer, or if we saved it to the disk and recreated the object at a later point in time.
