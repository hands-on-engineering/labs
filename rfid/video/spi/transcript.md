# RFID Lab 1: SPI 
## Goal
The goal of this video is to introduce what Serial Peripheral Interface
(SPI) is to students. We will compare it to I2C and UART to give students
a comprehensive understanding of interface communications.

## Content Organization
### Overview

- Asynchronous vs synchronous
- Useful for high speed transfer over short distances
- Occasionally SPI will be our only option if the sensor doesn't support I2C or UART
- There is no formal standard, so we need to be familiar with reading the datasheet to determine how to send data messages correctly

### Interface
- MISO, MOSI, SCK, SS
- Multiple slaves: individual SS lines or daisy chaining
- SPI Mode: polarity and clock phase
- Timing
    * SS low 
    * SCK indicates sampling
    * Data sent over MISO and MOSI
    * SS goes high again

#### Arduino SPI capabilities
- The Arduino uses AVR chips that provide dedicated SPI communication
hardware, with certain pins dedicated to be MOSI/MISO/SCK/SS
    * An ICSP header can be used to standardize which pins these are for
    most boards; they are usually tied to certain digital pins
    * On an Arduino Nano, the ICSP header is tied to the following pins:
        - 10 (SS), 11 (MOSI), 12 (MISO), 13 (SCK)
        - Pin 13 is also tied to the built in LED
- Can use other pins with bit banging, but we won't cover this

### Comparison to other Serial communication protocols
|      | Pins Needed | Speeds                                                   | Distance |
|------|-------------|----------------------------------------------------------|----------|
| UART | 2           | 115.2 kbps                                               | 10+ m    |
| SPI  | 4           | 4 Mbps as slave, 8 Mbps as master                        | ~0.25 m  |
| I2C  | 2           | Typically 0.4 Mbps, some processors can support 3.4 Mbps | ~1 m     |

## Transcript

