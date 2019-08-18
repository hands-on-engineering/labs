# RFID Lab 2: High Level RFID
## Goal
The goal of this video is to go over the basics of RFID. We will cover
the uses of RFID, how waves are used to communicate between a reader 
and passive card, and introduce the ISO/IEC 14443 documents. 

## Content Organization
### Overview
Definitions:
- Proximity Integrated Circuit Card (PICC): This is an RFID card or tag
- Proximity Coupling Device (PCD): This is an RFID card reader

### Uses

RFID technology is implemented across many industries. It is used in factories to track production progress of an asset, warehouses to track inventory, and even animals. It is also used for security applications to verify identity, and to store customer information. 

### Physics 

- Active tags use a battery for longer distance communication
- Passive tags use the power of the energizing field around the reader itself to power up a small IC

Our tutorial focuses on passive tags since they are most widely used by consumers.

#### Coupling

The cards and sensors we will be using communicate using close coupling. Other methods of coupling do exist that are meant for larger distances; the methods we will cover are typically used for consumer transactions where close contact between the card and reader is safer.

There are two methods of close coupling. Our card and reader use magnetic coupling, where the reader has a primary coil that couples with a secondary coil in the PICC. 

The reader pulses the primary coil creating changing magnetic flux in the field around the PCD. This is the "energizing field". When a PICC's antenna enters the changing flux, current is induced in the antenna.

The PICC will use this energy to power its microchip and its own antenna.

##### Load modulation

The PCD can detect voltage drops in the PICCs return signal.

So, if the PICC wants to communicate back to the PCD, it can repeatedly connect and disconnect a load (like a resistor) across its antenna at particular times.

What this does is it will affect the amplitude of the return signal at different times. We refer to this as ASK modulation, or Amplitude Shift Keying.

### ISO/IEC 14443
#### Documents Overview

1. 14443-1: Physical Characteristics
    - Defines minimum environmental factors that cards have to be able to withstand
2. 14443-2: Radio frequency power and signal interface
    - Defines how the PCD should create its energizing field for communication between PCDs and PICCs
    - Modulation principle for ASK percentage defined
3. 14443-3: Initialization and anticollision
    - Defines how to poll for PICCs and how byte frames for commands are organized
    - Defines anticollision as a method to communication with one PICC out of many PICCs
4. 14443-4: Transmission Protocol
    - Defines a method to exchange data with PICCs
    
#### ISO/IEC 14443-3 

This is the most interesting part of the collection of documents for us. It goes over how we can send out special commands encoded in the waves sent out by the reader to interact with cards in the region.

##### Card Types

There are Type A and Type B cards that are compliant with the standard. The reason these two interfaces exist is a historic competition between companies that slowly became irrelevant as technology advanced.

The international standards bodies work with companies who are experts in relevant fields.

Type A came first and was made by Mikron and their MIFARE technology. Mikron was later bought by Philips. Their cards were connected directly to a memory unit with no microprocessor involved.

Another company called Innovatron was tasked with developing a card with a microprocessor involved, as they viewed a card hooked directly to a memory unit as a security concern. After they developed it, they had it inserted into the ISO document as a Type B.

Now that technology has advanced and both interfaces are capable of having a memory unit and microprocessor chip, the difference is irrelevant. Most notable institutions simply rely on supporting both interfaces.

In our tutorial, we'll focus on just supporting Type A.

[Source](https://www.secureidnews.com/news-item/is-the-debate-still-relevant-an-in-depth-look-at-iso-14443-and-its-competing-interface-types/)

##### Polling

The PCD constantly is sending out Request commands (called REQA, Request for Type A), and waits until a PICC in the energizing field sends back a response (called ATQA, an Answer to Request of Type A).


##### Frame formats

Byte frames make up the commands. The timing of these command frames is complicated and extremely particular. Thankfully, the sensors we use to interact with such cards handle all of this in their hardware. 

We simply need to create command frame byte buffers in our software, and instruct the sensor to blast the command out through radio waves while following the standard. We then can have the sensor read the data coming back, and again interpret it as a byte buffer of data to parse. 
We do have two special types of frames:
- Short frame (only 7 bits)
- Standard frame (multiple bytes separated by parity bits)

When we send out a short frame, we'll need to instruct the sensor to only transmit 7 bits over the radio waves. The reason the standard uses only 7 bits is because it's impossible to mistake the signal for another frame type.

Error checking is done in two different ways in different scenarios. Some scenarios require using an XOR check over 4 bytes, called BCC. Other times, we will uses a Cyclic Redundancy Check, called a CRC_A.

##### PICC States

We will cover Finite State Machines in more detail in a later video. For now though: PICCs remain in certain states until we send commands to transition them. 

They are normally either powered off, or if in the presence of a PCD they are in the IDLE state.

##### REQA and ATQA

We repeatedly send a Request for Type A (REQA) or Wake Up Type A (WUPA) command from the PCD while polling.

When a PICC enters the field and receives this command, it will transition to a READY state and simultaneously send back an Answer to Request of Type A (ATQA).

Receiving an ATQA means that a PICC is in the energizing field and is ready to be selected for further communication. The ATQA also encodes some other information, but we don't need to worry about that.

##### Selection and Anticollision

We can send out a Select command (SEL) to try and choose the PICC for further communication. 

If there's only one PICC in the field, this is easy: we send out a blank SEL command and the PICC will return the first 4 bytes of its UID. 

If there are multiple PICCs in the field, the radio waves coming back from multiple PICCs will collide at certain bit positions. Our sensor hardware is capable of detecting where this bit collision occurs, and uses a process of anticollision to narrow down which card it would like to talk to.

We will detail anticollision more in a further video, but for now you can view it as a method for the reader to pick out 1 card and communicate only with that card.

## Transcript

Hello and welcome to another Hands on engineering video.
