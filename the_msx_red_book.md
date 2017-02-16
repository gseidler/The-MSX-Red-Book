#<a name="contents"></a>Contents

[Introduction](#introduction)

1. [Programmable Peripheral Interface](#chapter1)
2. [Video Display Processor](#chapter2)
3. [Programmable Sound Generator](#chapter3)
4. [ROM BIOS](#chapter4)
5. [ROM BASIC Interpreter](#chapter5)
6. [Memory Map](#chapter6)
7. [Machine Code Programs](#chapter7)

[Index](#index)

Contents Copyright 1985 Avalon Software  
Iver Lane, Cowley, Middx, UB8 2JD

MSX is a trademark of Microsoft Corp.  
Z80 is a trademark of Zilog Corp.  
ACADEMY is trademark of Alfred.

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


#<a name="chapter1"></a>1. Programmable Peripheral Interface

The 8255 PPI is a general purpose parallel interface device configured as three eight bit data ports, called A, B and C, and a mode port. It appears to the Z80 as four I/O ports through which the keyboard, the memory switching hardware, the cassette motor, the cassette output, the Caps Lock LED and the Key Click audio output can be controlled. Once the PPI has been initialized access to a particular piece of hardware just involves writing to or reading the relevant I/O port.

##<a name="ppiporta"></a>PPI Port A (I/O Port A8H)

<a name="figure1"></a>![][CH01F01]

**Figure 1:** Primary Slot Register

This output port, known as the Primary Slot Register in MSX terminology, is used to control the memory switching hardware.  The Z80 Microprocessor can only access 64 KB of memory directly.  This limitation is currently regarded as too restrictive and several of the newer personal computers employ methods to overcome it.

MSX machines can have multiple memory devices at the same address and the Z80 may switch in any one of them as required.  The processor address space is regarded as being duplicated "sideways" into four separate 64 KB areas, called Primary Slots 0 to 3, each of which receives its own slot select signal alongside the normal Z80 bus signals. The contents of the Primary Slot Register determine which slot select signal is active and therefore which Primary Slot is selected.

To increase flexibility each 16 KB "page" of the Z80 address space may be selected from a different Primary Slot. As shown in [Figure 1](#figure1) two bits of the Primary Slot Register are required to define the Primary Slot number for each page.

The first operation performed by the MSX ROM at power-up is to search through each slot for RAM in pages 2 and 3 (8000H to FFFFH). The Primary Slot Register is then set so that the relevant slots are selected thus making the RAM permanently available. The memory configuration of any MSX machine can be determined by displaying the Primary Slot Register setting with the BASIC statement:

`PRINT RIGHT$("0000000"+BIN$(INP(&HA8)),8)`

As an example "10100000" would be produced on a Toshiba HX10 where pages 3 and 2 (the RAM) both come from Primary Slot 2 and pages 1 and 0 (the MSX ROM) from Primary Slot 0. The MSX ROM must always be placed in Primary Slot 0 by a manufacturer as this is the slot selected by the hardware at power-up. Other memory devices, RAM and any additional ROM, may be placed in any slot by a manufacturer.

A typical UK machine will have one Primary Slot containing the MSX ROM, one containing 64 KB of RAM and two slots brought out to external connectors. Most Japanese machines have a cartridge type connector on each of these external slots but UK machines usually have one cartridge connector and one IDC connector.

##<a name="expanders"></a>Expanders

System memory can be increased to a theoretical maximum of sixteen 64 KB areas by using expander interfaces. An expander plugs into any Primary Slot to provide four 64 KB Secondary Slots, numbered 0 to 3, instead of one primary one. Each expander has its own local hardware, called a Secondary Slot Register, to select which of the Secondary Slots should appear in the Primary Slot. As before pages can be selected from different Secondary Slots.

<a name="figure2">![][CH01F02]

**Figure 2:** Secondary Slot Register

Each Secondary Slot Register, while actually being an eight bit read/write latch, is made to appear as memory location FFFFH of its Primary Slot by the expander hardware. In order to gain access to this location on a particular expander it will usually be necessary to first switch page 3 (C000H to FFFFH) of that Primary Slot into the processor address space. The Secondary Slot Register can then be modified and, if necessary, page 3 restored to its original Primary Slot setting. Accessing memory in expanders can become rather a convoluted process.

It is apparent that there must be some way of determining whether a Primary Slot contains ordinary RAM or an expander in order to access it properly. To achieve this the Secondary Slot Registers are designed to invert their contents when read back.  During the power-up RAM search memory location FFFFH of each Primary Slot is examined to determine whether it behaves normally or whether the slot contains an expander. The results of these tests are stored in the Workspace Area system resource map EXPTBL for later use. This is done at power-up because of the difficulty in performing tests when the Secondary Slot Registers actually contain live settings.

Memory switching is obviously an area demanding extra caution, particularly with the hierarchical mechanisms needed to control expanders. Care must be taken to avoid switching out the page in which a program is running or, if it is being used, the page containing the stack. There are a number of standard routines available to the machine code programmer in the BIOS section of the MSX ROM to simplify the process.

The BASIC Interpreter itself has four methods of accessing extension ROMs. The first three of these are for use with machine code ROMs placed in page 1 (4000H to 7FFFH), they are:

1. Hooks ([Chapter 6](#chapter6)).
2. The "[CALL](#call)" statement ([Chapter 5](#chapter5)).
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

The Name Table occupies 768 bytes of VRAM from 1800H to 1AFFH. As in [40x24 Text Mode](#40x24textmode) normal operation involves placing character codes in the required position in the table. The "[VPOKE](#vpoke)" statement may be used to attain familiarity with the screen layout:

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

#<a name="chapter3"></a>3. Programmable Sound Generator

As well as controlling three sound channels the 8910 PSG contains two eight bit data ports, called A and B, through which it interfaces the joysticks and the cassette input. The PSG appears to the Z80 as three I/O ports called the Address Port, the Data Write Port and the Data Read Port.

##<a name="addressport"></a>Address Port (I/O port A0H)

The PSG contains sixteen internal registers which completely define its operation. A specific register is selected by writing its number, from 0 to 15, to this port. Once selected, repeated accesses to that register may be made via the two data ports.

##<a name="datawriteport"></a>Data Write Port (I/O port A1H)

This port is used to write to any register once it has been selected by the Address Port.

##<a name="datareadport"></a>Data Read Port (I/O port A2H)

This port is used to read any register once it has been selected by the Address Port.

##<a name="registers0and1"></a>Registers 0 and 1

<a name="figure25"></a>~[][CH03F25]

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

This register is used to read in PSG Port A. The six joystick bits reflect the state of the four direction switches and two trigger buttons on a joystick: 0=Pressed, 1=Not pressed. Alternatively up to six Paddles may be connected instead of one joystick. Although most MSX machines have two 9 pin joystick connectors only one can be read at a time. The one to be selected for reading is determined by the Joystick Select bit in PSG Register 15.

The Keyboard Mode bit is unused on UK machines. On Japanese machines it is tied to a jumper link to determine the keyboard's character set.

The Cassette Input is used to read the signal from the cassette EAR output. This is passed through a comparator to clean the edges and to convert to digital levels but is otherwise unprocessed.

##<a name="register15"></a>Register 15

<a name="figure33"></a>![][CH03F33]

**Figure 33**

This register is used to output to PSG Port B. The four least significant bits are connected via TTL open-collector buffers to pins 6 and 7 of each joystick connector. They are normally set to a 1, when a paddle or joystick is connected, so that the pins can function as inputs. When a touchpad is connected they are used as handshaking outputs.

The two Pulse bits are used to generate a short positive- going pulse to any paddles attached to joystick connectors 1 or 2. Each paddle contains a monostable timer with a variable resistor controlling its pulse length. Once the timer is triggered the position of the variable resistor can be determined by counting until the monostable times out.

The Joystick Select bit determines which joystick connector is connected to PSG Port A for input: 0=Connector 1, 1=Connector 2.

The Kana LED output is unused on UK machines. On Japanese machines it is used to drive a keyboard mode indicator.



[CH01F01]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/97f807a4/images/CH01F01.svg
[CH01F02]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/97f807a4/images/CH01F02.svg
[CH01F03]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/97f807a4/images/CH01F03.svg
[CH01F04]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/97f807a4/images/CH01F04.svg
[CH01F05]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/97f807a4/images/CH01F05.svg
[CH01F06]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/97f807a4/images/CH01F06.svg
[CH02F07]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/b575e527/images/CH02F07.svg
[CH02F08]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/b575e527/images/CH02F08.svg
[CH02F09]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/b575e527/images/CH02F09.svg
[CH02F10]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/b575e527/images/CH02F10.svg
[CH02F11]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/b575e527/images/CH02F11.svg
[CH02F12]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/b575e527/images/CH02F12.svg
[CH02F13]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/b575e527/images/CH02F13.svg
[CH02F14]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/b575e527/images/CH02F14.svg
[CH02F15]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/b575e527/images/CH02F15.svg
[CH02F16]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/b575e527/images/CH02F16.svg
[CH02F17]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/b575e527/images/CH02F17.svg
[CH02F18]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/b575e527/images/CH02F18.svg
[CH02F19]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/b575e527/images/CH02F19.svg
[CH02F20]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/b575e527/images/CH02F20.svg
[CH02F21]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/b575e527/images/CH02F21.svg
[CH02F22]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/b575e527/images/CH02F22.svg
[CH02F23]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/b575e527/images/CH02F23.svg
[CH02F24]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/b575e527/images/CH02F24.svg
[CH03F25]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/b575e527/images/CH03F25.svg
[CH03F26]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/b575e527/images/CH03F26.svg
[CH03F27]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/b575e527/images/CH03F27.svg
[CH03F28]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/b575e527/images/CH03F28.svg
[CH03F29]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/b575e527/images/CH03F29.svg
[CH03F30]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/b575e527/images/CH03F30.svg
[CH03F31]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/b575e527/images/CH03F31.svg
[CH03F32]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/b575e527/images/CH03F32.svg
[CH03F33]: https://cdn.rawgit.com/oraculo666/the_msx_red_book/b575e527/images/CH03F33.svg
