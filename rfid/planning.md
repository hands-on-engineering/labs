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

- I2C allows for multiple masters and slaves, SPI does not
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

Passive RFID basics: http://ftp.it.murdoch.edu.au/units/ICT219/Papers%20for%20transfer/Passive%20RFID%20Basics.pdf

### Readers

### Tags
