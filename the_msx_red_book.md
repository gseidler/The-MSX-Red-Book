#<a name="contents"></a>Contents

[Introduction](#introduction)

1. [Programmable Peripheral Interface](#chapter1)
    + [PPI Port A (I/O Port A8H)](#ppiporta)
    + [Expanders](#expanders)
    + [PPI Port B (I/O Port A9H)](#ppiportb)
    + [PPI Port C (I/O Port AAH)](#ppiportc)
    + [PPI Mode Port (I/O Port ABH)](#ppimodeport)
2. [Video Display Processor](#chapter2)
    + [Data Port (I/O Port 98H)](#dataport)
    + [Command Port (I/O Port 99H)](#commandport)
    + [Address Register](#addressregister)
    + [VDP Status Register](#vdpstatusregister)
    + [VDP Mode Registers](#vdpmoderegisters)
    + [Mode Register 0](#moderegister0)
    + [Mode Register 1](#moderegister1)
    + [Mode Register 2](#moderegister2)
    + [Mode Register 3](#moderegister3)
    + [Mode Register 4](#moderegister4)
    + [Mode Register 5](#moderegister5)
    + [Mode Register 6](#moderegister6)
    + [Mode Register 7](#moderegister7)
    + [Screen Modes](#screenmodes)
    + [40x24 Text Mode](#40x24textmode)
    + [32x24 Text Mode](#32x24textmode)
    + [Graphics Mode](#graphicsmode)
    + [Multicolour Mode](#multicolourmode)
    + [Sprites](#sprites)
3. [Programmable Sound Generator](#chapter3)
    + [Address Port (I/O port A0H)](#addressport)
    + [Data Write Port (I/O port A1H)](#datawriteport)
    + [Data Read Port (I/O port A2H)](#datareadport)
    + [Registers 0 and 1](#registers0and1)
    + [Registers 2 and 3](#registers2and3)
    + [Registers 4 and 5](#registers4and5)
    + [Register 6](#register6)
    + [Register 7](#register7)
    + [Register 8](#register8)
    + [Register 9](#register9)
    + [Register 10](#register10)
    + [Registers 11 and 12](#registers11and12)
    + [Register 13](#register13)
    + [Register 14](#register14)
    + [Register 15](#register15)
4. [ROM BIOS](#chapter4)
    + [Data Areas](#dataareas)
    + [Terminology](#terminology)
5. [ROM BASIC Interpreter](#chapter5)
6. [Memory Map](#chapter6)
7. [Machine Code Programs](#chapter7)

[Index](#index)

Contents Copyright 1985 Avalon Software  
Iver Lane, Cowley, Middx, UB8 2JD

MSX is a trademark of Microsoft Corp.  
Z80 is a trademark of Zilog Corp.  
ACADEMY is trademark of Alfred.

<br><br><br>

#<a name="introduction"></a>Introduction

##<a name="aims"></a>Aims

This book is about MSX computers and how they work. For technical and commercial reasons MSX computer manufacturers only make a limited amount of information available to the end user about the design of their machines. Usually this will be a fairly detailed description of Microsoft MSX BASIC together with a broad outline of the system hardware. While this level of documentation is adequate for the casual user it will inevitably prove limiting to anyone engaged in more sophisticated programming.

The aim of this book is to provide a description of the standard MSX hardware and software at a level of detail sufficient to satisfy that most demanding of users, the machine code programmer. It is not an introductory course on programming and is necessarily of a rather technical nature. It is assumed that you already possess, or intend to acquire by other means, an understanding of the Z80 Microprocessor at the machine code level. As there are so many general purpose books already in existence about the Z80 any description of its characteristics would simply duplicate widely available information.

##<a name="organization"></a>Organization

The MSX Standard specifies the following as the major functional components in any MSX computer:

1. Zilog Z80 Microprocessor
2. Intel 8255 Programmable Peripheral Interface
3. Texas 9929 Video Display Processor
4. General Instrument 8910 Programmable Sound Generator
5. 32 KB MSX BASIC ROM
6. 8 KB RAM minimum

Although there are obviously a great many additional components involved in the design of an MSX computer they are all small-scale, non-programmable ones and therefore "invisible" to the user. Manufacturers generally have considerable freedom in the selection of these small-scale components. The programmable components cannot be varied and therefore all MSX machines are identical as far as the programmer is concerned.

[Chapters 1](#chapter1), [2](#chapter2) and [3](#chapter3) describe the operation of the Programmable Peripheral Interface, Video Display Processor and Programmable Sound Generator respectively. These three devices provide the interface between the Z80 and the peripheral hardware on a standard MSX machine. All occupy positions on the Z80 I/O (Input/Output) Bus.

[Chapter 4](#chapter4) covers the software contained in the first part of the MSX ROM. This section of the ROM is concerned with controlling the machine hardware at the fine detail level and is known as the ROM BIOS (Basic Input Output System). It is structured in such a way that most of the functions a machine code programmer requires, such as keyboard and video drivers, are readily available.

[Chapter 5](#chapter5) describes the software contained in the remainder of the ROM, the Microsoft MSX BASIC Interpreter. Although this is largely a text-driven program, and consequently of less use to the programmer, a close examination reveals many points not documented by manufacturers.

[Chapter 6](#chapter6) is concerned with the organization of system memory. Particular attention is paid to the Workspace Area, that section of RAM from F380H to FFFFH, as this is used as a scratchpad by the BIOS and the BASIC Interpreter and contains much information of use to any application program.

[Chapter 7](#chapter7) gives some examples of machine code programs that make use of ROM features to minimize design effort.

It is believed that this book contains zero defects, if you know otherwise the author would be delighted to hear from you. This book is dedicated to the Walking Nightmare.

<br><br><br>

#<a name="chapter1"></a>1. Programmable Peripheral Interface

The 8255 PPI is a general purpose parallel interface device configured as three eight bit data ports, called A, B and C, and a mode port. It appears to the Z80 as four I/O ports through which the keyboard, the memory switching hardware, the cassette motor, the cassette output, the Caps Lock LED and the Key Click audio output can be controlled. Once the PPI has been initialized access to a particular piece of hardware just involves writing to or reading the relevant I/O port.

##<a name="ppiporta"></a>PPI Port A (I/O Port A8H)

<a name="figure1"></a>![][CH01F01]

**Figure 1:** Primary Slot Register

This output port, known as the Primary Slot Register in MSX terminology, is used to control the memory switching hardware.  The Z80 Microprocessor can only access 64 KB of memory directly.  This limitation is currently regarded as too restrictive and several of the newer personal computers employ methods to overcome it.

MSX machines can have multiple memory devices at the same address and the Z80 may switch in any one of them as required.  The processor address space is regarded as being duplicated "sideways" into four separate 64 KB areas, called Primary Slots 0 to 3, each of which receives its own slot select signal alongside the normal Z80 bus signals. The contents of the Primary Slot Register determine which slot select signal is active and therefore which Primary Slot is selected.

To increase flexibility each 16 KB "page" of the Z80 address space may be selected from a different Primary Slot. As shown in [Figure 1](#figure1) two bits of the Primary Slot Register are required to define the Primary Slot number for each page.

The first operation performed by the MSX ROM at power-up is to search through each slot for RAM in pages 2 and 3 (8000H to FFFFH). The Primary Slot Register is then set so that the relevant slots are selected thus making the RAM permanently available. The memory configuration of any MSX machine can be determined by displaying the Primary Slot Register setting with the BASIC statement:

    PRINT RIGHT$("0000000"+BIN$(INP(&HA8)),8)

As an example "10100000" would be produced on a Toshiba HX10 where pages 3 and 2 (the RAM) both come from Primary Slot 2 and pages 1 and 0 (the MSX ROM) from Primary Slot 0. The MSX ROM must always be placed in Primary Slot 0 by a manufacturer as this is the slot selected by the hardware at power-up. Other memory devices, RAM and any additional ROM, may be placed in any slot by a manufacturer.

A typical UK machine will have one Primary Slot containing the MSX ROM, one containing 64 KB of RAM and two slots brought out to external connectors. Most Japanese machines have a cartridge type connector on each of these external slots but UK machines usually have one cartridge connector and one IDC connector.

##<a name="expanders"></a>Expanders

System memory can be increased to a theoretical maximum of sixteen 64 KB areas by using expander interfaces. An expander plugs into any Primary Slot to provide four 64 KB Secondary Slots, numbered 0 to 3, instead of one primary one. Each expander has its own local hardware, called a Secondary Slot Register, to select which of the Secondary Slots should appear in the Primary Slot. As before pages can be selected from different Secondary Slots.

<a name="figure2"></a>![][CH01F02]

**Figure 2:** Secondary Slot Register

Each Secondary Slot Register, while actually being an eight bit read/write latch, is made to appear as memory location FFFFH of its Primary Slot by the expander hardware. In order to gain access to this location on a particular expander it will usually be necessary to first switch page 3 (C000H to FFFFH) of that Primary Slot into the processor address space. The Secondary Slot Register can then be modified and, if necessary, page 3 restored to its original Primary Slot setting. Accessing memory in expanders can become rather a convoluted process.

It is apparent that there must be some way of determining whether a Primary Slot contains ordinary RAM or an expander in order to access it properly. To achieve this the Secondary Slot Registers are designed to invert their contents when read back.  During the power-up RAM search memory location FFFFH of each Primary Slot is examined to determine whether it behaves normally or whether the slot contains an expander. The results of these tests are stored in the Workspace Area system resource map EXPTBL for later use. This is done at power-up because of the difficulty in performing tests when the Secondary Slot Registers actually contain live settings.

Memory switching is obviously an area demanding extra caution, particularly with the hierarchical mechanisms needed to control expanders. Care must be taken to avoid switching out the page in which a program is running or, if it is being used, the page containing the stack. There are a number of standard routines available to the machine code programmer in the BIOS section of the MSX ROM to simplify the process.

The BASIC Interpreter itself has four methods of accessing extension ROMs. The first three of these are for use with machine code ROMs placed in page 1 (4000H to 7FFFH), they are:

1. Hooks ([Chapter 6](#chapter6)).
2. The "`CALL`" statement ([Chapter 5](#chapter5)).
3. Additional device names ([Chapter 5](#chater5)).

The BASIC Interpreter can also execute a BASIC program ROM detected in page 2 (8000H to BFFFH) during the power-up ROM search. What the BASIC Interpreter cannot do is use any RAM hidden behind other memory devices. This limitation is a reflection of the difficulty in converting an established program to take advantage of newer, more complex machines. A similar situation exists with the version of Microsoft BASIC available on the IBM PC. Out of a 1 MB memory space only 64 KB can be used for program storage.

##<a name="ppiportb"></a>PPI Port B (I/O Port A9H)

<a name="figure3"></a>![][CH01F03]

**Figure 3**

This input port is used to read the eight bits of column data from the currently selected row of the keyboard. The MSX keyboard is a software scanned eleven row by eight column matrix of normally open switches. Current machines usually only have keys in rows zero to eight. Conversion of key depressions into character codes is performed by the MSX ROM interrupt handler, this process is described in [Chapter 4](#chapter4).

##<a name="ppiportc"></a>PPI Port C (I/O Port AAH)

<a name="figure4"></a>![][CH01F04]

**Figure 4**

This output port controls a variety of functions. The four Keyboard Row Select bits select which of the eleven keyboard rows, numbered from 0 to 10, is to be read in by PPI Port B.

The Cas Motor bit determines the state of the cassette motor relay: 0=On, 1=Off.

The Cas Out bit is filtered and attenuated before being taken to the cassette DIN socket as the MIC signal. All cassette tone generation is performed by software.

The Cap LED bit determines the state of the Caps Lock LED: 0=On, 1=Off.

The Key Click output is attenuated and mixed with the audio output from the Programmable Sound Generator. To actually generate a sound this bit should be flipped on and off.

Note that there are standard routines in the ROM BIOS to access all of the functions available with this port. These should be used in preference to direct manipulation of the hardware if at all possible.

##<a name="ppimodeport"></a>PPI Mode Port (I/O Port ABH)

<a name="figure5"></a>![][CH01F05]

**Figure 5:** PPI Mode Selection

This port is used to set the operating mode of the PPI. As the MSX hardware is designed to work in one particular configuration only this port should not be modified under any circumstances. Details are given for completeness only.

Bit 7 must be 1 in order to alter the PPI mode, when it is 0 the PPI performs the single bit set/reset function shown in [Figure 6](#figure6).

The A&C Mode bits determine the operating mode of Port A and the upper four bits only of Port C: 00=Normal Mode (MSX), 01=Strobed Mode, 10=Bidirectional Mode

The A Dir mode determines the direction of Port A: 0=Output (MSX), 1=Input.

The C Dir bit determines the direction of the upper four bits only of Port C: 0=Output (MSX), 1=Input.

The B&C Mode bits determine the operating mode of Port B and the lower four bits only of Port C: 0=Normal Mode (MSX), 1=Strobed Mode.

The B Dir bit determines the direction of Port B: 0=Output, 1=Input (MSX).

The C Dir bit determines the direction of the lower four bits only of Port C: 0=Output (MSX), 1=Input

<a name="figure6"></a>![][CH01F06]

**Figure 6:** PPI Bit Set/Reset

The PPI Mode Port can be used to directly set or reset any bit of Port C when bit 7 is 0. The Bit Number, from 0 to 7, determines which bit is to be affected. Its new value is determined by the Set/Reset bit: 0=Reset, 1=Set. The advantage of this mode is that a single output can be easily modified. As an example the Caps Lock LED may be turned on with the BASIC statement `OUT &HAB,12` and off with the statement `OUT &HAB,13`.

<br><br><br>

#<a name="chapter2"></a>2. Video Display Processor

The 9929 VDP contains all the circuitry necessary to generate the video display. It appears to the Z80 as two I/O ports called the [Data Port](#dataport) and the [Command Port](#commandport). Although the VDP has its own 16 KB of VRAM (Video RAM), the contents of which define the screen image, this cannot be directly accessed by the Z80. Instead it must use the two I/O ports to modify the VRAM and to set the various VDP operating conditions.

##<a name="dataport"></a>Data Port (I/O Port 98H)

The Data Port is used to read or write single bytes to the VRAM. The VDP possesses an internal address register pointing to a location in the VRAM. Reading the Data Port will input the byte from this VRAM location while writing to the Data Port will store a byte there. After a read or write the [address register](#addressregister) is automatically incremented to point to the next VRAM location. Sequential bytes can be accessed simply by continuous reads or writes to the Data Port.

##<a name="commandport"></a>Command Port (I/O Port 99H)

The Command Port is used for three purposes:

1. To set up the Data Port [address register](#addressregister).
2. To read the [VDP Status Register](#vdpstatusregister).
3. To write to one of the VDP Mode Registers.

##<a name="addressregister"></a>Address Register

The Data Port address register must be set up in different ways depending on whether the subsequent access is to be a read or a write. The address register can be set to any value from 0000H to 3FFFH by first writing the LSB (Least Significant Byte) and then the MSB (Most Significant Byte) to the [Command Port](#commandport). Bits 6 and 7 of the MSB are used by the VDP to determine whether the address register is being set up for subsequent reads or writes as follows:

<a name="figure7"></a>![][CH02F07]

**Figure 7:** VDP Address Setup

It is important that no other accesses are made to the VDP in between writing the LSB and the MSB as this will upset its synchronization. The MSX ROM interrupt handler is continuously reading the [VDP Status Register](#vdpstatusregister) as a background task so interrupts should be disabled as necessary.

##<a name="vdpstatusregister"></a>VDP Status Register

Reading the Command Port will input the contents of the VDP Status Register. This contains various flags as below:

<a name="figure8"></a>![][CH02F08]

**Figure 8:** VDP Status Register

The Fifth Sprite Number bits contain the number (0 to 31) of the sprite triggering the Fifth Sprite Flag.

The Coincidence Flag is normally 0 but is set to 1 if any sprites have one or more overlapping pixels. Reading the Status Register will reset this flag to a 0. Note that coincidence is only checked as each pixel is generated during a video frame, on a UK machine this is every 20 ms. If fast moving sprites pass over each other between checks then no coincidence will be flagged.

The Fifth Sprite Flag is normally 0 but is set to 1 when there are more than four sprites on any pixel line. Reading the Status Register will reset this flag to a 0.

The Frame Flag is normally 0 but is set to a 1 at the end of the last active line of the video frame. For UK machines with a 50 Hz frame rate this will occur every 20 ms. Reading the Status register will reset this flag to a 0. There is an associated output signal from the VDP which generates Z80 interrupts at the same rate, this drives the MSX ROM interrupt handler.

##<a name="vdpmoderegisters"></a>VDP Mode Registers

The VDP has eight write-only registers, numbered 0 to 7, which control its general operation. A particular register is set by first writing a data byte then a register selection byte to the Command Port. The register selection byte contains the register number in the lower three bits: 10000RRR. As the Mode Registers are write-only, and cannot be read, the MSX ROM maintains an exact copy of the eight registers in the Workspace Area of RAM ([Chapter 6](#chapter6)). Using the MSX ROM standard routines for VDP functions ensures that this register image is correctly updated.

##<a name="moderegister0"></a>Mode Register 0

<a name="figure9"></a>![][CH02F09]

**Figure 9**

The External VDP bit determines whether external VDP input is to be enabled or disabled: 0=Disabled, 1=Enabled.

The M3 bit is one of the three VDP mode selection bits, see [Mode Register 1](#moderegister1).

##<a name="moderegister1"></a>Mode Register 1

<a name="figure10"></a>![][CH02F10]

**Figure 10**

The Magnification bit determines whether sprites will be normal or doubled in size: 0=Normal, 1=Doubled.

The Size bit determines whether each sprite pattern will be 8x8 bits or 16x16 bits: 0=8x8, 1=16x16.

The M1 and M2 bits determine the VDP operating mode in conjunction with the M3 bit from [Mode Register 0](#moderegister0):

    M1 M2 M3
    0  0  0  32x24 Text Mode
    0  0  1  Graphics Mode
    0  1  0  Multicolour Mode
    1  0  0  40x24 Text Mode

The Interrupt Enable bit enables or disables the interrupt output signal from the VDP: 0=Disable, 1=Enable.

The Blank bit is used to enable or disable the entire video display: 0=Disable, 1=Enable. When the display is blanked it will be the same colour as the border.

The 4/16K bit alters the VDP VRAM addressing characteristics to suit either 4 KB or 16 KB chips: 0=4 KB, 1=16 KB.

##<a name="moderegister2"></a>Mode Register 2

<a name="figure11"></a>![][CH02F11]

**Figure 11**

Mode Register 2 defines the starting address of the Name Table in the VDP VRAM. The four available bits only specify positions 00BB BB00 0000 0000 of the full address so register contents of 0FH would result in a base address of 3C00H.


##<a name="moderegister3"></a>Mode Register 3

<a name="figure12"></a>![][CH02F12]

**Figure 12**

Mode Register 3 defines the starting address of the Colour Table in the VDP VRAM. The eight available bits only specify positions 00BB BBBB BB00 0000 of the full address so register contents of FFH would result in a base address of 3FC0H. In [Graphics Mode](#graphicsmode) only bit 7 is effective thus offering a base of 0000H or 2000H. Bits 0 to 6 must be 1.

##<a name="moderegister4"></a>Mode Register 4

<a name="figure13"></a>![][CH02F13]

**Figure 13**

Mode Register 4 defines the starting address of the Character Pattern Table in the VDP VRAM. The three available bits only specify positions 00BB B000 0000 0000 of the full address so register contents of 07H would result in a base address of 3800H. In [Graphics Mode](#graphicsmode) only bit 2 is effective thus offering a base of 0000H or 2000H. Bits 0 and 1 must be 1.

##<a name="moderegister5"></a>Mode Register 5

<a name="figure14"></a>![][CH02F14]

**Figure 14**

Mode Register 5 defines the starting address of the Sprite Attribute Table in the VDP VRAM. The seven available bits only specify positions 00BB BBBB B000 0000 of the full address so register contents of 7FH would result in a base address of 3F80H.

##<a name="moderegister6"></a>Mode Register 6

<a name="figure15"></a>![][CH02F15]

**Figure 15**

Mode Register 6 defines the starting address of the Sprite Pattern Table in the VDP VRAM. The three available bits only specify positions 00BB B000 0000 0000 of the full address so register contents of 07H would result in a base address of 3800H.

##<a name="moderegister7"></a>Mode Register 7

<a name="figure16"></a>![][CH02F16]

**Figure 16**

The Border Colour bits determine the colour of the region surrounding the active video area in all four VDP modes. They also determine the colour of all 0 pixels on the screen in [40x24 Text Mode](#40x24textmode). Note that the border region actually extends across the entire screen but will only become visible in the active area if the overlying pixel is transparent.

The Text Colour 1 bits determine the colour of all 1 pixels in [40x24 Text Mode](#40x24textmode). They have no effect in the other three modes where greater flexibility is provided through the use of the Colour Table. The VDP colour codes are:

    0 Transparent  4 Dark Blue   8 Red           12 Dark Green
    1 Black        5 Light Blue  9 Bright Red    13 Purple
    2 Green        6 Dark Red   10 Yellow        14 Grey
    3 Light Green  7 Sky Blue   11 Light Yellow  15 White

##<a name="screenmodes"></a>Screen Modes

The VDP has four operating modes, each one offering a slightly different set of capabilities. Generally speaking, as the resolution goes up the price to be paid in VRAM size and updating complexity also increases. In a dedicated application these associated hardware and software costs are important considerations. For an MSX machine they are irrelevant, it therefore seems a pity that a greater attempt was not made to standardize on one particular mode. The [Graphics Mode](#graphicsmode) is capable of adequately performing all the functions of the other modes with only minor reservations.

An added difficulty in using the VDP arises because insufficient allowance was made in its design for the overscanning used by most televisions. The resulting loss of characters at the screen edges has forced all the video-related MSX software into being based on peculiar screen sizes. UK machines normally use only the central thirty-seven characters available in [40x24 Text Mode](#40x24textmode). Japanese machines, with NTSC (National Television Standards Committee) video outputs, use the central thirty-nine characters.

The central element in the VDP, from the programmer's point of view, is the Name Table. This is a simple list of single- byte character codes held in VRAM. It is 960 bytes long in [40x24 Text Mode](#40x24textmode), 768 bytes long in [32x24 Text Mode](#32x24textmode), [Graphics Mode](#graphicsmode) and [Multicolour Mode](#multicolourmode). Each position in the Name Table corresponds to a particular location on the screen.

During a video frame the VDP will sequentially read every character code from the Name Table, starting at the base. As each character code is read the corresponding 8x8 pattern of pixels is looked up in the Character Pattern Table and displayed on the screen. The appearance of the screen can thus be modified by either changing the character codes in the Name Table or the pixel patterns in the Character Pattern Table.

Note that the VDP has no hardware cursor facility, if one is required it must be software generated.

##<a name="40x24textmode"></a>40x24 Text Mode

The Name Table occupies 960 bytes of VRAM from 0000H to 03BFH:

<a name="figure17"></a>![][CH02F17]

**Figure 17:** 40x24 Name Table

Pattern Table occupies 2 KB of VRAM from 0800H to 0FFFH. Each eight byte block contains the pixel pattern for a character code:

<a name="figure18"></a>![][CH02F18]

**Figure 18:** Character Pattern Block (No. 65 shown = 'A')

The first block contains the pattern for character code 0, the second the pattern for character code 1 and so on to character code 255. Note that only the leftmost six pixels are actually displayed in this mode. The colours of the 0 and 1 pixels in this mode are defined by [VDP Mode Register 7](#moderegister7), initially they are blue and white.

##<a name="32x24textmode"></a>32x24 Text Mode

The Name Table occupies 768 bytes of VRAM from 1800H to 1AFFH. As in [40x24 Text Mode](#40x24textmode) normal operation involves placing character codes in the required position in the table. The "`VPOKE`" statement may be used to attain familiarity with the screen layout:

<a name="figure19"></a>![][CH02F19]

**Figure 19:** 32x24 Name Table

The Character Pattern Table occupies 2 KB of VRAM from 0000H to 07FFH. Its structure is the same as in [40x24 Text Mode](#40x24textmode), all eight pixels of an 8x8 pattern are now displayed.

The border colour is defined by [VDP Mode Register 7](#moderegister7) and is initially blue. An additional table, the Colour Table, determines the colour of the 0 and 1 pixels. This occupies thirty-two bytes of VRAM from 2000H to 201FH. Each entry in the Colour Table defines the 0 and 1 pixel colours for a group of eight character codes, the lower four bits defining the 0 pixel colour, the upper four bits the 1 pixel colour. The first entry in the table defines the colours for character codes 0 to 7, the second for character codes 8 to 15 and so on for thirty-two entries. The MSX ROM initializes all entries to the same value, blue and white, and provides no facilities for changing individual ones.

##<a name="graphicsmode"></a>Graphics Mode

The Name Table occupies 768 bytes of VRAM from 1800H to 1AFFH, the same as in [32x24 Text Mode](#32x24textmode). The table is initialized with the character code sequence 0 to 255 repeated three times and is then left untouched, in this mode it is the Character Pattern Table which is modified during normal operation.

The Character Pattern Table occupies 6 KB of VRAM from 0000H to 17FFH. While its structure is the same as in the text modes it does not contain a character set but is initialized to all 0 pixels. The first 2 KB of the Character Pattern Table is addressed by the character codes from the first third of the Name Table, the second 2 KB by the central third of the Name Table and the last 2 KB by the final third of the Name Table.  Because of the sequential pattern in the Name Table the entire Character Pattern Table is read out linearly during a video frame. Setting a point on the screen involves working out where the corresponding bit is in the Character Pattern Table and turning it on. For a BASIC program to convert X,Y coordinates to an address see the [MAPXYC](#mapxyc) standard routine in [Chapter 4](#chapter4).

<a name="figure20"></a>![][CH02F20]

**Figure 20:** Graphics Character Pattern Table

The border colour is defined by VDP Mode Register 7 and is initially blue. The Colour Table occupies 6 KB of VRAM from 2000H to 37FFH. There is an exact byte-to-byte mapping from the Character Pattern Table to the Colour Table but, because it takes a whole byte to define the 0 pixel and 1 pixel colours, there is a lower resolution for colours than for pixels. The lower four bits of a Colour Table entry define the colour of all the 0 pixels on the corresponding eight pixel line. The upper four bits define the colour of the 1 pixels. The Colour Table is initialized so that the 0 pixel colour and the 1 pixel colour are blue for the entire table. Because both colours are the same it will be necessary to alter one colour when a bit is set in the Character Pattern Table.

##<a name="multicolourmode"></a>Multicolour Mode

The Name Table occupies 768 bytes of VRAM from 0800H to 0AFFH, the screen mapping is the same as in [32x24 Text Mode](#32x24textmode). The table is initialized with the following character code pattern:

    00H to 1FH (Repeated four times)
    20H to 3FH (Repeated four times)
    40H to 5FH (Repeated four times)
    60H to 7FH (Repeated four times)
    80H to 9FH (Repeated four times)
    A0H to BFH (Repeated four times)

As with [Graphics Mode](#graphicsmode) this is just a character code "driver" pattern, it is the Character Pattern Table which is modified during normal operation.

The Character Pattern table occupies 1536 bytes of VRAM from 0000H to 05FFH. As in the other modes each character code maps onto an eight byte block in the Character Pattern Table.  Because of the lower resolution in this mode only two bytes of the pattern block are actually needed to define an 8x8 pattern:

<a name="figure21"></a>![][CH02F21]

**Figure 21:** Multicolour Pattern Block

As can be seen from [Figure 21](#figure21) each four bit section of the two byte block contains a colour code and thus defines the colour of a quadrant of the 8x8 pixel pattern. So that the entire eight bytes of the pattern block can be utilized a given character code will use a different two byte section depending upon the character code's screen location (i.e. its position in the Name Table):

    Video row 0, 4, 8, 12, 16, 20   Uses bytes 0 and 1
    Video row 1, 5, 9, 13, 17, 21   Uses bytes 2 and 3
    Video row 2, 6, 10, 14, 18, 22  Uses bytes 4 and 5
    Video row 3, 7, 11, 15, 19, 23  Uses bytes 6 and 7

When the Name Table is filled with the special driver sequence of character codes shown above the Character Pattern Table will be read out linearly during a video frame:

<a name="figure22"></a>![][CH02F22]

**Figure 22:** Multicolour Character Pattern Table

The border colour is defined by [VDP Mode Register 7](#moderegister7) and is initially blue. There is no separate Colour Table as the colours are defined directly by the contents of the Character Pattern Table, this is initially filled with blue.

##<a name="sprites"></a>Sprites

The VDP can control thirty-two sprites in all modes except [40x24 Text Mode](#40x24textmode). Their treatment is identical in all modes and independent of any character-orientated activity.

The Sprite Attribute Table occupies 128 bytes of VRAM from 1B00H to 1B7FH. The table contains thirty-two four byte blocks, one for each sprite. The first block controls sprite 0 (the "top" sprite), the second controls sprite 1 and so on to sprite 31. The format of each block is as below:

<a name="figure23"></a>![][CH02F23]

**Figure 23:** Sprite Attribute Block

Byte 0 specifies the vertical (Y) coordinate of the top-left pixel of the sprite. The coordinate system runs from -1 (FFH) for the top pixel line on the screen down to 190 (BEH) for the bottom line. Values less than -1 can be used to slide the sprite in from the top of the screen. The exact values needed will obviously depend upon the size of the sprite. Curiously there has been no attempt in MSX BASIC to reconcile this coordinate system with the normal graphics range of Y=0 to 191.  As a consequence a sprite will always be one pixel lower on the screen than the equivalent graphic point. Note that the special vertical coordinate value of 208 (D0H) placed in a sprite attribute block will cause the VDP to ignore all subsequent blocks in the Sprite Attribute Table. Effectively this means that any lower sprites will disappear from the screen.

Byte 1 specifies the horizontal (X) coordinate of the top- left pixel of the sprite. The coordinate system runs from 0 for the leftmost pixel to 255 (FFH) for the rightmost. As this coordinate system provides no mechanism for sliding a sprite in from the left a special bit in byte 3 is used for this purpose, see below.

Byte 2 selects one of the two hundred and fifty-six 8x8 bit patterns available in the Sprite Pattern Table. If the Size bit is set in VDP Mode Register 1, resulting in 16x16 bit patterns occupying thirty-two bytes each, the two least significant bits of the pattern number are ignored. Thus pattern numbers 0, 1, 2 and 3 would all select pattern number 0.

In Byte 3 the four Colour Code bits define the colour of the 1 pixels in the sprite patterns, 0 pixels are always transparent. The Early Clock bit is normally 0 but will shift the sprite thirty-two pixels to the left when set to 1. This is so that sprites can slide in from the left of the screen, there being no spare coordinates in the horizontal direction.

The Sprite Pattern Table occupies 2 KB of VRAM from 3800H to 3FFFH. It contains two hundred and fifty-six 8x8 pixel patterns, numbered from 0 to 255. If the Size bit in VDP Mode Register 1 is 0, resulting in 8x8 sprites, then each eight byte sprite pattern block is structured in the same way as the character pattern block shown in [Figure 18](#figure18). If the Size bit is 1, resulting in 16x16 sprites, then four eight byte blocks are needed to define the pattern as below:

<a name="figure24"></a>![][CH02F24]

**Figure 24:** 16x16 Sprite Pattern Block

<br><br><br>

#<a name="chapter3"></a>3. Programmable Sound Generator

As well as controlling three sound channels the 8910 PSG contains two eight bit data ports, called A and B, through which it interfaces the joysticks and the cassette input. The PSG appears to the Z80 as three I/O ports called the [Address Port](#addressport), the [Data Write Port](#datawriteport) and the [Data Read Port](#datareadport).

##<a name="addressport"></a>Address Port (I/O port A0H)

The PSG contains sixteen internal registers which completely define its operation. A specific register is selected by writing its number, from 0 to 15, to this port. Once selected, repeated accesses to that register may be made via the two data ports.

##<a name="datawriteport"></a>Data Write Port (I/O port A1H)

This port is used to write to any register once it has been selected by the Address Port.

##<a name="datareadport"></a>Data Read Port (I/O port A2H)

This port is used to read any register once it has been selected by the Address Port.

##<a name="registers0and1"></a>Registers 0 and 1

<a name="figure25"></a>![][CH03F25]

**Figure 25**

These two registers are used to define the frequency of the Tone Generator for Channel A. Variable frequencies are produced by dividing a fixed master frequency with the number held in Registers 0 and 1, this number can be in the range 1 to 4095.  Register 0 holds the least significant eight bits and Register 1 the most significant four. The PSG divides an external 1.7897725 MHz frequency by sixteen to produce a Tone Generator master frequency of 111,861 Hz. The output of the Tone Generator can therefore range from 111,861 Hz (divide by 1) down to 27.3 Hz (divide by 4095). As an example to produce a middle "A" (440 Hz) the divider value in Registers 0 and 1 would be 254.

##<a name="registers2and3"></a>Registers 2 and 3

These two registers control the Channel B Tone Generator as for Channel A.

##<a name="registers4and5"></a>Registers 4 and 5

These two registers control the Channel C Tone Generator as for Channel A.

##<a name="register6"></a>Register 6

<a name="figure26"></a>![][CH03F26]

**Figure 26**

In addition to three square wave Tone Generators the PSG contains a single Noise Generator. The fundamental frequency of the noise source can be controlled in a similar fashion to the Tone Generators. The five least significant bits of Register 6 hold a divider value from 1 to 31. The Noise Generator master frequency is 111,861 Hz as before.

##<a name="register7"></a>Register 7

<a name="figure27"></a>![][CH03F27]

**Figure 27**

This register enables or disables the Tone Generator and Noise Generator for each of the three channels: 0=Enable 1=Disable. It also controls the direction of interface ports A and B, to which the joysticks and cassette are attached: 0=Input, 1=Output. Register 7 must always contain 10xxxxxx or possible damage could result to the PSG, there are active devices connected to its I/O pins. The BASIC "SOUND" statement will force these bits to the correct value for Register 7 but there is no protection at the machine code level.

##<a name="register8"></a>Register 8

<a name="figure28"></a>![][CH03F28]

**Figure 28**

The four Amplitude bits determine the amplitude of Channel A from a minimum of 0 to a maximum of 15. The Mode bit selects either fixed or modulated amplitude: 0=Fixed, 1=Modulated. When modulated amplitude is selected the fixed amplitude value is ignored and the channel is modulated by the output from the Envelope Generator.

##<a name="register9"></a>Register 9

This register controls the amplitude of Channel B as for Channel A.

##<a name="register10"></a>Register 10

This register controls the amplitude of Channel C as for Channel A.

##<a name="registers11and12"></a>Registers 11 and 12

<a name="figure29"></a>![][CH03F29]

**Figure 29**

These two registers control the frequency of the single Envelope Generator used for amplitude modulation. As for the Tone Generators this frequency is determined by placing a divider count in the registers. The divider value may range from 1 to 65535 with Register 11 holding the least significant eight bits and Register 12 the most significant. The master frequency for the Envelope Generator is 6991 Hz so the envelope frequency may range from 6991 Hz (divide by 1) to 0.11 Hz (divide by 65535).

##<a name="register13"></a>Register 13

<a name="figure30"></a>![][CH03F30]

**Figure 30**

The four Envelope Shape bits determine the shape of the amplitude modulation envelope produced by the Envelope Generator:

<a name="figure31"></a>![][CH03F31]

**Figure 31**

##<a name="register14"></a>Register 14

<a name="figure32"></a>![][CH03F32]

**Figure 32**

This register is used to read in PSG Port A. The six joystick bits reflect the state of the four direction switches and two trigger buttons on a joystick: 0=Pressed, 1=Not pressed. Alternatively up to six Paddles may be connected instead of one joystick. Although most MSX machines have two 9 pin joystick connectors only one can be read at a time. The one to be selected for reading is determined by the Joystick Select bit in [PSG Register 15](#register15).

The Keyboard Mode bit is unused on UK machines. On Japanese machines it is tied to a jumper link to determine the keyboard's character set.

The Cassette Input is used to read the signal from the cassette EAR output. This is passed through a comparator to clean the edges and to convert to digital levels but is otherwise unprocessed.

##<a name="register15"></a>Register 15

<a name="figure33"></a>![][CH03F33]

**Figure 33**

This register is used to output to PSG Port B. The four least significant bits are connected via TTL open-collector buffers to pins 6 and 7 of each joystick connector. They are normally set to a 1, when a paddle or joystick is connected, so that the pins can function as inputs. When a touchpad is connected they are used as handshaking outputs.

The two Pulse bits are used to generate a short positive- going pulse to any paddles attached to joystick connectors 1 or 2. Each paddle contains a monostable timer with a variable resistor controlling its pulse length. Once the timer is triggered the position of the variable resistor can be determined by counting until the monostable times out.

The Joystick Select bit determines which joystick connector is connected to PSG Port A for input: 0=Connector 1, 1=Connector 2.

The Kana LED output is unused on UK machines. On Japanese machines it is used to drive a keyboard mode indicator.

<br><br><br>

#<a name="chapter4"></a>4. ROM BIOS

The design of the MSX ROM is of importance if machine code programs are to be developed efficiently and Operate reliably.  Almost every program, including the BASIC Interpreter itself, will require a certain set of primitive functions to operate.  These include screen and printer drivers, a keyboard decoder and other hardware related functions. By separating these routines from the BASIC Interpreter they can be made available to any application program. The section of ROM from 0000H to 268BH is largely devoted to such routines and is called the ROM BIOS (Basic Input Output System).

This chapter gives a functional description of every recognizably separate routine in the ROM BIOS. Special attention is given to the "standard" routines. These are documented by Microsoft and guaranteed to remain consistent through possible hardware and software changes. The first few hundred bytes of the ROM consists of Z80 JP instructions which provide fixed position entry points to these routines. For maximum compatibility with future software an application program should restrict its dependence on the ROM to these locations only. The description of the ROM begins with this list of entry points to the standard routines. A brief comment is placed with each entry point, the full description is given with the routine itself.

##<a name="dataareas"></a>Data Areas

It is expected that most users will wish to disassemble the ROM to some extent (the full listing runs to nearly four hundred pages). In order to ease this process the data areas, which do not contain executable Z80 code, are shown below:

    0004H-0007H    185DH-1863H 4B3AH-4B4CH    73E4H-73E4H
    002BH-002FH    1B97H-1BAAH 4C2FH-4C3FH    752EH-7585H
    0508H-050DH    1BBFH-23BEH 555AH-5569H    7754H-7757H
    092FH-097FH    2439H-2459H 5D83H-5DB0H    7BA3H-7BCAH
    0DA5H-0EC4H    2CF1H-2E70H 6F76H-6F8EH    7ED8H-7F26H
    1033H-105AH    3030H-3039H 70FFH-710CH    7F41H-7FB6H
    1061H-10C1H    3710H-3719H 7182H-7195H    7FBEH-7FFFH
    1233H-1252H    392EH-3FE1H 71A2H-71B5H
    13A9H-1448H    43B5H-43C3H 71C7H-71DAH
    160BH-1612H    46E6H-46E7H 72A6H-72B9H

Note that these data areas are for the UK ROM, there are slight differences in the Japanese ROM relating to the keyboard decoder and the video character set. Disparities between the ROMs are restricted to these regions with the bulk of the code being identical in both cases.

##<a name="terminology"></a>Terminology

Reference is frequently made in this chapter to the standard routines and to Workspace Area variables. Whenever this is done the Microsoft-recommended name is used in upper case letters, for example "the [FILVRM](#filvrm) standard routine" and "[SCRMOD](#scrmod) is set".  Subroutines which are not named are referred to by a parenthesized address, "the screen is cleared (0777H)" for example. When reference is made to the Z80 status flags assembly language conventions are used, for example "Flag C" would mean that the carry flag is set while "Flag NZ" means that the zero flag is reset. The terms "EI" and "DI" mean enabled interrupts and disabled interrupts respectively.

|ADDR. |NAME             |TO    |FUNCTION
|:----:|:---------------:|:----:|--------------------------------------
|0000H |[CHKRAM](#chkram)|02D7H |Power-up, check RAM
|0004H |......           |..... |Two bytes, address of ROM character set
|0006H |......           |..... |One byte, VDP Data Port number
|0007H |......           |..... |One byte, VDP Data Port number
|0008H |[SYNCHR](#synchr)|2683H |Check BASIC program character
|000BH |......           |..... |NOP
|000CH |[RDSLT](#rdslt)  |01B6H |Read RAM in any slot
|000FH |......           |..... |NOP
|0010H |[CHRGTR](#chrgtr)|2686H |Get next BASIC program character
|0013H |......           |..... |NOP
|0014H |[WRSLT](#wrslt)  |01D1H |Write to RAM in any slot
|0017H |......           |..... |NOP
|0018H |[OUTDO](#outdo)  |1B45H |Output to current device
|001BH |......           |..... |NOP
|001CH |[CALSLT](#calslt)|0217H |Call routine in any slot
|001FH |......           |..... |NOP
|0020H |[DCOMPR](#dcompr)|146AH |Compare register pairs HL and DE
|0023H |......           |..... |NOP
|0024H |[ENASLT](#enaslt)|025EH |Enable any slot permanently
|0027H |......           |..... |NOP
|0028H |[GETYPR](#getypr)|2689H |Get BASIC operand type
|002BH |......           |..... |Five bytes Version Number
|0030H |[CALLF](#callf)  |0205H |Call routine in any slot
|0033H |......           |..... |Five NOPs
|0038H |[KEYINT](#keyint)|0C3CH |Interrupt handler, keyboard scan
|003BH |[INITIO](#initio)|049DH |Initialize I/O devices
|003EH |[INIFNK](#inifnk)|139DH |Initialize function key strings
|0041H |[DISSCR](#disscr)|0577H |Disable screen
|0044H |[ENASCR](#enascr)|0570H |Enable screen
|0047H |[WRTVDP](#wrtvdp)|057FH |Write to any VDP register
|004AH |[RDVRM](#rdvrm)  |07D7H |Read byte from VRAM
|004DH |[WRTVRM](#wrtvrm)|07CDH |Write byte to VRAM
|0050H |[SETRD](#setrd)  |07ECH |Set up VDP for read
|0053H |[SETWRT](#setwrt)|07DFH |Set up VDP for write
|0056H |[FILVRM](#filvrm)|0815H |Fill block of VRAM with data byte
|0059H |[LDIRMV](#ldirmv)|070FH |Copy block to memory from VRAM
|005CH |[LDIRVM](#ldirvm)|0744H |Copy block to VRAM, from memory
|005FH |[CHGMOD](#chgmod)|084FH |Change VDP mode
|0062H |[CHGCLR](#chgclr)|07F7H |Change VDP colours
|0065H |......           |..... |NOP
|0066H |[NMI](#nmi)      |1398H |Non Maskable Interrupt handler
|0069H |[CLRSPR](#clrspr)|06A8H |Clear all sprites
|006CH |[INITXT](#initxt)|050EH |Initialize VDP to 40x24 Text Mode
|006FH |[INIT32](#init32)|0538H |Initialize VDP to 32x24 Text Mode
|0072H |[INIGRP](#inigrp)|05D2H |Initialize VDP to Graphics Mode
|0075H |[INIMLT](#inimlt)|061FH |Initialize VDP to Multicolour Mode
|0078H |[SETTXT](#settxt)|0594H |Set VDP to 40x24 Text Mode
|007BH |[SETT32](#sett32)|05B4H |Set VDP to 32x24 Text Mode
|007EH |[SETGRP](#setgrp)|0602H |Set VDP to Graphics Mode
|0081H |[SETMLT](#setmlt)|0659H |Set VDP to Multicolour Mode
|0084H |[CALPAT](#calpat)|06E4H |Calculate address of sprite pattern
|0087H |[CALATR](#calatr)|06F9H |Calculate address of sprite attribute
|008AH |[GSPSIZ](#gspsiz)|0704H |Get sprite size
|008DH |[GRPPRT](#grpprt)|1510H |Print character on graphic screen
|0090H |[GICINI](#gicini)|04BDH |Initialize PSG (GI Chip)
|0093H |[WRTPSG](#wrtpsg)|1102H |Write to any PSG register
|0096H |[RDPSG](#rdpsg)  |110EH |Read from any PSG register
|0099H |[STRTMS](#strtms)|11C4H |Start music dequeueing
|009CH |[CHSNS](#chsns)  |0D6AH |Sense keyboard buffer for character
|009FH |[CHGET](#chget)  |10CBH |Get character from keyboard buffer (wait)
|00A2H |[CHPUT](#chput)  |08BCH |Screen character output
|00A5H |[LPTOUT](#lptout)|085DH |Line printer character output
|00A8H |[LPTSTT](#lptstt)|0884H |Line printer status test
|00ABH |[CNVCHR](#cnvchr)|089DH |Convert character with graphic header
|00AEH |[PINLIN](#pinlin)|23BFH |Get line from console (editor)
|00B1H |[INLIN](#inlin)  |23D5H |Get line from console (editor)
|00B4H |[QINLIN](#qinlin)|23CCH |Display "?", get line from console (editor)
|00B7H |[BREAKX](#breakx)|046FH |Check CTRL-STOP key directly
|00BAH |[ISCNTC](#iscntc)|03FBH |Check CRTL-STOP key
|00BDH |[CKCNTC](#ckcntc)|10F9H |Check CTRL-STOP key
|00C0H |[BEEP](#beep)    |1113H |Go beep
|00C3H |[CLS](#cls)      |0848H |Clear screen
|00C6H |[POSIT](#posit)  |088EH |Set cursor position
|00C9H |[FNKSB](#fnksb)  |0B26H |Check if function key display on
|00CCH |[ERAFNK](#erafnk)|0B15H |Erase function key display
|00CFH |[DSPFNK](#dspfnk)|0B2BH |Display function keys
|00D2H |[TOTEXT](#totext)|083BH |Return VDP to text mode
|00D5H |[GTSTCK](#gtstck)|11EEH |Get joystick status
|00D8H |[GTTRIG](#gttrig)|1253H |Get trigger status
|00DBH |[GTPAD](#gtpad)  |12ACH |Get touch pad status
|00DEH |[GTPDL](#gtpdl)  |1273H |Get paddle status
|00E1H |[TAPION](#tapion)|1A63H |Tape input ON
|00E4H |[TAPIN](#tapin)  |1ABCH |Tape input
|00E7H |[TAPIOF](#tapiof)|19E9H |Tape input OFF
|00EAH |[TAPOON](#tapoon)|19F1H |Tape output ON
|00EDH |[TAPOUT](#tapout)|1A19H |Tape output
|00F0H |[TAPOOF](#tapoof)|19DDH |Tape output OFF
|00F3H |[STMOTR](#stmotr)|1384H |Turn motor ON/OFF
|00F6H |[LFTQ](#lftq)    |14EBH |Space left in music queue
|00F9H |[PUTQ](#putq)    |1492H |Put byte in music queue
|00FCH |[RIGHTC](#rightc)|16C5H |Move current pixel physical address right
|00FFH |[LEFTC](#leftc)  |16EEH |Move current pixel physical address left
|0102H |[UPC](#upc)      |175DH |Move current pixel physical address up
|0105H |[TUPC](#tupc)    |173CH |Test then UPC if legal
|0108H |[DOWNC](#downc)  |172AH |Move current pixel physical address down
|010BH |[TDOWNC](#tdownc)|170AH |Test then DOWNC if legal
|010EH |[SCALXY](#scalxy)|1599H |Scale graphics coordinates
|0111H |[MAPXYC](#mapxyc)|15DFH |Map graphic coordinates to physical address 
|0114H |[FETCHC](#fetchc)|1639H |Fetch current pixel physical address
|0117H |[STOREC](#storec)|1640H |Store current pixel physical address
|011AH |[SETATR](#setatr)|1676H |Set attribute byte
|011DH |[READC](#readc)  |1647H |Read attribute of current pixel
|0120H |[SETC](#setc)    |167EH |Set attribute of current pixel
|0123H |[NSETCX](#nsetcx)|1809H |Set attribute of number of pixels
|0126H |[GTASPC](#gtaspc)|18C7H |Get aspect ratio
|0129H |[PNTINI](#pntini)|18CFH |Paint initialize
|012CH |[SCANR](#scanr)  |18E4H |Scan pixels to right
|012FH |[SCANL](#scanl)  |197AH |Scan pixels to left
|0132H |[CHGCAP](#chgcap)|0F3DH |Change Caps Lock LED
|0135H |[CHGSND](#chgsnd)|0F7AH |Change Key Click sound output
|0138H |[RSLREG](#rslreg)|144CH |Read Primary Slot Register
|013BH |[WSLREG](#wslreg)|144FH |Write to Primary Slot Register
|013EH |[RDVDP](#rdvdp)  |1449H |Read VDP Status Register
|0141H |[SNSMAT](#snsmat)|1452H |Read row of keyboard matrix
|0144H |[PHYDIO](#phydio)|148AH |Disk, no action
|0147H |[FORMAT](#format)|148EH |Disk, no action
|014AH |[ISFLIO](#isflio)|145FH |Check for file I/O
|014DH |[OUTDLP](#outdlp)|1B63H |Formatted output to line printer
|0150H |[GETVCP](#getvcp)|1470H |Get music voice pointer
|0153H |[GETVC2](#getvc2)|1474H |Get music voice pointer
|0156H |[KILBUF](#kilbuf)|0468H |Clear keyboard buffer
|0159H |[CALBAS](#calbas)|01FFH |Call to BASIC from any slot
|015CH |......           |..... |NOPs to 01B5H for expansion

<a name="rdslt"></a>

    Address... 01B6H
    Name...... RDSLT
    Entry..... A=Slot ID, HL=Address
    Exit...... A=Byte read
    Modifies.. AF, BC, DE, DI

Standard routine to read a single byte from memory in any slot. The Slot Identifier is composed of a Primary Slot number a Secondary Slot number and a flag:

<a name="figure34"></a>![][CH04F34]

**Figure 34:** Slot ID

The flag is normally 0 but must be 1 if a Secondary Slot number is included in the Slot ID. The memory address and Slot ID are first processed (027EH) to yield a set of bit masks to apply to the relevant slot register. If a Secondary Slot number is specified then the Secondary Slot Register is first modified to select the relevant page from that Secondary Slot (02A3H). The Primary Slot is then switched in to the Z80 address space, the byte read and the Primary Slot restored to its original setting via the RDPRIM routine in the Workspace Area. Finally, if a Secondary Slot number is included in the Slot ID, the original Secondary Slot Register setting is restored (01ECH).

Note that, unless it is the slot containing the Workspace Area, any attempt to access page 3 (C000H to FFFFH) will cause the system to crash as [RDPRIM](#rdprim) will switch itself out. Note also that interrupts are left disabled by all the memory switching routines.

<a name="wrslt"></a>

    Address... 01D1H
    Name...... WRSLT
    Entry..... A=Slot ID, HL=Address, E=Byte to write
    Exit...... None
    Modifies.. AF, BC, D, DI

Standard routine to write a single byte to memory in any slot. Its operation is fundamentally the same as that of the RDSLT standard routine except that the Workspace Area routine [WRPRIM](#wrprim) is used rather than [RDPRIM](#rdprim).

<a name="calbas"></a>

    Address... 01FFH
    Name...... CALBAS
    Entry..... IX=Address
    Exit...... None
    Modifies.. AF', BC', DE', HL', IY, DI

Standard routine to call an address in the BASIC Interpreter from any slot. Usually this will be from a machine code program running in an extension ROM in page 1 (4000H to 7FFFH). The high byte of register pair IY is loaded with the MSX ROM Slot ID (00H) and control transfers to the [CALSLT](#calslt) standard routine.

<a name="callf"></a>

    Address... 0205H
    Name...... CALLF
    Entry..... None
    Exit...... None
    Modifies.. AF', BC', DE', HL', IX, IY, DI

Standard routine to call an address in any slot. The Slot ID and address are supplied as inline parameters rather than in registers to fit inside a hook ([Chapter 6](#chapter6)), for example:

    RST 30H
    DEFB Slot ID
    DEFW Address
    RET

The Slot ID is first collected and placed in the high byte of register pair IY. The address is then placed in register pair IX and control drops into the [CALSLT](#calslt) standard routine.

<a name="calslt"></a>

    Address... 0217H
    Name...... CALSLT
    Entry..... IY(High byte)=Slot ID, IX=Address
    Exit...... None
    Modifies.. AF', BC', DE', HL', DI

Standard routine to call an address in any slot. Its operation is fundamentally the same as that of the [RDSLT](#rdslt) standard routine except that the Workspace Area routine [CLPRIM](#clprim) is used rather than [RDPRIM](#rdprim). Note that [CALBAS](#calbas) and [CALLF](#callf) are just specialized entry points to this standard routine which offer a reduction in the amount of code required.

<a name="enaslt"></a>

    Address... 025EH
    Name...... ENASLT
    Entry..... A=Slot ID, HL=Address
    Exit...... None
    Modifies.. AF, BC, DE, DI

Standard routine to switch in a page permanently from any slot. Unlike the [RDSLT](#rdslt), [WRSLT](#wrslt) and [CALSLT](#calslt) standard routines the Primary Slot switching is performed directly and not by a Workspace Area routine. Consequently addresses in page 0 (0000H to 3FFFH) will cause an immediate system crash.

    Address... 027EH

This routine is used by the memory switching standard routines to turn an address, in register pair HL, and a Slot ID, in register A, into a set of bit masks. As an example a Slot ID of FxxxSSPP and an address in Page 1 (4000H to 7FFFH) would return the following:

    Register B=00 00 PP 00 (OR mask)
    Register C=11 11 00 11 (AND mask)
    Register D=PP PP PP PP (Replicated)
    Register E=00 00 11 00 (Page mask)

Registers B and C are derived from the Primary Slot number and the page mask. They are later used to mix the new Primary Slot number into the existing contents of the Primary Slot Register.  Register D contains the Primary Slot number replicated four times and register E the page mask. This is produced by examining the two most significant bits of the address, to determine the page number, and then shifting the mask along to the relevant position. These registers are later used during Secondary Slot switching.

As the routine terminates bit 7 of the Slot ID is tested, to determine whether a Secondary Slot has been specified, and Flag M returned if this is so.

    Address... 02A3H

This routine is used by the memory switching standard routines to modify a Secondary Slot Register. The Slot ID is supplied in register A while registers D and E contain the bit masks shown in the previous routine.

Bits 6 and 7 of register D are first copied into the Primary Slot register. This switches in page 3 from the Primary Slot specified by the Slot ID and makes the required Secondary Slot Register available. This is then read from memory location FFFFH and the page mask, inverted, used to clear the required two bits. The Secondary Slot number is shifted to the relevant position and mixed in. Finally the new setting is placed in the Secondary Slot Register and the Primary Slot Register restored to its original setting.

<a name="chkram"></a>

    Address... 02D7H
    Name...... CHKRAM
    Entry..... None
    Exit...... None
    Modifies.. AF, BC, DE, HL, SP

Standard routine to perform memory initialization at power- up. It non-destructively tests for RAM in pages 2 and 3 in all sixteen possible slots then sets the Primary and Secondary Slot registers to switch in the largest area found. The entire Workspace Area (F380H to FFC9H) is zeroed and [EXPTBL](#exptbl) and [SLTTBL](#slttbl) filled in to map any expansion interfaces in existence Interrupt Mode 1 is set and control transfers to the remainder of the power-up initialization routine (7C76H).

<a name="iscntc"></a>

    Address... 03FBH
    Name...... ISCNTC
    Entry..... None
    Exit...... None
    Modifies.. AF, EI

Standard routine to check whether the CTRL-STOP or STOP keys have been pressed. It is used by the BASIC Interpreter at the end of each statement to check for program termination. [BASROM](#basrom) is first examined to see if it contains a non-zero value, if so the routine terminates immediately. This is to prevent users breaking into any extension ROM containing a BASIC program.

INTFLG is then checked to determine whether the interrupt handler has placed the CTRL-STOP or STOP key codes (03H or 04H) there. If STOP has been detected then the cursor is turned on (09DAH) and [INTFLG](#intflg) continually checked until one of the two key codes reappears. The cursor is then turned off (0A27H) and, if the key is STOP, the routine terminates.

If CTRL-STOP has been detected then the keyboard buffer is first cleared via the [KILBUF](#kilbuf) standard routine and [TRPTBL](#trptbl) is checked to see whether an "`ON STOP GOSUB`" statement is active.  If so the relevant entry in [TRPTBL](#trptbl) is updated (0EF1H) and the routine terminates as the event will be handled by the Interpreter Runloop. Otherwise the [ENASLT](#enaslt) standard routine is used to switch in page 1 from the MSX ROM, in case an extension ROM is using the routine, and control transfers to the "`STOP`" statement handler (63E6H).

<a name="kilbuf"></a>

    Address... 0468H
    Name...... KILBUF
    Entry..... None
    Exit...... None
    Modifies.. HL

Standard Routine to clear the forty character type-ahead keyboard buffer [KEYBUF](#keybuf). There are two pointers into this buffer, [PUTPNT](#putpnt) where the interrupt handler places characters, and [GETPNT](#getpnt) where application programs fetch them from. As the number of characters in the buffer is indicated by the difference between these two pointers [KEYBUF](#keybuf) is emptied simply by making them both equal.

<a name="breakx"></a>

    Address... 046FH
    Name...... BREAKX
    Entry..... None
    Exit...... Flag C if CTRL-STOP key pressed
    Modifies.. AF

Standard routine which directly tests rows 6 and 7 of the keyboard to determine whether the CTRL and STOP keys are both pressed. If they are then [KEYBUF](#keybuf) is cleared and row 7 of [OLDKEY](#oldkey) modified to prevent the interrupt handler picking the keys up as well. This routine may often be more suitable for use by an application program, in preference to [ISCNTC](#iscntc), as it will work when interrupts are disabled, during cassette I/O for example, and does not exit to the Interpreter.

<a name="initio"></a>

    Address... 049DH
    Name...... INITIO
    Entry..... None
    Exit...... None
    Modifies.. AF, E, EI

Standard routine to initialize the PSG and the Centronics Status Port. PSG Register 7 is first set to 80H making PSG Port B=Output and PSG Port A=Input. PSG Register 15 is set to CFH to initialize the Joystick connector control hardware. PSG Register 14 is then read and the Keyboard Mode bit placed in [KANAMD](#kanamd), this has no relevance for UK machines.

Finally a value of FFH is output to the Centronics Status Port (I/O port 90H) to set the [STROBE](#strobe) signal high. Control then drops into the [GICINI](#gicini) standard routine to complete initialization.

<a name="gicini"></a>

    Address... 04BDH
    Name...... GICINI
    Entry..... None
    Exit...... None
    Modifies.. EI

Standard routine to initialize the PSG and the Workspace Area variables associated with the "PLAY" statement. [QUETAB](#quetab), [VCBA](#vcba), [VCBB](#vcbb) and [VCBC](#vcbc) are first initialized with the values shown in Chapter 6. PSG Registers 8, 9 and 10 are then set to zero amplitude and PSG Register 7 to B8H. This enables the Tone Generator and disables the Noise Generator on each channel.

    Address... 0508H

This six byte table contains the "PLAY" statement parameters initially placed in [VCBA](#vcba), [VCBB](#vcbb) and [VCBC](#vcbc) by the [GICINI](#gicini) standard routine: Octave=4, Length=4, Tempo=120, Volume=88H, Envelope=00FFH.

<a name="initxt"></a>

    Address... 050EH
    Name...... INITXT
    Entry..... None
    Exit...... None
    Modifies.. AF, BC, DE, HL, EI

Standard routine to initialize the VDP to [40x24 Text Mode](#40x24textmode).  The screen is temporarily disabled via the [DISSCR](#disscr) standard routine and [SCRMOD](#scrmod) and [OLDSCR](#oldscr) set to 00H. The parameters required by the [CHPUT](#chput) standard routine are set up by copying [LINL40](#linl40) to [LINLEN](#linlen), [TXTNAM](#txtnam) to [NAMBAS](#nambas) and [TXTCGP](#txtcgp) to [CGPBAS](#cgpbas). The VDP colours are then set by the [CHGCLR](#chgclr) standard routine and the screen is cleared (077EH). The current character set is copied into the VRAM Character Pattern Table (071EH). Finally the VDP mode and base addresses are set via the [SETTXT](#settxt) standard routine and the screen is enabled.

<a name="init32"></a>

    Address... 0538H
    Name...... INIT32
    Entry..... None
    Exit...... None
    Modifies.. AF, BC, DE, HL, EI

Standard routine to initialize the VDP to [32x24 Text Mode](#32x24textmode).  The screen is temporarily disabled via the [DISSCR](#disscr) standard routine and [SCRMOD](#scrmod) and [OLDSCR](#oldscr) set to 01H. The parameters required by the [CHPUT](#chput) standard routine are set up by copying [LINL32](#linl32) to [LINLEN](#linlen), [T32NAM](#t32nam) to [NAMBAS](#nambas), [T32CGP](#t32cgp) to [CGPBAS](#cgpbas), [T32PAT](#t32pat) to [PATBAS](#patbas) and [T32ATR](#t32atr) to [ATRBAS](#atrbas). The VDP colours are then set via the [CHGCLR](#chgclr) standard routine and the screen is cleared (077EH).  The current character set is copied into the VRAM Character Pattern Table (071EH) and all sprites cleared (06BBH). Finally the VDP mode and base addresses are set via the [SETT32](#sett32) standard routine and the screen is enabled.

<a name="enascr"></a>

    Address... 0570H
    Name...... ENASCR
    Entry..... None
    Exit...... None
    Modifies.. AF, BC, EI

Standard routine to enable the screen. This simply involves setting bit 6 of VDP [Mode Register 1](#moderegister1).

<a name="disscr"></a>

    Address... 0577H
    Name...... DISSCR
    Entry..... None
    Exit...... None
    Modifies.. AF, BC, EI

Standard routine to disable the screen. This simply involves resetting bit 6 of VDP [Mode Register 1](#moderegister1).

<a name="wrtvdp"></a>

    Address... 057FH
    Name...... WRTVDP
    Entry..... B=Data byte, C=VDP Mode Register number
    Exit...... None
    Modifies.. AF, B, EI

Standard routine to write a data byte to any VDP [Mode Register](#vdpmoderegisters). The register selection byte is first written to the VDP [Command Port](#commandpport), followed by the data byte. This is then copied to the relevant register image, [RGOSAV](#rgosav) to [RG7SAV](#rg7sav), in the Workspace Area

<a name="settxt"></a>

    Address... 0594H
    Name...... SETTXT
    Entry..... None
    Exit...... None
    Modifies.. AF, BC, DE, HL, EI

Standard routine to partially set the VDP to [40x24 Text Mode](#40x24textmode). The mode bits M1, M2 and M3 are first set in VDP Mode Registers [0](#moderegister0) and [1](#moderegister1). The five VRAM table base addresses, beginning with [TXTNAM](#txtnam), are then copied from the Workspace Area into VDP Mode Registers [2](#moderegister2), [3](#moderegister3), [4](#moderegister4), [5](#moderegister5) and [6](#moderegister6) (0677H).

<a name="sett32"></a>

    Address... 05B4H
    Name...... SETT32
    Entry..... None
    Exit...... None
    Modifies.. AF, BC, DE, HL, EI

Standard routine to partially set the VDP to [32x24 Text Mode](#32x24textmode). The mode bits M1, M2 and M3 are first set in VDP Mode Registers [0](#moderegister0) and [1](#moderegister1). The five VRAM table base addresses, beginning with [T32NAM](#t32nam), are then copied from the Workspace Area into VDP Mode Registers [2](#moderegister2), [3](#moderegister3), [4](#moderegister4), [5](#moderegister5) and [6](#moderegister6) (0677H).

<a name="inigrp"></a>

    Address... 05D2H
    Name...... INIGRP
    Entry..... None
    Exit...... None
    Modifies.. AF, BC, DE, HL, EI

Standard routine to initialize the VDP to [Graphics Mode](#graphicsmode). The screen is temporarily disabled via the [DISSCR](#disscr) standard routine and [SCRMOD](#scrmod) set to 02H. The parameters required by the [GRPPRT](#grpprt) standard routine are set up by copying [GRPPAT](#grppat) to [PATBAS](#patbas) and [GRPATR](#grpatr) to [ATRBAS](#atrbas). The character code driver pattern is then copied into the VDP Name Table, the screen cleared (07A1H) and all sprites cleared (06BBH). Finally the VDP mode and base addresses are set via the [SETGRP](#setgrp) standard routine and the screen is enabled.

<a name="setgrp"></a>

    Address... 0602H
    Name...... SETGRP
    Entry..... None
    Exit...... None
    Modifies.. AF, BC, DE, HL, EI

Standard routine to partially set the VDP to [Graphics Mode](#graphicsmode).  The mode bits M1, M2 and M3 are first set in VDP Mode Registers [0](#moderegister0) and [1](#moderegister1). The five VRAM table base addresses, beginning with [GRPNAM](#grpnam), are then copied from the Workspace Area into VDP Mode Registers [2](#moderegister2), [3](#moderegister3), [4](#moderegister4), [5](#moderegister5) and [6](#moderegister6) (0677H).

<a name="inimlt"></a>

    Address... 061FH
    Name...... INIMLT
    Entry..... None
    Exit...... None
    Modifies.. AF, BC, DE, HL, EI

Standard routine to initialize the VDP to [Multicolour Mode](#multicolourmode).  The screen is temporarily disabled via the [DISSCR](#disscr) standard routine and [SCRMOD](#scrmod) set to 03H. The parameters required by the [GRPPRT](#grpprt) standard routine are set up by copying [MLTPAT](#mltpat) to [PATBAS](#patbas) and [MLTATR](#mltatr) to [ATRBAS](#atrbas). The character code driver pattern is then copied into the VDP Name Table, the screen cleared (07B9H) and all sprites cleared (06BBH). Finally the VDP mode and base addresses are set via the [SETMLT](#setmlt) standard routine and the screen is enabled.

<a name="setmlt"></a>

    Address... 0659H
    Name...... SETMLT
    Entry..... None
    Exit...... None
    Modifies.. AF, BC, DE, HL, EI

Standard routine to partially set the VDP to [Multicolour Mode](#multicolourmode). The mode bits M1, M2 and M3 are first set in VDP Mode Registers [0](#moderegister0) and [1](#moderegister1). The five VRAM table base addresses, beginning with [MLTNAM](#mltnam), are then copied from the Workspace Area to VDP Mode Registers [2](#moderegister2), [3](#moderegister3), [4](#moderegister4), [5](#moderegister5) and [6](#moderegister6).

    Address... 0677H

This routine is used by the [SETTXT](#settxt), [SETT32](#sett32), [SETGRP](#setgrp) and [SETMLT](#setmlt) standard routines to copy a block of five table base addresses from the Workspace Area into VDP Mode Registers [2](#moderegister2), [3](#moderegister3), [4](#moderegister4), [5](#moderegister5) and [6](#moderegister6). On entry register pair HL points to the relevant group of addresses. Each base address is collected in turn shifted the required number of places and then written to the relevant Mode Register via the [WRTVDP](#wrtvdp) standard routine.

<a name="clrspr"></a>

    Address... 06A8H
    Name...... CLRSPR
    Entry..... None
    Exit...... None
    Modifies.. AF, BC, DE, HL, EI

Standard routine to clear all sprites. The entire 2 KB Sprite Pattern Table is first filled with zeros via the [FILVRM](#filvrm) standard routine. The vertical coordinate of each of the thirty-two sprite attribute blocks is then set to -47 (D1H) to place the sprite above the top of the screen, the horizontal coordinate is left unchanged.

The pattern numbers in the Sprite Attribute Table are initialized with the series 0, 1, 2, 3, 4,... 31 for 8x8 sprites or the series 0, 4, 8, 12, 16,... 124 for 16x16 sprites. The series to be generated is determined by the Size bit in VDP [Mode Register 1](#moderegister1). Finally the colour byte of each sprite attribute block is filled in with the colour code contained in [FORCLR](#forclr), this is initially white.

Note that the Size and Mag bits in VDP Mode Register 1 are not affected by this routine. Note also that the [INIT32](#init32), [INIGRP](#inigrp) and [INIMLT](#inimlt) standard routines use this routine with an entry point at 06BBH, leaving the Sprite Pattern Table undisturbed.

<a name="calpat"></a>

    Address... 06E4H
    Name...... CALPAT
    Entry..... A=Sprite pattern number
    Exit...... HL=Sprite pattern address
    Modifies.. AF, DE, HL

Standard routine to calculate the address of a sprite pattern. The pattern number is first multiplied by eight then, if 16x16 sprites are selected, multiplied by a further factor of four. This is then added to the Sprite Pattern Table base address, taken from [PATBAS](#patbas), to produce the final address.

This numbering system is in line with the BASIC Interpreter's usage of pattern numbers rather than the VDP's when 16x16 sprites are selected. As an example while the Interpreter calls the second pattern number one, it is actually VDP pattern number four. This usage means that the maximum pattern number this routine should allow, when 16x16 sprites are selected, is sixty-three. There is no actual check on this limit so large pattern numbers will produce addresses greater than 3FFFH. Such addresses, when passed to the other VDP routines, will wrap around past zero and corrupt the Character Pattern Table in VRAM.

<a name="calatr"></a>

    Address... 06F9H
    Name...... CALATR
    Entry..... A=Sprite number
    Exit...... HL=Sprite attribute address
    Modifies.. AF, DE, HL

Standard routine to calculate the address of a sprite attribute block. The sprite number, from zero to thirty-one, is multiplied by four and added to the Sprite Attribute Table base address taken from [ATRBAS](#atrbas).

<a name="gspsiz"></a>

    Address... 0704H
    Name...... GSPSIZ
    Entry..... None
    Exit...... A=Bytes in sprite pattern (8 or 32)
    Modifies.. AF

Standard routine to return the number of bytes occupied by each sprite pattern in the Sprite Pattern Table. The result is determined simply by examining the Size bit in VDP [Mode Register 1](#moderegister1).

<a name="ldirmv"></a>

    Address... 070FH
    Name...... LDIRMV
    Entry..... BC=Length, DE=RAM address, HL=VRAM address
    Exit...... None
    Modifies.. AF, BC, DE, EI

Standard routine to copy a block into main memory from the VDP VRAM. The VRAM starting address is set via the [SETRD](#setrd) standard routine and then sequential bytes read from the VDP Data Port and placed in main memory.

    Address... 071EH

This routine is used to copy a 2 KB character set into the VDP Character Pattern Table in any mode. The base address of the Character Pattern Table in VRAM is taken from [CGPBAS](#cgpbas). The starting address of the character set is taken from [CGPNT](#cgpnt). The [RDSLT](#rdslt) standard routine is used to read the character data so this may be situated in an extension ROM.

At power-up [CGPNT](#cgpnt) is initialized with the address contained at ROM location 0004H, which is 1BBFH. [CGPNT](#cgpnt) is easily altered to produce some interesting results, `POKE &HF920,&HC7:SCREEN 0` provides a thoroughly confusing example.

<a name="ldirvm"></a>

    Address... 0744H
    Name...... LDIRVM
    Entry..... BC=Length, DE=VRAM address, HL=RAM address
    Exit...... None
    Modifies.. AF, BC, DE, HL, EI

Standard routine to copy a block to VRAM from main memory.  The VRAM starting address is set via the [SETWRT](#setwrt) standard routine and then sequential bytes taken from main memory and written to the VDP [Data Port](#dataport).

    Address... 0777H

This routine will clear the screen in any VDP mode. In [40x24 Text Mode](#40x24textmode) and [32x24 Text Mode](#32x24textmode) the Name Table, whose base address is taken from [NAMBAS](#nambas), is first filled with ASCII spaces. The cursor is then set to the home position (0A7FH) and [LINTTB](#linttb), the line termination table, re-initialized. Finally the function key display is restored, if it is enabled, via the [FNKSB](#fnksb) standard routine.

In [Graphics Mode](#graphicsmode) the border colour is first set via VDP [Mode Register 7](#moderegister7) (0832H). The Colour Table is then filled with the background colour code, taken from [BAKCLR](#bakclr), for both 0 and 1 pixels. Finally the Character Pattern Table is filled with zeroes.

In [Multicolour Mode](#multicolourmode) the border colour is first set via VDP [Mode Register 7](#moderegister7) (0832H). The Character Pattern Table is then filled with the background colour taken from [BAKCLR](#bakclr).

<a name="wrtvrm"></a>

    Address... 07CDH
    Name...... WRTVRM
    Entry..... A=Data byte, HL=VRAM address
    Exit...... None
    Modifies.. EI

Standard routine to write a single byte to the VDP VRAM. The VRAM address is first set up via the [SETWRT](#setwrt) standard routine and then the data byte written to the VDP [Data Port](#dataport). Note that the two seemingly spurious `EX(SP),HL` instructions in this routine, and several others, are required to meet the VDP's timing constraints.

<a name="rdvrm"></a>

    Address... 07D7H
    Name...... RDVRM
    Entry..... HL=VRAM address
    Exit...... A=Byte read
    Modifies.. AF, EI

Standard routine to read a single byte from the VDP VRAM. The VRAM address is first set up via the [SETRD](#setrd) standard routine and then the byte read from the VDP [Data Port](#dataport).

<a name="setwrt"></a>

    Address... 07DFH
    Name...... SETWRT
    Entry..... HL=VRAM address
    Exit...... None
    Modifies.. AF, EI

Standard routine to set up the VDP for subsequent writes to VRAM via the [Data Port](#dataport). The address contained in register pair HL is written to the VDP [Command Port](#commandport) LSB first, MSB second as shown in [Figure 7](#figure7). Addresses greater than 3FFFH will wrap around past zero as the two most significant bits of the address are ignored.

<a name="setrd"></a>

    Address... 07ECH
    Name...... SETRD
    Entry..... HL=VRAM address
    Exit...... None
    Modifies.. AF, EI

Standard routine to set up the VDP for subsequent reads from VRAM via the [Data Port](#dataport). The address contained in register pair HL is written to the VDP [Command Port](#commandport) LSB first, MSB second as shown in [Figure 7](#figure7). Addresses greater than 3FFFH will wrap around past zero as the two most significant bits of the address are ignored.

<a name="chgclr"></a>

    Address... 07F7H
    Name...... CHGCLR
    Entry..... None
    Exit...... None
    Modifies.. AF, BC, HL, EI

Standard routine to set the VDP colours. [SCRMOD](#scrmod) is first examined to determine the appropriate course of action. In [40x24 Text Mode](#40x24textmode) the contents of [BAKCLR](#bakclr) and [FORCLR](#forclr) are written to VDP [Mode Register 7](#moderegister7) to set the colour of the 0 and 1 pixels, these are initially blue and white. Note that in this mode there is no way of specifying the border colour, this will be the same as the 0 pixel colour. In [32x24 Text Mode](#32x24textmode), [Graphics Mode](#graphicsmode) or [Multicolour Mode](#multicolourmode) the contents of [BDRCLR](#bdrclr) are written to VDP [Mode Register 7](#moderegister7) to set the colour of the border, this is initially blue. Also in [32x24 Text Mode](#32x24textmode) the contents of [BAKCLR](#bakclr) and [FORCLR](#forclr) are copied to the whole of the Colour Table to determine the 0 and 1 pixel colours.

<a name="filvrm"></a>

    Address... 0815H
    Name...... FILVRM
    Entry..... A=Data byte, BC=Length, HL=VRAM address
    Exit...... None
    Modifies.. AF, BC, EI

Standard routine to fill a block of the VDP VRAM with a single data byte. The VRAM starting address, contained in register pair HL, is first set up via the [SETWRT](#setwrt) standard routine. The data byte is then repeatedly written to the VDP Data Port to fill successive VRAM locations.

<a name="totext"></a>

    Address... 083BH
    Name...... TOTEXT
    Entry..... None
    Exit...... None
    Modifies.. AF, BC, DE, HL, EI

Standard routine to return the VDP to either [40x24 Text Mode](#40x24textmode) or [32x24 Text Mode](#32x24textmode) if it is currently in [Graphics Mode](#graphicsmode) or [Multicolour Mode](#multicolourmode). It is used by the BASIC Interpreter Mainloop and by the "[INPUT](#input)" statement handler. Whenever the [INITXT](#initxt) or [INIT32](#init32) standard routines are used the mode byte, 00H or 01H, is copied into [OLDSCR](#oldscr). If the mode is subsequently changed to [Graphics Mode](#graphicsmode) or [Multicolour Mode](#multicolourmode), and then has to be returned to one of the two text modes for keyboard input, this routine ensures that it returns to the same one.

[SCRMOD](#scrmod) is first examined and, if the screen is already in either text mode, the routine simply terminates with no action.  Otherwise the previous text mode is taken from [OLDSCR](#oldscr) and passed to the [CHGMOD](#chgmod) standard routine.

<a name="cls"></a>

    Address... 0848H
    Name...... CLS
    Entry..... Flag Z
    Exit...... None
    Modifies.. AF, BC, DE, EI

Standard routine to clear the screen in any mode, it does nothing but call the routine at 0777H. This is actually the "`CLS`" statement handler and, because this indicates that there is illegal text after the statement, it will simply return if entered with Flag NZ.

<a name="chgmod"></a>

    Address... 084FH
    Name...... CHGMOD
    Entry..... A=Screen mode required (0, 1, 2, 3)
    Exit...... None
    Modifies.. AF, BC, DE, HL, EI

Standard routine to set a new screen mode. Register A, containing the required screen mode, is tested and control transferred to [INITXT](#initxt), [INIT32](#init32), [INIGRP](#inigrp) or [INIMLT](#inimlt).

<a name="lptout"></a>

    Address... 085DH
    Name...... LPTOUT
    Entry..... A=Character to print
    Exit...... Flag C if CTRL-STOP termination
    Modifies.. AF

Standard routine to output a character to the line printer via the Centronics Port. The printer status is continually tested, via the [LPTSTT](#lptstt) standard routine, until the printer becomes free. The character is then written to the Centronics Data Port (I/O port 91H) and the [STROBE](#strobe) signal of the Centronics Status Port (I/O port 90H) briefly pulsed low. Note that the [BREAKX](#breakx) standard routine is used to test for the CTRL-STOP key if the printer is busy. If CTRL-STOP is detected a CR code is written to the Centronics Data Port, to flush the printer's line buffer, and the routine terminates with Flag C.

<a name="lptstt"></a>

    Address... 0884H
    Name...... LPTSTT
    Entry..... None
    Exit...... A=0 and Flag Z if printer busy
    Modifies.. AF

Standard routine to test the Centronics Status Port [BUSY](#busy) signal. This just involves reading I/O port 90H and examining the state of bit 1: 0=Ready, 1=Busy.

<a name="posit"></a>

    Address... 088EH
    Name...... POSIT
    Entry..... H=Column, L=Row
    Exit...... None
    Modifies.. AF, EI

Standard routine to set the cursor coordinates. The row and column coordinates are sent to the [OUTDO](#outdo) standard routine as the parameters in an ESC,"Y",Row+1FH, Column+1FH sequence. Note that the BIOS home position has coordinates of 1,1 rather than the 0,0 used by the BASIC Interpreter.

<a name="cnvchr"></a>

    Address... 089DH
    Name...... CNVCHR
    Entry..... A=Character
    Exit...... Flag Z,NC=Header; Flag NZ,C=Graphic; Flag Z,C=Normal
    Modifies.. AF

Standard routine to test for, and convert if necessary, characters with graphic headers. Characters less than 20H are normally interpreted by the output device drivers as control characters. A character code in this range can be treated as a displayable character by preceding it with a graphic header control code (01H) and adding 40H to its value. For example to directly display character code 0DH, rather than have it interpreted as a carriage return, it is necessary to output the two bytes 01H,4DH. This routine is used by the output device drivers, such as the [CHPUT](#chput) standard routine, to check for such sequences.

If the character is a graphic header [GRPHED](#grphed) is set to 01H and the routine terminates, otherwise [GRPHED](#grphed) is zeroed. If the character is outside the range 40H to 5FH it is left unchanged.  If it is inside this range, and [GRPHED](#grphed) contains 01H indicating a previous graphic header, it is converted by subtracting 40H.

<a name="chput"></a>

    Address... 08BCH
    Name...... CHPUT
    Entry..... A=Character
    Exit...... None
    Modifies.. EI

Standard routine to output a character to the screen in [40x24 Text Mode](#40x24textmode) or [32x24 Text Mode](#32x24textmode). [SCRMOD](#scrmod) is first checked and, if the VDP is in either [Graphics Mode](#graphicsmode) or [Multicolour Mode](#multicolourmode), the routine terminates with no action. Otherwise the cursor is removed (0A2EH), the character decoded (08DFH) and then the cursor replaced (09E1H). Finally the cursor column position is placed in [TTYPOS](#ttypos), for use by the "`PRINT`" statement, and the routine terminates.

    Address... 08DFH

This routine is used by the [CHPUT](#chput) standard routine to decode a character and take the appropriate action. The [CNVCHR](#cnvchr) standard routine is first used to check for a graphic character, if the character is a header code (01H) then the routine terminates with no action. If the character is a converted graphic one then the control code decoding section is skipped. Otherwise [ESCCNT](#esccnt) is checked to see if a previous ESC character (1BH) has been received, if so control transfers to the ESC sequence processor (098FH). Otherwise the character is checked to see if it is smaller than 20H, if so control transfers to the control code processor (0914H). The character is then checked to see if it is DEL (7FH), if so control transfers to the delete routine (0AE3H).

Assuming the character is displayable the cursor coordinates are taken from [CSRY](#csry) and [CSRX](#csrx) and placed in register pair HL, H=Column, L=Row. These are then converted to a physical address in the VDP Name Table and the character placed there (0BE6H).  The cursor column position is then incremented (0A44H) and, assuming the rightmost column has not been exceeded, the routine terminates. Otherwise the row's entry in [LINTTB](#linttb), the line termination table, is zeroed to indicate an extended logical line, the column number is set to 01H and a LF is performed.

    Address... 0908H

This routine performs the LF operation for the [CHPUT](#chput) standard routine control code processor. The cursor row is incremented (0A61H) and, assuming the lowest row has not been exceeded, the routine terminates. Otherwise the screen is scrolled upwards and the lowest row erased (0A88H).

    Address... 0914H

This is the control code processor for the [CHPUT](#chput) standard routine. The table at 092FH is searched for a match with the code and control transferred to the associated address.

    Address... 092FH

This table contains the control codes, each with an associated address, recognized by the [CHPUT](#chput) standard routine:

|CODE |TO     |FUNCTION
|:---:|:-----:|--------------------------------
|07H  |1113H  |BELL, go beep
|08H  |0A4CH  |BS, cursor left
|09H  |0A71H  |TAB, cursor to next tab position
|0AH  |0908H  |LF, cursor down a row
|0BH  |0A7FH  |HOME, cursor to home
|0CH  |077EH  |FORMFEED, clear screen and home
|0DH  |0A81H  |CR, cursor to leftmost column
|1BH  |0989H  |ESC, enter escape sequence
|1CH  |0A5BH  |RIGHT, cursor right
|1DH  |0A4CH  |LEFT, cursor left
|1EH  |0A57H  |UP, cursor up
|1FH  |0A61H  |DOWN, cursor down.

</a>

    Address... 0953H

This table contains the ESC control codes, each with an associated address, recognized by the [CHPUT](#chput) standard routine:

|CODE |TO     |FUNCTION
|:---:|:-----:|-------------------------------
|6AH  |077EH  |ESC,"j", clear screen and home
|45H  |077EH  |ESC,"E", clear screen and home
|4BH  |0AEEH  |ESC,"K", clear to end of line
|4AH  |0B05H  |ESC,"J", clear to end of screen
|6CH  |0AECH  |ESC,"l", clear line
|4CH  |0AB4H  |ESC,"L", insert line
|4DH  |0A85H  |ESC,"M", delete line
|59H  |0986H  |ESC,"Y", set cursor coordinates
|41H  |0A57H  |ESC,"A", cursor up
|42H  |0A61H  |ESC,"B", cursor down
|43H  |0A44H  |ESC,"C", cursor right
|44H  |0A55H  |ESC,"D", cursor left
|48H  |0A7FH  |ESC,"H", cursor home
|78H  |0980H  |ESC,"x", change cursor
|79H  |0983H  |ESC,"y", change cursor

</a>

    Address... 0980H

This routine performs the ESC,"x" operation for the [CHPUT](#chput) standard routine control code processor. [ESCCNT](#esccnt) is set to 01H to indicate that the next character received is a parameter.

    Address... 0983H

This routine performs the ESC,"y" operation for the [CHPUT](#chput) standard routine control code decoder. [ESCCNT](#esccnt) is set to 02H to indicate that the next character received is a parameter.

    Address... 0986H

This routine performs the ESC",Y" operation for the [CHPUT](#chput) standard routine control code processor. [ESCCNT](#esccnt) is set to 04H to indicate that the next character received is a parameter.

    Address... 0989H

This routine performs the ESC operation for the [CHPUT](#chput) standard routine control code processor. [ESCCNT](#esccnt) is set to FFH to indicate that the next character received is the second control character.

    Address... 098FH

This is the [CHPUT](#chput) standard routine ESC sequence processor.  If [ESCCNT](#esccnt) contains FFH then the character is the second control character and control transfers to the control code processor (0919H) to search the ESC code table at 0953H.

If [ESCCNT](#esccnt) contains 01H then the character is the single parameter of the ESC,"x" sequence. If the parameter is "4" (34H) then [CSTYLE](#cstyle) is set to 00H resulting in a block cursor. If the parameter is "5" (35H) then [CSRSW](#csrsw) is set to 00H making the cursor normally disabled.

If [ESCCNT](#esccnt) contains 02H then the character is the single parameter in the ESC,"y" sequence. If the parameter is "4" (34H) then [CSTYLE](#cstyle) is set to 01H resulting in an underline cursor. If the parameter is "5" (35H) then [CSRSW](#csrsw) is set to 01H making the cursor normally enabled.

If [ESCCNT](#esccnt) contains 04H then the character is the first parameter of the ESC,"Y" sequence and is the row coordinate.  The parameter has 1FH subtracted and is placed in [CSRY](#csry), [ESCCNT](#esccnt) is then decremented to 03H.

If [ESCCNT](#esccnt) contains 03H then the character is the second parameter of the ESC,"Y" sequence and is the column coordinate.  The parameter has 1FH subtracted and is placed in [CSRX](#csrx).


    Address... 09DAH

This routine is used, by the [CHGET](#chget) standard routine for example, to display the cursor character when it is normally disabled. If [CSRSW](#csrsw) is non-zero the routine simply terminates with no action, otherwise the cursor is displayed (09E6H).

    Address... 09E1H

This routine is used, by the [CHPUT](#chput) standard routine for example, to display the cursor character when it is normally enabled. If [CSRSW](#csrsw) is zero the routine simply terminates with no action. [SCRMOD](#scrmod) is checked and, if the screen is in [Graphics Mode](#graphicsmode) or [Multicolour Mode](#multicolourmode), the routine terminates with no action. Otherwise the cursor coordinates are converted to a physical address in the VDP Name Table and the character read from that location (0BD8H) and saved in [CURSAV](#cursav).

The character's eight byte pixel pattern is read from the VDP Character Pattern Table into the [LINWRK](#linwrk) buffer (0BA5H). The pixel pattern is then inverted, all eight bytes if [CSTYLE](#cstyle) indicates a block cursor, only the bottom three if [CSTYLE](#cstyle) indicates an underline cursor. The pixel pattern is copied back to the position for character code 255 in the VDP Character Pattern Table (0BBEH). The character code 255 is then placed at the current cursor location in the VDP Name Table (0BE6H) and the routine terminates.

This method of generating the cursor character, by using character code 255, can produce curious effects under certain conditions. These can be demonstrated by executing the BASIC statement `FOR N=1 TO 100: PRINT CHR$(255);:NEXT` and then pressing the cursor up key.

    Address... 0A27H

This routine is used, by the [CHGET](#chget) standard routine for example, to remove the cursor character when it is normally disabled. If [CSRSW](#csrsw) is non-zero the routine simply terminates with no action, otherwise the cursor is removed (0A33H).

    Address... 0A2EH

This routine is used, by the [CHPUT](#chput) standard routine for example, .to remove the cursor character when it is normally enabled. If [CSRSW](#csrsw) is zero the routine simply terminates with no action. [SCRMOD](#scrmod) is checked and, if the screen is in [Graphics Mode](#graphicsmode) or [Multicolour Mode](#multicolourmode), the routine terminates with no action. Otherwise the cursor coordinates are converted to a physical address in the VDP Name Table and the character held in [CURSAV](#cursav) written to that location (0BE6H).

    Address... 0A44H

This routine performs the ESC,"C" operation for the [CHPUT](#chput) standard routine control code processor. If the cursor column coordinate is already at the rightmost column, determined by [LINLEN](#linlen), then the routine terminates with no action. Otherwise the column coordinate is incremented and [CSRX](#csrx) updated.

    Address... 0A4CH

This routine performs the BS/LEFT operation for the [CHPUT](#chput) standard routine control code processor. The cursor column coordinate is decremented and [CSRX](#csrx) updated. If the column coordinate has moved beyond the leftmost position it is set to the rightmost position, from [LINLEN](#linlen), and an UP operation performed.

    Address... 0A55H

This routine performs the ESC,"D" operation for the [CHPUT](#chput) standard routine control code processor. If the cursor column coordinate is already at the leftmost position then the routine terminates with no action. Otherwise the column coordinate is decremented and [CSRX](#csrx) updated.

    Address... 0A57H

This routine performs the ESC,"A" (UP) operation for the [CHPUT](#chput) standard routine control code processor. If the cursor row coordinate is already at the topmost position the routine terminates with no action. Otherwise the row coordinate is decremented and [CSRY](#csry) updated.

    Address... 0A5BH

This routine performs the RIGHT operation for the [CHPUT](#chput) standard routine control code processor. The cursor column coordinate is incremented and [CSRX](#csrx) updated. If the column coordinate has moved beyond the rightmost position, determined by [LINLEN](#linlen), it is set to the leftmost position (01H) and a DOWN operation performed.

    Address... 0A61H

This routine performs the ESC,"B" (DOWN) operation for the [CHPUT](#chput) standard routine control code processor. If the cursor row coordinate is already at the lowest position, determined by [CRTCNT](#crtcnt) and [CNSDFG](#cnsdfg) (0C32H), then the routine terminates with no action. Otherwise the row coordinate is incremented and [CSRY](#csry) updated.

    Address... 0A71H

This routine performs the TAB operation for the [CHPUT](#chput) standard routine control code processor. ASCII spaces are output (08DFH) until [CSRX](#csrx) is a multiple of eight plus one (BIOS columns 1, 9, 17, 25, 33).

    Address... 0A7FH

This routine performs the ESC,"H" (HOME) operation for the [CHPUT](#chput) standard routine control code processor, [CSRX](#csrx) and [CSRY](#csry) are simply set to 1,1. The ROM BIOS cursor coordinate system, while functionally identical to that used by the BASIC Interpreter, numbers the screen rows from 1 to 24 and the columns from 1 to 32/40.

    Address... 0A81H

This routine performs the CR operation for the [CHPUT](#chput) standard routine control code processor, [CSRX](#csrx) is simply set to 01H .

    Address... 0A85H

This routine performs the ESC,"M" function for the [CHPUT](#chput) standard routine control code processor. A CR operation is first performed to set the cursor column coordinate to the leftmost position. The number of rows from the current row to the bottom of the screen is then determined, if this is zero the current row is simply erased (0AECH). The row count is first used to scroll up the relevant section of [LINTTB](#linttb), the line termination table, by one byte. It is then used to scroll up the relevant section of the screen a row at a time. Starting at the row below the current row, each line is copied from the VDP Name Table into the [LINWRK](#linwrk) buffer (0BAAH) then copied back to the Name Table one row higher (0BC3H). Finally the lowest row on the screen is erased (0AECH).

    Address... 0AB4H

This routine performs the ESC,"L" operation for the [CHPUT](#chput) standard routine control code processor. A CR operation is first performed to set the cursor column coordinate to the leftmost position. The number of rows from the current row to the bottom of the screen is then determined, if this is zero the current row is simply erased (0AECH). The row count is first used to scroll down the relevant section of [LINTTB](#linttb), the line termination table, by one byte. It is then used to scroll down the relevant section of the screen a row at a time.  Starting at the next to last row of the screen, each line is copied from the VDP Name Table into the [LINWRK](#linwrk) buffer (0BAAH), then copied back to the Name Table one row lower (0BC3H). Finally the current row is erased (0AECH).

    Address... 0AE3H

This routine is used to perform the DEL operation for the [CHPUT](#chput) standard routine control code processor. A LEFT operation is first performed. If this cannot be completed, because the cursor is already at the home position, then the routine terminates with no action. Otherwise a space is written to the VDP Name Table at the cursor's physical location (0BE6H).

    Address... 0AECH

This routine performs the ESC,"l" operation for the [CHPUT](#chput) standard routine control code processor. The cursor column coordinate is set to 01H and control drops into the ESC,"K" routine.

    Address... 0AEEH

This routine performs the ESC,"K" operation for the [CHPUT](#chput) standard routine control code processor. The row's entry in [LINTTB](#linttb), the line termination table, is first made non-zero to indicate that the logical line is not extended (0C29H). The cursor coordinates are converted to a physical address (0BF2H) in the VDP Name Table and the VDP set up for writes via the [SETWRT](#setwrt) standard routine. Spaces are then written directly to the VDP [Data Port](#dataport) until the rightmost column, determined by [LINLEN](#linlen), is reached.

    Address... 0B05H

This routine performs the ESC,"J" operation for the [CHPUT](#chput) standard routine control code processor. An ESC,"K" operation is performed on successive rows, starting with the current one, until the bottom of the screen is reached.

<a name="erafnk"></a>

    Address... 0B15H
    Name...... ERAFNK
    Entry..... None
    Exit...... None
    Modifies.. AF, DE, EI

Standard routine to turn the function key display off. [CNSDFG](#cnsdfg) is first zeroed and, if the VDP is in [Graphics Mode](#graphicsmode) or [Multicolour Mode](#multicolourmode), the routine terminates with no further action. If the VDP is in [40x24 Text Mode](#40x24textmode) or [32x24 Text Mode](#32x24textmode) the last row on the screen is then erased (0AECH).

<a name="fnksb"></a>

    Address... 0B26H
    Name...... FNKSB
    Entry..... None
    Exit...... None
    Modifies.. AF, BC, DE, EI

Standard routine to show the function key display if it is enabled. If [CNSDFG](#cnsdfg) is zero the routine terminates with no action, otherwise control drops into the [DSPFNK](#dspfnk) standard routine..

<a name="dspfnk"></a>

    Address... 0B2BH
    Name...... DSPFNK
    Entry..... None
    Exit...... None
    Modifies.. AF, BC, DE, EI

Standard routine to turn the function key display on. [CNSDFG](#cnsdfg) is set to FFH and, if the VDP is in [Graphics Mode](#graphicsmode) or [Multicolour Mode](#multicolourmode), the routine terminates with no further action. Otherwise the cursor row coordinate is checked and, if the cursor is on the last row of the screen, a LF code (0AH) issued to the [OUTDO](#outdo) standard routine to scroll the screen up.

Register pair HL is then set to point to either the unshifted or shifted function strings in the Workspace Area depending upon whether the SHIFT key is pressed. [LINLEN](#linlen) has four subtracted, to allow a minimum of one space between fields, and is divided by five to determine the field size for each string.  Successive characters are then taken from each function string, checked for graphic headers via the [CNVCHR](#cnvchr) standard routine and placed in the [LINWRK](#linwrk) buffer until the string is exhausted or the zone is filled. When all five strings are completed the [LINWRK](#linwrk) buffer is written to the last row in the VDP Name Table (0BC3H).

    Address... 0B9CH

This routine is used by the function key display related standard routines. The contents of register A are placed in [CNSDFG](#cnsdfg) then [SCRMOD](#scrmod) tested and Flag NC returned if the screen is in [Graphics Mode](#graphicsmode) or [Multicolour Mode](#multicolourmode).

    Address... 0BA5H

This routine copies eight bytes from the VDP VRAM into the [LINWRK](#linwrk) buffer, the VRAM physical address is supplied in register pair HL.

    Address... 0BAAH

This routine copies a complete row of characters, with the length determined by [LINLEN](#linlen), from the VDP VRAM into the [LINWRK](#linwrk) buffer. The cursor row coordinate is supplied in register L.

    Address... 0BBEH

This routine copies eight bytes from the [LINWRK](#linwrk) buffer into the VDP VRAM, the VRAM physical address is supplied in register pair HL.

    Address... 0BC3H

This routine copies a complete row of characters, with the length determined by [LINLEN](#linlen), from the [LINWRK](#linwrk) buffer into the VDP VRAM. The cursor row coordinate is supplied in register L.

    Address... 0BD8H

This routine reads a single byte from the VDP VRAM into register C. The column coordinate is supplied in register H, the row coordinate in register L.

    Address... 0BE6H

This routine converts a pair of screen coordinates, the column in register H and the row in register L, into a physical address in the VDP Name Table. This address is returned in register pair HL.

The row coordinate is first multiplied by thirty-two or forty, depending upon the screen mode, and added to the column coordinate. This is then added to the Name Table base address, taken from [NAMBAS](#nambas), to produce an initial address.

Because of the variable screen width, as contained in [LINLEN](#linlen), an additional offset has to be added to the initial address to keep the active region roughly centered within the screen. The difference between the "true" number of characters per row, thirty-two or forty, and the current width is halved and then rounded up to produce the left hand offset. For a UK machine, with a thirty-seven character width in [40x24 Text Mode](#40x24textmode), this will result in two unused characters on the left hand side and one on the right. The statement `PRINT (41-WID)\2`, where `WID` is any screen width, will display the left hand column offset in [40x24 Text Mode](#40x24textmode).

A complete BASIC program which emulates this routine is given below:

    10 CPR=40:NAM=BASE(0):WID=PEEK(&HF3AE)
    20 SCRMD=PEEK(&HFCAF):IF SCRMD=0 THEN 40
    30 CPR=32:NAM=BASE(5):WID=PEEK(&HF3AF)
    40 LH=(CPR+1-WID)\2
    50 ADDR=NAM+(ROW-1)*CPR+(COL-1)+LH

This program is designed for the `ROW` and `COL` coordinate system used by the ROM BIOS where home is 1,1. Line 50 may be simplified, by removing the "-1" factors, if the BASIC Interpreter's coordinate system is to be used.

    Address... 0C1DH

This routine calculates the address of a row's entry in [LINTTB](#linttb), the line termination table. The row coordinate is supplied in register L and the address returned in register pair DE.

    Address... 0C29H

This routine makes a row's entry in [LINTTB](#linttb) non-zero when entered at 0C29H and zero when entered at 0C2AH. The row coordinate is supplied in register L.

    Address... 0C32H

This routine returns the number of rows on the screen in register A. It will normally return twenty-four if the function key display is disabled and twenty-three if it is enabled. Note that the screen size is determined by [CRTCNT](#crtcnt) and may be modified with a BASIC statement, `POKE &HF3B1H,14:SCREEN 0` for example.

<a name="keyint"></a>

    Address... 0C3CH
    Name...... KEYINT
    Entry..... None
    Exit...... None
    Modifies.. EI

Standard routine to process Z80 interrupts, these are generated by the VDP once every 20 ms on a UK machine. The [VDP Status Register](#vdpstatusregister) is first read and bit 7 checked to ensure that this is a frame rate interrupt, if not the routine terminates with no action. The contents of the [Status Register](#vdpstatusregister) are saved in [STATFL](#statfl) and bit 5 checked for sprite coincidence. If the Coincidence Flag is active then the relevant entry in [TRPTBL](#trptbl) is updated (0EF1H).

[INTCNT](#intcnt), the "INTERVAL" counter, is then decremented. If this has reached zero the relevant entry in [TRPTBL](#trptbl) is updated (0EF1H) and the counter reset with the contents of [INTVAL](#intval).

[JIFFY](#jiffy), the "TIME" counter, is then incremented. This counter just wraps around to zero when it overflows.

[MUSICF](#musicf) is examined to determine whether any of the three music queues generated by the "`PLAY`" statement are active. For each active queue the dequeueing routine (113BH) is called to fetch the next music packet and write it to the PSG.

[SCNCNT](#scncnt) is then decremented to determine if a joystick and keyboard scan is required, if not the interrupt handler terminates with no further action. This counter is used to increase throughput and to minimize keybounce problems by ensuring that a scan is only carried out every three interrupts. Assuming a scan is required joystick connector 1 is selected and the two Trigger bits read (120CH), followed by the two Trigger bits from joystick connector 2 (120CH) and the SPACE key from row 8 of the keyboard (1226H). These five inputs, which are all related to the "`STRIG`" statement, are combined into a single byte where 0=Pressed, 1=Not pressed:

<a name="figure35"></a>![][CH04F35]

**Figure 35:** "`STRIG`" Inputs

This reading is compared with the previous one, held in [TRGFLG](#trgflg), to produce an active transition byte and [TRGFLG](#trgflg) is updated with the new reading. The active transition byte is normally zero but contains a 1 in each position where a transition from unpressed to pressed has occurred. This active transition byte is shifted out bit by bit and the relevant entry in [TRPTBL](#trptbl) updated (0EF1H) for each active device.

A complete scan of the keyboard matrix is then performed to identify new key depressions, any found are translated into key codes and placed in [KEYBUF](#keybuf) (0D12H). If [KEYBUF](#keybuf) is found to be empty at the end of this process [REPCNT](#repcnt) is decremented to see whether the auto-repeat delay has expired, if not the routine terminates. If the delay period has expired [REPCNT](#repcnt) is reset with the fast repeat value (60 ms), the [OLDKEY](#oldkey) keyboard map is reinitialized and the keyboard scanned again (0D4EH). Any keys which are continuously pressed will show up as new transitions during this scan. Note that keys will only auto-repeat while an application program keeps [KEYBUF](#keybuf) empty by reading characters.  The interrupt handler then terminates.

    Address... 0D12H

This routine performs a complete scan of all eleven rows of the keyboard matrix for the interrupt handler. Each of the eleven rows is read in via the PPI and placed in ascending order in [NEWKEY](#newkey). [ENSTOP](#enstop) is then checked to see if warm starts are enabled. If its contents are non-zero and the keys CODE, GRAPH, CTRL and SHIFT are pressed control transfers to the BASIC Interpreter (409BH) via the [CALBAS](#calbas) standard routine. This facility is useful as even a machine code program can be terminated as long as the interrupt handler is running.  The contents of [NEWKEY](#newkey) are compared with the previous scan contained in [OLDKEY](#oldkey). If any change at all has occurred [REPCNT](#repcnt) is loaded with the initial auto-repeat delay (780 ms). Each row 1, reading from [NEWKEY](#newkey) is then compared with the previous one, held in [OLDKEY](#oldkey), to produce an active transition byte and [OLDKEY](#oldkey) is updated with the new reading. The active transition byte is normally zero but contains a 1 in each position where a transition from unpressed to pressed has occurred. If the row contains any transitions these are decoded and placed in [KEYBUF](#keybuf) as key codes (0D89H). When all eleven rows have been completed the routine checks whether there are any characters in [KEYBUF](#keybuf), by subtracting [GETPNT](#getpnt) from [PUTPNT](#putpnt), and terminates.

<a name="chsns"></a>

    Address... 0D6AH
    Name...... CHSNS
    Entry..... None
    Exit...... Flag NZ if characters in KEYBUF
    Modifies.. AF, EI

Standard routine to check if any keyboard characters are ready. If the screen is in Graphics Mode or Multicolour Mode then GETPNT is subtracted from PUTPNT (0D62H) and the routine terminates. If the screen is in 40x24 Text Mode or 32x24 Text Mode the state of the SHIFT key is also examined and the function key display updated, via the DSPFNK standard routine, if it has changed.

    Address... 0D89H

This routine converts each active bit in a keyboard row transition byte into a key code. A bit is first converted into a key number determined by its position in the keyboard matrix:

<a name="figure36"></a>![][CH04F36]

**Figure 36:** Key Numbers

The key number is then converted into a key code and placed in KEYBUF (1021H). When all eight possible bits have been processed the routine terminates.

    Address... 0DA5H

This table contains the key codes of key numbers 00H to 2FH for various combinations of the control keys. A zero entry in the table means that no key code will be produced when that key is pressed:

           37H  36H  35H  34H  33H  32H  31H  30H   Row  0
           3BH  5DH  5BH  5CH  3DH  2DH  39H  38H   Row  1
    NORMAL 62H  61H  9CH  2FH  2EH  2CH  60H  27H   Row  2
           6AH  69H  68H  67H  66H  65H  64H  63H   Row  3
           72H  71H  70H  6FH  6EH  6DH  6CH  6BH   Row  4
           7AH  79H  78H  77H  76H  75H  74H  73H   Row  5

           26H  5EH  25H  24H  23H  40H  21H  29H   Row  0
           3AH  7DH  7BH  7CH  2BH  5FH  28H  2AH   Row  1
    SHIFT  42H  41H  9CH  3FH  3EH  3CH  7EH  22H   Row  2
           4AH  49H  48H  47H  46H  45H  44H  43H   Row  3
           52H  51H  50H  4FH  4EH  4DH  4CH  4BH   Row  4
           5AH  59H  58H  57H  56H  55H  54H  53H   Row  5

           FBH  F4H  BDH  EFH  BAH  ABH  ACH  09H   Row  0
           06H  0DH  01H  1EH  F1H  17H  07H  ECH   Row  1
    GRAPH  11H  C4H  9CH  1DH  F2H  F3H  BBH  05H   Row  2
           C6H  DCH  13H  15H  14H  CDH  C7H  BCH   Row  3
           18H  CCH  DBH  C2H  1BH  0BH  C8H  DDH   Row  4
           0FH  19H  1CH  CFH  1AH  C0H  12H  D2H   Row  5

           00H  F5H  00H  00H  FCH  FDH  00H  0AH   Row  0
           04H  0EH  02H  16H  F0H  1FH  08H  00H   Row  1
    SHIFT  00H  FEH  9CH  F6H  AFH  AEH  F7H  03H   Row  2
    GRAPH  CAH  DFH  D6H  10H  D4H  CEH  C1H  FAH   Row  3
           A9H  CBH  D7H  C3H  D3H  0CH  C9H  DEH   Row  4
           F8H  AAH  F9H  D0H  D5H  C5H  00H  D1H   Row  5

           E1H  E0H  98H  9BH  BFH  D9H  9FH  EBH   Row  0
           B7H  DAH  EDH  9CH  E9H  EEH  87H  E7H   Row  1
    CODE   97H  84H  9CH  A7H  A6H  86H  E5H  B9H   Row  2
           91H  A1H  B1H  81H  94H  8CH  8BH  8DH   Row  3
           93H  83H  A3H  A2H  A4H  E6H  B5H  B3H   Row  4
           85H  A0H  8AH  88H  95H  82H  96H  89H   Row  5

           00H  00H  9DH  9CH  BEH  9EH  ADH  D8H   Row  0
           B6H  EAH  E8H  00H  00H  00H  80H  E2H   Row  1
    SHIFT  00H  8EH  9CH  A8H  00H  8FH  E4H  B8H   Row  2
    CODE   92H  00H  B0H  9AH  99H  00H  00H  00H   Row  3
           00H  00H  E3H  00H  A5H  00H  B4H  B2H   Row  4
           00H  00H  00H  00H  00H  90H  00H  00H   Row  5

            7    6    5    4    3    2    1    0    Column

    Address... 0EC5H

Control transfers to this routine, from 0FC3H, to complete decoding of the five function keys. The relevant entry in FNKFLG is first checked to determine whether the key is associated with an "ON KEY GOSUB" statement. If so, and provided that CURLIN shows the BASIC Interpreter to be in program mode, the relevant entry in TRPTBL is updated (0EF1H) and the routine terminates. If the key is not tied to an "ON KEY GOSUB" statement, or if the Interpreter is in direct mode, the string of characters associated with the function key is returned instead. The key number is multiplied by sixteen, as each string is sixteen characters long, and added to the starting address of the function key strings in the Workspace Area. Sequential characters are then taken from the string and placed in KEYBUF (0F55H) until the zero byte terminator is reached.

    Address... 0EF1H

This routine is used to update a device's entry in TRPTBL when it has produced a BASIC program interrupt. On entry register pair HL points to the device's status byte in the table. Bit 0 of the status byte is checked first, if the device is not "ON" then the routine terminates with no action. Bit 2, the event flag, is then checked. If this is already set then the routine terminates, otherwise it is set to indicate that an event has occurred. Bit 1, the "STOP" flag, is then checked. If the device is stopped then the routine terminates with no further action. Otherwise ONGSBF is incremented to signal to the Interpreter Runloop that the event should now be processed.

    Address... 0F06H

This section of the key decoder processes the HOME key only.  The state of the SHIFT key is determined via row 6 of NEWKEY and the key code for HOME (0BH) or CLS (0CH) placed in KEYBUF (0F55H) accordingly.

    Address... 0F10H

This section of the keyboard decoder processes key numbers 30H to 57H apart from the CAP, F1 to F5, STOP and HOME keys.  The key number is simply used to look up the key code in the table at 1033H and this is then placed in KEYBUF (0F55H).

    Address... 0F1FH

This section of the keyboard decoder processes the DEAD key found on European MSX machines. On UK machines the key in row 2, column 5 always generates the pound key code (9CH) shown in the table at 0DA5H. On European machines this table will have the key code FFH in the same locations. This key code only serves as a flag to indicate that the next key pressed, if it is a vowel, should be modified to produce an accented graphics character.

The state of the SHIFT and CODE keys is determined via row 6 of NEWKEY and one of the following placed in KANAST: 01H=DEAD, 02H=DEAD+SHIFT, 03H=DEAD+CODE, 04H=DEAD+SHIFT+CODE.

    Address... 0F36H

This section of the keyboard decoder processes the CAP key.  The current state of CAPST is inverted and control drops into the CHGCAP standard routine.

<a name="chgcap"></a>

    Address... 0F3DH
    Name...... CHGCAP
    Entry..... A=ON/OFF Switch
    Exit...... None
    Modifies.. AF

Standard routine to turn the Caps Lock LED on or off as determined by the contents of register A: 00H=On, NZ=Off. The LED is modified using the bit set/reset facility of the PPI Mode Port. As CAPST is not changed this routine does not affect the characters produced by the keyboard.

    Address... 0F46H

This section of the keyboard decoder processes the STOP key.  The state of the CTRL key is determined via row 6 of NEWKEY and the key code for STOP (04H) or CTRL/STOP (03H) produced as appropriate. If the CTRL/STOP code is produced it is copied to INTFLG, for use by the ISCNTC standard routine, and then placed in KEYBUF (0F55H). If the STOP code is produced it is also copied to INTFLG but is not placed in KEYBUF, instead only a click is generated (0F64H). This means that an application program cannot read the STOP key code via the ROM BIOS standard routines.

    Address... 0F55H

This section of the keyboard decoder places a key code in KEYBUF and generates an audible click. The correct address in the keyboard buffer is first taken from PUTPNT and the code placed there. The address is then incremented (105BH). If it has wrapped round and caught up with GETPNT then the routine terminates with no further action as the keyboard buffer is full. Otherwise PUTPNT is updated with the new address.

CLIKSW and CLIKFL are then both checked to determine whether a click is required. CLIKSW is a general enable/disable switch while CLIKFL is used to prevent multiple clicks when the function keys are pressed. Assuming a click is required the Key Click output is set via the PPI Mode Port and, after a delay of 50 µs, control drops into the CHGSND standard routine.

<a name="chgsnd"></a>

    Address... 0F7AH
    Name...... CHGSND
    Entry..... A=ON/OFF Switch
    Exit...... None
    Modifies.. AF

Standard routine to set or reset the Key Click output via the PPI Mode Port: 00H=Reset, NZ=Set. This audio output is AC coupled so absolute polarities should not be taken too seriously.

    Address... 0F83H

This section of the keyboard decoder processes key numbers 00H to 2FH. The state of the SHIFT, GRAPH and CODE keys is determined via row 6 of NEWKEY and combined with the key number to form a look-up address into the table at 0DA5H. The key code is then taken from the table. If it is zero the routine terminates with no further action, if it is FFH control transfers to the DEAD key processor (0F1FH). If the code is in the range 40H to 5FH or 60H to 7FH and the CTRL key is pressed then the corresponding control code is placed in KEYBUF (0F55H). If the code is in the range 01H to 1FH then a graphic header code (01H) is first placed in KEYBUF (0F55H) followed by the code with 40H added. If the code is in the range 61H to 7BH and CAPST indicates that caps lock is on then it is converted to upper case by subtracting 20H. Assuming that KANAST contains zero, as it always will on UK machines, then the key code is placed in KEYBUF (0F55H) and the routine terminates. On European MSX machines, with a DEAD key instead of a pound key, then the key codes corresponding to the vowels a, e, i, o, u may be further modified into graphics codes.

    Address... 0FC3H

This section of the keyboard decoder processes the five function keys. The state of the SHIFT key is examined via row 6 of NEWKEY and five added to the key number if it is pressed.  Control then transfers to 0EC5H to complete processing.

    Address... 1021H

This routine searches the table at 1B97H to determine which group of keys the key number supplied in register C belongs to.  The associated address is then taken from the table and control transferred to that section of the keyboard decoder. Note that the table itself is actually patched into the middle of the OUTDO standard routine as a result of the modifications made to the Japanese ROM.

    Address... 1033H

This table contains the key codes of key numbers 30H to 57H other than the special keys CAP, F1 to F5, STOP and HOME. A zero entry in the table means that no key code will be produced when that key is pressed:

           00H 00H 00H 00H 00H 00H 00H 00H Row 6
           0DH 18H 08H 00H 09H 1BH 00H 00H Row 7
           1CH 1FH 1EH 1DH 7FH 12H 0CH 20H Row 8
           34H 33H 32H 31H 30H 00H 00H 00H Row 9
           2EH 2CH 2DH 39H 38H 37H 36H 35H Row 10

            7   6   5   4   3   2   1   0  Column

    Address... 105BH

This routine simply zeroes KANAST and then transfers control to 10C2H.

    Address... 1061H

This table contains the graphics characters which replace the vowels a, e, i, o, u on European machines.

    Address... 10C2H

This routine increments the keyboard buffer pointer, either PUTPNT or GETPNT, supplied in register pair HL. If the pointer then exceeds the end of the keyboard buffer it is wrapped back to the beginning.

<a name="chget"></a>

    Address... 10CBH
    Name...... CHGET
    Entry..... None
    Exit...... A=Character from keyboard
    Modifies.. AF, EI

Standard routine to fetch a character from the keyboard buffer. The buffer is first checked to see if already contains a character (0D6AH). If not the cursor is turned on (09DAH), the buffer checked repeatedly until a character appears (0D6AH) and then the cursor turned off (0A27H). The character is taken from the buffer using GETPNT which is then incremented (10C2H).

<a name="ckcntc"></a>

    Address... 10F9H
    Name...... CKCNTC
    Entry..... None
    Exit...... None
    Modifies.. AF, EI

Standard routine to check whether the CTRL-STOP or STOP keys have been pressed. It is used by the BASIC Interpreter inside processor-intensive statements, such as "WAIT" and "CIRCLE", to check for program termination. Register pair HL is first zeroed and then control transferred to the ISCNTC standard routine.  When the Interpreter is running register pair HL normally contains the address of the current character in the BASIC program text. If ISCNTC is CTRL-STOP terminated this address will be placed in OLDTXT by the "STOP" statement handler (63E6H) for use by a later "CONT" statement. Zeroing register pair HL beforehand signals to the "CONT" handler that termination occurred inside a statement and it will issue a "Can't CONTINUE" error if continuation is attempted.

<a name="wrtpsg"></a>

    Address... 1102H
    Name...... WRTPSG
    Entry..... A=Register number, E=Data byte
    Exit...... None
    Modifies.. EI

Standard routine to write a data byte to any of the sixteen PSG registers. The register selection number is written to the PSG Address Port and the data byte written to the PSG Data Write Port.

<a name="rdpsg"></a>

    Address... 110EH
    Name...... RDPSG
    Entry..... A=Register number
    Exit...... A=Data byte read from PSG
    Modifies.. A

Standard routine to read a data byte from any of the sixteen PSG registers. The register selection number is written to the PSG Address Port and the data byte read from the PSG Data Read Port.

<a name="beep"></a>

    Address... 1113H
    Name...... BEEP
    Entry..... None
    Exit...... None
    Modifies.. AF, BC, E, EI

Standard routine to produce a beep via the PSG. Channel A is set to produce a tone of 1316Hz then enabled with an amplitude of seven. After a delay of 40 ms control transfers to the GICINI standard routine to reinitialize the PSG.

    Address... 113BH

This routine is used by the interrupt handler to service a music queue. As there are three of these, each feeding a PSG channel, the queue to be serviced is specified by supplying its number in register A: 0=VOICAQ, 1=VOICBQ and 2=VOICCQ.

Each string in a "PLAY" statement is translated into a series of data packets by the BASIC Interpreter. These are placed in the appropriate queue followed by an end of data byte (FFH). The task of dequeueing the packets, decoding them and setting the PSG is left to the interrupt handler. The Interpreter is thus free to proceed immediately to the next statement without having to wait for notes to finish.

The first two bytes of any packet specify its byte count and duration. The three most significant bits of the first byte specify the number of bytes following the header in the packet.  The remainder of the header specifies the event duration in 20 ms units. This duration count determines how long it will be before the next packet is read from the queue.

<a name="figure37"></a>![][CH04F37]

**Figure 37:** Packet Header

The packet header may be followed by zero or more blocks, in any order, containing frequency or amplitude information:

<a name="figure38"></a>![][CH04F38]

**Figure 38:** Packet Block Types

The routine first locates the current duration counter in the relevant voice buffer (VCBA, VCBB or VCBC) via the GETVCP standard routine and decrements it. If the counter has reached zero then the next packet must be read from the queue, otherwise the routine terminates.

The queue number is placed in QUEUEN and a byte read from the queue (11E2H). This is then checked to see if it is the end of data mark (FFH), if so the queue terminates (11B0H).  Otherwise the byte count is placed in register C and the duration MSB in the relevant voice buffer. The second byte is read (11E2H) and the duration LSB placed in the relevant voice buffer. The byte count is then examined, if there are no bytes to follow the packet header the routine terminates. Otherwise successive bytes are read from the queue, and the appropriate action taken, until the byte count is exhausted.

If a frequency block is found then a second byte is read and both bytes written to PSG Registers 0 and 1, 2 and 3 or 4 and 5 depending on the queue number.

If an amplitude block is found the Amplitude and Mode bits are written to PSG Registers 8, 9 or 10 depending on the queue number. If the Mode bit is 1, selecting modulated rather than fixed amplitude, then the byte is also written to PSG Register 13 to set the envelope shape.

If an envelope block is found, or if bit 6 of an amplitude block is set, then a further two bytes are read from the queue and written to PSG Registers 11 and 12.

    Address... 11B0H

This routine is used when an end of data mark (FFH) is found in one of the three music queues. An amplitude value of zero is written to PSG Register 8 9 or 10, depending on the queue number, to shut the channel down. The channel's bit in MUSICF is then reset and control drops into the STRTMS standard routine.

<a name="strtms"></a>

    Address... 11C4H
    Name...... STRTMS
    Entry..... None
    Exit...... None
    Modifies.. AF, HL

Standard routine used by the "PLAY" statement handler to initiate music dequeueing by the interrupt handler. MUSICF is first examined, if any channels are already running the routine terminates with no action. PLYCNT is then decremented, if there are no more "PLAY" strings queued up the routine terminates.  Otherwise the three duration counters, in VCBA, VCBB and VCBC, are set to 0001H, so that the first packet of the new group will be dequeued at the next interrupt, and MUSICF is set to 07H to enable all three channels.

    Address... 11E2H

This routine loads register A with the current queue number, from QUEUEN, and then reads a byte from that queue (14ADH).

<a name="gtstck"></a>

    Address... 11EEH
    Name...... GTSTCK
    Entry..... A=Joystick ID (0, 1 or 2)
    Exit...... A=Joystick position code
    Modifies.. AF, B, DE, HL, EI

Standard routine to read the position of a joystick or the four cursor keys. If the supplied ID is zero the state of the cursor keys is read via PPI Port B (1226H) and converted to a position code using the look-up table at 1243H. Otherwise joystick connector 1 or 2 is read (120CH) and the four direction bits converted to a position code using the look-up table at 1233H. The returned position codes are:

<a name="figure39a"></a>![][CH04F39a]

    Address... 120CH

This routine reads the joystick connector specified by the contents of register A: 0=Connector 1, 1=Connector 2. The current contents of PSG Register 15 are read in then written back with the Joystick Select bit appropriately set. PSG Register 14 is then read into register A (110CH) and the routine terminates.

    Address... 1226H

This routine reads row 8 of the keyboard matrix. The current contents of PPI Port C are read in then written back with the four Keyboard Row Select bits set for row 8. The column inputs are then read into register A from PPI Port B.

<a name="gttrig"></a>

    Address... 1253H
    Name...... GTTRIG
    Entry..... A=Trigger ID (0, 1, 2, 3 or 4)
    Exit...... A=Status code
    Modifies.. AF, BC, EI

Standard routine to check the joystick trigger or space key status. If the supplied ID is zero row 8 of the keyboard matrix is read (1226H) and converted to a status code. Otherwise joystick connector 1 or 2 is read (120CH) and converted to a status code. The selection IDs are:

    0=SPACE KEY
    1=JOY 1, TRIGGER A
    2=JOY 2, TRIGGER A
    3=JOY 1, TRIGGER B
    4=JOY 2, TRIGGER B

The value returned is FFH if the relevant trigger is pressed and zero otherwise.

<a name="gtpdl"></a>

    Address... 1273H
    Name...... GTPDL
    Entry..... A=Paddle ID (1 to 12)
    Exit...... A=Paddle value (0 to 255)
    Modifies.. AF, BC, DE, EI

Standard routine to read the value of any paddle attached to a joystick connector. Each of the six input lines (four direction plus two triggers) per connector can support a paddle so twelve are possible altogether. The paddles attached to joystick connector 1 have entry identifiers 1, 3, 5, 7, 9 and 11.  Those attached to joystick connector 2 have entry identifiers 2, 4, 6, 8, 10 and 12. Each paddle is basically a one-shot pulse generator, the length of the pulse being controlled by a variable resistor. A start pulse is issued to the specified joystick connector via PSG Register 15. A count is then kept of how many times PSG Register 14 has to be read until the relevant input times out. Each unit increment represents an approximate period of 12 µs on an MSX machine with one wait state.

<a name="gtpad"></a>

    Address... 12ACH
    Name...... GTPAD
    Entry..... A=Function code (0 to 7)
    Exit...... A=Status or value
    Modifies.. AF, BC, DE, HL, EI

Standard routine to access a touchpad attached to either of the joystick connectors. Available functions codes for joystick connector 1 are:

    0=Return Activity Status
    1=Return "X" coordinate
    2=Return "Y" coordinate
    3=Return Switch Status

Function codes 4 to 7 have the same effect with respect to joystick connector 2. The Activity Status function returns FFH if the Touchpad is being touched and zero otherwise. The Switch Status function returns FFH if the switch is being pressed and zero otherwise. The two coordinate request functions return the coordinates of the last location touched. These coordinates are actually stored in the Workspace Area variables PADX and PADY when a call with function code 0 or 4 detects activity. Note that these variables are shared by both joystick connectors.

<a name="stmotr"></a>

    Address... 1384H
    Name...... STMOTR
    Entry..... A=Motor ON/OFF code
    Exit...... None
    Modifies.. AF

Standard routine to turn the cassette motor relay on or off via PPI Port C: 00H=Off, 01H=On, FFH=Reverse current state.

<a name="nmi"></a>

    Address... 1398H
    Name...... NMI
    Entry..... None
    Exit...... None
    Modifies.. None

Standard routine to process a Z80 Non Maskable Interrupt, simply returns on a standard MSX machine.

<a name="inifnk"></a>

    Address... 139DH
    Name...... INIFNK
    Entry..... None
    Exit...... None
    Modifies.. BC, DE, HL

Standard routine to initialize the ten function key strings to their power-up values. The one hundred and sixty bytes of data commencing at 13A9H are copied to the FNKSTR buffer in the Workspace Area.

    Address... 13A9H

This area contains the power-up strings for the ten function keys. Each string is sixteen characters long, unused positions contain zeroes:

    F1 to F5  F6 to F10
    color     color 15,4,4 CR
    auto      cload"
    goto      cont CR
    list      list. CR UP UP
    run CR    run CLS CR

<a name="rdvdp"></a>

    Address... 1449H
    Name...... RDVDP
    Entry..... None
    Exit...... A=VDP Status Register contents
    Modifies.. A

Standard routine to input the contents of the VDP Status Register by reading the Command Port. Note that reading the VDP Status Register will clear the associated flags and may affect the interrupt handler.

<a name="rslreg"></a>

    Address... 144CH
    Name...... RSLREG
    Entry..... None
    Exit...... A=Primary Slot Register contents
    Modifies.. A

Standard routine to input the contents of the Primary slot Register by reading PPI Port A.

<a name="wslreg"></a>

    Address... 144FH
    Name...... WSLREG
    Entry..... A=Value to write
    Exit...... None
    Modifies.. None

Standard routine to set the Primary Slot Register by writing to PPI Port A.

<a name="snsmat"></a>

    Address... 1452H
    Name...... SNSMAT
    Entry..... A=Keyboard row number
    Exit...... A=Column data of keyboard row
    Modifies.. AF, C, EI

Standard routine to read a complete row of the keyboard matrix. PPI Port C is read in then written back with the row number occupying the four Keyboard Row Select bits. PPI Port B is then read into register A to return the eight column inputs.  The four miscellaneous control outputs of PPI Port C are unaffected by this routine.

<a name="isflio"></a>

    Address... 145FH
    Name...... ISFLIO
    Entry..... None
    Exit...... Flag NZ if file I/O active
    Modifies.. AF

Standard routine to check whether the BASIC Interpreter is currently directing its input or output via an I/O buffer. This is determined by examining PTRFIL. It is normally zero but will contain a buffer FCB (File Control Block) address while statements such as "PRINT#1", "INPUT#1", etc. are being executed by the Interpreter.

<a name="dcompr"></a>

    Address... 146AH
    Name...... DCOMPR
    Entry..... HL, DE
    Exit...... Flag NC if HL>DE, Flag Z if HL=DE, Flag C if HL<DE
    Modifies.. AF

Standard routine used by the BASIC Interpreter to check the relative values of register pairs HL and DE.

<a name="getvcp"></a>

    Address... 1470H
    Name...... GETVCP
    Entry..... A=Voice number (0, 1, 2)
    Exit...... HL=Address in voice buffer
    Modifies.. AF, HL

Standard routine to return the address of byte 2 in the specified voice buffer (VCBA, VCBB or VCBC).

<a name="getvc2"></a>

    Address... 1474H
    Name...... GETVC2
    Entry..... L=Byte number (0 to 36)
    Exit...... HL=Address in voice buffer
    Modifies.. AF, HL

Standard routine to return the address of any byte in the voice buffer (VCBA, VCBB or VCBC) specified by the voice number in VOICEN.

<a name="phydio"></a>

    Address... 148AH
    Name...... PHYDIO
    Entry..... None
    Exit...... None
    Modifies.. None

Standard routine for use by Disk BASIC, simply returns on standard MSX machines.

<a name="format"></a>

    Address... 148EH
    Name...... FORMAT
    Entry..... None
    Exit...... None
    Modifies.. None

Standard routine for use by Disk BASIC, simply returns on standard MSX machines.

<a name="putq"></a>

    Address... 1492H
    Name...... PUTQ
    Entry..... A=Queue number, E=Data byte
    Exit...... Flag Z if queue full
    Modifies.. AF, BC, HL

Standard routine to place a data byte in one of the three music queues. The queue's get and put positions are first taken from QUETAB (14FAH). The put position is temporarily incremented and compared with the get position, if they are equal the routine terminates as the queue is full. Otherwise the queue's address is taken from QUETAB and the put position added to it. The data byte is placed at this location in the queue, the put position is incremented and the routine terminates. Note that the music queues are circular, if the get or put pointers reach the last position in the queue they wrap around back to the start.

    Address... 14ADH

This routine is used by the interrupt handler to read a byte from one of the three music queues. The queue number is supplied in register A, the data byte is returned in register A and the routine returns Flag Z if the queue is empty. The queue's get and put positions are first taken from QUETAB (14FAH). If the putback flag is active then the data byte is taken from QUEBAK and the routine terminates (14D1H), this facility is unused in the current versions of the MSX ROM. The put position is then compared with the get position, if they are equal the routine terminates as the queue is empty.  Otherwise the queue's address is taken from QUETAB and the get position added to it. The data byte is read from this location in the queue, the get position is incremented and the routine terminates.

    Address... 14DAH

This routine is used by the GICINI standard routine to initialize a queue's control block in QUETAB. The control block is first located in QUETAB (1504H) and the put, get and putback bytes zeroed. The size byte is set from register B and the queue address from register pair DE.

<a name="lftq"></a>

    Address... 14EBH
    Name...... LFTQ
    Entry..... A=Queue number
    Exit...... HL=Free space left in queue
    Modifies.. AF, BC, HL

Standard routine to return the number of free bytes left in a music queue. The queue's get and put positions are taken from QUETAB (14FAH) and the free space determined by subtracting put from get.

    Address... 14FAH

This routine returns a queue's control parameters from QUETAB, the queue number is supplied in register A. The control block is first located in QUETAB (1504H), the put position is then placed in register B, the get position in register C and the putback flag in register A.

    Address... 1504H

This routine locates a queue's control block in QUETAB. The queue number is supplied in register A and the control block address returned in register pair HL. The queue number is simply multiplied by six, as there are six bytes per block, and added to the address of QUETAB as held in QUEUES.

<a name="grpprt"></a>

    Address... 1510H
    Name...... GRPPRT
    Entry..... A=Character
    Exit...... None
    Modifies.. EI

Standard routine to display a character on the screen in either Graphics Mode or Multicolour Mode, it is functionally equivalent to the CHPUT standard routine.

The CNVCHR standard routine is first used to check for a graphic character, if the character is a header code (01H) then the routine terminates with no action. If the character is a converted graphic one then the control code decoding section is skipped. Otherwise the character is checked to see if it is a control code. Only the CR code (0DH) is recognized (157EH), all other characters smaller than 20H are ignored.

Assuming the character is displayable its eight byte pixel pattern is copied from the ROM character set into the PATWRK buffer (0752H) and FORCLR copied to ATRBYT to set its colour.  The current graphics coordinates are then taken from GRPACX and GRPACY and used to set the current pixel physical address via the SCALXY and MAPXYC standard routines.

The eight byte pattern in PATWRK is processed a byte at a time. At the start of each byte the current pixel physical address is obtained via the FETCHC standard routine and saved.  The eight bits are then examined in turn. If the bit is a 1 the associated pixel is set by the SETC standard routine, if it is a 0 no action is taken. After each bit the current pixel physical address is moved right (16ACH). When the byte is finished, or the right hand edge of the screen is reached, the initial current pixel physical address is restored and moved down one position by the TDOWNC standard routine.

When the pattern is complete, or the bottom of the screen has been reached, GRPACX is updated. In Graphics Mode its value is increased by eight, in Multicolour Mode by thirty-two. If GRPACX then exceeds 255, the right hand edge of the screen, a CR operation is performed (157EH).

    Address... 157EH

This routine performs the CR operation for the GRPPRT standard routine, this code functions as a combined CR,LF.  GRPACX is zeroed and eight or thirty-two, depending on the screen mode, added to GRPACY. If GRPACY then exceeds 191, the bottom of the screen, it is set to zero.

GRPACX and GRPACY may be manipulated directly by an application program to compensate for the limited number of control functions available.

<a name="scalxy"></a>

    Address... 1599B
    Name...... SCALXY
    Entry..... BC=X coordinate, DE=Y coordinate
    Exit...... Flag NC if clipped
    Modifies.. AF

Standard routine to clip a pair of graphics coordinates if necessary. The BASIC Interpreter can produce coordinates in the range -32768 to +32767 even though this far exceeds the actual screen size. This routine modifies excessive coordinate values to fit within the physically realizable range. If the X coordinate is greater than 255 it is set to 255, if the Y coordinate is greater than 191 it is set to 191. If either coordinate is negative (greater than 7FFFH) it is set to zero.  Finally if the screen is in Multicolour Mode both coordinates are divided by four as required by the MAPXYC standard routine.

    Address... 15D9H

This routine is used to check the current screen mode, it returns Flag Z if the screen is in Graphics Mode.

<a name="mapxyc"></a>

    Address... 15DFH
    Name...... MAPXYC
    Entry..... BC=X coordinate, DE=Y coordinate
    Exit...... None
    Modifies.. AF, D, HL

Standard routine to convert a graphics coordinate pair into the current pixel physical address. The location in the Character Pattern Table of the byte containing the pixel is placed in CLOC. The bit mask identifying the pixel within that byte is placed in CMASK. Slightly different conversion methods are used for Graphics Mode and Multicolour Mode, equivalent programs in BASIC are:

    Graphics Mode
    
    10 INPUT"X,Y Coordinates";X,Y
    20 A=(Y\8)*256+(Y AND 7)+(X AND &HF8)
    30 PRINT"ADDR=";HEX$(Base(12)+A);"H ";
    40 RESTORE 100
    50 FOR N=0 TO (X AND 7):READ M$: NEXT N
    60 PRINT"MASK=";M$
    70 GOTO 10
    100 DATA 10000000
    110 DATA 01000000
    120 DATA 00100000
    130 DATA 00010000
    140 DATA 00001000
    150 DATA 00000100
    160 DATA 00000010
    170 DATA 00000001
    
    Multicolour Mode
    
    10 INPUT"X,Y Coordinates";X,Y
    20 X=X\4:Y-Y\4
    30 A=(Y\8)*256+(Y AND 7)+(X*4 AND &HF8)
    40 PRINT"ADDR=";HEX$(BASE(17)+A);"H ";
    50 IF X MOD 2=0 THEN MS="11110000" ELSE MS="00001111"
    60 PRINT"MASK=";M$
    70 GOTO 10

The allowable input range for both programs is X=0 to 255 and Y=0 to 191. The data statements in the Graphics Mode program correspond to the eight byte mask table commencing at 160BH in the MSX ROM. Line 20 in the Multicolour Mode program actually corresponds to the division by four in the SCALXY standard routine. It is included to make the coordinate system consistent for both programs.

<a name="fetchc"></a>

    Address... 1639H
    Name...... FETCHC
    Entry..... None
    Exit...... A=CMASK, HL=CLOC
    Modifies.. A, HL

Standard routine to return the current pixel physical address, register pair HL is loaded from CLOC and register A from CMASK.

<a name="storec"></a>

    Address... 1640H
    Name...... STOREC
    Entry..... A=CMASK, HL=CLOC
    Exit...... None
    Modifies.. None

Standard routine to set the current pixel physical address, register pair HL is copied to CLOC and register A is copied to CMASK.

<a name="readc"></a>

    Address... 1647H
    Name...... READC
    Entry..... None
    Exit...... A=Colour code of current pixel
    Modifies.. AF, EI

Standard routine to return the colour of the current pixel.  The VRAM physical address is first obtained via the FETCHC standard routine. If the screen is in Graphics Mode the byte pointed to by CLOC is read from the Character Pattern Table via the RDVRM standard routine. The required bit is then isolated by CMASK and used to select either the upper or lower four bits of the corresponding entry in the Colour Table.

If the screen is in Multicolour Mode the byte pointed to by CLOC is read from the Character Pattern Table via the RDVRM standard routine. CMASK is then used to select either the upper or lower four bits of this byte. The value returned in either case will be a normal VDP colour code from zero to fifteen.

<a name="setatr"></a>

    Address... 1676H
    Name...... SETATR
    Entry..... A=Colour code
    Exit...... Flag C if illegal code
    Modifies.. Flags

Standard routine to set the graphics ink colour used by the SETC and NSETCX standard routines. The colour code, from zero to fifteen, is simply placed in ATRBYT.

<a name="setc"></a>

    Address... 167EH
    Name...... SETC
    Entry..... None
    Exit...... None
    Modifies.. AF, EI

Standard routine to set the current pixel to any colour, the colour code is taken from ATRBYT. The pixel's VRAM physical address is first obtained via the FETCHC standard routine. In Graphics Mode both the Character Pattern Table and Colour Table are then modified (186CH).

In Multicolour Mode the byte pointed to by CLOC is read from the Character Pattern Table by the RDVRM standard routine. The contents of ATRBYT are then placed in the upper or lower four bits, as determined by CMASK, and the byte written back via the WRTVRM standard routine

    Address... 16ACH

This routine moves the current pixel physical address one position right. If the right hand edge of the screen is exceeded it returns with Flag C and the physical address is unchanged. In Graphics Mode CMASK is first shifted one bit right, if the pixel still remains within the byte the routine terminates. If CLOC is at the rightmost character cell (LSB=F8H to FFH) then the routine terminates with Flag C (175AH).  Otherwise CMASK is set to 80H, the leftmost pixel, and 0008H added to CLOC.

In Multicolour Mode control transfers to a separate routine (1779H).

<a name="rightc"></a>

    Address... 16C5H
    Name...... RIGHTC
    Entry..... None
    Exit...... None
    Modifies.. AF

Standard routine to move the current pixel physical address one position right. In Graphics Mode CMASK is first shifted one bit right, if the pixel still remains within the byte the routine terminates. Otherwise CMASK is set to 80H, the leftmost pixel, and 0008H added to CLOC. Note that incorrect addresses will be produced if the right hand edge of the screen is exceeded.

In Multicolour Mode control transfers to a separate routine (178BH).

    Address... 16D8H

This routine moves the current pixel physical address one position left. If the left hand edge of the screen is exceeded it returns Flag C and the physical address is unchanged. In Graphics Mode CMASK is first shifted one bit left, if the pixel still remains within the byte the routine terminates. If CLOC is at the leftmost character cell (LSB=00H to 07H) then the routine terminates with Flag C (175AH). Otherwise CMASK is set to 01H, the rightmost pixel, and 0008H subtracted from CLOC.

In Multicolour Mode control transfers to a separate routine (179CH).

<a name="leftc"></a>

    Address... 16EEH
    Name...... LEFTC
    Entry..... None
    Exit...... None
    Modifies.. AF

Standard routine to move the current pixel physical address one position left. In Graphics Mode CMASK is first shifted one bit left, if the pixel still remains within the byte the routine terminates. Otherwise CMASK is set to 01H, the leftmost pixel, and 0008H subtracted from CLOC. Note that incorrect addresses will be produced if the left hand edge of the screen is exceeded.

In Multicolour Mode control transfers to a separate routine (17ACH).

<a name="tdownc"></a>

    Address... 170AH
    Name...... TDOWNC
    Entry..... None
    Exit...... Flag C if off screen
    Modifies.. AF

Standard routine to move the current pixel physical address one position down. If the bottom edge of the screen is exceeded it returns Flag C and the physical address is unchanged. In Graphics Mode CLOC is first incremented, if it still remains within an eight byte boundary the routine terminates. If CLOC was in the bottom character row (CLOC>=1700H) then the routine terminates with Flag C (1759H). Otherwise 00F8H is added to CLOC.

In Multicolour Mode control transfers to a separate routine (17C6H).

<a name="downc"></a>

    Address... 172AH
    Name...... DOWNC
    Entry..... None
    Exit...... None
    Modifies.. AF

Standard routine to move the current pixel physical address one position down. In Graphics Mode CLOC is first incremented, if it still remains within an eight byte boundary the routine terminates. Otherwise 00F8H is added to CLOC. Note that incorrect addresses will be produced if the bottom edge of the screen is exceeded.

In Multicolour Mode control transfers to a separate routine (17DCH).

<a name="tupc"></a>

    Address... 173CH
    Name...... TUPC
    Entry..... None
    Exit...... Flag C if off screen
    Modifies.. AF

Standard routine to move the current pixel physical address one position up. If the top edge of the screen is exceeded it returns with Flag C and the physical address is unchanged. In Graphics Mode CLOC is first decremented, if it still remains within an eight byte boundary the routine terminates. If CLOC was in the top character row (CLOC<0100H) then the routine terminates with Flag C. Otherwise 00F8H is subtracted from CLOC.

In Multicolour Mode control transfers to a separate routine (17E3H).

<a name="upc"></a>

    Address... 175DH
    Name...... UPC
    Entry..... None
    Exit...... None
    Modifies.. AF

Standard routine to move the current pixel physical address one position up. In Graphics Mode CLOC is first decremented, if it still remains within an eight byte boundary the routine terminates. Otherwise 00F8H is subtracted from CLOC. Note that incorrect addresses will be produced if the top edge of the screen is exceeded.

In Multicolour Mode control transfers to a separate routine (17F8H).

    Address... 1779H

This is the Multicolour Mode version of the routine at 16ACH. It is identical to the Graphics Mode version except that CMASK is shifted four bit positions right and becomes F0H if a cell boundary is crossed.

    Address... 178BH

This is the Multicolour Mode version of the RIGHTC standard routine. It is identical to the Graphics Mode version except that CMASK is shifted four bit positions right and becomes F0H if a cell boundary is crossed.

    Address... 179CH

This is the Multicolour Mode version of the routine at 16D8H. It is identical to the Graphics Mode version except that CMASK is shifted four bit positions left and becomes 0FH if a cell boundary is crossed.

    Address... 17ACH

This is the Multicolour Mode version of the LEFTC standard routine. It is identical to the Graphics Mode version except that CMASK is shifted four bit positions left and becomes 0FH if a cell boundary is crossed.

    Address... 17C6H

This is the Multicolour Mode version of the TDOWNC standard routine. It is identical to the Graphics Mode version except that the bottom boundary address is 0500H instead of 1700H.  There is a bug in this routine which will cause it to behave unpredictably if MLTCGP, the Character Pattern Table base address, is changed from its normal value of zero. There should be an EX DE,HL instruction inserted at address 17CEH.

If the Character Pattern Table base is increased the routine will think it has reached the bottom of the screen when it actually has not. This routine is used by the "PAINT" statement so the following demonstrates the fault:

    10 BASE(17)=&H1000
    20 SCREEN 3
    30 PSET(200,0)
    40 DRAW"D180L100U180R100"
    50 PAINT(150,90)
    60 GOTO 60

    Address... 17DCH

This is the Multicolour Mode version of the DOWNC standard routine, it is identical to the Graphics Mode version.

    Address... 17E3H

This is the Multicolour Mode version of the TUPC standard routine. It is identical to the Graphics Mode version except that is has a bug as above, this time there should be an EX DE,HL instruction at address 17EBH.

If the Character Pattern Table base address is increased the routine will think it is within the table when it has actually exceeded the top edge of the screen. This may be demonstrated by removing the "R100" part of Line 40 in the previous program.

    Address... 17F8H

This is the Multicolour Mode version of the UPC standard routine, it is identical to the Graphics Mode version.

<a name="nsetcx"></a>

    Address... 1809H
    Name...... NSETCX
    Entry..... HL=Pixel fill count
    Exit...... None
    Modifies.. AF, BC, DE, HL, EI

Standard routine to set the colour of multiple pixels horizontally rightwards from the current pixel physical address. Although its function can be duplicated by the SETC and RIGHTC standard routines this would result in significantly slower operation. The supplied pixel count should be chosen so that the right-hand edge of the screen is not passed as this will produce anomalous behaviour. The current pixel physical address is unchanged by this routine.

In Graphics Mode CMASK is first examined to determine the number of pixels to the right within the current character cell. Assuming the fill count is large enough these are then set (186CH). The remaining fill count is divided by eight to determine the number of whole character cells. Successive bytes in the Character Pattern Table are then zeroed and the corresponding bytes in the Colour Table set from ATRBYT to fill these whole cells. The remaining fill count is then converted to a bit mask, using the seven byte table at 185DH, and these pixels are set (186CH).

In Multicolour Mode control transfers to a separate routine (18BBH).

    Address... 186CH

This routine sets up to eight pixels within a cell to a specified colour in Graphics Mode. ATRBYT contains the colour code, register pair HL the address of the relevant byte in the Character Pattern Table and register A a bit mask, 11100000 for example, where every 1 specifies a bit to be set.

If ATRBYT matches the existing 1 pixel colour in the corresponding Colour Table byte then each specified bit is set to 1 in the Character Pattern Table byte. If ATRBYT matches the existing 0 pixel colour in the corresponding Colour Table byte then each specified bit is set to 0 in the Character Pattern Table byte.

If ATRBYT does not match either of the existing colours in the Colour Table Byte then normally each specified bit is set to 1 in the Character Pattern Table byte and the 1 pixel colour changed in the Colour Table byte. However if this would result in all bits being set to 1 in the Character Pattern Table byte then each specified bit is set to 0 and the 0 pixel colour changed in the Colour Table byte.

    Address... 18BBH

This is the Multicolour Mode version of the NSETCX standard routine. The SETC and RIGHTC standard routines are called until the fill count is exhausted. Speed of operation is not so important in Multicolour Mode because of the lower screen resolution and the consequent reduction in the number of operations required.

<a name="gtaspc"></a>

    Address... 18C7H
    Name...... GTASPC
    Entry..... None
    Exit...... DE=ASPCT1, HL=ASPCT2
    Modifies.. DE, HL

Standard routine to return the "CIRCLE" statement default aspect ratios.

<a name="pntini"></a>

    Address... 18CFH
    Name...... PNTINI
    Entry..... A=Boundary colour (0 to 15)
    Exit...... Flag C if illegal colour
    Modifies.. AF

Standard routine to set the boundary colour for the "PAINT" statement. In Multicolour Mode the supplied colour code is placed in BDRATR. In Graphics Mode BDRATR is copied from ATRBYT as it is not possible to have separate paint and boundary colours.

<a name="scanr"></a>

    Address... 18E4H
    Name...... SCANR
    Entry..... B=Fill switch, DE=Skip count
    Exit...... DE=Skip remainder, HL=Pixel count
    Modifies.. AF, BC, DE, HL, EI

Standard routine used by the "PAINT" statement handler to search rightwards from the current pixel physical address until a colour code equal to BDRATR is found or the edge of the screen is reached. The terminating position becomes the current pixel physical address and the initial position is returned in CSAVEA and CSAVEM. The size of the traversed region is returned in register pair HL and FILNAM+1. The traversed region is normally filled in but this can be inhibited, in Graphics Mode only, by using an entry parameter of zero in register B. The skip count in register pair DE determines the maximum number of pixels of the required colour that may be ignored from the initial starting position. This facility is used by the "PAINT" statement handler to search for gaps in a horizontal boundary blocking its upward progress.

<a name="scanl"></a>

    Address... 197AH
    Name...... SCANL
    Entry..... None
    Exit...... HL=Pixel count
    Modifies.. AF, BC, DE, HL, EI

Standard routine to search leftwards from the current pixel physical address until a colour code equal to BDRATR is found or the edge of the screen is reached. The terminating position becomes the current pixel physical address and the size of the traversed region is returned in register pair HL. The traversed region is always filled in.

    Address... 19C7H

This routine is used by the SCANL and SCANR standard routines to check the current pixel's colour against the boundary colour in BDRATR.

<a name="tapoof"></a>

    Address... 19DDH
    Name...... TAPOOF
    Entry..... None
    Exit...... None
    Modifies.. EI

Standard routine to stop the cassette motor after data has been written to the cassette. After a delay of 550 ms, on MSX machines with one wait state, control drops into the TAPIOF standard routine.

<a name="tapiof"></a>

    Address... 19E9H
    Name...... TAPIOF
    Entry..... None
    Exit...... None
    Modifies.. EI

Standard routine to stop the cassette motor after data has been read from the cassette. The motor relay is opened via the PPI Mode Port. Note that interrupts, which must be disabled during cassette data transfers for timing reasons, are enabled as this routine terminates.

<a name="tapoon"></a>

    Address... 19F1H
    Name...... TAPOON
    Entry..... A=Header length switch
    Exit...... Flag C if CTRL-STOP termination
    Modifies.. AF, BC, HL, DI

Standard routine to turn the cassette motor on, wait 550 ms for the tape to come up to speed and then write a header to the cassette. A header is a burst of HI cycles written in front of every data block so the baud rate can be determined when the data is read back.

The length of the header is determined by the contents of register A: 00H=Short header, NZ=Long header. The BASIC cassette statements "SAVE", "CSAVE" and "BSAVE" all generate a long header at the start of the file, in front of the identification block, and thereafter use short headers between data blocks. The number of cycles in the header is also modified by the current baud rate so as to keep its duration constant:

    1200 Baud SHORT ... 3840 Cycles ... 1.5 Seconds
    1200 Baud LONG ... 15360 Cycles ... 6.1 Seconds
    2400 Baud SHORT ... 7936 Cycles ... 1.6 Seconds
    2400 Baud LONG ... 31744 Cycles ... 6.3 Seconds

After the motor has been turned on and the delay has expired the contents of HEADER are multiplied by two hundred and fifty- six and, if register A is non-zero, by a further factor of four to produce the cycle count. HI cycles are then generated (1A4DH) until the count is exhausted whereupon control transfers to the BREAKX standard routine. Because the CTRL-STOP key is only examined at termination it is impossible to break out part way through this routine.

<a name="tapout"></a>

    Address... 1A19H
    Name...... TAPOUT
    Entry..... A=Data byte
    Exit...... Flag C if CTRL-STOP termination
    Modifies.. AF, B, HL

Standard routine to write a single byte of data to the cassette. The MSX ROM uses a software driven FSK (Frequency Shift Keyed) method for storing information on the cassette. At the 1200 baud rate this is identical to the Kansas City Standard used by the BBC for the distribution of BASICODE programs.

At 1200 baud each 0 bit is written as one complete 1200 Hz LO cycle and each 1 bit as two complete 2400 Hz HI cycles. The data rate is thus constant as 0 and 1 bits have the same duration.  When the 2400 baud rate is selected the two frequencies change to 2400 Hz and 4800 Hz but the format is otherwise unchanged.

A byte of data is written with a 0 start bit (1A50H), eight data bits with the least significant bit first, and two 1 stop bits (1A40H). At the 1200 baud rate a single byte will have a nominal duration of 11 x 833 µs = 9.2 ms. After the stop bits have been written control transfers to the BREAKX standard routine to check the CTRL-STOP key. The byte 43H is shown below as it would be written to cassette:

<a name="figure39b"></a>![][CH04F39b]

**Figure 39:** Cassette Data Byte

It is important not to leave too long an interval between bytes when writing data as this will increase the error rate. An inter-byte gap of 80 µs, for example, produces a read failure rate of approximately twelve percent. If a substantial amount of processing is required between each byte then buffering should be used to lump data into headered blocks. The BASIC "SAVE" format is of this type.

    Address... 1A39H

This routine writes a single LO cycle with a length of approximately 816 µs to the cassette. The length of each half of the cycle is taken from LOW and control transfers to the general cycle generator (1A50H).

    Address... 1A40H

This routine writes two HI cycles to the cassette. The first cycle is generated (1A4DH) followed by a 17 µs delay and then the second cycle (1A4DH).

    Address... 1A4DH

This routine writes a single HI cycle with a length of approximately 396 µs to the cassette. The length of each half of the cycle is taken from HIGH and control drops into the general cycle generator.

    Address... 1A50H

This routine writes a single cycle to the cassette. The length of the cycle's first half is supplied in register L and its second half in register H. The first length is counted down and then the Cas Out bit set via the PPI Mode Port. The second length is counted down and the Cas Out bit reset.

On all MSX machines the Z80 runs at a clock frequency of 3.579545 MHz (280 ns) with one wait state during the M1 cycle. As this routine counts every 16T states each unit increment in the length count represents a period of 4.47 µs. There is also a fixed overhead of 20.7 µs associated with the routine whatever the length count.

<a name="tapion"></a>

    Address... 1A63H
    Name...... TAPION
    Entry..... None
    Exit...... Flag C if CTRL-STOP termination
    Modifies.. AF, BC, DE, HL, DI

Standard routine to turn the cassette motor on, read the cassette until a header is found and then determine the baud rate. Successive cycles are read from the cassette and the length of each one measured (1B34H). When 1,111 cycles have been found with less than 35 µs variation in their lengths a header has been located.

The next 256 cycles are then read (1B34H) and averaged to determine the cassette HI cycle length. This figure is multiplied by 1.5 and placed in LOWLIM where it defines the minimum acceptable length of a 0 start bit. The HI cycle length is placed in WINWID and will be used to discriminate between LO and HI cycles.

<a name="tapin"></a>

    Address... 1ABCH
    Name...... TAPIN
    Entry..... None
    Exit...... A=Byte read, Flag C if CTRL-STOP or I/O error
    Modifies.. AF, BC, DE, L

Standard routine to read a byte of data from the cassette.  The cassette is first read continuously until a start bit is found. This is done by locating a negative transition, measuring the following cycle length (1B1FH) and comparing this to see if it is greater than LOWLIM.

Each of the eight data bits is then read by counting the number of transitions within a fixed period of time (1B03H). If zero or one transitions are found it is a 0 bit, if two or three are found it is a 1 bit. If more than three transitions are found the routine terminates with Flag C as this is presumed to be a hardware error of some sort. After the value of each bit has been determined a further one or two transitions are read (1B23H) to retain synchronization. With an odd transition count one more will be read, with an even transition count two more.

    Address... 1B03H

This routine is used by the TAPIN standard routine to count the number of cassette transitions within a fixed period of time. The window duration is contained in WINWID and is approximately 1.5 times the length of a HI cycle as shown below:

<a name="figure40"></a>![][CH04F40]

**Figure 40:** Cassette Window

The Cas Input bit is continuously sampled via PSG Register 14 and compared with the previous reading held in register E. Each time a change of state is found register C is incremented. The sampling rate is once every 17.3 µs so the value in WINWID, which was determined by the TAPION standard routine with a count rate of 11.45 µs, is effectively multiplied one and a half times.

    Address... 1B1FH

This routine measures the time to the next cassette input transition. The Cassette Input bit is continuously sampled via PSG Register 14 until it changes from the state supplied in register E. The state flag is then inverted and the duration count returned in register C, each unit increment represents a period of 11.45 µs.

    Address... 1B34H

This routine measures the length of a complete cassette cycle from negative transition to negative transition. The Cassette Input bit is sampled via PSG Register 14 until it goes to zero. The transition flag in register E is set to zero and the time to the positive transition measured (1B23H). The time to the negative transition is then measured (1B25H) and the total returned in register C.

<a name="outdo"></a>

    Address... 1B45H
    Name...... OUTDO
    Entry..... A=Character to output
    Exit...... None
    Modifies.. EI

Standard routine used by the BASIC Interpreter to output a character to the current device. The ISFLIO standard routine is first used to check whether output is currently directed to an I/O buffer, if so control transfers to the sequential output driver (6C48H) via the CALBAS standard routine. If PRTFLG is zero control transfers to the CHPUT standard routine to output the character to the screen. Assuming the printer is active RAWPRT is checked. If this is non-zero the character is passed directly to the printer (1BABH), otherwise control drops into the OUTDLP standard routine.

<a name="outdlp"></a>

    Address... 1B63H
    Name...... OUTDLP
    Entry..... A=Character to output
    Exit...... None
    Modifies.. EI

Standard routine to output a character to the printer. If the character is a TAB code (09H) spaces are issued to the OUTDLP standard routine until LPTPOS is a multiple of eight (0, 8, 16 etc.). If the character is a CR code (0DH) LPTPOS is zeroed if it is any other control code LPTPOS is unaffected, if it is a displayable character LPTPOS is incremented.

If NTMSXP is zero, meaning an MSX-specific printer is connected, the character is passed directly to the printer (1BABH). Assuming a normal printer is connected the CNVCHR standard routine is used to check for graphic characters. If the character is a header code (01H) the routine terminates with no action. If it is a converted graphic character it is replaced by a space, all other characters are passed to the printer (1BACH).

    Address... 1B97H

This twenty byte table is used by the keyboard decoder to find the correct routine for a given key number:

        KEY NUMBER  TO     FUNCTION
        ---------------------------------------
        00H to 2FH  0F83H  Rows 0 to 5
        30H to 32H  0F10H  SHIFT, CTRL, GRAPH
        33H         0F36H  CAP
        34H         0F10H  CODE
        35H to 39H  0FC3H  F1 to F5
        3AH to 3BH  0F10H  ESC, TAB
        3CH         0F46H  STOP
        3DH to 40H  0F10H  BS, CR, SEL, SPACE
        41H         0F06H  HOME
        42H to 57H  0F10H  INS, DEL, CURSOR

    Address... 1BABH

This routine is used by the OUTDLP standard routine to pass a character to the printer. It is sent via the LPTOUT standard routine, if this returns Flag C control transfers to the "Device I/O error" generator (73B2H) via the CALBAS standard routine.

    Address... 1BBFH

The following 2 KB contains the power-up character set. The first eight bytes contain the pattern for character code 00H, the second eight bytes the pattern for character code 01H and so on to character code FFH.

<a name="pinlin"></a>

    Address... 23BFH
    Name...... PINLIN
    Entry..... None
    Exit...... HL=Start of text, Flag C if CTRL-STOP termination
    Modifies.. AF, BC, DE, HL, EI

Standard routine used by the BASIC Interpreter Mainloop to collect a logical line of text from the console. Control transfers to the INLIN standard routine just after the point where the previous line has been cut (23E0H).

<a name="qinlin"></a>

    Address... 23CCH
    Name...... QINLIN
    Entry..... None
    Exit...... HL=Start of text, Flag C if CTRL-STOP termination
    Modifies.. AF, BC, DE, HL, EI

Standard routine used by the "INPUT" statement handler to collect a logical line of text from the console. The characters "? " are displayed via the OUTDO standard routine and control drops into the INLIN standard routine.

<a name="inlin"></a>

    Address... 23D5H
    Name...... INLIN
    Entry..... None
    Exit...... HL=Start of text, Flag C if CTRL-STOP termination
    Modifies.. AF, BC, DE, HL, EI

Standard routine used by the "LINE INPUT" statement handler to collect a logical line of text from the console. Characters are read from the keyboard until either the CR or CTRL-STOP keys are pressed. The logical line is then read from the screen character by character and placed in the Workspace Area text buffer BUF.

The current screen coordinates are first taken from CSRX and CSRY and placed in FSTPOS. The screen row immediately above the current one then has its entry in LINTTB made non-zero (0C29H) to stop it extending logically into the current row.

Each keyboard character read via the CHGET standard routine is checked (0919H) against the editing key table at 2439H.  Control then transfers to one of the editing routines or to the default key handler (23FFH) as appropriate. This process continues until Flag C is returned by the CTRL-STOP or CR routines. Register pair HL is then set to point to the start of BUF and the routine terminates. Note that the carry, flag is cleared when Flag NZ is also returned to distinguish between a CR or protected CTRL-STOP termination and a normal CTRL-STOP termination.

    Address... 23FFH

This routine processes all characters for the INLIN standard routine except the special editing keys. If the character is a TAB code (09H) spaces are issued (23FFH) until CSRX is a multiple of eight plus one (columns 1, 9, 17, 25, 33). If the character is a graphic header code (01H) it is simply echoed to the OUTDO standard routine. All other control codes smaller than 20H are echoed to the OUTDO standard routine after which INSFLG and CSTYLE are zeroed. For the displayable characters INSFLG is first checked and a space inserted (24F2H) if applicable before the character is echoed to the OUTDO standard routine.

    Address... 2439H

This table contains the special editing keys recognized by the INLIN standard routine together with the relevant addresses:

        CODE TO    FUNCTION
        --------------------------------------------
        08H  2561H BS, backspace
        12H  24E5H INS, toggle insert mode
        1BH  23FEH ESC, no action
        02H  260EH CTRL-B, previous word
        06H  25F8H CTRL-F, next word
        0EH  25D7H CTRL-N, end of logical line
        05H  25B9H CTRL-E, clear to end of line
        03H  24C5H CTRL-STOP, terminate
        0DH  245AH CR, terminate
        15H  25AEH CTRL-U, clear line
        7FH  2550H DEL, delete character

    Address... 245AH

This routine performs the CR operation for the INLIN standard routine. The starting coordinates of the logical line are found (266CH) and the cursor removed from the screen (0A2EH). Up to 254 characters are then read from the VDP VRAM (0BD8H) and placed in BUF. Any null codes (00H) are ignored, any characters smaller than 20H are replaced by a graphic header code (01H) and the character itself with 40H added. As the end of each physical row is reached LINTTB is checked (0C1DH) to see whether the logical line extends to the next physical row. Trailing spaces are then stripped from BUF and a zero byte added as an end of text marker. The cursor is restored to the screen (09E1H) and its coordinates set to the last physical row of the logical line via the POSIT standard routine. A LF code is issued to the OUTDO standard routine, INSFLG is zeroed and the routine terminates with a CR code (0DH) in register A and Flag NZ,C. This CR code will be echoed to the screen by the INLIN standard routine mainloop just before it terminates.

    Address... 24C5H

This routine performs the CTRL-STOP operation for the INLIN standard routine. The last physical row of the logical line is found by examining LINTTB (0C1DH), CSTYLE is zeroed, a zero byte is placed at the start of BUF and all music variables are cleared via the GICINI standard routine. TRPTBL is then examined (0454H) to see if an "ON STOP" statement is active, if so the cursor is reset (24AFH) and the routine terminates with Flag NZ,C. BASROM is then checked to see whether a protected ROM is running, if so the cursor is reset (24AFH) and the routine terminates with Flag NZ,C. Otherwise the cursor is reset (24B2H) and the routine terminates with Flag Z,C.

    Address... 24E5H

This routine performs the INS operation for the INLIN standard routine. The current state of INSFLG is inverted and control terminates via the CSTYLE setting routine (242CH).

    Address... 24F2H

This routine inserts a space character for the default key section of the INLIN standard routine. The cursor is removed (0A2EH) and the current cursor coordinates taken from CSRX and CSRY. The character at this position is read from the VDP VRAM (0BD8H) and replaced with a space (0BE6H). Successive characters are then copied one column position to the right until the end of the physical row is reached.

At this point LINTTB is examined (0C1DH) to determine whether the logical line is extended, if so the process continues on the next physical row. Otherwise the character taken from the last column position is examined, if this is a space the routine terminates by replacing the cursor (09E1H).  Otherwise the physical row's entry in LINTTB is zeroed to indicate an extended logical line. The number of the next physical row is compared with the number of rows on the screen (0C32H). If the next row is the last one the screen is scrolled up (0A88H), otherwise a blank row is inserted (0AB7H) and the copying process continues.

    Address... 2550H

This routine performs the DEL operation for the INLIN standard routine. If the current cursor position is at the rightmost column and the logical line is not extended no action is taken other than to write a space to the VDP VRAM (2595H).  Otherwise a RIGHT code (1CH) is issued to the OUTDO standard routine and control drops into the BS routine.

    Address... 2561H

This routine performs the BS operation for the INLIN standard routine. The cursor is first removed (0A2EH) and the cursor column coordinate decremented unless it is at the leftmost position and the previous row is not extended.  Characters are then read from the VDP VRAM (0BD8H) and written back one position to the left (0BE6H) until the end of the logical line is reached. At this point a space is written to the VDP VRAM (0BE6H) and the cursor character is restored (09E1H).

    Address... 25AEH

This routine performs the CTRL-U operation for the INLIN standard routine. The cursor is removed (0A2EH) and the start of the logical line located (266CH) and placed in CSRX and CSRY. The entire logical line is then cleared (25BEH).

    Address... 25B9H

This routine performs the CTRL-E operation for the INLIN standard routine. The cursor is removed (0A2EH) and the remainder of the physical row cleared (0AEEH). This process is repeated for successive physical rows until the end of the logical line is found in LINTBB (0C1DH). The cursor is then restored (09E1H), INSFLG zeroed and CSTLYE reset to a block cursor (242DH).

    Address... 25D7H

This routine performs the CTRL-N operation for the INLIN standard routine. The cursor is removed (0A2EH) and the last physical row of the logical line found by examination of LINTTB (0C1DH). Starting at the rightmost column of this physical row characters are read from the VDP VRAM (0BD8H) until a non-space character is found. The cursor coordinates are then set one column to the right of this position (0A5BH) and the routine terminates by restoring the cursor (25CDH).

    Address... 25F8H

This routine performs the CTRL-F operation for the INLIN standard routine. The cursor is removed (0A2EH) and moved successively right (2624H) until a non-alphanumeric character is found. The cursor is then moved successively right (2624H) until an alphanumeric character is found. The routine terminates by restoring the cursor (25CDH).

    Address... 260EH

This routine performs the CTRL-B operation for the INLIN standard routine. The cursor is removed (0A2EH) and moved successively left (2634H) until an alphanumeric character is found. The cursor is then moved successively left (2634H) until a non-alphanumeric character is found and then moved one position right (0A5BH). The routine terminates by restoring the cursor (25CDH).

    Address... 2624H

This routine moves the cursor one position right (0A5BH), loads register D with the rightmost column number, register E with the bottom row number and then tests for an alphanumeric character at the cursor position (263DH).

    Address... 2634H

This routine moves the cursor one position left (0A4CH), loads register D with the leftmost column number and register E with the top row number. The current cursor coordinates are compared with these values and the routine terminates Flag Z if the cursor is at this position. Otherwise the character at this position is read from the VDP VRAM (0BD8H) and checked to see if it is alphanumeric. If so the routine terminates Flag NZ,C otherwise it terminates Flag NZ,NC.

The alphanumeric characters are the digits "0" to "9" and the letters "A" to "Z" and "a" to "z". Also included are the graphics characters 86H to 9FH and A6H to FFH, these were originally Japanese letters and should have been excluded during the conversion to the UK ROM.

    Address... 266CH

This routine finds the start of a logical line and returns its screen coordinates in register pair HL. Each physical row above the current one is checked via the LINTTB table (0C1DH) until a non-extended row is found. The row immediately below this on the screen is the start of the logical line and its row number is placed in register L. This is then compared with FSTPOS, which contains the row number when the INLIN standard routine was first entered, to see if the cursor is still on the same line. If so the column coordinate in register H is set to its initial position from FSTPOS. Otherwise register H is set to the leftmost position to return the whole line.

    Address...2680H, JP to power-up initialize routine (7C76H).
    Address...2683H, JP to the SYNCHR standard routine (558CH).
    Address...2686H, JP to the CHRGTR standard routine (4666H).
    Address...2689H, JP to the GETYPR standard routine (5597H).

[CH01F01]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH01F01.svg
[CH01F02]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH01F02.svg
[CH01F03]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH01F03.svg
[CH01F04]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH01F04.svg
[CH01F05]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH01F05.svg
[CH01F06]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH01F06.svg
[CH02F07]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH02F07.svg
[CH02F08]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH02F08.svg
[CH02F09]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH02F09.svg
[CH02F10]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH02F10.svg
[CH02F11]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH02F11.svg
[CH02F12]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH02F12.svg
[CH02F13]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH02F13.svg
[CH02F14]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH02F14.svg
[CH02F15]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH02F15.svg
[CH02F16]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH02F16.svg
[CH02F17]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH02F17.svg
[CH02F18]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH02F18.svg
[CH02F19]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH02F19.svg
[CH02F20]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH02F20.svg
[CH02F21]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH02F21.svg
[CH02F22]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH02F22.svg
[CH02F23]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH02F23.svg
[CH02F24]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH02F24.svg
[CH03F25]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH03F25.svg
[CH03F26]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH03F26.svg
[CH03F27]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH03F27.svg
[CH03F28]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH03F28.svg
[CH03F29]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH03F29.svg
[CH03F30]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH03F30.svg
[CH03F31]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH03F31.svg
[CH03F32]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH03F32.svg
[CH03F33]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH03F33.svg
[CH04F34]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH04F34.svg
[CH04F35]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH04F35.svg
[CH04F36]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH04F36.svg
[CH04F37]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH04F37.svg
[CH04F38]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH04F38.svg
[CH04F39a]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH04F39a.svg
[CH04F39b]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH04F39b.svg
[CH04F40]: https://rawgit.com/oraculo666/the_msx_red_book/master/images/CH04F40.svg
