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

There are 3 different categories of frequency operation:
- Low Frequency: 30 KHz to 300 KHz; typically 125 KHz
- High Frequency: 3 MHz to 30 MHz; typically 13.56 MHz
- Ultra High Frequency: 300 MHz to 3 GHz

Higher frequencies are meant for larger distances.

The cards and sensors we will be using communicate using close coupling
and operate at 13.56 MHz, so they are High Frequency (HF). These HF applications
are typically for transportation ticketing, identification, and sometimes payment.

[Source](https://www.impinj.com/about-rfid/types-of-rfid-systems/)

There are two methods of close coupling. Our card and reader use magnetic coupling, where the reader has a primary coil that couples with a secondary coil in the PICC. 

The reader alternates current in the primary coil creating changing magnetic flux in the field around the PCD. This is the "energizing field". When a PICC's antenna enters the changing flux, current is induced in the antenna.

The PICC will use this energy to power its microchip and its own antenna.

##### Load modulation

The PCD can detect voltage drops in the PICCs circuit. The way it detects voltage changes is the principle that power in the primary coil equals power in the secondary coil.

So, if the PICC wants to communicate back to the PCD, it can repeatedly connect and disconnect a load (like a resistor) across its antenna at particular times. 

This will change the power demanded by the secondary coil, thus drawing more current from the primary. The PCD can then measure these changes in current drawn and determine what data the PICC is trying to send back. This known as load modulation.

The particular method that data is encoded by load modulation is called Amplitude Shift Keying (ASK modulation). Connecting and disconnecting the load changes the amplitude of the signal on the PCD noticeably and is interpreted as 1s and 0s.


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

Hello and welcome to another Hands on engineering video. In this video
we'll be covering the basics of RFID at a high level. We'll learn what
RFID is and where it's used, the physics behind RFID communication, and
we'll get an overview of the international standards for RFID communication.

**Transition: Overview and Uses**

RFID stands for Radio Frequency IDentification. It uses electromagnetic
fields for object identification and tracking. 

RFID is used in many industries. For instance, RFID is used in factories
to track progress, warehouses to track inventory, and in farms to track
animals. It is also used in security applications to verify identity and
for payment data exchange.

Before we go further, let's go over some important definitions:
- Proximity Integrated Circuit Card (PICC): This is an RFID card or tag
- Proximity Coupling Device (PCD): This is an RFID reader
- Active: A PICC that uses a battery for its power source
- Passive: A PICC that reuses energy from a PCD's magnetic field

**Transition: Physics — Coupling**

Our tutorial focuses on passive tags since that's what most people are
familiar with, and is also most used in hobby projects incorporating RFID.

There are 3 frequency bands that most tags operate under:
- Low Frequency: 30 KHz to 300 KHz; typically 125 KHz
- High Frequency: 3 MHz to 30 MHz; typically 13.56 MHz
- Ultra High Frequency: 300 MHz to 3 GHz

Higher frequencies are meant for longer distances. The cards we use are
HF and operate at 13.56 MHz. These are most common for ticketing, identification, and sometimes payment.

Our card will use magnetic coupling to receive power and talk back to the PCD. The reader has a primary coil, and the card has a secondary coil.

The reader alternates current in the primary coil creating changing magnetic flux in the field around the PCD. This is the "energizing field". When a PICC's antenna enters the changing flux, current is induced in the antenna.

The PICC will use this energy to power its microchip and its own antenna.

**Transition: Physics — Load modulation**

**Diagram with animation of primary and secondary coils, and switching load**


The PCD can detect voltage drops in the PICCs circuit. The way it detects voltage changes is the principle that power in the primary coil equals power in the secondary coil.

So, if the PICC wants to communicate back to the PCD, it can repeatedly connect and disconnect a load (like a resistor) across its antenna at particular times.

This will change the power demanded by the secondary coil, thus drawing more current from the primary. The PCD can then measure these changes in current drawn and determine what data the PICC is trying to send back. This known as load modulation.

The particular method that data is encoded by load modulation is called Amplitude Shift Keying (ASK modulation). Connecting and disconnecting the load changes the amplitude of the signal on the PCD noticeably and is interpreted as 1s and 0s.

**Transition: ISO/IEC 14443 — Overview of Documents**
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

**Transition: ISO/IEC 14443-3 — Type A vs Type B**

There are Type A and Type B cards that are compliant with the standard. The reason these two interfaces exist is a historic competition between companies that slowly became irrelevant as technology advanced.

The international standards bodies work with companies who are experts in relevant fields.

Type A came first and was made by Mikron and their MIFARE technology. Mikron was later bought by Philips. Their cards were connected directly to a memory unit with no microprocessor involved.

Another company called Innovatron was tasked with developing a card with a microprocessor involved, as they viewed a card hooked directly to a memory unit as a security concern. After they developed it, they had it inserted into the ISO document as a Type B.

Now that technology has advanced and both interfaces are capable of having a memory unit and microprocessor chip, the difference is irrelevant. Most notable institutions simply rely on supporting both interfaces.

In our tutorial, we'll focus on just supporting Type A.

**Transition: ISO/IEC 14443-3 — Polling**

**Diagram/Picture of RFID setup with pulsing waves from PCD**

The PCD constantly is sending out Request commands (called REQA, Request for Type A), and waits until a PICC in the energizing field sends back a response (called ATQA, an Answer to Request of Type A).

These commands are organized into byte frames. The sensor hardware takes
care of the complicated details of frame timing, parity bits, etc. All we need to do is create command frame byte buffers in our software, and instruct the sensor to blast the command out through radio waves while following the standard. 

There are two types of frames: a short frame which is only 7 bits long, and a standard frame which is any number of bytes separated by parity bits.

For short frames, we need to tell the sensor to only send out 7 bits over the radio waves. The reason for this odd bit count is because it is impossible to mistake the signal for another frame type.

**Transition: ISO/IEC 14443-3 — Commands and PICC states**

**Picture of PICC FSM**

We will cover Finite State Machines in more detail in a later video. For now though: PICCs remain in certain states until we send commands to transition them.

They are normally either powered off, or if in the presence of a PCD they are in the IDLE state.

As mentioned before, while polling our PCD will constantly send out REQA commands. 

When a PICC enters the field and receives this command, it will transition to a READY state and simultaneously send back an Answer to Request of Type A (ATQA).

Receiving an ATQA means that a PICC is in the energizing field and is ready to be selected for further communication. The ATQA also encodes some other information, but we don't need to worry about that.

**Transition: ISO/IEC 14443-3 — Selection and Anticollision**

We can send out a Select command (SEL) to try and choose the PICC for further communication.

**Diagram of 1 PICC and PCD**

If there's only one PICC in the field, this is easy: we send out a blank SEL command and the PICC will return the first 4 bytes of its UID.

**Diagram of multiple PICCs and PCD**

If there are multiple PICCs in the field, the radio waves coming back from multiple PICCs will collide at certain bit positions. Our sensor hardware is capable of detecting where this bit collision occurs, and uses a process of anticollision to narrow down which card it would like to talk to.

We will detail anticollision more in a further video, but for now you can view it as a method for the reader to pick out 1 card and communicate only with that card.

**Transition: Credits**

All right everyone, that's it for this lab. We hope you enjoyed it and learned a little bit about what RFID is and how it works.

If you did, be sure to leave a like and subscribe to our channel. Feel free to leave a comment with suggestions for future videos. 

Stay tuned for more videos where we'll write code to use a sensor and actually interact with RFID cards using what we've learned here.

That's it for Hands on Engineering! See ya next time. 

