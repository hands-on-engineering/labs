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

The standard defines two important terms: 

- PICC: Proximity Integrated Circuit Card (the actual smart card)
- PCD: Proximity Coupling Device (the card reader)


At a high level, the PCD creates an energizing field and constantly is polling for PICCs. It does this by sending out a command frame which can be either REQA (Request for Type A card) or a WUPA (Wake Up Type A card). When a PICC enters the energizing field, it should respond to either of these commands with an ATQA command frame (Answer to Request Type A). 

PICCs essentially are state machines. They are `IDLE` prior to any functioning, and then switch to different `READY` states based off of what commands they receive from a PCD.

#### Type A vs Type B

This difference is not very relevant anymore because of advances in technology. In general, the difference is historical. 

Type A was created first by Mikron (later purchased by NXP). This implementation was memory card only without a microprocessor. Type A at the time couldn't provide continuous power to a Type A PICC with a microprocessor. Another company managed to do this, and it became known as Type B in the ISO/IEC. Now you can have either memory or microprocessor as either Type A or Type B, hence the difference isn't very important anymore.

There are small differences though in ASK modulation settings and bit rate speeds, so care must be taken when impementing the chosen type. We will focus on Type A in this lab.

[Source](https://electronics.stackexchange.com/questions/222055/why-are-there-types-a-and-b-in-iso-14443).

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
The sensor has a 64 byte First In First Out (FIFO) buffer. This is used as IO between the Arduino and the sensor's internal processes. 

Using the FIFO registers, we can flush the buffer or access information about it.

#### Timer Unit
The sensor has a timer unit meant for the Arduino to manage tasks. The timer does not affect anything within the sensor itself. Our code takes advantage of the timer to determine how long has elapsed after the sensor has finished receiving data; we use this to create a timeout for when PICCs have to respond by.

### Sensor setup
#### Communicating with registers
The MFRC522 uses the most common command format used with SPI. It is described in the datasheet, but any SPI tutorial will cover the basic communication.

Some important notes about communication through SPI:

- The sensor requires Most Significant Bit first format (MSBFirst)
- The LSB of addresses is always logic 0
    * **Important:** This means that the datasheet gives addresses that actually have to fit within bits 6 to 1 in a byte, so we have to shift the address bytes over by 1 bit to the left
- The MSB of addresses determines whether we are reading (1) or writing (0)
- MFRC522 8.1.2.1 and 8.1.2.2 gives us more details on SPI read/write
    * Regarding reading: We should send out n addresses, and start reading after our first
    send command. We should discard the data that comes out of MISO when writing the first
    byte. To end reading, we should send `0x00`.

#### Get sensor version
Once we have implemented basic communication with the sensor, let's make sure we've done it right by getting the version.

Read from the VersionReg (0x37h) and see what you get. If you get `91h` or `92h`, you have successfully set up reading registers! The 9 stands for NXP chipset, and the second digit is the version number (v1 or v2).

#### Implement soft reset
Changes we make to our code won't be reflected by simply uploading new code to the Arduino. The registers won't be reset unless we either fully remove power and restart the sensor, or if we issue a reset command.

To issue a soft reset command, write to the CommandReg (0x01h) the SoftReset command code (00001111b). Add a delay to account for how long it takes for the oscillator to start up (150 ms should be enough).

#### Control antennas
After a soft reset, the MFRC522 disables its transmitting antennas. Let's turn them back on by writing to the TxControlReg (0x14h). The first 6 bits of this register store settings, while only the last two control whether antennas are on (there are 2 antennas).

To make sure we only flip on the last two bits, we should implement a function to set or clear bit masks. 

#### Various register settings
Before we proceed to try and implement some commands in the ISO/IEC, we should adjust a few settings to make sure the sensor will behave as we expect.

- Timer Unit
    * Enable TAuto = 1 for the TModeReg
        * This will instruct the timer to automatically start a countdown every time we finish transmitting some data
    * Set TPrescalerReg = `0xA9`, TReloadRegH = `0x03`, TReloadRegL = `0xE8`
        * This will instruct the timer to be a countdown of 25 milliseconds
        * We calculated these register values from the datasheet's equation (5); see the below section on the Timer Unit for an explanation of this equation
    * Set TxASKReg to use 100% ASK modulation
        * If you search online, you will find that Type A interfacing uses 100% ASK modulation
    * Set ModeReg = `0x3D`
        * ISO/IEC 14443-3 6.1.6 states that the initial value of the CRC coprocessor should be `6363` for Type A interfacing. This value of the register switches the last 2 bits to `01` causing it to set the CRC coprocessor register value correctly.

### Important register descriptions and how to use them 
#### CommandReg 
We can write commands to this register and have them execute. The datasheet describes how these commands are used.

Some commands, like `Transceive`, need data to work with. We can provide this data by passing it into the FIFO buffer.

Some commands terminate themselves, others require specifically being directed to end. These are described in the subsections of MFRC522 10.3.1. The default state of the device is Idle and the command `Idle` will place the device in this state.

#### ComIrqReg
Unfortunately, the device's IRQ pin isn't physically wired to anything. Because of this, we can't create cleaner event-driven code.

However, this doesn't stop us from polling the IRQ register and detecting when certain events happen. This register has 8 irq flags that we can use to detect when important events happen.

These events tend to be things like the timer unit finishing its countdown, data transmission ending, and more. 

#### ErrorReg
The error register can be used in the same way as we use the ComIrqReg: polling for events.

By polling the ErrorRegister, we can detect when we have things like a Buffer Overflow or a collision.

#### FIFO Registers
- FIFODataReg: this register lets us read and write from a 64 byte buffer
    * We use this for storing the commands that we want to broadcast using the device antennas. We can create a byte buffer in our code, create a command frame, and then copy this command frame into the physical FIFO buffer.
- FIFOLevelReg: reading this register will return how many bytes are currently in the register

### Executing commands
#### Transceive

### Communicating with a PICC
