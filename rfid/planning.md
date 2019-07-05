# RFID Lab

## Outline

- SPI tutorial
- How RFID works
- Details on the MFRC522
- Interfacting with the MFRC522

## SPI Tutorial

Serial Peripheral Interface (SPI) is a synchronous serial communication interface,
similar in purpose to UART and I2C. 

### Comparisons to Other Protocols
Since we've focused on I2C in previous tutorials, let's discuss some differences
between the communications protocols:

- I2C allows for multiple masters, SPI does not
- Due to its simplicity, SPI is typically much much faster
    * I2C is typically 100 kbps, 400 kbps, or 3.4 Mbps
    * SPI does not have a maximum and is typically between 10 Mbps to 20 Mbps
- I2C requires just 2 wires for up to 128 devices on one master, SPI is a 4
wire protocol and each slave gets its own address line
- I2C has a very well defined protocol with messages comprised of frames,
SPI defines no protocol for data exchange and is up to manufacturers. 

### Basics of SPI
In typical 4-wire mode SPI, we have one master (which could be a microcontroller
like an Arduino) and one or more slaves. A clock wire synchronizes communication 
speeds. We have two wires for communication, one for master to slave (Master Out 
Slave In, or MOSI), and one for slave to master (Master In Slave Out, MISO). The
last wire in the communication protocol is the Slave Select line, which the 
master can draw low to specify which slave it wants to talk to.

### SPI Modes
SPI has 4 modes for the clock to operate. We define two settings that can be 
0 or 1: Clock Polarity (CPOL), and Clock Phase (CPHA). These yield 4 total setting 
combinations which are the 4 modes.

Mode 0 is CPOL=0 and CPHA=1, and data is sampled at the leading rising edges.

Mode 1 is CPOL=0 and CPHA=1, and data is sampled at the trailing falling edges.

Mode 2 is CPOL=1 and CPHA=0, and data is sampled at the leading falling edges.

Mode 3 is CPOL=1 and CPHA=1, and data is sampled at the trailing rising edges.

TODO: Show picture of examples of these 4 modes.

Mode 0 is by far the most common mode of operation for SPI.

### Data Exchange Protocol
As mentioned, SPI defines no data exchange protocol. It is completely up
to the manufacturer of each component to define how it should communicate
with a master. 

Nevertheless, we will discuss the most common modes of reading and writing.

#### Writing
First the master draws the slave select line low for the device it wants to
write to.

Next, the master writes the register instruction that it wants to send
data to; this is done on the MOSI line.

The following bytes are the data to write to the register.

#### Reading
Similar to writing, the master first draws the slave select line now and
then writes an instruction register to read from on the MOSI line.

The core difference is that now the slave can send data on the MISO line,
and notify the master that it's ending transmission by drawing the slave
select line high.

## How RFID Works

Radio Frequency IDentification technology is what allows seemingly
magical technology like Apple Pay to function. It has many uses across
industries, such as animal tracking; store security; and university 
card identification (MCards!).

While there are a plethora of RFID communication protocols, the basic 
physics remains the same. 

There are two big picture components: tags and readers. Tags are 
what get embedded into ID cards or animals, and readers can identify 
these tags.


Passive RFID basics: http://ftp.it.murdoch.edu.au/units/ICT219/Papers%20for%20transfer/Passive%20RFID%20Basics.pdf

### Tags

There are two types of tags: passive and active. Passive tags gain their
power from the reader using some clever manipulation of electromagnetic
waves, while active tags have a battery as their power source.

The main difference is that passive tags are cheaper at the trade-off
of operating at shorter distances. We will be focusing on passive tags
in this lab, as that is what is used most commonly in our daily lives.

#### Passive Tag

The reader is the power source for an RFID tag. The reader constantly 
transmits energy to an antenna which creates electromagnetic waves that
permeate the space around it.

A tag contains a small coil, and when the magnetic wave of the reader
passes through the area of the coil it produces a changing magnetic flux,
which induces a current in the tag's coil.
This current is used to power a small integrated circuit (IC) embedded 
within the tag.

The IC interacts with a small memory chip which is also
embedded in the tag. Once the tag has determined what it wants to 
send back to the reader, it must somehow relay this data to back to the
reader.

The way a tag communicates back to a reader is through _backscatter_.
When the reader first emitted a signal, it was done by powering the
reader's antenna. Now that the tag's antenna also has current through it,
it will also emit a weaker but detectable signal back to the reader.

The tag's IC can affect the backscatter signal by changing the voltage
drop across the tag's coil. It does this by switching on and off a load
across the circuit. These on and off signals affect the backscattered wave
and can be detected by the reader. These fluctuations in the backscattered
wave are interpreted as 1s and 0s.

## ISO/IEC 1444
### PCD standard 
### PICC standard 
#### Type A vs Type B

## MFRC522

The MFRC522 is a contactless reader/writer created by NXP Semiconductors. 
It supports various MIFARE variants, which is NXP's brand of smartcard
solutions.

### What is MIFARE? What is the difference with RFID?

Both RFID and MIFARE technology are radio frequency based systems that
can be used for identification purposes; however, MIFARE technology
was created with much more than basic identification systems in mind.

MIFARE smartcards typically have a secure memory unit within the chip 
that can store much more information than typical RFID solutions. 
Additionally, the MFRC522 is compliant with the first 3 parts of the 
ISO/IEC 14443 (the international standard for proximity cards).

Since the sensor and cards are so cheap, we can easily learn everything
about RFID but also take it a step further and understand how practical
implementations in hotels, stadiums, etc. are able to securely store
data on these cards.

### Sensor notable features
#### FIFO Buffer

### Sensor setup
#### Communication
#### Get sensor version
#### Implement ability to soft reset
#### Control antennas

### Important register descriptions and how to use them 
#### CommandReg 
#### ComIrqReg
#### ErrorReg
#### FIFO Registers

### Executing commands
#### Tranceive

### Communicating with a PICC
