<a name="contents"></a>
# Contents

[Introduction](#introduction)

1. [Programmable Peripheral Interface](#chapter_1)
    + [PPI Port A (I/O Port A8H)](#ppi_port_a)
    + [Expanders](#expanders)
    + [PPI Port B (I/O Port A9H)](#ppi_port_b)
    + [PPI Port C (I/O Port AAH)](#ppi_port_c)
    + [PPI Mode Port (I/O Port ABH)](#ppi_mode_port)
2. [Video Display Processor](#chapter_2)
    + [Data Port (I/O Port 98H)](#data_port)
    + [Command Port (I/O Port 99H)](#command_port)
    + [Address Register](#address_register)
    + [VDP Status Register](#vdp_status_register)
    + [VDP Mode Registers](#vdp_mode_registers)
    + [Mode Register 0](#mode_register_0)
    + [Mode Register 1](#mode_register_1)
    + [Mode Register 2](#mode_register_2)
    + [Mode Register 3](#mode_register_3)
    + [Mode Register 4](#mode_register_4)
    + [Mode Register 5](#mode_register_5)
    + [Mode Register 6](#mode_register_6)
    + [Mode Register 7](#mode_register_7)
    + [Screen Modes](#screen_modes)
    + [40x24 Text Mode](#40x24_text_mode)
    + [32x24 Text Mode](#32x24_text_mode)
    + [Graphics Mode](#graphics_mode)
    + [Multicolour Mode](#multicolour_mode)
    + [Sprites](#sprites)
3. [Programmable Sound Generator](#chapter_3)
    + [Address Port (I/O port A0H)](#address_port)
    + [Data Write Port (I/O port A1H)](#data_write_port)
    + [Data Read Port (I/O port A2H)](#data_read_port)
    + [Registers 0 and 1](#registers_0_and_1)
    + [Registers 2 and 3](#registers_2_and_3)
    + [Registers 4 and 5](#registers_4_and_5)
    + [Register 6](#register_6)
    + [Register 7](#register_7)
    + [Register 8](#register_8)
    + [Register 9](#register_9)
    + [Register 10](#register_10)
    + [Registers 11 and 12](#registers_11_and_12)
    + [Register 13](#register_13)
    + [Register 14](#register_14)
    + [Register 15](#register_15)
4. [ROM BIOS](#chapter_4)
    + [Data Areas](#data_areas)
    + [Terminology](#terminology)
5. [ROM BASIC Interpreter](#chapter_5)
6. [Memory Map](#chapter_6)
    + [Workspace Area](#workspace_area)
    + [The Hooks](#the_hooks)
7. [Machine Code Programs](#chapter_7)
    + [Keyboard Matrix](#keyboard_matrix)
    + [40 Column Graphics Text](#40_column_graphics_text)
    + [String Bubble Sort](#string_bubble_sort)
    + [Graphics Screen Dump](#graphics_screen_dump)
    + [Character Editor](#character_editor)

Contents Copyright 1985 Avalon Software<br>
Iver Lane, Cowley, Middx, UB8 2JD

MSX is a trademark of Microsoft Corp.<br>
Z80 is a trademark of Zilog Corp.<br>
ACADEMY is trademark of Alfred.

<br><br><br>

<a name="introduction"></a>
# Introduction

## <a name="aims"></a>Aims

This book is about MSX computers and how they work. For technical and commercial reasons MSX computer manufacturers only make a limited amount of information available to the end user about the design of their machines. Usually this will be a fairly detailed description of Microsoft MSX BASIC together with a broad outline of the system hardware. While this level of documentation is adequate for the casual user it will inevitably prove limiting to anyone engaged in more sophisticated programming.

The aim of this book is to provide a description of the standard MSX hardware and software at a level of detail sufficient to satisfy that most demanding of users, the machine code programmer. It is not an introductory course on programming and is necessarily of a rather technical nature. It is assumed that you already possess, or intend to acquire by other means, an understanding of the Z80 Microprocessor at the machine code level. As there are so many general purpose books already in existence about the Z80 any description of its characteristics would simply duplicate widely available information.

<a name="organization"></a>
## Organization

The MSX Standard specifies the following as the major functional components in any MSX computer:

1. Zilog Z80 Microprocessor
2. Intel 8255 Programmable Peripheral Interface
3. Texas 9929 Video Display Processor
4. General Instrument 8910 Programmable Sound Generator
5. 32 KB MSX BASIC ROM
6. 8 KB RAM minimum

Although there are obviously a great many additional components involved in the design of an MSX computer they are all small-scale, non-programmable ones and therefore "invisible" to the user. Manufacturers generally have considerable freedom in the selection of these small-scale components. The programmable components cannot be varied and therefore all MSX machines are identical as far as the programmer is concerned.

[Chapters 1](chapter_1), [2](chapter_2) and [3](chapter_3) describe the operation of the Programmable Peripheral Interface, Video Display Processor and Programmable Sound Generator respectively. These three devices provide the interface between the Z80 and the peripheral hardware on a standard MSX machine. All occupy positions on the Z80 I/O (Input/Output) Bus.

[Chapter 4](chapter_4) covers the software contained in the first part of the MSX ROM. This section of the ROM is concerned with controlling the machine hardware at the fine detail level and is known as the ROM BIOS (Basic Input Output System). It is structured in such a way that most of the functions a machine code programmer requires, such as keyboard and video drivers, are readily available.

[Chapter 5](chapter_5) describes the software contained in the remainder of the ROM, the Microsoft MSX BASIC Interpreter. Although this is largely a text-driven program, and consequently of less use to the programmer, a close examination reveals many points not documented by manufacturers.

[Chapter 6](chapter_6) is concerned with the organization of system memory. Particular attention is paid to the Workspace Area, that section of RAM from F380H to FFFFH, as this is used as a scratchpad by the BIOS and the BASIC Interpreter and contains much information of use to any application program.

[Chapter 7](#chapter_7) gives some examples of machine code programs that make use of ROM features to minimize design effort.

It is believed that this book contains zero defects, if you know otherwise the author would be delighted to hear from you. This book is dedicated to the Walking Nightmare.

<br><br><br>

<a name="chapter_1"></a>
# 1. Programmable Peripheral Interface

The 8255 PPI is a general purpose parallel interface device configured as three eight bit data ports, called A, B and C, and a mode port. It appears to the Z80 as four I/O ports through which the keyboard, the memory switching hardware, the cassette motor, the cassette output, the Caps Lock LED and the Key Click audio output can be controlled. Once the PPI has been initialized access to a particular piece of hardware just involves writing to or reading the relevant I/O port.

<a name="ppi_port_a"></a>
## PPI Port A (I/O Port A8H)

<a name="figure1"></a>![][CH01F01]

**Figure 1:** Primary Slot Register

This output port, known as the Primary Slot Register in MSX terminology, is used to control the memory switching hardware. The Z80 Microprocessor can only access 64 KB of memory directly. This limitation is currently regarded as too restrictive and several of the newer personal computers employ methods to overcome it.

MSX machines can have multiple memory devices at the same address and the Z80 may switch in any one of them as required. The processor address space is regarded as being duplicated "sideways" into four separate 64 KB areas, called Primary Slots 0 to 3, each of which receives its own slot select signal alongside the normal Z80 bus signals. The contents of the Primary Slot Register determine which slot select signal is active and therefore which Primary Slot is selected.

To increase flexibility each 16 KB "page" of the Z80 address space may be selected from a different Primary Slot. As shown in [Figure 1](#figure1) two bits of the Primary Slot Register are required to define the Primary Slot number for each page.

The first operation performed by the MSX ROM at power-up is to search through each slot for RAM in pages 2 and 3 (8000H to FFFFH). The Primary Slot Register is then set so that the relevant slots are selected thus making the RAM permanently available. The memory configuration of any MSX machine can be determined by displaying the Primary Slot Register setting with the BASIC statement:

    PRINT RIGHT$("0000000"+BIN$(INP(&HA8)),8)

As an example "10100000" would be produced on a Toshiba HX10 where pages 3 and 2 (the RAM) both come from Primary Slot 2 and pages 1 and 0 (the MSX ROM) from Primary Slot 0. The MSX ROM must always be placed in Primary Slot 0 by a manufacturer as this is the slot selected by the hardware at power-up. Other memory devices, RAM and any additional ROM, may be placed in any slot by a manufacturer.

A typical UK machine will have one Primary Slot containing the MSX ROM, one containing 64 KB of RAM and two slots brought out to external connectors. Most Japanese machines have a cartridge type connector on each of these external slots but UK machines usually have one cartridge connector and one IDC connector.

<a name="expanders"></a>
## Expanders

System memory can be increased to a theoretical maximum of sixteen 64 KB areas by using expander interfaces. An expander plugs into any Primary Slot to provide four 64 KB Secondary Slots, numbered 0 to 3, instead of one primary one. Each expander has its own local hardware, called a Secondary Slot Register, to select which of the Secondary Slots should appear in the Primary Slot. As before pages can be selected from different Secondary Slots.

<a name="figure2"></a>![][CH01F02]

**Figure 2:** Secondary Slot Register

Each Secondary Slot Register, while actually being an eight bit read/write latch, is made to appear as memory location FFFFH of its Primary Slot by the expander hardware. In order to gain access to this location on a particular expander it will usually be necessary to first switch page 3 (C000H to FFFFH) of that Primary Slot into the processor address space. The Secondary Slot Register can then be modified and, if necessary, page 3 restored to its original Primary Slot setting. Accessing memory in expanders can become rather a convoluted process.

It is apparent that there must be some way of determining whether a Primary Slot contains ordinary RAM or an expander in order to access it properly. To achieve this the Secondary Slot Registers are designed to invert their contents when read back. During the power-up RAM search memory location FFFFH of each Primary Slot is examined to determine whether it behaves normally or whether the slot contains an expander. The results of these tests are stored in the Workspace Area system resource map [EXPTBL](#exptbl) for later use. This is done at power-up because of the difficulty in performing tests when the Secondary Slot Registers actually contain live settings.

Memory switching is obviously an area demanding extra caution, particularly with the hierarchical mechanisms needed to control expanders. Care must be taken to avoid switching out the page in which a program is running or, if it is being used, the page containing the stack. There are a number of standard routines available to the machine code programmer in the BIOS section of the MSX ROM to simplify the process.

The BASIC Interpreter itself has four methods of accessing extension ROMs. The first three of these are for use with machine code ROMs placed in page 1 (4000H to 7FFFH), they are:

1. Hooks ([Chapter 6](chapter_6)).
2. The "`CALL`" statement ([Chapter 5](#chapter_5)).
3. Additional device names ([Chapter 5](#chapter_5)).

The BASIC Interpreter can also execute a BASIC program ROM detected in page 2 (8000H to BFFFH) during the power-up ROM search. What the BASIC Interpreter cannot do is use any RAM hidden behind other memory devices. This limitation is a reflection of the difficulty in converting an established program to take advantage of newer, more complex machines. A similar situation exists with the version of Microsoft BASIC available on the IBM PC. Out of a 1 MB memory space only 64 KB can be used for program storage.

<a name="ppi_port_b"></a>
## PPI Port B (I/O Port A9H)

<a name="figure3"></a>![][CH01F03]

**Figure 3**

This input port is used to read the eight bits of column data from the currently selected row of the keyboard. The MSX keyboard is a software scanned eleven row by eight column matrix of normally open switches. Current machines usually only have keys in rows zero to eight. Conversion of key depressions into character codes is performed by the MSX ROM interrupt handler, this process is described in [Chapter 4](chapter_4).

<a name="ppi_port_c"></a>
## PPI Port C (I/O Port AAH)

<a name="figure4"></a>![][CH01F04]

**Figure 4**

This output port controls a variety of functions. The four Keyboard Row Select bits select which of the eleven keyboard rows, numbered from 0 to 10, is to be read in by PPI Port B.

The Cas Motor bit determines the state of the cassette motor relay: 0=On, 1=Off.

The Cas Out bit is filtered and attenuated before being taken to the cassette DIN socket as the MIC signal. All cassette tone generation is performed by software.

The Cap LED bit determines the state of the Caps Lock LED: 0=On, 1=Off.

The Key Click output is attenuated and mixed with the audio output from the Programmable Sound Generator. To actually generate a sound this bit should be flipped on and off.

Note that there are standard routines in the ROM BIOS to access all of the functions available with this port. These should be used in preference to direct manipulation of the hardware if at all possible.

<a name="ppi_mode_port"></a>
## PPI Mode Port (I/O Port ABH)

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

<a name="chapter_2"></a>
# 2. Video Display Processor

The 9929 VDP contains all the circuitry necessary to generate the video display. It appears to the Z80 as two I/O ports called the [Data Port](#data_port) and the [Command Port](#command_port). Although the VDP has its own 16 KB of VRAM (Video RAM), the contents of which define the screen image, this cannot be directly accessed by the Z80. Instead it must use the two I/O ports to modify the VRAM and to set the various VDP operating conditions.

<a name="data_port"></a>
## Data Port (I/O Port 98H)

The Data Port is used to read or write single bytes to the VRAM. The VDP possesses an internal address register pointing to a location in the VRAM. Reading the Data Port will input the byte from this VRAM location while writing to the Data Port will store a byte there. After a read or write the [address register](#address_register) is automatically incremented to point to the next VRAM location. Sequential bytes can be accessed simply by continuous reads or writes to the Data Port.

<a name="command_port"></a>
## Command Port (I/O Port 99H)

The Command Port is used for three purposes:

1. To set up the [Data Port](#data_port) [address register](#address_register).
2. To read the [VDP Status Register](#vdp_status_register).
3. To write to one of the [VDP Mode Registers](#vdp_mode_registers).

<a name="address_register"></a>
## Address Register

The [Data Port](#data_port) address register must be set up in different ways depending on whether the subsequent access is to be a read or a write. The address register can be set to any value from 0000H to 3FFFH by first writing the LSB (Least Significant Byte) and then the MSB (Most Significant Byte) to the [Command Port](#command_port). Bits 6 and 7 of the MSB are used by the VDP to determine whether the address register is being set up for subsequent reads or writes as follows:

<a name="figure7"></a>![][CH02F07]

**Figure 7:** VDP Address Setup

It is important that no other accesses are made to the VDP in between writing the LSB and the MSB as this will upset its synchronization. The MSX ROM interrupt handler is continuously reading the [VDP Status Register](#vdp_status_register) as a background task so interrupts should be disabled as necessary.

<a name="vdp_status_register"></a>
## VDP Status Register

Reading the [Command Port](#command_port) will input the contents of the VDP Status Register. This contains various flags as below:

<a name="figure8"></a>![][CH02F08]

**Figure 8:** VDP Status Register

The Fifth Sprite Number bits contain the number (0 to 31) of the sprite triggering the Fifth Sprite Flag.

The Coincidence Flag is normally 0 but is set to 1 if any sprites have one or more overlapping pixels. Reading the Status Register will reset this flag to a 0. Note that coincidence is only checked as each pixel is generated during a video frame, on a UK machine this is every 20 ms. If fast moving sprites pass over each other between checks then no coincidence will be flagged.

The Fifth Sprite Flag is normally 0 but is set to 1 when there are more than four sprites on any pixel line. Reading the Status Register will reset this flag to a 0.

The Frame Flag is normally 0 but is set to a 1 at the end of the last active line of the video frame. For UK machines with a 50 Hz frame rate this will occur every 20 ms. Reading the Status register will reset this flag to a 0. There is an associated output signal from the VDP which generates Z80 interrupts at the same rate, this drives the MSX ROM interrupt handler.

<a name="vdp_mode_registers"></a>
## VDP Mode Registers

The VDP has eight write-only registers, numbered 0 to 7, which control its general operation. A particular register is set by first writing a data byte then a register selection byte to the [Command Port](#command_port). The register selection byte contains the register number in the lower three bits: 10000RRR. As the Mode Registers are write-only, and cannot be read, the MSX ROM maintains an exact copy of the eight registers in the Workspace Area of RAM ([Chapter 6](chapter_6)). Using the MSX ROM standard routines for VDP functions ensures that this register image is correctly updated.

<a name="mode_register_0"></a>
## Mode Register 0

<a name="figure9"></a>![][CH02F09]

**Figure 9**

The External VDP bit determines whether external VDP input is to be enabled or disabled: 0=Disabled, 1=Enabled.

The M3 bit is one of the three VDP mode selection bits, see [Mode Register 1](#mode_register_1).

<a name="mode_register_1"></a>
## Mode Register 1

<a name="figure10"></a>![][CH02F10]

**Figure 10**

The Magnification bit determines whether sprites will be normal or doubled in size: 0=Normal, 1=Doubled.

The Size bit determines whether each sprite pattern will be 8x8 bits or 16x16 bits: 0=8x8, 1=16x16.

The M1 and M2 bits determine the VDP operating mode in conjunction with the M3 bit from [Mode Register 0](#mode_register_0):

```
M1 M2 M3
0  0  0  32x24 Text Mode
0  0  1  Graphics Mode
0  1  0  Multicolour Mode
1  0  0  40x24 Text Mode
```

The Interrupt Enable bit enables or disables the interrupt output signal from the VDP: 0=Disable, 1=Enable.

The Blank bit is used to enable or disable the entire video display: 0=Disable, 1=Enable. When the display is blanked it will be the same colour as the border.

The 4/16K bit alters the VDP VRAM addressing characteristics to suit either 4 KB or 16 KB chips: 0=4 KB, 1=16 KB.

<a name="mode_register_2"></a>
## Mode Register 2

<a name="figure11"></a>![][CH02F11]

**Figure 11**

Mode Register 2 defines the starting address of the Name Table in the VDP VRAM. The four available bits only specify positions 00BB BB00 0000 0000 of the full address so register contents of 0FH would result in a base address of 3C00H.


<a name="mode_register_3"></a>
## Mode Register 3

<a name="figure12"></a>![][CH02F12]

**Figure 12**

Mode Register 3 defines the starting address of the Colour Table in the VDP VRAM. The eight available bits only specify positions 00BB BBBB BB00 0000 of the full address so register contents of FFH would result in a base address of 3FC0H. In [Graphics Mode](#graphics_mode) only bit 7 is effective thus offering a base of 0000H or 2000H. Bits 0 to 6 must be 1.

<a name="mode_register_4"></a>
## Mode Register 4

<a name="figure13"></a>![][CH02F13]

**Figure 13**

Mode Register 4 defines the starting address of the Character Pattern Table in the VDP VRAM. The three available bits only specify positions 00BB B000 0000 0000 of the full address so register contents of 07H would result in a base address of 3800H. In [Graphics Mode](#graphics_mode) only bit 2 is effective thus offering a base of 0000H or 2000H. Bits 0 and 1 must be 1.

<a name="mode_register_5"></a>
## Mode Register 5

<a name="figure14"></a>![][CH02F14]

**Figure 14**

Mode Register 5 defines the starting address of the Sprite Attribute Table in the VDP VRAM. The seven available bits only specify positions 00BB BBBB B000 0000 of the full address so register contents of 7FH would result in a base address of 3F80H.

<a name="mode_register_6"></a>
## Mode Register 6

<a name="figure15"></a>![][CH02F15]

**Figure 15**

Mode Register 6 defines the starting address of the Sprite Pattern Table in the VDP VRAM. The three available bits only specify positions 00BB B000 0000 0000 of the full address so register contents of 07H would result in a base address of 3800H.

<a name="mode_register_7"></a>
## Mode Register 7

<a name="figure16"></a>![][CH02F16]

**Figure 16**

The Border Colour bits determine the colour of the region surrounding the active video area in all four VDP modes. They also determine the colour of all 0 pixels on the screen in [40x24 Text Mode](#40x24_text_mode). Note that the border region actually extends across the entire screen but will only become visible in the active area if the overlying pixel is transparent.

The Text Colour 1 bits determine the colour of all 1 pixels in [40x24 Text Mode](#40x24_text_mode). They have no effect in the other three modes where greater flexibility is provided through the use of the Colour Table. The VDP colour codes are:

```
0 Transparent   4 Dark Blue      8 Red              12 Dark Green
1 Black         5 Light Blue     9 Bright Red       13 Purple
2 Green         6 Dark Red      10 Yellow           14 Grey
3 Light Green   7 Sky Blue      11 Light Yellow     15 White
```

<a name="screen_modes"></a>
## Screen Modes

The VDP has four operating modes, each one offering a slightly different set of capabilities. Generally speaking, as the resolution goes up the price to be paid in VRAM size and updating complexity also increases. In a dedicated application these associated hardware and software costs are important considerations. For an MSX machine they are irrelevant, it therefore seems a pity that a greater attempt was not made to standardize on one particular mode. The [Graphics Mode](#graphics_mode) is capable of adequately performing all the functions of the other modes with only minor reservations.

An added difficulty in using the VDP arises because insufficient allowance was made in its design for the overscanning used by most televisions. The resulting loss of characters at the screen edges has forced all the video-related MSX software into being based on peculiar screen sizes. UK machines normally use only the central thirty-seven characters available in [40x24 Text Mode](#40x24_text_mode). Japanese machines, with NTSC (National Television Standards Committee) video outputs, use the central thirty-nine characters.

The central element in the VDP, from the programmer's point of view, is the Name Table. This is a simple list of single- byte character codes held in VRAM. It is 960 bytes long in [40x24 Text Mode](#40x24_text_mode), 768 bytes long in [32x24 Text Mode](#32x24_text_mode), [Graphics Mode](#graphics_mode) and [Multicolour Mode](#multicolour_mode). Each position in the Name Table corresponds to a particular location on the screen.

During a video frame the VDP will sequentially read every character code from the Name Table, starting at the base. As each character code is read the corresponding 8x8 pattern of pixels is looked up in the Character Pattern Table and displayed on the screen. The appearance of the screen can thus be modified by either changing the character codes in the Name Table or the pixel patterns in the Character Pattern Table.

Note that the VDP has no hardware cursor facility, if one is required it must be software generated.

<a name="40x24_text_mode"></a>
## 40x24 Text Mode

The Name Table occupies 960 bytes of VRAM from 0000H to 03BFH:

<a name="figure17"></a>![][CH02F17]

**Figure 17:** 40x24 Name Table

Pattern Table occupies 2 KB of VRAM from 0800H to 0FFFH. Each eight byte block contains the pixel pattern for a character code:

<a name="figure18"></a>![][CH02F18]

**Figure 18:** Character Pattern Block (No. 65 shown = 'A')

The first block contains the pattern for character code 0, the second the pattern for character code 1 and so on to character code 255. Note that only the leftmost six pixels are actually displayed in this mode. The colours of the 0 and 1 pixels in this mode are defined by VDP [Mode Register 7](#mode_register_7), initially they are blue and white.

<a name="32x24_text_mode"></a>
## 32x24 Text Mode

The Name Table occupies 768 bytes of VRAM from 1800H to 1AFFH. As in [40x24 Text Mode](#40x24_text_mode) normal operation involves placing character codes in the required position in the table. The "`VPOKE`" statement may be used to attain familiarity with the screen layout:

<a name="figure19"></a>![][CH02F19]

**Figure 19:** 32x24 Name Table

The Character Pattern Table occupies 2 KB of VRAM from 0000H to 07FFH. Its structure is the same as in [40x24 Text Mode](#40x24_text_mode), all eight pixels of an 8x8 pattern are now displayed.

The border colour is defined by VDP [Mode Register 7](#mode_register_7) and is initially blue. An additional table, the Colour Table, determines the colour of the 0 and 1 pixels. This occupies thirty-two bytes of VRAM from 2000H to 201FH. Each entry in the Colour Table defines the 0 and 1 pixel colours for a group of eight character codes, the lower four bits defining the 0 pixel colour, the upper four bits the 1 pixel colour. The first entry in the table defines the colours for character codes 0 to 7, the second for character codes 8 to 15 and so on for thirty-two entries. The MSX ROM initializes all entries to the same value, blue and white, and provides no facilities for changing individual ones.

<a name="graphics_mode"></a>
## Graphics Mode

The Name Table occupies 768 bytes of VRAM from 1800H to 1AFFH, the same as in [32x24 Text Mode](#32x24_text_mode). The table is initialized with the character code sequence 0 to 255 repeated three times and is then left untouched, in this mode it is the Character Pattern Table which is modified during normal operation.

The Character Pattern Table occupies 6 KB of VRAM from 0000H to 17FFH. While its structure is the same as in the text modes it does not contain a character set but is initialized to all 0 pixels. The first 2 KB of the Character Pattern Table is addressed by the character codes from the first third of the Name Table, the second 2 KB by the central third of the Name Table and the last 2 KB by the final third of the Name Table. Because of the sequential pattern in the Name Table the entire Character Pattern Table is read out linearly during a video frame. Setting a point on the screen involves working out where the corresponding bit is in the Character Pattern Table and turning it on. For a BASIC program to convert X,Y coordinates to an address see the [MAPXYC](#mapxyc) standard routine in [Chapter 4](chapter_4).

<a name="figure20"></a>![][CH02F20]

**Figure 20:** Graphics Character Pattern Table

The border colour is defined by VDP [Mode Register 7](#mode_register_7) and is initially blue. The Colour Table occupies 6 KB of VRAM from 2000H to 37FFH. There is an exact byte-to-byte mapping from the Character Pattern Table to the Colour Table but, because it takes a whole byte to define the 0 pixel and 1 pixel colours, there is a lower resolution for colours than for pixels. The lower four bits of a Colour Table entry define the colour of all the 0 pixels on the corresponding eight pixel line. The upper four bits define the colour of the 1 pixels. The Colour Table is initialized so that the 0 pixel colour and the 1 pixel colour are blue for the entire table. Because both colours are the same it will be necessary to alter one colour when a bit is set in the Character Pattern Table.

<a name="multicolour_mode"></a>
## Multicolour Mode

The Name Table occupies 768 bytes of VRAM from 0800H to 0AFFH, the screen mapping is the same as in [32x24 Text Mode](#32x24_text_mode). The table is initialized with the following character code pattern:

```
00H to 1FH (Repeated four times)
20H to 3FH (Repeated four times)
40H to 5FH (Repeated four times)
60H to 7FH (Repeated four times)
80H to 9FH (Repeated four times)
A0H to BFH (Repeated four times)
```

As with [Graphics Mode](#graphics_mode) this is just a character code "driver" pattern, it is the Character Pattern Table which is modified during normal operation.

The Character Pattern table occupies 1536 bytes of VRAM from 0000H to 05FFH. As in the other modes each character code maps onto an eight byte block in the Character Pattern Table. Because of the lower resolution in this mode only two bytes of the pattern block are actually needed to define an 8x8 pattern:

<a name="figure21"></a>![][CH02F21]

**Figure 21:** Multicolour Pattern Block

As can be seen from [Figure 21](#figure21) each four bit section of the two byte block contains a colour code and thus defines the colour of a quadrant of the 8x8 pixel pattern. So that the entire eight bytes of the pattern block can be utilized a given character code will use a different two byte section depending upon the character code's screen location (i.e. its position in the Name Table):

```
Video row 0, 4, 8, 12, 16, 20   Uses bytes 0 and 1
Video row 1, 5, 9, 13, 17, 21   Uses bytes 2 and 3
Video row 2, 6, 10, 14, 18, 22  Uses bytes 4 and 5
Video row 3, 7, 11, 15, 19, 23  Uses bytes 6 and 7
```

When the Name Table is filled with the special driver sequence of character codes shown above the Character Pattern Table will be read out linearly during a video frame:

<a name="figure22"></a>![][CH02F22]

**Figure 22:** Multicolour Character Pattern Table

The border colour is defined by VDP [Mode Register 7](#mode_register_7) and is initially blue. There is no separate Colour Table as the colours are defined directly by the contents of the Character Pattern Table, this is initially filled with blue.

<a name="sprites"></a>
## Sprites

The VDP can control thirty-two sprites in all modes except [40x24 Text Mode](#40x24_text_mode). Their treatment is identical in all modes and independent of any character-orientated activity.

The Sprite Attribute Table occupies 128 bytes of VRAM from 1B00H to 1B7FH. The table contains thirty-two four byte blocks, one for each sprite. The first block controls sprite 0 (the "top" sprite), the second controls sprite 1 and so on to sprite 31. The format of each block is as below:

<a name="figure23"></a>![][CH02F23]

**Figure 23:** Sprite Attribute Block

Byte 0 specifies the vertical (Y) coordinate of the top-left pixel of the sprite. The coordinate system runs from -1 (FFH) for the top pixel line on the screen down to 190 (BEH) for the bottom line. Values less than -1 can be used to slide the sprite in from the top of the screen. The exact values needed will obviously depend upon the size of the sprite. Curiously there has been no attempt in MSX BASIC to reconcile this coordinate system with the normal graphics range of Y=0 to 191. As a consequence a sprite will always be one pixel lower on the screen than the equivalent graphic point. Note that the special vertical coordinate value of 208 (D0H) placed in a sprite attribute block will cause the VDP to ignore all subsequent blocks in the Sprite Attribute Table. Effectively this means that any lower sprites will disappear from the screen.

Byte 1 specifies the horizontal (X) coordinate of the top- left pixel of the sprite. The coordinate system runs from 0 for the leftmost pixel to 255 (FFH) for the rightmost. As this coordinate system provides no mechanism for sliding a sprite in from the left a special bit in byte 3 is used for this purpose, see below.

Byte 2 selects one of the two hundred and fifty-six 8x8 bit patterns available in the Sprite Pattern Table. If the Size bit is set in VDP [Mode Register 1](#mode_register_1), resulting in 16x16 bit patterns occupying thirty-two bytes each, the two least significant bits of the pattern number are ignored. Thus pattern numbers 0, 1, 2 and 3 would all select pattern number 0.

In Byte 3 the four Colour Code bits define the colour of the 1 pixels in the sprite patterns, 0 pixels are always transparent. The Early Clock bit is normally 0 but will shift the sprite thirty-two pixels to the left when set to 1. This is so that sprites can slide in from the left of the screen, there being no spare coordinates in the horizontal direction.

The Sprite Pattern Table occupies 2 KB of VRAM from 3800H to 3FFFH. It contains two hundred and fifty-six 8x8 pixel patterns, numbered from 0 to 255. If the Size bit in VDP [Mode Register 1](#mode_register_1) is 0, resulting in 8x8 sprites, then each eight byte sprite pattern block is structured in the same way as the character pattern block shown in [Figure 18](#figure18). If the Size bit is 1, resulting in 16x16 sprites, then four eight byte blocks are needed to define the pattern as below:

<a name="figure24"></a>![][CH02F24]

**Figure 24:** 16x16 Sprite Pattern Block

<br><br><br>

<a name="chapter_3"></a>
# 3. Programmable Sound Generator

As well as controlling three sound channels the 8910 PSG contains two eight bit data ports, called A and B, through which it interfaces the joysticks and the cassette input. The PSG appears to the Z80 as three I/O ports called the [Address Port](#address_port), the [Data Write Port](#data_write_port) and the [Data Read Port](#data_read_port).

<a name="address_port"></a>
## Address Port (I/O port A0H)

The PSG contains sixteen internal registers which completely define its operation. A specific register is selected by writing its number, from 0 to 15, to this port. Once selected, repeated accesses to that register may be made via the two data ports.

<a name="data_write_port"></a>
## Data Write Port (I/O port A1H)

This port is used to write to any register once it has been selected by the [Address Port](#address_port).

<a name="data_read_port"></a>
## Data Read Port (I/O port A2H)

This port is used to read any register once it has been selected by the [Address Port](#address_port).

<a name="registers_0_and_1"></a>
## Registers 0 and 1

<a name="figure25"></a>![][CH03F25]

**Figure 25**

These two registers are used to define the frequency of the Tone Generator for Channel A. Variable frequencies are produced by dividing a fixed master frequency with the number held in Registers 0 and 1, this number can be in the range 1 to 4095. Register 0 holds the least significant eight bits and Register 1 the most significant four. The PSG divides an external 1.7897725 MHz frequency by sixteen to produce a Tone Generator master frequency of 111,861 Hz. The output of the Tone Generator can therefore range from 111,861 Hz (divide by 1) down to 27.3 Hz (divide by 4095). As an example to produce a middle "`A`" (440 Hz) the divider value in Registers 0 and 1 would be 254.

<a name="registers_2_and_3"></a>
## Registers 2 and 3

These two registers control the Channel B Tone Generator as for Channel A.

<a name="registers_4_and_5"></a>
## Registers 4 and 5

These two registers control the Channel C Tone Generator as for Channel A.

<a name="register_6"></a>
## Register 6

<a name="figure26"></a>![][CH03F26]

**Figure 26**

In addition to three square wave Tone Generators the PSG contains a single Noise Generator. The fundamental frequency of the noise source can be controlled in a similar fashion to the Tone Generators. The five least significant bits of Register 6 hold a divider value from 1 to 31. The Noise Generator master frequency is 111,861 Hz as before.

<a name="register_7"></a>
## Register 7

<a name="figure27"></a>![][CH03F27]

**Figure 27**

This register enables or disables the Tone Generator and Noise Generator for each of the three channels: 0=Enable 1=Disable. It also controls the direction of interface ports A and B, to which the joysticks and cassette are attached: 0=Input, 1=Output. Register 7 must always contain 10xxxxxx or possible damage could result to the PSG, there are active devices connected to its I/O pins. The BASIC "`SOUND`" statement will force these bits to the correct value for Register 7 but there is no protection at the machine code level.

<a name="register_8"></a>
## Register 8

<a name="figure28"></a>![][CH03F28]

**Figure 28**

The four Amplitude bits determine the amplitude of Channel A from a minimum of 0 to a maximum of 15. The Mode bit selects either fixed or modulated amplitude: 0=Fixed, 1=Modulated. When modulated amplitude is selected the fixed amplitude value is ignored and the channel is modulated by the output from the Envelope Generator.

<a name="register_9"></a>
## Register 9

This register controls the amplitude of Channel B as for Channel A.

<a name="register_10"></a>
## Register 10

This register controls the amplitude of Channel C as for Channel A.

<a name="registers_11_and_12"></a>
## Registers 11 and 12

<a name="figure29"></a>![][CH03F29]

**Figure 29**

These two registers control the frequency of the single Envelope Generator used for amplitude modulation. As for the Tone Generators this frequency is determined by placing a divider count in the registers. The divider value may range from 1 to 65535 with Register 11 holding the least significant eight bits and Register 12 the most significant. The master frequency for the Envelope Generator is 6991 Hz so the envelope frequency may range from 6991 Hz (divide by 1) to 0.11 Hz (divide by 65535).

<a name="register_13"></a>
## Register 13

<a name="figure30"></a>![][CH03F30]

**Figure 30**

The four Envelope Shape bits determine the shape of the amplitude modulation envelope produced by the Envelope Generator:

<a name="figure31"></a>![][CH03F31]

**Figure 31**

<a name="register_14"></a>
## Register 14

<a name="figure32"></a>![][CH03F32]

**Figure 32**

This register is used to read in PSG Port A. The six joystick bits reflect the state of the four direction switches and two trigger buttons on a joystick: 0=Pressed, 1=Not pressed. Alternatively up to six Paddles may be connected instead of one joystick. Although most MSX machines have two 9 pin joystick connectors only one can be read at a time. The one to be selected for reading is determined by the Joystick Select bit in [PSG Register 15](#register_15).

The Keyboard Mode bit is unused on UK machines. On Japanese machines it is tied to a jumper link to determine the keyboard's character set.

The Cassette Input is used to read the signal from the cassette EAR output. This is passed through a comparator to clean the edges and to convert to digital levels but is otherwise unprocessed.

<a name="register_15"></a>
## Register 15

<a name="figure33"></a>![][CH03F33]

**Figure 33**

This register is used to output to PSG Port B. The four least significant bits are connected via TTL open-collector buffers to pins 6 and 7 of each joystick connector. They are normally set to a 1, when a paddle or joystick is connected, so that the pins can function as inputs. When a touchpad is connected they are used as handshaking outputs.

The two Pulse bits are used to generate a short positive- going pulse to any paddles attached to joystick connectors 1 or 2. Each paddle contains a monostable timer with a variable resistor controlling its pulse length. Once the timer is triggered the position of the variable resistor can be determined by counting until the monostable times out.

The Joystick Select bit determines which joystick connector is connected to PSG Port A for input: 0=Connector 1, 1=Connector 2.

The Kana LED output is unused on UK machines. On Japanese machines it is used to drive a keyboard mode indicator.

<br><br><br>

<a name="chapter_4"></a>
# 4. ROM BIOS

The design of the MSX ROM is of importance if machine code programs are to be developed efficiently and Operate reliably. Almost every program, including the BASIC Interpreter itself, will require a certain set of primitive functions to operate. These include screen and printer drivers, a keyboard decoder and other hardware related functions. By separating these routines from the BASIC Interpreter they can be made available to any application program. The section of ROM from 0000H to 268BH is largely devoted to such routines and is called the ROM BIOS (Basic Input Output System).

This chapter gives a functional description of every recognizably separate routine in the ROM BIOS. Special attention is given to the "standard" routines. These are documented by Microsoft and guaranteed to remain consistent through possible hardware and software changes. The first few hundred bytes of the ROM consists of Z80 JP instructions which provide fixed position entry points to these routines. For maximum compatibility with future software an application program should restrict its dependence on the ROM to these locations only. The description of the ROM begins with this list of entry points to the standard routines. A brief comment is placed with each entry point, the full description is given with the routine itself.

<a name="data_areas"></a>
## Data Areas

It is expected that most users will wish to disassemble the ROM to some extent (the full listing runs to nearly four hundred pages). In order to ease this process the data areas, which do not contain executable Z80 code, are shown below:

```
0004H-0007H     185DH-1863H     4B3AH-4B4CH     73E4H-73E4H
002BH-002FH     1B97H-1BAAH     4C2FH-4C3FH     752EH-7585H
0508H-050DH     1BBFH-23BEH     555AH-5569H     7754H-7757H
092FH-097FH     2439H-2459H     5D83H-5DB0H     7BA3H-7BCAH
0DA5H-0EC4H     2CF1H-2E70H     6F76H-6F8EH     7ED8H-7F26H
1033H-105AH     3030H-3039H     70FFH-710CH     7F41H-7FB6H
1061H-10C1H     3710H-3719H     7182H-7195H     7FBEH-7FFFH
1233H-1252H     392EH-3FE1H     71A2H-71B5H
13A9H-1448H     43B5H-43C3H     71C7H-71DAH
160BH-1612H     46E6H-46E7H     72A6H-72B9H
```

Note that these data areas are for the UK ROM, there are slight differences in the Japanese ROM relating to the keyboard decoder and the video character set. Disparities between the ROMs are restricted to these regions with the bulk of the code being identical in both cases.

<a name="terminology"></a>
## Terminology

Reference is frequently made in this chapter to the standard routines and to Workspace Area variables. Whenever this is done the Microsoft-recommended name is used in upper case letters, for example "the [FILVRM](#filvrm) standard routine" and "[SCRMOD](#scrmod) is set". Subroutines which are not named are referred to by a parenthesized address, "the screen is cleared ([0777H](#0777h))" for example. When reference is made to the Z80 status flags assembly language conventions are used, for example "Flag C" would mean that the carry flag is set while "Flag NZ" means that the zero flag is reset. The terms "EI" and "DI" mean enabled interrupts and disabled interrupts respectively.

|ADDRESS    |NAME               |TO                 |FUNCTION
|:---------:|:-----------------:|:-----------------:|--------------------------------------
|0000H      |[CHKRAM](#chkram)  |[02D7H](#02d7h)    |Power-up, check RAM
|0004H      |......             |.....              |Two bytes, address of ROM character set
|0006H      |......             |.....              |One byte, VDP [Data Port](#data_port) number
|0007H      |......             |.....              |One byte, VDP [Data Port](#data_port) number
|0008H      |[SYNCHR](#synchr)  |[2683H](#2683h)    |Check BASIC program character
|000BH      |......             |.....              |NOP
|000CH      |[RDSLT](#rdslt)    |[01B6H](#01b6h)    |Read RAM in any slot
|000FH      |......             |.....              |NOP
|0010H      |[CHRGTR](#chrgtr)  |[2686H](#2686h)    |Get next BASIC program character
|0013H      |......             |.....              |NOP
|0014H      |[WRSLT](#wrslt)    |[01D1H](#01d1h)    |Write to RAM in any slot
|0017H      |......             |.....              |NOP
|0018H      |[OUTDO](#outdo)    |[1B45H](#1b45h)    |Output to current device
|001BH      |......             |.....              |NOP
|001CH      |[CALSLT](#calslt)  |[0217H](#0217h)    |Call routine in any slot
|001FH      |......             |.....              |NOP
|0020H      |[DCOMPR](#dcompr)  |[146AH](#146ah)    |Compare register pairs HL and DE
|0023H      |......             |.....              |NOP
|0024H      |[ENASLT](#enaslt)  |[025EH](#025eh)    |Enable any slot permanently
|0027H      |......             |.....              |NOP
|0028H      |[GETYPR](#getypr)  |[2689H](#2689h)    |Get BASIC operand type
|002BH      |......             |.....              |Five bytes Version Number
|0030H      |[CALLF](#callf)    |[0205H](#0205h)    |Call routine in any slot
|0033H      |......             |.....              |Five NOPs
|0038H      |[KEYINT](#keyint)  |[0C3CH](#0c3ch)    |Interrupt handler, keyboard scan
|003BH      |[INITIO](#initio)  |[049DH](#049dh)    |Initialize I/O devices
|003EH      |[INIFNK](#inifnk)  |[139DH](#139dh)    |Initialize function key strings
|0041H      |[DISSCR](#disscr)  |[0577H](#0577h)    |Disable screen
|0044H      |[ENASCR](#enascr)  |[0570H](#0570h)    |Enable screen
|0047H      |[WRTVDP](#wrtvdp)  |[057FH](#057fh)    |Write to any VDP register
|004AH      |[RDVRM](#rdvrm)    |[07D7H](#07d7h)    |Read byte from VRAM
|004DH      |[WRTVRM](#wrtvrm)  |[07CDH](#07cdh)    |Write byte to VRAM
|0050H      |[SETRD](#setrd)    |[07ECH](#07ech)    |Set up VDP for read
|0053H      |[SETWRT](#setwrt)  |[07DFH](#07dfh)    |Set up VDP for write
|0056H      |[FILVRM](#filvrm)  |[0815H](#0815h)    |Fill block of VRAM with data byte
|0059H      |[LDIRMV](#ldirmv)  |[070FH](#070fh)    |Copy block to memory from VRAM
|005CH      |[LDIRVM](#ldirvm)  |[0744H](#0744h)    |Copy block to VRAM, from memory
|005FH      |[CHGMOD](#chgmod)  |[084FH](#084fh)    |Change VDP mode
|0062H      |[CHGCLR](#chgclr)  |[07F7H](#07f7h)    |Change VDP colours
|0065H      |......             |.....              |NOP
|0066H      |[NMI](#nmi)        |[1398H](#1398h)    |Non Maskable Interrupt handler
|0069H      |[CLRSPR](#clrspr)  |[06A8H](#06a8h)    |Clear all sprites
|006CH      |[INITXT](#initxt)  |[050EH](#050eh)    |Initialize VDP to [40x24 Text Mode](#40x24_text_mode)
|006FH      |[INIT32](#init32)  |[0538H](#0538h)    |Initialize VDP to [32x24 Text Mode](#32x24_text_mode)
|0072H      |[INIGRP](#inigrp)  |[05D2H](#05d2h)    |Initialize VDP to [Graphics Mode](#graphics_mode)
|0075H      |[INIMLT](#inimlt)  |[061FH](#061fh)    |Initialize VDP to [Multicolour Mode](#multicolor_mode)
|0078H      |[SETTXT](#settxt)  |[0594H](#0594h)    |Set VDP to [40x24 Text Mode](#40x24_text_mode)
|007BH      |[SETT32](#sett32)  |[05B4H](#05b4h)    |Set VDP to [32x24 Text Mode](#32x24_text_mode)
|007EH      |[SETGRP](#setgrp)  |[0602H](#0602h)    |Set VDP to [Graphics Mode](#graphics_mode)
|0081H      |[SETMLT](#setmlt)  |[0659H](#0659h)    |Set VDP to [Multicolour Mode](#multicolour_mode)
|0084H      |[CALPAT](#calpat)  |[06E4H](#06e4h)    |Calculate address of sprite pattern
|0087H      |[CALATR](#calatr)  |[06F9H](#06f9h)    |Calculate address of sprite attribute
|008AH      |[GSPSIZ](#gspsiz)  |[0704H](#0704h)    |Get sprite size
|008DH      |[GRPPRT](#grpprt)  |[1510H](#1510h)    |Print character on graphic screen
|0090H      |[GICINI](#gicini)  |[04BDH](#04bdh)    |Initialize PSG (GI Chip)
|0093H      |[WRTPSG](#wrtpsg)  |[1102H](#1102h)    |Write to any PSG register
|0096H      |[RDPSG](#rdpsg)    |[110EH](#110eh)    |Read from any PSG register
|0099H      |[STRTMS](#strtms)  |[11C4H](#11c4h)    |Start music dequeueing
|009CH      |[CHSNS](#chsns)    |[0D6AH](#0d6ah)    |Sense keyboard buffer for character
|009FH      |[CHGET](#chget)    |[10CBH](#10cbh)    |Get character from keyboard buffer (wait)
|00A2H      |[CHPUT](#chput)    |[08BCH](#08bch)    |Screen character output
|00A5H      |[LPTOUT](#lptout)  |[085DH](#085dh)    |Line printer character output
|00A8H      |[LPTSTT](#lptstt)  |[0884H](#0884h)    |Line printer status test
|00ABH      |[CNVCHR](#cnvchr)  |[089DH](#089dh)    |Convert character with graphic header
|00AEH      |[PINLIN](#pinlin)  |[23BFH](#23bfh)    |Get line from console (editor)
|00B1H      |[INLIN](#inlin)    |[23D5H](#23d5h)    |Get line from console (editor)
|00B4H      |[QINLIN](#qinlin)  |[23CCH](#23cch)    |Display "`?`", get line from console (editor)
|00B7H      |[BREAKX](#breakx)  |[046FH](#046fh)    |Check CTRL-STOP key directly
|00BAH      |[ISCNTC](#iscntc)  |[03FBH](#03fbh)    |Check CRTL-STOP key
|00BDH      |[CKCNTC](#ckcntc)  |[10F9H](#10f9h)    |Check CTRL-STOP key
|00C0H      |[BEEP](#beep)      |[1113H](#1113h)    |Go beep
|00C3H      |[CLS](#cls)        |[0848H](#0848h)    |Clear screen
|00C6H      |[POSIT](#posit)    |[088EH](#088eh)    |Set cursor position
|00C9H      |[FNKSB](#fnksb)    |[0B26H](#0b26h)    |Check if function key display on
|00CCH      |[ERAFNK](#erafnk)  |[0B15H](#0b15h)    |Erase function key display
|00CFH      |[DSPFNK](#dspfnk)  |[0B2BH](#0b2bh)    |Display function keys
|00D2H      |[TOTEXT](#totext)  |[083BH](#083bh)    |Return VDP to text mode
|00D5H      |[GTSTCK](#gtstck)  |[11EEH](#11eeh)    |Get joystick status
|00D8H      |[GTTRIG](#gttrig)  |[1253H](#1253h)    |Get trigger status
|00DBH      |[GTPAD](#gtpad)    |[12ACH](#12ach)    |Get touch pad status
|00DEH      |[GTPDL](#gtpdl)    |[1273H](#1273h)    |Get paddle status
|00E1H      |[TAPION](#tapion)  |[1A63H](#1a63h)    |Tape input ON
|00E4H      |[TAPIN](#tapin)    |[1ABCH](#1abch)    |Tape input
|00E7H      |[TAPIOF](#tapiof)  |[19E9H](#19e9h)    |Tape input OFF
|00EAH      |[TAPOON](#tapoon)  |[19F1H](#19f1h)    |Tape output ON
|00EDH      |[TAPOUT](#tapout)  |[1A19H](#1a19h)    |Tape output
|00F0H      |[TAPOOF](#tapoof)  |[19DDH](#19ddh)    |Tape output OFF
|00F3H      |[STMOTR](#stmotr)  |[1384H](#1384h)    |Turn motor ON/OFF
|00F6H      |[LFTQ](#lftq)      |[14EBH](#14ebh)    |Space left in music queue
|00F9H      |[PUTQ](#putq)      |[1492H](#1492h)    |Put byte in music queue
|00FCH      |[RIGHTC](#rightc)  |[16C5H](#16c5h)    |Move current pixel physical address right
|00FFH      |[LEFTC](#leftc)    |[16EEH](#16eeh)    |Move current pixel physical address left
|0102H      |[UPC](#upc)        |[175DH](#175dh)    |Move current pixel physical address up
|0105H      |[TUPC](#tupc)      |[173CH](#173ch)    |Test then [UPC](#upc) if legal
|0108H      |[DOWNC](#downc)    |[172AH](#172ah)    |Move current pixel physical address down
|010BH      |[TDOWNC](#tdownc)  |[170AH](#170ah)    |Test then [DOWNC](#downc) if legal
|010EH      |[SCALXY](#scalxy)  |[1599H](#1599h)    |Scale graphics coordinates
|0111H      |[MAPXYC](#mapxyc)  |[15DFH](#15dfh)    |Map graphic coordinates to physical address
|0114H      |[FETCHC](#fetchc)  |[1639H](#1639h)    |Fetch current pixel physical address
|0117H      |[STOREC](#storec)  |[1640H](#1640h)    |Store current pixel physical address
|011AH      |[SETATR](#setatr)  |[1676H](#1676h)    |Set attribute byte
|011DH      |[READC](#readc)    |[1647H](#1647h)    |Read attribute of current pixel
|0120H      |[SETC](#setc)      |[167EH](#167eh)    |Set attribute of current pixel
|0123H      |[NSETCX](#nsetcx)  |[1809H](#1809h)    |Set attribute of number of pixels
|0126H      |[GTASPC](#gtaspc)  |[18C7H](#18c7h)    |Get aspect ratio
|0129H      |[PNTINI](#pntini)  |[18CFH](#18cfh)    |Paint initialize
|012CH      |[SCANR](#scanr)    |[18E4H](#18e4h)    |Scan pixels to right
|012FH      |[SCANL](#scanl)    |[197AH](#197ah)    |Scan pixels to left
|0132H      |[CHGCAP](#chgcap)  |[0F3DH](#0f3dh)    |Change Caps Lock LED
|0135H      |[CHGSND](#chgsnd)  |[0F7AH](#0f7ah)    |Change Key Click sound output
|0138H      |[RSLREG](#rslreg)  |[144CH](#144ch)    |Read Primary Slot Register
|013BH      |[WSLREG](#wslreg)  |[144FH](#144fh)    |Write to Primary Slot Register
|013EH      |[RDVDP](#rdvdp)    |[1449H](#1449h)    |Read VDP Status Register
|0141H      |[SNSMAT](#snsmat)  |[1452H](#1452h)    |Read row of keyboard matrix
|0144H      |[PHYDIO](#phydio)  |[148AH](#148ah)    |Disk, no action
|0147H      |[FORMAT](#format)  |[148EH](#148eh)    |Disk, no action
|014AH      |[ISFLIO](#isflio)  |[145FH](#145fh)    |Check for file I/O
|014DH      |[OUTDLP](#outdlp)  |[1B63H](#1b63h)    |Formatted output to line printer
|0150H      |[GETVCP](#getvcp)  |[1470H](#1470h)    |Get music voice pointer
|0153H      |[GETVC2](#getvc2)  |[1474H](#1474h)    |Get music voice pointer
|0156H      |[KILBUF](#kilbuf)  |[0468H](#0468h)    |Clear keyboard buffer
|0159H      |[CALBAS](#calbas)  |[01FFH](#01ffh)    |Call to BASIC from any slot
|015CH      |......             |.....              |NOPs to 01B5H for expansion

<a name="01b6h"></a><a name="rdslt"></a>

```
Address... 01B6H
Name...... RDSLT
Entry..... A=Slot ID, HL=Address
Exit...... A=Byte read
Modifies.. AF, BC, DE, DI
```

Standard routine to read a single byte from memory in any slot. The Slot Identifier is composed of a Primary Slot number a Secondary Slot number and a flag:

<a name="figure34"></a>![][CH04F34]

**Figure 34:** Slot ID

The flag is normally 0 but must be 1 if a Secondary Slot number is included in the Slot ID. The memory address and Slot ID are first processed ([027EH](#027eh)) to yield a set of bit masks to apply to the relevant slot register. If a Secondary Slot number is specified then the Secondary Slot Register is first modified to select the relevant page from that Secondary Slot ([02A3H](#02a3h)). The Primary Slot is then switched in to the Z80 address space, the byte read and the Primary Slot restored to its original setting via the [RDPRIM](#rdprim) routine in the Workspace Area. Finally, if a Secondary Slot number is included in the Slot ID, the original Secondary Slot Register setting is restored (01ECH).

Note that, unless it is the slot containing the Workspace Area, any attempt to access page 3 (C000H to FFFFH) will cause the system to crash as [RDPRIM](#rdprim) will switch itself out. Note also that interrupts are left disabled by all the memory switching routines.

<a name="01d1h"></a><a name="wrslt"></a>

```
Address... 01D1H
Name...... WRSLT
Entry..... A=Slot ID, HL=Address, E=Byte to write
Exit...... None
Modifies.. AF, BC, D, DI
```

Standard routine to write a single byte to memory in any slot. Its operation is fundamentally the same as that of the [RDSLT](#rdslt) standard routine except that the Workspace Area routine [WRPRIM](#wrprim) is used rather than [RDPRIM](#rdprim).

<a name="01ffh"></a><a name="calbas"></a>

```
Address... 01FFH
Name...... CALBAS
Entry..... IX=Address
Exit...... None
Modifies.. AF', BC', DE', HL', IY, DI
```

Standard routine to call an address in the BASIC Interpreter from any slot. Usually this will be from a machine code program running in an extension ROM in page 1 (4000H to 7FFFH). The high byte of register pair IY is loaded with the MSX ROM Slot ID (00H) and control transfers to the [CALSLT](#calslt) standard routine.

<a name="0205h"></a><a name="callf"></a>

```
Address... 0205H
Name...... CALLF
Entry..... None
Exit...... None
Modifies.. AF', BC', DE', HL', IX, IY, DI
```

Standard routine to call an address in any slot. The Slot ID and address are supplied as inline parameters rather than in registers to fit inside a hook ([Chapter 6](chapter_6)), for example:

```
RST 30H
DEFB Slot ID
DEFW Address
RET
```

The Slot ID is first collected and placed in the high byte of register pair IY. The address is then placed in register pair IX and control drops into the [CALSLT](#calslt) standard routine.

<a name="0217h"></a><a name="calslt"></a>

```
Address... 0217H
Name...... CALSLT
Entry..... IY(High byte)=Slot ID, IX=Address
Exit...... None
Modifies.. AF', BC', DE', HL', DI
```

Standard routine to call an address in any slot. Its operation is fundamentally the same as that of the [RDSLT](#rdslt) standard routine except that the Workspace Area routine [CLPRIM](#clprim) is used rather than [RDPRIM](#rdprim). Note that [CALBAS](#calbas) and [CALLF](#callf) are just specialized entry points to this standard routine which offer a reduction in the amount of code required.

<a name="025eh"></a><a name="enaslt"></a>

```
Address... 025EH
Name...... ENASLT
Entry..... A=Slot ID, HL=Address
Exit...... None
Modifies.. AF, BC, DE, DI
```

Standard routine to switch in a page permanently from any slot. Unlike the [RDSLT](#rdslt), [WRSLT](#wrslt) and [CALSLT](#calslt) standard routines the Primary Slot switching is performed directly and not by a Workspace Area routine. Consequently addresses in page 0 (0000H to 3FFFH) will cause an immediate system crash.

<a name="027eh"></a>

    Address... 027EH

This routine is used by the memory switching standard routines to turn an address, in register pair HL, and a Slot ID, in register A, into a set of bit masks. As an example a Slot ID of FxxxSSPP and an address in Page 1 (4000H to 7FFFH) would return the following:

```
Register B=00 00 PP 00 (OR mask)
Register C=11 11 00 11 (AND mask)
Register D=PP PP PP PP (Replicated)
Register E=00 00 11 00 (Page mask)
```

Registers B and C are derived from the Primary Slot number and the page mask. They are later used to mix the new Primary Slot number into the existing contents of the Primary Slot Register. Register D contains the Primary Slot number replicated four times and register E the page mask. This is produced by examining the two most significant bits of the address, to determine the page number, and then shifting the mask along to the relevant position. These registers are later used during Secondary Slot switching.

As the routine terminates bit 7 of the Slot ID is tested, to determine whether a Secondary Slot has been specified, and Flag M returned if this is so.

<a name="02a3h"></a>

    Address... 02A3H

This routine is used by the memory switching standard routines to modify a Secondary Slot Register. The Slot ID is supplied in register A while registers D and E contain the bit masks shown in the previous routine.

Bits 6 and 7 of register D are first copied into the Primary Slot register. This switches in page 3 from the Primary Slot specified by the Slot ID and makes the required Secondary Slot Register available. This is then read from memory location FFFFH and the page mask, inverted, used to clear the required two bits. The Secondary Slot number is shifted to the relevant position and mixed in. Finally the new setting is placed in the Secondary Slot Register and the Primary Slot Register restored to its original setting.

<a name="02d7h"></a><a name="chkram"></a>

```
Address... 02D7H
Name...... CHKRAM
Entry..... None
Exit...... None
Modifies.. AF, BC, DE, HL, SP
```

Standard routine to perform memory initialization at power- up. It non-destructively tests for RAM in pages 2 and 3 in all sixteen possible slots then sets the Primary and Secondary Slot registers to switch in the largest area found. The entire Workspace Area (F380H to FFC9H) is zeroed and [EXPTBL](#exptbl) and [SLTTBL](#slttbl) filled in to map any expansion interfaces in existence Interrupt Mode 1 is set and control transfers to the remainder of the power-up initialization routine ([7C76H](#7c76h)).

<a name="03fbh"></a><a name="iscntc"></a>

```
Address... 03FBH
Name...... ISCNTC
Entry..... None
Exit...... None
Modifies.. AF, EI
```

Standard routine to check whether the CTRL-STOP or STOP keys have been pressed. It is used by the BASIC Interpreter at the end of each statement to check for program termination. [BASROM](#basrom) is first examined to see if it contains a non-zero value, if so the routine terminates immediately. This is to prevent users breaking into any extension ROM containing a BASIC program.

[INTFLG](#intflg) is then checked to determine whether the interrupt handler has placed the CTRL-STOP or STOP key codes (03H or 04H) there. If STOP has been detected then the cursor is turned on ([09DAH](#09dah)) and [INTFLG](#intflg) continually checked until one of the two key codes reappears. The cursor is then turned off ([0A27H](#0a27h)) and, if the key is STOP, the routine terminates.

If CTRL-STOP has been detected then the keyboard buffer is first cleared via the [KILBUF](#kilbuf) standard routine and [TRPTBL](#trptbl) is checked to see whether an "`ON STOP GOSUB`" statement is active. If so the relevant entry in [TRPTBL](#trptbl) is updated ([0EF1H](#0ef1h)) and the routine terminates as the event will be handled by the Interpreter Runloop. Otherwise the [ENASLT](#enaslt) standard routine is used to switch in page 1 from the MSX ROM, in case an extension ROM is using the routine, and control transfers to the "`STOP`" statement handler (63E6H).

<a name="0468h"></a><a name="kilbuf"></a>

```
Address... 0468H
Name...... KILBUF
Entry..... None
Exit...... None
Modifies.. HL
```

Standard Routine to clear the forty character type-ahead keyboard buffer [KEYBUF](#keybuf). There are two pointers into this buffer, [PUTPNT](#putpnt) where the interrupt handler places characters, and [GETPNT](#getpnt) where application programs fetch them from. As the number of characters in the buffer is indicated by the difference between these two pointers [KEYBUF](#keybuf) is emptied simply by making them both equal.

<a name="046fh"></a><a name="breakx"></a>

```
Address... 046FH
Name...... BREAKX
Entry..... None
Exit...... Flag C if CTRL-STOP key pressed
Modifies.. AF
```

Standard routine which directly tests rows 6 and 7 of the keyboard to determine whether the CTRL and STOP keys are both pressed. If they are then [KEYBUF](#keybuf) is cleared and row 7 of [OLDKEY](#oldkey) modified to prevent the interrupt handler picking the keys up as well. This routine may often be more suitable for use by an application program, in preference to [ISCNTC](#iscntc), as it will work when interrupts are disabled, during cassette I/O for example, and does not exit to the Interpreter.

<a name="049dh"></a><a name="initio"></a>

```
Address... 049DH
Name...... INITIO
Entry..... None
Exit...... None
Modifies.. AF, E, EI
```

Standard routine to initialize the PSG and the Centronics Status Port. [PSG Register 7](#register_7) is first set to 80H making PSG Port B=Output and PSG Port A=Input. [PSG Register 15](#register_15) is set to CFH to initialize the Joystick connector control hardware. [PSG Register 14](#register_14) is then read and the Keyboard Mode bit placed in [KANAMD](#kanamd), this has no relevance for UK machines.

Finally a value of FFH is output to the Centronics Status Port (I/O port 90H) to set the [STROBE](#strobe) signal high. Control then drops into the [GICINI](#gicini) standard routine to complete initialization.

<a name="04bdh"></a><a name="gicini"></a>

```
Address... 04BDH
Name...... GICINI
Entry..... None
Exit...... None
Modifies.. EI
```

Standard routine to initialize the PSG and the Workspace Area variables associated with the "`PLAY`" statement. [QUETAB](#quetab), [VCBA](#vcba), [VCBB](#vcbb) and [VCBC](#vcbc) are first initialized with the values shown in Chapter 6. PSG Registers [8](#register_8), [9](#register_9) and [10](#register_10) are then set to zero amplitude and [PSG Register 7](#register_7) to B8H. This enables the Tone Generator and disables the Noise Generator on each channel.

<a name="0508h"></a>

    Address... 0508H

This six byte table contains the "`PLAY`" statement parameters initially placed in [VCBA](#vcba), [VCBB](#vcbb) and [VCBC](#vcbc) by the [GICINI](#gicini) standard routine: Octave=4, Length=4, Tempo=120, Volume=88H, Envelope=00FFH.

<a name="050eh"></a><a name="initxt"></a>

```
Address... 050EH
Name...... INITXT
Entry..... None
Exit...... None
Modifies.. AF, BC, DE, HL, EI
```

Standard routine to initialize the VDP to [40x24 Text Mode](#40x24_text_mode). The screen is temporarily disabled via the [DISSCR](#disscr) standard routine and [SCRMOD](#scrmod) and [OLDSCR](#oldscr) set to 00H. The parameters required by the [CHPUT](#chput) standard routine are set up by copying [LINL40](#linl40) to [LINLEN](#linlen), [TXTNAM](#txtnam) to [NAMBAS](#nambas) and [TXTCGP](#txtcgp) to [CGPBAS](#cgpbas). The VDP colours are then set by the [CHGCLR](#chgclr) standard routine and the screen is cleared (077EH). The current character set is copied into the VRAM Character Pattern Table ([071EH](#071eh)). Finally the VDP mode and base addresses are set via the [SETTXT](#settxt) standard routine and the screen is enabled.

<a name="0538h"></a><a name="init32"></a>

```
Address... 0538H
Name...... INIT32
Entry..... None
Exit...... None
Modifies.. AF, BC, DE, HL, EI
```

Standard routine to initialize the VDP to [32x24 Text Mode](#32x24_text_mode). The screen is temporarily disabled via the [DISSCR](#disscr) standard routine and [SCRMOD](#scrmod) and [OLDSCR](#oldscr) set to 01H. The parameters required by the [CHPUT](#chput) standard routine are set up by copying [LINL32](#linl32) to [LINLEN](#linlen), [T32NAM](#t32nam) to [NAMBAS](#nambas), [T32CGP](#t32cgp) to [CGPBAS](#cgpbas), [T32PAT](#t32pat) to [PATBAS](#patbas) and [T32ATR](#t32atr) to [ATRBAS](#atrbas). The VDP colours are then set via the [CHGCLR](#chgclr) standard routine and the screen is cleared (077EH). The current character set is copied into the VRAM Character Pattern Table ([071EH](#071eh)) and all sprites cleared (06BBH). Finally the VDP mode and base addresses are set via the [SETT32](#sett32) standard routine and the screen is enabled.

<a name="0570h"></a><a name="enascr"></a>

```
Address... 0570H
Name...... ENASCR
Entry..... None
Exit...... None
Modifies.. AF, BC, EI
```

Standard routine to enable the screen. This simply involves setting bit 6 of VDP [Mode Register 1](#mode_register_1).

<a name="0577h"></a><a name="disscr"></a>

```
Address... 0577H
Name...... DISSCR
Entry..... None
Exit...... None
Modifies.. AF, BC, EI
```

Standard routine to disable the screen. This simply involves resetting bit 6 of VDP [Mode Register 1](#mode_register_1).

<a name="057fh"></a><a name="wrtvdp"></a>

```
Address... 057FH
Name...... WRTVDP
Entry..... B=Data byte, C=VDP Mode Register number
Exit...... None
Modifies.. AF, B, EI
```

Standard routine to write a data byte to any VDP [Mode Register](#vdp_mode_registers). The register selection byte is first written to the VDP [Command Port](#commandpport), followed by the data byte. This is then copied to the relevant register image, [RG0SAV](#rg0sav) to [RG7SAV](#rg7sav), in the Workspace Area

<a name="0594h"></a><a name="settxt"></a>

```
Address... 0594H
Name...... SETTXT
Entry..... None
Exit...... None
Modifies.. AF, BC, DE, HL, EI
```

Standard routine to partially set the VDP to [40x24 Text Mode](#40x24_text_mode). The mode bits M1, M2 and M3 are first set in VDP Mode Registers [0](#mode_register_0) and [1](#mode_register_1). The five VRAM table base addresses, beginning with [TXTNAM](#txtnam), are then copied from the Workspace Area into VDP Mode Registers [2](#mode_register_2), [3](#mode_register_3), [4](#mode_register_4), [5](#mode_register_5) and [6](#mode_register_6) ([0677H](#0677h)).

<a name="05b4h"></a><a name="sett32"></a>

```
Address... 05B4H
Name...... SETT32
Entry..... None
Exit...... None
Modifies.. AF, BC, DE, HL, EI
```

Standard routine to partially set the VDP to [32x24 Text Mode](#32x24_text_mode). The mode bits M1, M2 and M3 are first set in VDP Mode Registers [0](#mode_register_0) and [1](#mode_register_1). The five VRAM table base addresses, beginning with [T32NAM](#t32nam), are then copied from the Workspace Area into VDP Mode Registers [2](#mode_register_2), [3](#mode_register_3), [4](#mode_register_4), [5](#mode_register_5) and [6](#mode_register_6) ([0677H](#0677h)).

<a name="05d2h"></a><a name="inigrp"></a>

```
Address... 05D2H
Name...... INIGRP
Entry..... None
Exit...... None
Modifies.. AF, BC, DE, HL, EI
```

Standard routine to initialize the VDP to [Graphics Mode](#graphics_mode). The screen is temporarily disabled via the [DISSCR](#disscr) standard routine and [SCRMOD](#scrmod) set to 02H. The parameters required by the [GRPPRT](#grpprt) standard routine are set up by copying [GRPPAT](#grppat) to [PATBAS](#patbas) and [GRPATR](#grpatr) to [ATRBAS](#atrbas). The character code driver pattern is then copied into the VDP Name Table, the screen cleared (07A1H) and all sprites cleared (06BBH). Finally the VDP mode and base addresses are set via the [SETGRP](#setgrp) standard routine and the screen is enabled.

<a name="0602h"></a><a name="setgrp"></a>

```
Address... 0602H
Name...... SETGRP
Entry..... None
Exit...... None
Modifies.. AF, BC, DE, HL, EI
```

Standard routine to partially set the VDP to [Graphics Mode](#graphics_mode). The mode bits M1, M2 and M3 are first set in VDP Mode Registers [0](#mode_register_0) and [1](#mode_register_1). The five VRAM table base addresses, beginning with [GRPNAM](#grpnam), are then copied from the Workspace Area into VDP Mode Registers [2](#mode_register_2), [3](#mode_register_3), [4](#mode_register_4), [5](#mode_register_5) and [6](#mode_register_6) ([0677H](#0677h)).

<a name="061fh"></a><a name="inimlt"></a>

```
Address... 061FH
Name...... INIMLT
Entry..... None
Exit...... None
Modifies.. AF, BC, DE, HL, EI
```

Standard routine to initialize the VDP to [Multicolour Mode](#multicolour_mode). The screen is temporarily disabled via the [DISSCR](#disscr) standard routine and [SCRMOD](#scrmod) set to 03H. The parameters required by the [GRPPRT](#grpprt) standard routine are set up by copying [MLTPAT](#mltpat) to [PATBAS](#patbas) and [MLTATR](#mltatr) to [ATRBAS](#atrbas). The character code driver pattern is then copied into the VDP Name Table, the screen cleared (07B9H) and all sprites cleared (06BBH). Finally the VDP mode and base addresses are set via the [SETMLT](#setmlt) standard routine and the screen is enabled.

<a name="0659h"></a><a name="setmlt"></a>

```
Address... 0659H
Name...... SETMLT
Entry..... None
Exit...... None
Modifies.. AF, BC, DE, HL, EI
```

Standard routine to partially set the VDP to [Multicolour Mode](#multicolour_mode). The mode bits M1, M2 and M3 are first set in VDP Mode Registers [0](#mode_register_0) and [1](#mode_register_1). The five VRAM table base addresses, beginning with [MLTNAM](#mltnam), are then copied from the Workspace Area to VDP Mode Registers [2](#mode_register_2), [3](#mode_register_3), [4](#mode_register_4), [5](#mode_register_5) and [6](#mode_register_6).

<a name="0677h"></a>

    Address... 0677H

This routine is used by the [SETTXT](#settxt), [SETT32](#sett32), [SETGRP](#setgrp) and [SETMLT](#setmlt) standard routines to copy a block of five table base addresses from the Workspace Area into VDP Mode Registers [2](#mode_register_2), [3](#mode_register_3), [4](#mode_register_4), [5](#mode_register_5) and [6](#mode_register_6). On entry register pair HL points to the relevant group of addresses. Each base address is collected in turn shifted the required number of places and then written to the relevant Mode Register via the [WRTVDP](#wrtvdp) standard routine.

<a name="06a8h"></a><a name="clrspr"></a>

```
Address... 06A8H
Name...... CLRSPR
Entry..... None
Exit...... None
Modifies.. AF, BC, DE, HL, EI
```

Standard routine to clear all sprites. The entire 2 KB Sprite Pattern Table is first filled with zeros via the [FILVRM](#filvrm) standard routine. The vertical coordinate of each of the thirty-two sprite attribute blocks is then set to -47 (D1H) to place the sprite above the top of the screen, the horizontal coordinate is left unchanged.

The pattern numbers in the Sprite Attribute Table are initialized with the series 0, 1, 2, 3, 4,... 31 for 8x8 sprites or the series 0, 4, 8, 12, 16,... 124 for 16x16 sprites. The series to be generated is determined by the Size bit in VDP [Mode Register 1](#mode_register_1). Finally the colour byte of each sprite attribute block is filled in with the colour code contained in [FORCLR](#forclr), this is initially white.

Note that the Size and Mag bits in VDP [Mode Register 1](#mode_register_1) are not affected by this routine. Note also that the [INIT32](#init32), [INIGRP](#inigrp) and [INIMLT](#inimlt) standard routines use this routine with an entry point at 06BBH, leaving the Sprite Pattern Table undisturbed.

<a name="06e4h"></a><a name="calpat"></a>

```
Address... 06E4H
Name...... CALPAT
Entry..... A=Sprite pattern number
Exit...... HL=Sprite pattern address
Modifies.. AF, DE, HL
```

Standard routine to calculate the address of a sprite pattern. The pattern number is first multiplied by eight then, if 16x16 sprites are selected, multiplied by a further factor of four. This is then added to the Sprite Pattern Table base address, taken from [PATBAS](#patbas), to produce the final address.

This numbering system is in line with the BASIC Interpreter's usage of pattern numbers rather than the VDP's when 16x16 sprites are selected. As an example while the Interpreter calls the second pattern number one, it is actually VDP pattern number four. This usage means that the maximum pattern number this routine should allow, when 16x16 sprites are selected, is sixty-three. There is no actual check on this limit so large pattern numbers will produce addresses greater than 3FFFH. Such addresses, when passed to the other VDP routines, will wrap around past zero and corrupt the Character Pattern Table in VRAM.

<a name="06f9h"></a><a name="calatr"></a>

```
Address... 06F9H
Name...... CALATR
Entry..... A=Sprite number
Exit...... HL=Sprite attribute address
Modifies.. AF, DE, HL
```

Standard routine to calculate the address of a sprite attribute block. The sprite number, from zero to thirty-one, is multiplied by four and added to the Sprite Attribute Table base address taken from [ATRBAS](#atrbas).

<a name="0704h"></a><a name="gspsiz"></a>

```
Address... 0704H
Name...... GSPSIZ
Entry..... None
Exit...... A=Bytes in sprite pattern (8 or 32)
Modifies.. AF
```

Standard routine to return the number of bytes occupied by each sprite pattern in the Sprite Pattern Table. The result is determined simply by examining the Size bit in VDP [Mode Register 1](#mode_register_1).

<a name="070fh"></a><a name="ldirmv"></a>

```
Address... 070FH
Name...... LDIRMV
Entry..... BC=Length, DE=RAM address, HL=VRAM address
Exit...... None
Modifies.. AF, BC, DE, EI
```

Standard routine to copy a block into main memory from the VDP VRAM. The VRAM starting address is set via the [SETRD](#setrd) standard routine and then sequential bytes read from the VDP [Data Port](#data_port) and placed in main memory.

<a name="071eh"></a>

    Address... 071EH

This routine is used to copy a 2 KB character set into the VDP Character Pattern Table in any mode. The base address of the Character Pattern Table in VRAM is taken from [CGPBAS](#cgpbas). The starting address of the character set is taken from [CGPNT](#cgpnt). The [RDSLT](#rdslt) standard routine is used to read the character data so this may be situated in an extension ROM.

At power-up [CGPNT](#cgpnt) is initialized with the address contained at ROM location 0004H, which is [1BBFH](#1bbfh). [CGPNT](#cgpnt) is easily altered to produce some interesting results, `POKE &HF920,&HC7:SCREEN 0` provides a thoroughly confusing example.

<a name="0744h"></a><a name="ldirvm"></a>

```
Address... 0744H
Name...... LDIRVM
Entry..... BC=Length, DE=VRAM address, HL=RAM address
Exit...... None
Modifies.. AF, BC, DE, HL, EI
```

Standard routine to copy a block to VRAM from main memory. The VRAM starting address is set via the [SETWRT](#setwrt) standard routine and then sequential bytes taken from main memory and written to the VDP [Data Port](#data_port).

<a name="0777h"></a>

    Address... 0777H

This routine will clear the screen in any VDP mode. In [40x24 Text Mode](#40x24_text_mode) and [32x24 Text Mode](#32x24_text_mode) the Name Table, whose base address is taken from [NAMBAS](#nambas), is first filled with ASCII spaces. The cursor is then set to the home position ([0A7FH](#0a7fh)) and [LINTTB](#linttb), the line termination table, re-initialized. Finally the function key display is restored, if it is enabled, via the [FNKSB](#fnksb) standard routine.

In [Graphics Mode](#graphics_mode) the border colour is first set via VDP [Mode Register 7](#mode_register_7) (0832H). The Colour Table is then filled with the background colour code, taken from [BAKCLR](#bakclr), for both 0 and 1 pixels. Finally the Character Pattern Table is filled with zeroes.

In [Multicolour Mode](#multicolour_mode) the border colour is first set via VDP [Mode Register 7](#mode_register_7) (0832H). The Character Pattern Table is then filled with the background colour taken from [BAKCLR](#bakclr).

<a name="07cdh"></a><a name="wrtvrm"></a>

```
Address... 07CDH
Name...... WRTVRM
Entry..... A=Data byte, HL=VRAM address
Exit...... None
Modifies.. EI
```

Standard routine to write a single byte to the VDP VRAM. The VRAM address is first set up via the [SETWRT](#setwrt) standard routine and then the data byte written to the VDP [Data Port](#data_port). Note that the two seemingly spurious `EX(SP),HL` instructions in this routine, and several others, are required to meet the VDP's timing constraints.

<a name="07d7h"></a><a name="rdvrm"></a>

```
Address... 07D7H
Name...... RDVRM
Entry..... HL=VRAM address
Exit...... A=Byte read
Modifies.. AF, EI
```

Standard routine to read a single byte from the VDP VRAM. The VRAM address is first set up via the [SETRD](#setrd) standard routine and then the byte read from the VDP [Data Port](#data_port).

<a name="07dfh"></a><a name="setwrt"></a>

```
Address... 07DFH
Name...... SETWRT
Entry..... HL=VRAM address
Exit...... None
Modifies.. AF, EI
```

Standard routine to set up the VDP for subsequent writes to VRAM via the [Data Port](#data_port). The address contained in register pair HL is written to the VDP [Command Port](#command_port) LSB first, MSB second as shown in [Figure 7](#figure7). Addresses greater than 3FFFH will wrap around past zero as the two most significant bits of the address are ignored.

<a name="07ech"></a><a name="setrd"></a>

```
Address... 07ECH
Name...... SETRD
Entry..... HL=VRAM address
Exit...... None
Modifies.. AF, EI
```

Standard routine to set up the VDP for subsequent reads from VRAM via the [Data Port](#data_port). The address contained in register pair HL is written to the VDP [Command Port](#command_port) LSB first, MSB second as shown in [Figure 7](#figure7). Addresses greater than 3FFFH will wrap around past zero as the two most significant bits of the address are ignored.

<a name="07f7h"></a><a name="chgclr"></a>

```
Address... 07F7H
Name...... CHGCLR
Entry..... None
Exit...... None
Modifies.. AF, BC, HL, EI
```

Standard routine to set the VDP colours. [SCRMOD](#scrmod) is first examined to determine the appropriate course of action. In [40x24 Text Mode](#40x24_text_mode) the contents of [BAKCLR](#bakclr) and [FORCLR](#forclr) are written to VDP [Mode Register 7](#mode_register_7) to set the colour of the 0 and 1 pixels, these are initially blue and white. Note that in this mode there is no way of specifying the border colour, this will be the same as the 0 pixel colour. In [32x24 Text Mode](#32x24_text_mode), [Graphics Mode](#graphics_mode) or [Multicolour Mode](#multicolour_mode) the contents of [BDRCLR](#bdrclr) are written to VDP [Mode Register 7](#mode_register_7) to set the colour of the border, this is initially blue. Also in [32x24 Text Mode](#32x24_text_mode) the contents of [BAKCLR](#bakclr) and [FORCLR](#forclr) are copied to the whole of the Colour Table to determine the 0 and 1 pixel colours.

<a name="0815h"></a><a name="filvrm"></a>

```
Address... 0815H
Name...... FILVRM
Entry..... A=Data byte, BC=Length, HL=VRAM address
Exit...... None
Modifies.. AF, BC, EI
```

Standard routine to fill a block of the VDP VRAM with a single data byte. The VRAM starting address, contained in register pair HL, is first set up via the [SETWRT](#setwrt) standard routine. The data byte is then repeatedly written to the VDP [Data Port](#data_port) to fill successive VRAM locations.

<a name="083bh"></a><a name="totext"></a>

```
Address... 083BH
Name...... TOTEXT
Entry..... None
Exit...... None
Modifies.. AF, BC, DE, HL, EI
```

Standard routine to return the VDP to either [40x24 Text Mode](#40x24_text_mode) or [32x24 Text Mode](#32x24_text_mode) if it is currently in [Graphics Mode](#graphics_mode) or [Multicolour Mode](#multicolour_mode). It is used by the BASIC Interpreter Mainloop and by the "[INPUT](#input)" statement handler. Whenever the [INITXT](#initxt) or [INIT32](#init32) standard routines are used the mode byte, 00H or 01H, is copied into [OLDSCR](#oldscr). If the mode is subsequently changed to [Graphics Mode](#graphics_mode) or [Multicolour Mode](#multicolour_mode), and then has to be returned to one of the two text modes for keyboard input, this routine ensures that it returns to the same one.

[SCRMOD](#scrmod) is first examined and, if the screen is already in either text mode, the routine simply terminates with no action. Otherwise the previous text mode is taken from [OLDSCR](#oldscr) and passed to the [CHGMOD](#chgmod) standard routine.

<a name="0848h"></a><a name="cls"></a>

```
Address... 0848H
Name...... CLS
Entry..... Flag Z
Exit...... None
Modifies.. AF, BC, DE, EI
```

Standard routine to clear the screen in any mode, it does nothing but call the routine at 0777H. This is actually the "`CLS`" statement handler and, because this indicates that there is illegal text after the statement, it will simply return if entered with Flag NZ.

<a name="084fh"></a><a name="chgmod"></a>

```
Address... 084FH
Name...... CHGMOD
Entry..... A=Screen mode required (0, 1, 2, 3)
Exit...... None
Modifies.. AF, BC, DE, HL, EI
```

Standard routine to set a new screen mode. Register A, containing the required screen mode, is tested and control transferred to [INITXT](#initxt), [INIT32](#init32), [INIGRP](#inigrp) or [INIMLT](#inimlt).

<a name="085dh"></a><a name="lptout"></a>

```
Address... 085DH
Name...... LPTOUT
Entry..... A=Character to print
Exit...... Flag C if CTRL-STOP termination
Modifies.. AF
```

Standard routine to output a character to the line printer via the Centronics Port. The printer status is continually tested, via the [LPTSTT](#lptstt) standard routine, until the printer becomes free. The character is then written to the Centronics Data Port (I/O port 91H) and the [STROBE](#strobe) signal of the Centronics Status Port (I/O port 90H) briefly pulsed low. Note that the [BREAKX](#breakx) standard routine is used to test for the CTRL-STOP key if the printer is busy. If CTRL-STOP is detected a CR code is written to the Centronics Data Port, to flush the printer's line buffer, and the routine terminates with Flag C.

<a name="0884h"></a><a name="lptstt"></a>

```
Address... 0884H
Name...... LPTSTT
Entry..... None
Exit...... A=0 and Flag Z if printer busy
Modifies.. AF
```

Standard routine to test the Centronics Status Port BUSY signal. This just involves reading I/O port 90H and examining the state of bit 1: 0=Ready, 1=Busy.

<a name="088eh"></a><a name="posit"></a>

```
Address... 088EH
Name...... POSIT
Entry..... H=Column, L=Row
Exit...... None
Modifies.. AF, EI
```

Standard routine to set the cursor coordinates. The row and column coordinates are sent to the [OUTDO](#outdo) standard routine as the parameters in an ESC,"Y",Row+1FH, Column+1FH sequence. Note that the BIOS home position has coordinates of 1,1 rather than the 0,0 used by the BASIC Interpreter.

<a name="089dh"></a><a name="cnvchr"></a>

```
Address... 089DH
Name...... CNVCHR
Entry..... A=Character
Exit...... Flag Z,NC=Header; Flag NZ,C=Graphic; Flag Z,C=Normal
Modifies.. AF
```

Standard routine to test for, and convert if necessary, characters with graphic headers. Characters less than 20H are normally interpreted by the output device drivers as control characters. A character code in this range can be treated as a displayable character by preceding it with a graphic header control code (01H) and adding 40H to its value. For example to directly display character code 0DH, rather than have it interpreted as a carriage return, it is necessary to output the two bytes 01H,4DH. This routine is used by the output device drivers, such as the [CHPUT](#chput) standard routine, to check for such sequences.

If the character is a graphic header [GRPHED](#grphed) is set to 01H and the routine terminates, otherwise [GRPHED](#grphed) is zeroed. If the character is outside the range 40H to 5FH it is left unchanged. If it is inside this range, and [GRPHED](#grphed) contains 01H indicating a previous graphic header, it is converted by subtracting 40H.

<a name="08bch"></a><a name="chput"></a>

```
Address... 08BCH
Name...... CHPUT
Entry..... A=Character
Exit...... None
Modifies.. EI
```

Standard routine to output a character to the screen in [40x24 Text Mode](#40x24_text_mode) or [32x24 Text Mode](#32x24_text_mode). [SCRMOD](#scrmod) is first checked and, if the VDP is in either [Graphics Mode](#graphics_mode) or [Multicolour Mode](#multicolour_mode), the routine terminates with no action. Otherwise the cursor is removed ([0A2EH](#0a2eh)), the character decoded ([08DFH](#08dfh)) and then the cursor replaced ([09E1H](#09e1h)). Finally the cursor column position is placed in [TTYPOS](#ttypos), for use by the "`PRINT`" statement, and the routine terminates.

<a name="08dfh"></a>

    Address... 08DFH

This routine is used by the [CHPUT](#chput) standard routine to decode a character and take the appropriate action. The [CNVCHR](#cnvchr) standard routine is first used to check for a graphic character, if the character is a header code (01H) then the routine terminates with no action. If the character is a converted graphic one then the control code decoding section is skipped. Otherwise [ESCCNT](#esccnt) is checked to see if a previous ESC character (1BH) has been received, if so control transfers to the ESC sequence processor ([098FH](#098fh)). Otherwise the character is checked to see if it is smaller than 20H, if so control transfers to the control code processor ([0914H](#0914h)). The character is then checked to see if it is DEL (7FH), if so control transfers to the delete routine (0AE3H).

Assuming the character is displayable the cursor coordinates are taken from [CSRY](#csry) and [CSRX](#csrx) and placed in register pair HL, H=Column, L=Row. These are then converted to a physical address in the VDP Name Table and the character placed there ([0BE6H](#0be6h)). The cursor column position is then incremented ([0A44H](#0a44h)) and, assuming the rightmost column has not been exceeded, the routine terminates. Otherwise the row's entry in [LINTTB](#linttb), the line termination table, is zeroed to indicate an extended logical line, the column number is set to 01H and a LF is performed.

<a name="0908h"></a>

    Address... 0908H

This routine performs the LF operation for the [CHPUT](#chput) standard routine control code processor. The cursor row is incremented ([0A61H](#0a61h)) and, assuming the lowest row has not been exceeded, the routine terminates. Otherwise the screen is scrolled upwards and the lowest row erased (0A88H).

<a name="0914h"></a>

    Address... 0914H

This is the control code processor for the [CHPUT](#chput) standard routine. The table at [092FH](#092fh) is searched for a match with the code and control transferred to the associated address.

<a name="092fh"></a>

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

<a name="0953h"></a>

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

<a name="0980h"></a>

    Address... 0980H

This routine performs the ESC,"x" operation for the [CHPUT](#chput) standard routine control code processor. [ESCCNT](#esccnt) is set to 01H to indicate that the next character received is a parameter.

<a name="0983h"></a>

    Address... 0983H

This routine performs the ESC,"y" operation for the [CHPUT](#chput) standard routine control code decoder. [ESCCNT](#esccnt) is set to 02H to indicate that the next character received is a parameter.

<a name="0986h"></a>

    Address... 0986H

This routine performs the ESC",Y" operation for the [CHPUT](#chput) standard routine control code processor. [ESCCNT](#esccnt) is set to 04H to indicate that the next character received is a parameter.

<a name="0989h"></a>

    Address... 0989H

This routine performs the ESC operation for the [CHPUT](#chput) standard routine control code processor. [ESCCNT](#esccnt) is set to FFH to indicate that the next character received is the second control character.

<a name="098fh"></a>

    Address... 098FH

This is the [CHPUT](#chput) standard routine ESC sequence processor. If [ESCCNT](#esccnt) contains FFH then the character is the second control character and control transfers to the control code processor (0919H) to search the ESC code table at [0953H](#0953h).

If [ESCCNT](#esccnt) contains 01H then the character is the single parameter of the ESC,"x" sequence. If the parameter is "4" (34H) then [CSTYLE](#cstyle) is set to 00H resulting in a block cursor. If the parameter is "5" (35H) then [CSRSW](#csrsw) is set to 00H making the cursor normally disabled.

If [ESCCNT](#esccnt) contains 02H then the character is the single parameter in the ESC,"y" sequence. If the parameter is "4" (34H) then [CSTYLE](#cstyle) is set to 01H resulting in an underline cursor. If the parameter is "5" (35H) then [CSRSW](#csrsw) is set to 01H making the cursor normally enabled.

If [ESCCNT](#esccnt) contains 04H then the character is the first parameter of the ESC,"Y" sequence and is the row coordinate. The parameter has 1FH subtracted and is placed in [CSRY](#csry), [ESCCNT](#esccnt) is then decremented to 03H.

If [ESCCNT](#esccnt) contains 03H then the character is the second parameter of the ESC,"Y" sequence and is the column coordinate. The parameter has 1FH subtracted and is placed in [CSRX](#csrx).

<a name="09dah"></a>

    Address... 09DAH

This routine is used, by the [CHGET](#chget) standard routine for example, to display the cursor character when it is normally disabled. If [CSRSW](#csrsw) is non-zero the routine simply terminates with no action, otherwise the cursor is displayed (09E6H).

<a name="09e1h"></a>

    Address... 09E1H

This routine is used, by the [CHPUT](#chput) standard routine for example, to display the cursor character when it is normally enabled. If [CSRSW](#csrsw) is zero the routine simply terminates with no action. [SCRMOD](#scrmod) is checked and, if the screen is in [Graphics Mode](#graphics_mode) or [Multicolour Mode](#multicolour_mode), the routine terminates with no action. Otherwise the cursor coordinates are converted to a physical address in the VDP Name Table and the character read from that location ([0BD8H](#0bd8h)) and saved in [CURSAV](#cursav).

The character's eight byte pixel pattern is read from the VDP Character Pattern Table into the [LINWRK](#linwrk) buffer ([0BA5H](#0ba5h)). The pixel pattern is then inverted, all eight bytes if [CSTYLE](#cstyle) indicates a block cursor, only the bottom three if [CSTYLE](#cstyle) indicates an underline cursor. The pixel pattern is copied back to the position for character code 255 in the VDP Character Pattern Table ([0BBEH](#0bbeh)). The character code 255 is then placed at the current cursor location in the VDP Name Table ([0BE6H](#0be6h)) and the routine terminates.

This method of generating the cursor character, by using character code 255, can produce curious effects under certain conditions. These can be demonstrated by executing the BASIC statement `FOR N=1 TO 100: PRINT CHR$(255);:NEXT` and then pressing the cursor up key.

<a name="0a27h"></a>

    Address... 0A27H

This routine is used, by the [CHGET](#chget) standard routine for example, to remove the cursor character when it is normally disabled. If [CSRSW](#csrsw) is non-zero the routine simply terminates with no action, otherwise the cursor is removed (0A33H).

<a name="0a2eh"></a>

    Address... 0A2EH

This routine is used, by the [CHPUT](#chput) standard routine for example, .to remove the cursor character when it is normally enabled. If [CSRSW](#csrsw) is zero the routine simply terminates with no action. [SCRMOD](#scrmod) is checked and, if the screen is in [Graphics Mode](#graphics_mode) or [Multicolour Mode](#multicolour_mode), the routine terminates with no action. Otherwise the cursor coordinates are converted to a physical address in the VDP Name Table and the character held in [CURSAV](#cursav) written to that location ([0BE6H](#0be6h)).

<a name="0a44h"></a>

    Address... 0A44H

This routine performs the ESC,"C" operation for the [CHPUT](#chput) standard routine control code processor. If the cursor column coordinate is already at the rightmost column, determined by [LINLEN](#linlen), then the routine terminates with no action. Otherwise the column coordinate is incremented and [CSRX](#csrx) updated.

<a name="0a4ch"></a>

    Address... 0A4CH

This routine performs the BS/LEFT operation for the [CHPUT](#chput) standard routine control code processor. The cursor column coordinate is decremented and [CSRX](#csrx) updated. If the column coordinate has moved beyond the leftmost position it is set to the rightmost position, from [LINLEN](#linlen), and an UP operation performed.

<a name="0a55h"></a>

    Address... 0A55H

This routine performs the ESC,"D" operation for the [CHPUT](#chput) standard routine control code processor. If the cursor column coordinate is already at the leftmost position then the routine terminates with no action. Otherwise the column coordinate is decremented and [CSRX](#csrx) updated.

<a name="0a57h"></a>

    Address... 0A57H

This routine performs the ESC,"A" (UP) operation for the [CHPUT](#chput) standard routine control code processor. If the cursor row coordinate is already at the topmost position the routine terminates with no action. Otherwise the row coordinate is decremented and [CSRY](#csry) updated.

<a name="0a5bh"></a>

    Address... 0A5BH

This routine performs the RIGHT operation for the [CHPUT](#chput) standard routine control code processor. The cursor column coordinate is incremented and [CSRX](#csrx) updated. If the column coordinate has moved beyond the rightmost position, determined by [LINLEN](#linlen), it is set to the leftmost position (01H) and a DOWN operation performed.

<a name="0a61h"></a>

    Address... 0A61H

This routine performs the ESC,"B" (DOWN) operation for the [CHPUT](#chput) standard routine control code processor. If the cursor row coordinate is already at the lowest position, determined by [CRTCNT](#crtcnt) and [CNSDFG](#cnsdfg) ([0C32H](#0c32h)), then the routine terminates with no action. Otherwise the row coordinate is incremented and [CSRY](#csry) updated.

<a name="0a71h"></a>

    Address... 0A71H

This routine performs the TAB operation for the [CHPUT](#chput) standard routine control code processor. ASCII spaces are output ([08DFH](#08dfh)) until [CSRX](#csrx) is a multiple of eight plus one (BIOS columns 1, 9, 17, 25, 33).

<a name="0a7fh"></a>

    Address... 0A7FH

This routine performs the ESC,"H" (HOME) operation for the [CHPUT](#chput) standard routine control code processor, [CSRX](#csrx) and [CSRY](#csry) are simply set to 1,1. The ROM BIOS cursor coordinate system, while functionally identical to that used by the BASIC Interpreter, numbers the screen rows from 1 to 24 and the columns from 1 to 32/40.

<a name="0a81h"></a>

    Address... 0A81H

This routine performs the CR operation for the [CHPUT](#chput) standard routine control code processor, [CSRX](#csrx) is simply set to 01H .

<a name="0a85h"></a>

    Address... 0A85H

This routine performs the ESC,"M" function for the [CHPUT](#chput) standard routine control code processor. A CR operation is first performed to set the cursor column coordinate to the leftmost position. The number of rows from the current row to the bottom of the screen is then determined, if this is zero the current row is simply erased ([0AECH](#0aech)). The row count is first used to scroll up the relevant section of [LINTTB](#linttb), the line termination table, by one byte. It is then used to scroll up the relevant section of the screen a row at a time. Starting at the row below the current row, each line is copied from the VDP Name Table into the [LINWRK](#linwrk) buffer ([0BAAH](#0baah)) then copied back to the Name Table one row higher ([0BC3H](#0bc3h)). Finally the lowest row on the screen is erased ([0AECH](#0aech)).

<a name="0ab4h"></a>

    Address... 0AB4H

This routine performs the ESC,"L" operation for the [CHPUT](#chput) standard routine control code processor. A CR operation is first performed to set the cursor column coordinate to the leftmost position. The number of rows from the current row to the bottom of the screen is then determined, if this is zero the current row is simply erased ([0AECH](#0aech)). The row count is first used to scroll down the relevant section of [LINTTB](#linttb), the line termination table, by one byte. It is then used to scroll down the relevant section of the screen a row at a time. Starting at the next to last row of the screen, each line is copied from the VDP Name Table into the [LINWRK](#linwrk) buffer ([0BAAH](#0baah)), then copied back to the Name Table one row lower ([0BC3H](#0bc3h)). Finally the current row is erased ([0AECH](#0aech)).

    Address... 0AE3H

This routine is used to perform the DEL operation for the [CHPUT](#chput) standard routine control code processor. A LEFT operation is first performed. If this cannot be completed, because the cursor is already at the home position, then the routine terminates with no action. Otherwise a space is written to the VDP Name Table at the cursor's physical location ([0BE6H](#0be6h)).

<a name="0aech"></a>

    Address... 0AECH

This routine performs the ESC,"l" operation for the [CHPUT](#chput) standard routine control code processor. The cursor column coordinate is set to 01H and control drops into the ESC,"K" routine.

<a name="0aeeh"></a>

    Address... 0AEEH

This routine performs the ESC,"K" operation for the [CHPUT](#chput) standard routine control code processor. The row's entry in [LINTTB](#linttb), the line termination table, is first made non-zero to indicate that the logical line is not extended ([0C29H](#0c29h)). The cursor coordinates are converted to a physical address (0BF2H) in the VDP Name Table and the VDP set up for writes via the [SETWRT](#setwrt) standard routine. Spaces are then written directly to the VDP [Data Port](#data_port) until the rightmost column, determined by [LINLEN](#linlen), is reached.

    Address... 0B05H

This routine performs the ESC,"J" operation for the [CHPUT](#chput) standard routine control code processor. An ESC,"K" operation is performed on successive rows, starting with the current one, until the bottom of the screen is reached.

<a name="0b15h"></a><a name="erafnk"></a>

```
Address... 0B15H
Name...... ERAFNK
Entry..... None
Exit...... None
Modifies.. AF, DE, EI
```

Standard routine to turn the function key display off. [CNSDFG](#cnsdfg) is first zeroed and, if the VDP is in [Graphics Mode](#graphics_mode) or [Multicolour Mode](#multicolour_mode), the routine terminates with no further action. If the VDP is in [40x24 Text Mode](#40x24_text_mode) or [32x24 Text Mode](#32x24_text_mode) the last row on the screen is then erased ([0AECH](#0aech)).

<a name="0b26h"></a><a name="fnksb"></a>

```
Address... 0B26H
Name...... FNKSB
Entry..... None
Exit...... None
Modifies.. AF, BC, DE, EI
```

Standard routine to show the function key display if it is enabled. If [CNSDFG](#cnsdfg) is zero the routine terminates with no action, otherwise control drops into the [DSPFNK](#dspfnk) standard routine..

<a name="0b2bh"></a><a name="dspfnk"></a>

```
Address... 0B2BH
Name...... DSPFNK
Entry..... None
Exit...... None
Modifies.. AF, BC, DE, EI
```

Standard routine to turn the function key display on. [CNSDFG](#cnsdfg) is set to FFH and, if the VDP is in [Graphics Mode](#graphics_mode) or [Multicolour Mode](#multicolour_mode), the routine terminates with no further action. Otherwise the cursor row coordinate is checked and, if the cursor is on the last row of the screen, a LF code (0AH) issued to the [OUTDO](#outdo) standard routine to scroll the screen up.

Register pair HL is then set to point to either the unshifted or shifted function strings in the Workspace Area depending upon whether the SHIFT key is pressed. [LINLEN](#linlen) has four subtracted, to allow a minimum of one space between fields, and is divided by five to determine the field size for each string. Successive characters are then taken from each function string, checked for graphic headers via the [CNVCHR](#cnvchr) standard routine and placed in the [LINWRK](#linwrk) buffer until the string is exhausted or the zone is filled. When all five strings are completed the [LINWRK](#linwrk) buffer is written to the last row in the VDP Name Table ([0BC3H](#0bc3h)).

<a name="0b9ch"></a>

    Address... 0B9CH

This routine is used by the function key display related standard routines. The contents of register A are placed in [CNSDFG](#cnsdfg) then [SCRMOD](#scrmod) tested and Flag NC returned if the screen is in [Graphics Mode](#graphics_mode) or [Multicolour Mode](#multicolour_mode).

<a name="0ba5h"></a>

    Address... 0BA5H

This routine copies eight bytes from the VDP VRAM into the [LINWRK](#linwrk) buffer, the VRAM physical address is supplied in register pair HL.

<a name="0baah"></a>

    Address... 0BAAH

This routine copies a complete row of characters, with the length determined by [LINLEN](#linlen), from the VDP VRAM into the [LINWRK](#linwrk) buffer. The cursor row coordinate is supplied in register L.

<a name="0bbeh"></a>

    Address... 0BBEH

This routine copies eight bytes from the [LINWRK](#linwrk) buffer into the VDP VRAM, the VRAM physical address is supplied in register pair HL.

<a name="0bc3h"></a>

    Address... 0BC3H

This routine copies a complete row of characters, with the length determined by [LINLEN](#linlen), from the [LINWRK](#linwrk) buffer into the VDP VRAM. The cursor row coordinate is supplied in register L.

<a name="0bd8h"></a>

    Address... 0BD8H

This routine reads a single byte from the VDP VRAM into register C. The column coordinate is supplied in register H, the row coordinate in register L.

<a name="0be6h"></a>

    Address... 0BE6H

This routine converts a pair of screen coordinates, the column in register H and the row in register L, into a physical address in the VDP Name Table. This address is returned in register pair HL.

The row coordinate is first multiplied by thirty-two or forty, depending upon the screen mode, and added to the column coordinate. This is then added to the Name Table base address, taken from [NAMBAS](#nambas), to produce an initial address.

Because of the variable screen width, as contained in [LINLEN](#linlen), an additional offset has to be added to the initial address to keep the active region roughly centered within the screen. The difference between the "true" number of characters per row, thirty-two or forty, and the current width is halved and then rounded up to produce the left hand offset. For a UK machine, with a thirty-seven character width in [40x24 Text Mode](#40x24_text_mode), this will result in two unused characters on the left hand side and one on the right. The statement `PRINT (41-WID)\2`, where `WID` is any screen width, will display the left hand column offset in [40x24 Text Mode](#40x24_text_mode).

A complete BASIC program which emulates this routine is given below:

```
10 CPR=40:NAM=BASE(0):WID=PEEK(&HF3AE)
20 SCRMD=PEEK(&HFCAF):IF SCRMD=0 THEN 40
30 CPR=32:NAM=BASE(5):WID=PEEK(&HF3AF)
40 LH=(CPR+1-WID)\2
50 ADDR=NAM+(ROW-1)*CPR+(COL-1)+LH
```

This program is designed for the `ROW` and `COL` coordinate system used by the ROM BIOS where home is 1,1. Line 50 may be simplified, by removing the "-1" factors, if the BASIC Interpreter's coordinate system is to be used.

<a name="0c1dh"></a>

    Address... 0C1DH

This routine calculates the address of a row's entry in [LINTTB](#linttb), the line termination table. The row coordinate is supplied in register L and the address returned in register pair DE.

<a name="0c29h"></a>

    Address... 0C29H

This routine makes a row's entry in [LINTTB](#linttb) non-zero when entered at [0C29H](#0c29h) and zero when entered at 0C2AH. The row coordinate is supplied in register L.

<a name="0c32h"></a>

    Address... 0C32H

This routine returns the number of rows on the screen in register A. It will normally return twenty-four if the function key display is disabled and twenty-three if it is enabled. Note that the screen size is determined by [CRTCNT](#crtcnt) and may be modified with a BASIC statement, `POKE &HF3B1H,14:SCREEN 0` for example.

<a name="0c3ch"></a><a name="keyint"></a>

```
Address... 0C3CH
Name...... KEYINT
Entry..... None
Exit...... None
Modifies.. EI
```

Standard routine to process Z80 interrupts, these are generated by the VDP once every 20 ms on a UK machine. The [VDP Status Register](#vdp_status_register) is first read and bit 7 checked to ensure that this is a frame rate interrupt, if not the routine terminates with no action. The contents of the [Status Register](#vdp_status_register) are saved in [STATFL](#statfl) and bit 5 checked for sprite coincidence. If the Coincidence Flag is active then the relevant entry in [TRPTBL](#trptbl) is updated ([0EF1H](#0ef1h)).

[INTCNT](#intcnt), the "`INTERVAL`" counter, is then decremented. If this has reached zero the relevant entry in [TRPTBL](#trptbl) is updated ([0EF1H](#0ef1h)) and the counter reset with the contents of [INTVAL](#intval).

[JIFFY](#jiffy), the "`TIME`" counter, is then incremented. This counter just wraps around to zero when it overflows.

[MUSICF](#musicf) is examined to determine whether any of the three music queues generated by the "`PLAY`" statement are active. For each active queue the dequeueing routine ([113BH](#113bh)) is called to fetch the next music packet and write it to the PSG.

[SCNCNT](#scncnt) is then decremented to determine if a joystick and keyboard scan is required, if not the interrupt handler terminates with no further action. This counter is used to increase throughput and to minimize keybounce problems by ensuring that a scan is only carried out every three interrupts. Assuming a scan is required joystick connector 1 is selected and the two Trigger bits read ([120CH](#120ch)), followed by the two Trigger bits from joystick connector 2 ([120CH](#120ch)) and the SPACE key from row 8 of the keyboard ([1226H](#1226h)). These five inputs, which are all related to the "`STRIG`" statement, are combined into a single byte where 0=Pressed, 1=Not pressed:

<a name="figure35"></a>![][CH04F35]

**Figure 35:** "`STRIG`" Inputs

This reading is compared with the previous one, held in [TRGFLG](#trgflg), to produce an active transition byte and [TRGFLG](#trgflg) is updated with the new reading. The active transition byte is normally zero but contains a 1 in each position where a transition from unpressed to pressed has occurred. This active transition byte is shifted out bit by bit and the relevant entry in [TRPTBL](#trptbl) updated ([0EF1H](#0ef1h)) for each active device.

A complete scan of the keyboard matrix is then performed to identify new key depressions, any found are translated into key codes and placed in [KEYBUF](#keybuf) ([0D12H](#0d12h)). If [KEYBUF](#keybuf) is found to be empty at the end of this process [REPCNT](#repcnt) is decremented to see whether the auto-repeat delay has expired, if not the routine terminates. If the delay period has expired [REPCNT](#repcnt) is reset with the fast repeat value (60 ms), the [OLDKEY](#oldkey) keyboard map is reinitialized and the keyboard scanned again (0D4EH). Any keys which are continuously pressed will show up as new transitions during this scan. Note that keys will only auto-repeat while an application program keeps [KEYBUF](#keybuf) empty by reading characters. The interrupt handler then terminates.

<a name="0d12h"></a>

    Address... 0D12H

This routine performs a complete scan of all eleven rows of the keyboard matrix for the interrupt handler. Each of the eleven rows is read in via the PPI and placed in ascending order in [NEWKEY](#newkey). [ENSTOP](#enstop) is then checked to see if warm starts are enabled. If its contents are non-zero and the keys CODE, GRAPH, CTRL and SHIFT are pressed control transfers to the BASIC Interpreter (409BH) via the [CALBAS](#calbas) standard routine. This facility is useful as even a machine code program can be terminated as long as the interrupt handler is running. The contents of [NEWKEY](#newkey) are compared with the previous scan contained in [OLDKEY](#oldkey). If any change at all has occurred [REPCNT](#repcnt) is loaded with the initial auto-repeat delay (780 ms). Each row 1, reading from [NEWKEY](#newkey) is then compared with the previous one, held in [OLDKEY](#oldkey), to produce an active transition byte and [OLDKEY](#oldkey) is updated with the new reading. The active transition byte is normally zero but contains a 1 in each position where a transition from unpressed to pressed has occurred. If the row contains any transitions these are decoded and placed in [KEYBUF](#keybuf) as key codes ([0D89H](#0d89h)). When all eleven rows have been completed the routine checks whether there are any characters in [KEYBUF](#keybuf), by subtracting [GETPNT](#getpnt) from [PUTPNT](#putpnt), and terminates.

<a name="0d6ah"></a><a name="chsns"></a>

```
Address... 0D6AH
Name...... CHSNS
Entry..... None
Exit...... Flag NZ if characters in KEYBUF
Modifies.. AF, EI
```

Standard routine to check if any keyboard characters are ready. If the screen is in [Graphics Mode](#graphincsmode) or [Multicolour Mode](#multicolour_mode) then [GETPNT](#getpnt) is subtracted from [PUTPNT](#putpnt) (0D62H) and the routine terminates. If the screen is in [40x24 Text Mode](#40x24_text_mode) or [32x24 Text Mode](#32x24_text_mode) the state of the SHIFT key is also examined and the function key display updated, via the [DSPFNK](#dspfnk) standard routine, if it has changed.

<a name="0d89h"></a>

    Address... 0D89H

This routine converts each active bit in a keyboard row transition byte into a key code. A bit is first converted into a key number determined by its position in the keyboard matrix:

<a name="figure36"></a>![][CH04F36]

**Figure 36:** Key Numbers

The key number is then converted into a key code and placed in [KEYBUF](#keybuf) ([1021H](#1021h)). When all eight possible bits have been processed the routine terminates.

<a name="0da5h"></a>

    Address... 0DA5H

This table contains the key codes of key numbers 00H to 2FH for various combinations of the control keys. A zero entry in the table means that no key code will be produced when that key is pressed:

```
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
```

</a>

<a name="0ec5h"></a>

    Address... 0EC5H

Control transfers to this routine, from [0FC3H](#0fc3h), to complete decoding of the five function keys. The relevant entry in [FNKFLG](#fnkflg) is first checked to determine whether the key is associated with an "`ON KEY GOSUB`" statement. If so, and provided that [CURLIN](#curlin) shows the BASIC Interpreter to be in program mode, the relevant entry in [TRPTBL](#trptbl) is updated ([0EF1H](#0ef1h)) and the routine terminates. If the key is not tied to an "`ON KEY GOSUB`" statement, or if the Interpreter is in direct mode, the string of characters associated with the function key is returned instead. The key number is multiplied by sixteen, as each string is sixteen characters long, and added to the starting address of the function key strings in the Workspace Area. Sequential characters are then taken from the string and placed in [KEYBUF](#keybuf) ([0F55H](#0f55h)) until the zero byte terminator is reached.

<a name="0ef1h"></a>

    Address... 0EF1H

This routine is used to update a device's entry in [TRPTBL](#trptbl) when it has produced a BASIC program interrupt. On entry register pair HL points to the device's status byte in the table. Bit 0 of the status byte is checked first, if the device is not "`ON`" then the routine terminates with no action. Bit 2, the event flag, is then checked. If this is already set then the routine terminates, otherwise it is set to indicate that an event has occurred. Bit 1, the "`STOP`" flag, is then checked. If the device is stopped then the routine terminates with no further action. Otherwise [ONGSBF](#ongsbf) is incremented to signal to the Interpreter Runloop that the event should now be processed.

<a name="0f06h"></a>

    Address... 0F06H

This section of the key decoder processes the HOME key only. The state of the SHIFT key is determined via row 6 of [NEWKEY](#newkey) and the key code for HOME (0BH) or CLS (0CH) placed in [KEYBUF](#keybuf) ([0F55H](#0f55h)) accordingly.

<a name="0f10h"></a>

    Address... 0F10H

This section of the keyboard decoder processes key numbers 30H to 57H apart from the CAP, F1 to F5, STOP and HOME keys. The key number is simply used to look up the key code in the table at [1033H](#1033h) and this is then placed in [KEYBUF](#keybuf) ([0F55H](#0f55h)).

<a name="0f1fh"></a>

    Address... 0F1FH

This section of the keyboard decoder processes the DEAD key found on European MSX machines. On UK machines the key in row 2, column 5 always generates the pound key code (9CH) shown in the table at 0DA5H. On European machines this table will have the key code FFH in the same locations. This key code only serves as a flag to indicate that the next key pressed, if it is a vowel, should be modified to produce an accented graphics character.

The state of the SHIFT and CODE keys is determined via row 6 of [NEWKEY](#newkey) and one of the following placed in [KANAST](#kanast): 01H=DEAD, 02H=DEAD+SHIFT, 03H=DEAD+CODE, 04H=DEAD+SHIFT+CODE.

<a name="0f36h"></a>

    Address... 0F36H

This section of the keyboard decoder processes the CAP key. The current state of [CAPST](#capst) is inverted and control drops into the [CHGCAP](#chgcap) standard routine.

<a name="0f3dh"></a><a name="chgcap"></a>

```
Address... 0F3DH
Name...... CHGCAP
Entry..... A=ON/OFF Switch
Exit...... None
Modifies.. AF
```

Standard routine to turn the Caps Lock LED on or off as determined by the contents of register A: 00H=On, NZ=Off. The LED is modified using the bit set/reset facility of the PPI Mode Port. As [CAPST](#capst) is not changed this routine does not affect the characters produced by the keyboard.

<a name="0f46h"></a>

    Address... 0F46H

This section of the keyboard decoder processes the STOP key. The state of the CTRL key is determined via row 6 of [NEWKEY](#newkey) and the key code for STOP (04H) or CTRL/STOP (03H) produced as appropriate. If the CTRL/STOP code is produced it is copied to [INTFLG](#intflg), for use by the [ISCNTC](#iscntc) standard routine, and then placed in [KEYBUF](#keybuf) ([0F55H](#0f55h)). If the STOP code is produced it is also copied to [INTFLG](#intflg) but is not placed in [KEYBUF](#keybuf), instead only a click is generated (0F64H). This means that an application program cannot read the STOP key code via the ROM BIOS standard routines.

<a name="0f55h"></a>

    Address... 0F55H

This section of the keyboard decoder places a key code in [KEYBUF](#keybuf) and generates an audible click. The correct address in the keyboard buffer is first taken from [PUTPNT](#putpnt) and the code placed there. The address is then incremented ([105BH](#105bh)). If it has wrapped round and caught up with [GETPNT](#getpnt) then the routine terminates with no further action as the keyboard buffer is full. Otherwise [PUTPNT](#putpnt) is updated with the new address.

[CLIKSW](#cliksw) and [CLIKFL](#clikfl) are then both checked to determine whether a click is required. [CLIKSW](#cliksw) is a general enable/disable switch while [CLIKFL](#clikfl) is used to prevent multiple clicks when the function keys are pressed. Assuming a click is required the Key Click output is set via the [PPI Mode Port](#ppi_mode_port) and, after a delay of 50 µs, control drops into the [CHGSND](#chgsnd) standard routine.

<a name="0f7ah"></a><a name="chgsnd"></a>

```
Address... 0F7AH
Name...... CHGSND
Entry..... A=ON/OFF Switch
Exit...... None
Modifies.. AF
```

Standard routine to set or reset the Key Click output via the [PPI Mode Port](#ppi_mode_port): 00H=Reset, NZ=Set. This audio output is AC coupled so absolute polarities should not be taken too seriously.

<a name="0f83h"></a>

    Address... 0F83H

This section of the keyboard decoder processes key numbers 00H to 2FH. The state of the SHIFT, GRAPH and CODE keys is determined via row 6 of [NEWKEY](#newkey) and combined with the key number to form a look-up address into the table at [0DA5H](#0da5h). The key code is then taken from the table. If it is zero the routine terminates with no further action, if it is FFH control transfers to the DEAD key processor ([0F1FH](#0f1fh)). If the code is in the range 40H to 5FH or 60H to 7FH and the CTRL key is pressed then the corresponding control code is placed in [KEYBUF](#keybuf) ([0F55H](#0f55h)). If the code is in the range 01H to 1FH then a graphic header code (01H) is first placed in [KEYBUF](#keybuf) ([0F55H](#0f55h)) followed by the code with 40H added. If the code is in the range 61H to 7BH and [CAPST](#capst) indicates that caps lock is on then it is converted to upper case by subtracting 20H. Assuming that [KANAST](#kanast) contains zero, as it always will on UK machines, then the key code is placed in [KEYBUF](#keybuf) ([0F55H](#0f55h)) and the routine terminates. On European MSX machines, with a DEAD key instead of a pound key, then the key codes corresponding to the vowels a, e, i, o, u may be further modified into graphics codes.

<a name="0fc3h"></a>

    Address... 0FC3H

This section of the keyboard decoder processes the five function keys. The state of the SHIFT key is examined via row 6 of [NEWKEY](#newkey) and five added to the key number if it is pressed. Control then transfers to [0EC5H](#0ec5h) to complete processing.

<a name="1021h"></a>

    Address... 1021H

This routine searches the table at [1B97H](#1b97h) to determine which group of keys the key number supplied in register C belongs to. The associated address is then taken from the table and control transferred to that section of the keyboard decoder. Note that the table itself is actually patched into the middle of the [OUTDO](#outdo) standard routine as a result of the modifications made to the Japanese ROM.

<a name="1033h"></a>

    Address... 1033H

This table contains the key codes of key numbers 30H to 57H other than the special keys CAP, F1 to F5, STOP and HOME. A zero entry in the table means that no key code will be produced when that key is pressed:

```
00H 00H 00H 00H 00H 00H 00H 00H Row 6
0DH 18H 08H 00H 09H 1BH 00H 00H Row 7
1CH 1FH 1EH 1DH 7FH 12H 0CH 20H Row 8
34H 33H 32H 31H 30H 00H 00H 00H Row 9
2EH 2CH 2DH 39H 38H 37H 36H 35H Row 10

 7   6   5   4   3   2   1   0  Column
```

</a>

<a name="105bh"></a>

    Address... 105BH

This routine simply zeroes [KANAST](#kanast) and then transfers control to [10C2H](#10c2h).

<a name="1061h"></a>

    Address... 1061H

This table contains the graphics characters which replace the vowels a, e, i, o, u on European machines.

<a name="10c2h"></a>

    Address... 10C2H

This routine increments the keyboard buffer pointer, either [PUTPNT](#putpnt) or [GETPNT](#getpnt), supplied in register pair HL. If the pointer then exceeds the end of the keyboard buffer it is wrapped back to the beginning.

<a name="10cbh"></a><a name="chget"></a>

```
Address... 10CBH
Name...... CHGET
Entry..... None
Exit...... A=Character from keyboard
Modifies.. AF, EI
```

Standard routine to fetch a character from the keyboard buffer. The buffer is first checked to see if already contains a character ([0D6AH](#0d6ah)). If not the cursor is turned on ([09DAH](#09dah)), the buffer checked repeatedly until a character appears ([0D6AH](#0d6ah)) and then the cursor turned off ([0A27H](#0a27h)). The character is taken from the buffer using [GETPNT](#getpnt) which is then incremented ([10C2H](#10c2h)).

<a name="10f9h"></a><a name="ckcntc"></a>

```
Address... 10F9H
Name...... CKCNTC
Entry..... None
Exit...... None
Modifies.. AF, EI
```

Standard routine to check whether the CTRL-STOP or STOP keys have been pressed. It is used by the BASIC Interpreter inside processor-intensive statements, such as "`WAIT`" and "`CIRCLE`", to check for program termination. Register pair HL is first zeroed and then control transferred to the [ISCNTC](#iscntc) standard routine. When the Interpreter is running register pair HL normally contains the address of the current character in the BASIC program text. If [ISCNTC](#iscntc) is CTRL-STOP terminated this address will be placed in [OLDTXT](#oldtxt) by the "`STOP`" statement handler (63E6H) for use by a later "`CONT`" statement. Zeroing register pair HL beforehand signals to the "`CONT`" handler that termination occurred inside a statement and it will issue a "`Can't CONTINUE`" error if continuation is attempted.

<a name="1102h"></a><a name="wrtpsg"></a>

```
Address... 1102H
Name...... WRTPSG
Entry..... A=Register number, E=Data byte
Exit...... None
Modifies.. EI
```

Standard routine to write a data byte to any of the sixteen [PSG registers](#registers_0_and_1). The register selection number is written to the PSG [Address Port](#address_port) and the data byte written to the PSG [Data Write Port](#data_write_port).

<a name="110eh"></a><a name="rdpsg"></a>

```
Address... 110EH
Name...... RDPSG
Entry..... A=Register number
Exit...... A=Data byte read from PSG
Modifies.. A
```

Standard routine to read a data byte from any of the sixteen [PSG registers](#registers_0_and_1). The register selection number is written to the PSG [Address Port](#address_port) and the data byte read from the PSG [Data Read Port](#data_read_port).

<a name="1113h"></a><a name="beep"></a>

```
Address... 1113H
Name...... BEEP
Entry..... None
Exit...... None
Modifies.. AF, BC, E, EI
```

Standard routine to produce a beep via the PSG. Channel A is set to produce a tone of 1316Hz then enabled with an amplitude of seven. After a delay of 40 ms control transfers to the [GICINI](#gicini) standard routine to reinitialize the PSG.

<a name="113bh"></a>

    Address... 113BH

This routine is used by the interrupt handler to service a music queue. As there are three of these, each feeding a PSG channel, the queue to be serviced is specified by supplying its number in register A: 0=[VOICAQ](#voicaq), 1=[VOICBQ](#voicbq) and 2=[VOICCQ](#voiccq).

Each string in a "`PLAY`" statement is translated into a series of data packets by the BASIC Interpreter. These are placed in the appropriate queue followed by an end of data byte (FFH). The task of dequeueing the packets, decoding them and setting the PSG is left to the interrupt handler. The Interpreter is thus free to proceed immediately to the next statement without having to wait for notes to finish.

The first two bytes of any packet specify its byte count and duration. The three most significant bits of the first byte specify the number of bytes following the header in the packet. The remainder of the header specifies the event duration in 20 ms units. This duration count determines how long it will be before the next packet is read from the queue.

<a name="figure37"></a>![][CH04F37]

**Figure 37:** Packet Header

The packet header may be followed by zero or more blocks, in any order, containing frequency or amplitude information:

<a name="figure38"></a>![][CH04F38]

**Figure 38:** Packet Block Types

The routine first locates the current duration counter in the relevant voice buffer ([VCBA](#vcba), [VCBB](#vcbb) or [VCBC](#vcbc)) via the [GETVCP](#getvcp) standard routine and decrements it. If the counter has reached zero then the next packet must be read from the queue, otherwise the routine terminates.

The queue number is placed in [QUEUEN](#queuen) and a byte read from the queue ([11E2H](#11e2h)). This is then checked to see if it is the end of data mark (FFH), if so the queue terminates ([11B0H](#11b0h)). Otherwise the byte count is placed in register C and the duration MSB in the relevant voice buffer. The second byte is read ([11E2H](#11e2h)) and the duration LSB placed in the relevant voice buffer. The byte count is then examined, if there are no bytes to follow the packet header the routine terminates. Otherwise successive bytes are read from the queue, and the appropriate action taken, until the byte count is exhausted.

If a frequency block is found then a second byte is read and both bytes written to PSG Registers [0](#registers_0_and_1) and [1](#registers_0_and_1), [2](#registers_2_and_3) and [3](#registers_2_and_3) or [4](#registers_4_and_5) and [5](#registers_4_and_5) depending on the queue number.

If an amplitude block is found the Amplitude and Mode bits are written to PSG Registers [8](#register_8), [9](#register_9) or [10](#register_10) depending on the queue number. If the Mode bit is 1, selecting modulated rather than fixed amplitude, then the byte is also written to PSG [Register 13](#register_13) to set the envelope shape.

If an envelope block is found, or if bit 6 of an amplitude block is set, then a further two bytes are read from the queue and written to PSG Registers [11](#registers_11_and_12) and [12](#registers_11_and_12).

<a name="11b0h"></a>

    Address... 11B0H

This routine is used when an end of data mark (FFH) is found in one of the three music queues. An amplitude value of zero is written to PSG Register [8](#register_8) [9](#register_9) or [10](#register_10), depending on the queue number, to shut the channel down. The channel's bit in [MUSICF](#musicf) is then reset and control drops into the [STRTMS](#strtms) standard routine.

<a name="11c4h"></a><a name="strtms"></a>

```
Address... 11C4H
Name...... STRTMS
Entry..... None
Exit...... None
Modifies.. AF, HL
```

Standard routine used by the "`PLAY`" statement handler to initiate music dequeueing by the interrupt handler. [MUSICF](#musicf) is first examined, if any channels are already running the routine terminates with no action. [PLYCNT](#plycnt) is then decremented, if there are no more "`PLAY`" strings queued up the routine terminates. Otherwise the three duration counters, in [VCBA](#vcba), [VCBB](#vcbb) and [VCBC](#vcbc), are set to 0001H, so that the first packet of the new group will be dequeued at the next interrupt, and [MUSICF](#musicf) is set to 07H to enable all three channels.

<a name="11e2h"></a>

    Address... 11E2H

This routine loads register A with the current queue number, from [QUEUEN](#queuen), and then reads a byte from that queue ([14ADH](#14adh)).

<a name="11eeh"></a><a name="gtstck"></a>

```
Address... 11EEH
Name...... GTSTCK
Entry..... A=Joystick ID (0, 1 or 2)
Exit...... A=Joystick position code
Modifies.. AF, B, DE, HL, EI
```

Standard routine to read the position of a joystick or the four cursor keys. If the supplied ID is zero the state of the cursor keys is read via [PPI Port B](ppi_port_b) ([1226H](#1226h)) and converted to a position code using the look-up table at 1243H. Otherwise joystick connector 1 or 2 is read ([120CH](#120ch)) and the four direction bits converted to a position code using the look-up table at 1233H. The returned position codes are:

<a name="figure39a"></a>![][CH04F39a]

<a name="120ch"></a>

    Address... 120CH

This routine reads the joystick connector specified by the contents of register A: 0=Connector 1, 1=Connector 2. The current contents of PSG [Register 15](#register_15) are read in then written back with the Joystick Select bit appropriately set. PSG [Register 14](#register_14) is then read into register A (110CH) and the routine terminates.

<a name="1226h"></a>

    Address... 1226H

This routine reads row 8 of the keyboard matrix. The current contents of [PPI Port C](ppi_port_c) are read in then written back with the four Keyboard Row Select bits set for row 8. The column inputs are then read into register A from [PPI Port B](ppi_port_b).

<a name="1253h"></a><a name="gttrig"></a>

```
Address... 1253H
Name...... GTTRIG
Entry..... A=Trigger ID (0, 1, 2, 3 or 4)
Exit...... A=Status code
Modifies.. AF, BC, EI
```

Standard routine to check the joystick trigger or space key status. If the supplied ID is zero row 8 of the keyboard matrix is read ([1226H](#1226h)) and converted to a status code. Otherwise joystick connector 1 or 2 is read ([120CH](#120ch)) and converted to a status code. The selection IDs are:

```
0=SPACE KEY
1=JOY 1, TRIGGER A
2=JOY 2, TRIGGER A
3=JOY 1, TRIGGER B
4=JOY 2, TRIGGER B
```

The value returned is FFH if the relevant trigger is pressed and zero otherwise.

<a name="1273h"></a><a name="gtpdl"></a>

```
Address... 1273H
Name...... GTPDL
Entry..... A=Paddle ID (1 to 12)
Exit...... A=Paddle value (0 to 255)
Modifies.. AF, BC, DE, EI
```

Standard routine to read the value of any paddle attached to a joystick connector. Each of the six input lines (four direction plus two triggers) per connector can support a paddle so twelve are possible altogether. The paddles attached to joystick connector 1 have entry identifiers 1, 3, 5, 7, 9 and 11. Those attached to joystick connector 2 have entry identifiers 2, 4, 6, 8, 10 and 12. Each paddle is basically a one-shot pulse generator, the length of the pulse being controlled by a variable resistor. A start pulse is issued to the specified joystick connector via PSG [Register 15](#register_15). A count is then kept of how many times PSG [Register 14](#register_14) has to be read until the relevant input times out. Each unit increment represents an approximate period of 12 µs on an MSX machine with one wait state.

<a name="12ach"></a><a name="gtpad"></a>

```
Address... 12ACH
Name...... GTPAD
Entry..... A=Function code (0 to 7)
Exit...... A=Status or value
Modifies.. AF, BC, DE, HL, EI
```

Standard routine to access a touchpad attached to either of the joystick connectors. Available functions codes for joystick connector 1 are:

```
0=Return Activity Status
1=Return "X" coordinate
2=Return "Y" coordinate
3=Return Switch Status
```

Function codes 4 to 7 have the same effect with respect to joystick connector 2. The Activity Status function returns FFH if the Touchpad is being touched and zero otherwise. The Switch Status function returns FFH if the switch is being pressed and zero otherwise. The two coordinate request functions return the coordinates of the last location touched. These coordinates are actually stored in the Workspace Area variables [PADX](#padx) and [PADY](#pady) when a call with function code 0 or 4 detects activity. Note that these variables are shared by both joystick connectors.

<a name="1384h"></a><a name="stmotr"></a>

```
Address... 1384H
Name...... STMOTR
Entry..... A=Motor ON/OFF code
Exit...... None
Modifies.. AF
```

Standard routine to turn the cassette motor relay on or off via [PPI Port C](ppi_port_c): 00H=Off, 01H=On, FFH=Reverse current state.

<a name="1398h"></a><a name="nmi"></a>

```
Address... 1398H
Name...... NMI
Entry..... None
Exit...... None
Modifies.. None
```

Standard routine to process a Z80 Non Maskable Interrupt, simply returns on a standard MSX machine.

<a name="139dh"></a><a name="inifnk"></a>

```
Address... 139DH
Name...... INIFNK
Entry..... None
Exit...... None
Modifies.. BC, DE, HL
```

Standard routine to initialize the ten function key strings to their power-up values. The one hundred and sixty bytes of data commencing at [13A9H](#13a9h) are copied to the [FNKSTR](#fnkstr) buffer in the Workspace Area.

<a name="13a9h"></a>

    Address... 13A9H

This area contains the power-up strings for the ten function keys. Each string is sixteen characters long, unused positions contain zeroes:

```
F1 to F5  F6 to F10
color     color 15,4,4 CR
auto      cload"
goto      cont CR
list      list. CR UP UP
run CR    run CLS CR
```

<a name="1449h"></a><a name="rdvdp"></a>

```
Address... 1449H
Name...... RDVDP
Entry..... None
Exit...... A=VDP Status Register contents
Modifies.. A
```

Standard routine to input the contents of the [VDP Status Register](#vdp_status_register) by reading the [Command Port](#command_port). Note that reading the [VDP Status Register](#vdp_status_register) will clear the associated flags and may affect the interrupt handler.

<a name="144ch"></a><a name="rslreg"></a>

```
Address... 144CH
Name...... RSLREG
Entry..... None
Exit...... A=Primary Slot Register contents
Modifies.. A
```

Standard routine to input the contents of the Primary slot Register by reading [PPI Port A](ppi_port_a).

<a name="144fh"></a><a name="wslreg"></a>

```
Address... 144FH
Name...... WSLREG
Entry..... A=Value to write
Exit...... None
Modifies.. None
```

Standard routine to set the Primary Slot Register by writing to [PPI Port A](ppi_port_a).

<a name="1452h"></a><a name="snsmat"></a>

```
Address... 1452H
Name...... SNSMAT
Entry..... A=Keyboard row number
Exit...... A=Column data of keyboard row
Modifies.. AF, C, EI
```

Standard routine to read a complete row of the keyboard matrix. [PPI Port C](ppi_port_c) is read in then written back with the row number occupying the four Keyboard Row Select bits. [PPI Port B](ppi_port_b) is then read into register A to return the eight column inputs. The four miscellaneous control outputs of [PPI Port C](ppi_port_c) are unaffected by this routine.

<a name="145fh"></a><a name="isflio"></a>

```
Address... 145FH
Name...... ISFLIO
Entry..... None
Exit...... Flag NZ if file I/O active
Modifies.. AF
```

Standard routine to check whether the BASIC Interpreter is currently directing its input or output via an I/O buffer. This is determined by examining [PTRFIL](#ptrfil). It is normally zero but will contain a buffer FCB (File Control Block) address while statements such as "`PRINT#1`", "`INPUT#1`", etc. are being executed by the Interpreter.

<a name="146ah"></a><a name="dcompr"></a>

```
Address... 146AH
Name...... DCOMPR
Entry..... HL, DE
Exit...... Flag NC if HL>DE, Flag Z if HL=DE, Flag C if HL<DE
Modifies.. AF
```

Standard routine used by the BASIC Interpreter to check the relative values of register pairs HL and DE.

<a name="1470h"></a><a name="getvcp"></a>

```
Address... 1470H
Name...... GETVCP
Entry..... A=Voice number (0, 1, 2)
Exit...... HL=Address in voice buffer
Modifies.. AF, HL
```

Standard routine to return the address of byte 2 in the specified voice buffer ([VCBA](#vcba), [VCBB](#vcbb) or [VCBC](#vcbc)).

<a name="1474h"></a><a name="getvc2"></a>

```
Address... 1474H
Name...... GETVC2
Entry..... L=Byte number (0 to 36)
Exit...... HL=Address in voice buffer
Modifies.. AF, HL
```

Standard routine to return the address of any byte in the voice buffer ([VCBA](#vcba), [VCBB](#vcbb) or [VCBC](#vcbc)) specified by the voice number in [VOICEN](#voicen).

<a name="148ah"></a><a name="phydio"></a>

```
Address... 148AH
Name...... PHYDIO
Entry..... None
Exit...... None
Modifies.. None
```

Standard routine for use by Disk BASIC, simply returns on standard MSX machines.

<a name="148eh"></a><a name="format"></a>

```
Address... 148EH
Name...... FORMAT
Entry..... None
Exit...... None
Modifies.. None
```

Standard routine for use by Disk BASIC, simply returns on standard MSX machines.

<a name="1492h"></a><a name="putq"></a>

```
Address... 1492H
Name...... PUTQ
Entry..... A=Queue number, E=Data byte
Exit...... Flag Z if queue full
Modifies.. AF, BC, HL
```

Standard routine to place a data byte in one of the three music queues. The queue's get and put positions are first taken from [QUETAB](#quetab) ([14FAH](#14fah)). The put position is temporarily incremented and compared with the get position, if they are equal the routine terminates as the queue is full. Otherwise the queue's address is taken from [QUETAB](#quetab) and the put position added to it. The data byte is placed at this location in the queue, the put position is incremented and the routine terminates. Note that the music queues are circular, if the get or put pointers reach the last position in the queue they wrap around back to the start.

<a name="14adh"></a>

    Address... 14ADH

This routine is used by the interrupt handler to read a byte from one of the three music queues. The queue number is supplied in register A, the data byte is returned in register A and the routine returns Flag Z if the queue is empty. The queue's get and put positions are first taken from [QUETAB](#quetab) ([14FAH](#14fah)). If the putback flag is active then the data byte is taken from [QUEBAK](#quebak) and the routine terminates (14D1H), this facility is unused in the current versions of the MSX ROM. The put position is then compared with the get position, if they are equal the routine terminates as the queue is empty. Otherwise the queue's address is taken from [QUETAB](#quetab) and the get position added to it. The data byte is read from this location in the queue, the get position is incremented and the routine terminates.

    Address... 14DAH

This routine is used by the [GICINI](#gicini) standard routine to initialize a queue's control block in [QUETAB](#quetab). The control block is first located in [QUETAB](#quetab) ([1504H](#1504h)) and the put, get and putback bytes zeroed. The size byte is set from register B and the queue address from register pair DE.

<a name="14ebh"></a><a name="lftq"></a>

```
Address... 14EBH
Name...... LFTQ
Entry..... A=Queue number
Exit...... HL=Free space left in queue
Modifies.. AF, BC, HL
```

Standard routine to return the number of free bytes left in a music queue. The queue's get and put positions are taken from [QUETAB](#quetab) ([14FAH](#14fah)) and the free space determined by subtracting put from get.

<a name="14fah"></a>

    Address... 14FAH

This routine returns a queue's control parameters from [QUETAB](#quetab), the queue number is supplied in register A. The control block is first located in [QUETAB](#quetab) ([1504H](#1504h)), the put position is then placed in register B, the get position in register C and the putback flag in register A.

<a name="1504h"></a>

    Address... 1504H

This routine locates a queue's control block in [QUETAB](#quetab). The queue number is supplied in register A and the control block address returned in register pair HL. The queue number is simply multiplied by six, as there are six bytes per block, and added to the address of [QUETAB](#quetab) as held in [QUEUES](#queues).

<a name="1510h"></a><a name="grpprt"></a>

```
Address... 1510H
Name...... GRPPRT
Entry..... A=Character
Exit...... None
Modifies.. EI
```

Standard routine to display a character on the screen in either [Graphics Mode](#graphics_mode) or [Multicolour Mode](#multicolour_mode), it is functionally equivalent to the [CHPUT](#chput) standard routine.

The [CNVCHR](#cnvchr) standard routine is first used to check for a graphic character, if the character is a header code (01H) then the routine terminates with no action. If the character is a converted graphic one then the control code decoding section is skipped. Otherwise the character is checked to see if it is a control code. Only the CR code (0DH) is recognized ([157EH](#157eh)), all other characters smaller than 20H are ignored.

Assuming the character is displayable its eight byte pixel pattern is copied from the ROM character set into the [PATWRK](#patwrk) buffer (0752H) and [FORCLR](#forclr) copied to [ATRBYT](#atrbyt) to set its colour. The current graphics coordinates are then taken from [GRPACX](#grpacx) and [GRPACY](#grpacy) and used to set the current pixel physical address via the [SCALXY](#scalxy) and [MAPXYC](#mapxyc) standard routines.

The eight byte pattern in [PATWRK](#patwrk) is processed a byte at a time. At the start of each byte the current pixel physical address is obtained via the [FETCHC](#fetchc) standard routine and saved. The eight bits are then examined in turn. If the bit is a 1 the associated pixel is set by the [SETC](#setc) standard routine, if it is a 0 no action is taken. After each bit the current pixel physical address is moved right ([16ACH](#16ach)). When the byte is finished, or the right hand edge of the screen is reached, the initial current pixel physical address is restored and moved down one position by the [TDOWNC](#tdownc) standard routine.

When the pattern is complete, or the bottom of the screen has been reached, [GRPACX](#grpacx) is updated. In [Graphics Mode](#graphics_mode) its value is increased by eight, in [Multicolour Mode](#multicolour_mode) by thirty-two. If [GRPACX](#grpacx) then exceeds 255, the right hand edge of the screen, a CR operation is performed ([157EH](#157eh)).

<a name="157eh"></a>

    Address... 157EH

This routine performs the CR operation for the [GRPPRT](#grpprt) standard routine, this code functions as a combined CR,LF. [GRPACX](#grpacx) is zeroed and eight or thirty-two, depending on the screen mode, added to [GRPACY](#grpacy). If [GRPACY](#grpacy) then exceeds 191, the bottom of the screen, it is set to zero.

[GRPACX](#grpacx) and [GRPACY](#grpacy) may be manipulated directly by an application program to compensate for the limited number of control functions available.

<a name="1599h"></a><a name="scalxy"></a>

```
Address... 1599H
Name...... SCALXY
Entry..... BC=X coordinate, DE=Y coordinate
Exit...... Flag NC if clipped
Modifies.. AF
```

Standard routine to clip a pair of graphics coordinates if necessary. The BASIC Interpreter can produce coordinates in the range -32768 to +32767 even though this far exceeds the actual screen size. This routine modifies excessive coordinate values to fit within the physically realizable range. If the X coordinate is greater than 255 it is set to 255, if the Y coordinate is greater than 191 it is set to 191. If either coordinate is negative (greater than 7FFFH) it is set to zero. Finally if the screen is in [Multicolour Mode](#multicolour_mode) both coordinates are divided by four as required by the [MAPXYC](#mapxyc) standard routine.

    Address... 15D9H

This routine is used to check the current screen mode, it returns Flag Z if the screen is in [Graphics Mode](#graphics_mode).

<a name="15dfh"></a><a name="mapxyc"></a>

```
Address... 15DFH
Name...... MAPXYC
Entry..... BC=X coordinate, DE=Y coordinate
Exit...... None
Modifies.. AF, D, HL
```

Standard routine to convert a graphics coordinate pair into the current pixel physical address. The location in the Character Pattern Table of the byte containing the pixel is placed in [CLOC](#cloc). The bit mask identifying the pixel within that byte is placed in [CMASK](#cmask). Slightly different conversion methods are used for [Graphics Mode](#graphics_mode) and [Multicolour Mode](#multicolour_mode), equivalent programs in BASIC are:

```
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
```

</a>

```
Multicolour Mode

10 INPUT"X,Y Coordinates";X,Y
20 X=X\4:Y-Y\4
30 A=(Y\8)*256+(Y AND 7)+(X*4 AND &HF8)
40 PRINT"ADDR=";HEX$(BASE(17)+A);"H ";
50 IF X MOD 2=0 THEN MS="11110000" ELSE MS="00001111"
60 PRINT"MASK=";M$
70 GOTO 10
```

The allowable input range for both programs is X=0 to 255 and Y=0 to 191. The data statements in the [Graphics Mode](#graphics_mode) program correspond to the eight byte mask table commencing at 160BH in the MSX ROM. Line 20 in the [Multicolour Mode](#multicolour_mode) program actually corresponds to the division by four in the [SCALXY](#scalxy) standard routine. It is included to make the coordinate system consistent for both programs.

<a name="1639h"></a><a name="fetchc"></a>

```
Address... 1639H
Name...... FETCHC
Entry..... None
Exit...... A=CMASK, HL=CLOC
Modifies.. A, HL
```

Standard routine to return the current pixel physical address, register pair HL is loaded from [CLOC](#cloc) and register A from [CMASK](#cmask).

<a name="1640h"></a><a name="storec"></a>

```
Address... 1640H
Name...... STOREC
Entry..... A=CMASK, HL=CLOC
Exit...... None
Modifies.. None
```

Standard routine to set the current pixel physical address, register pair HL is copied to [CLOC](#cloc) and register A is copied to [CMASK](#cmask).

<a name="1647h"></a><a name="readc"></a>

```
Address... 1647H
Name...... READC
Entry..... None
Exit...... A=Colour code of current pixel
Modifies.. AF, EI
```

Standard routine to return the colour of the current pixel. The VRAM physical address is first obtained via the [FETCHC](#fetchc) standard routine. If the screen is in [Graphics Mode](#graphics_mode) the byte pointed to by [CLOC](#cloc) is read from the Character Pattern Table via the [RDVRM](#rdvrm) standard routine. The required bit is then isolated by [CMASK](#cmask) and used to select either the upper or lower four bits of the corresponding entry in the Colour Table.

If the screen is in [Multicolour Mode](#multicolour_mode) the byte pointed to by [CLOC](#cloc) is read from the Character Pattern Table via the [RDVRM](#rdvrm) standard routine. [CMASK](#cmask) is then used to select either the upper or lower four bits of this byte. The value returned in either case will be a normal VDP colour code from zero to fifteen.

<a name="1676h"></a><a name="setatr"></a>

```
Address... 1676H
Name...... SETATR
Entry..... A=Colour code
Exit...... Flag C if illegal code
Modifies.. Flags
```

Standard routine to set the graphics ink colour used by the [SETC](#setc) and [NSETCX](#nsetcx) standard routines. The colour code, from zero to fifteen, is simply placed in [ATRBYT](#atrbyt).

<a name="167eh"></a><a name="setc"></a>

```
Address... 167EH
Name...... SETC
Entry..... None
Exit...... None
Modifies.. AF, EI
```

Standard routine to set the current pixel to any colour, the colour code is taken from [ATRBYT](#atrbyt). The pixel's VRAM physical address is first obtained via the [FETCHC](#fetchc) standard routine. In [Graphics Mode](#graphics_mode) both the Character Pattern Table and Colour Table are then modified ([186CH](#186ch)).

In [Multicolour Mode](#multicolour_mode) the byte pointed to by [CLOC](#cloc) is read from the Character Pattern Table by the [RDVRM](#rdvrm) standard routine. The contents of [ATRBYT](#atrbyt) are then placed in the upper or lower four bits, as determined by [CMASK](#cmask), and the byte written back via the [WRTVRM](#wrtvrm) standard routine

<a name="16ach"></a>

    Address... 16ACH

This routine moves the current pixel physical address one position right. If the right hand edge of the screen is exceeded it returns with Flag C and the physical address is unchanged. In [Graphics Mode](#graphics_mode) [CMASK](#cmask) is first shifted one bit right, if the pixel still remains within the byte the routine terminates. If [CLOC](#cloc) is at the rightmost character cell (LSB=F8H to FFH) then the routine terminates with Flag C (175AH). Otherwise [CMASK](#cmask) is set to 80H, the leftmost pixel, and 0008H added to [CLOC](#cloc).

In [Multicolour Mode](#multicolour_mode) control transfers to a separate routine ([1779H](#1779h)).

<a name="16c5h"></a><a name="rightc"></a>

```
Address... 16C5H
Name...... RIGHTC
Entry..... None
Exit...... None
Modifies.. AF
```

Standard routine to move the current pixel physical address one position right. In [Graphics Mode](#graphics_mode) [CMASK](#cmask) is first shifted one bit right, if the pixel still remains within the byte the routine terminates. Otherwise [CMASK](#cmask) is set to 80H, the leftmost pixel, and 0008H added to [CLOC](#cloc). Note that incorrect addresses will be produced if the right hand edge of the screen is exceeded.

In [Multicolour Mode](#multicolour_mode) control transfers to a separate routine ([178BH](#178bh)).

<a name="16d8h"></a>

    Address... 16D8H

This routine moves the current pixel physical address one position left. If the left hand edge of the screen is exceeded it returns Flag C and the physical address is unchanged. In [Graphics Mode](#graphics_mode) [CMASK](#cmask) is first shifted one bit left, if the pixel still remains within the byte the routine terminates. If [CLOC](#cloc) is at the leftmost character cell (LSB=00H to 07H) then the routine terminates with Flag C (175AH). Otherwise [CMASK](#cmask) is set to 01H, the rightmost pixel, and 0008H subtracted from [CLOC](#cloc).

In [Multicolour Mode](#multicolour_mode) control transfers to a separate routine ([179CH](#179ch)).

<a name="16eeh"></a><a name="leftc"></a>

```
Address... 16EEH
Name...... LEFTC
Entry..... None
Exit...... None
Modifies.. AF
```

Standard routine to move the current pixel physical address one position left. In [Graphics Mode](#graphics_mode) [CMASK](#cmask) is first shifted one bit left, if the pixel still remains within the byte the routine terminates. Otherwise [CMASK](#cmask) is set to 01H, the leftmost pixel, and 0008H subtracted from [CLOC](#cloc). Note that incorrect addresses will be produced if the left hand edge of the screen is exceeded.

In [Multicolour Mode](#multicolour_mode) control transfers to a separate routine ([17ACH](#17ach)).

<a name="170ah"></a><a name="tdownc"></a>

```
Address... 170AH
Name...... TDOWNC
Entry..... None
Exit...... Flag C if off screen
Modifies.. AF
```

Standard routine to move the current pixel physical address one position down. If the bottom edge of the screen is exceeded it returns Flag C and the physical address is unchanged. In [Graphics Mode](#graphics_mode) [CLOC](#cloc) is first incremented, if it still remains within an eight byte boundary the routine terminates. If [CLOC](#cloc) was in the bottom character row ([CLOC](#cloc)>=1700H) then the routine terminates with Flag C (1759H). Otherwise 00F8H is added to [CLOC](#cloc).

In [Multicolour Mode](#multicolour_mode) control transfers to a separate routine ([17C6H](#17c6h)).

<a name="172ah"></a><a name="downc"></a>

```
Address... 172AH
Name...... DOWNC
Entry..... None
Exit...... None
Modifies.. AF
```

Standard routine to move the current pixel physical address one position down. In [Graphics Mode](#graphics_mode) [CLOC](#cloc) is first incremented, if it still remains within an eight byte boundary the routine terminates. Otherwise 00F8H is added to [CLOC](#cloc). Note that incorrect addresses will be produced if the bottom edge of the screen is exceeded.

In [Multicolour Mode](#multicolour_mode) control transfers to a separate routine ([17DCH](#17dch)).

<a name="173ch"></a><a name="tupc"></a>

```
Address... 173CH
Name...... TUPC
Entry..... None
Exit...... Flag C if off screen
Modifies.. AF
```

Standard routine to move the current pixel physical address one position up. If the top edge of the screen is exceeded it returns with Flag C and the physical address is unchanged. In [Graphics Mode](#graphics_mode) [CLOC](#cloc) is first decremented, if it still remains within an eight byte boundary the routine terminates. If [CLOC](#cloc) was in the top character row ([CLOC](#cloc)<0100H) then the routine terminates with Flag C. Otherwise 00F8H is subtracted from [CLOC](#cloc).

In [Multicolour Mode](#multicolour_mode) control transfers to a separate routine ([17E3H](#17e3h)).

<a name="175dh"></a><a name="upc"></a>

```
Address... 175DH
Name...... UPC
Entry..... None
Exit...... None
Modifies.. AF
```

Standard routine to move the current pixel physical address one position up. In [Graphics Mode](#graphics_mode) [CLOC](#cloc) is first decremented, if it still remains within an eight byte boundary the routine terminates. Otherwise 00F8H is subtracted from [CLOC](#cloc). Note that incorrect addresses will be produced if the top edge of the screen is exceeded.

In [Multicolour Mode](#multicolour_mode) control transfers to a separate routine ([17F8H](#17f8h)).

<a name="1779h"></a>

    Address... 1779H

This is the [Multicolour Mode](#multicolour_mode) version of the routine at [16ACH](#16ach). It is identical to the [Graphics Mode](#graphics_mode) version except that [CMASK](#cmask) is shifted four bit positions right and becomes F0H if a cell boundary is crossed.

<a name="178bh"></a>

    Address... 178BH

This is the [Multicolour Mode](#multicolour_mode) version of the [RIGHTC](#rightc) standard routine. It is identical to the [Graphics Mode](#graphics_mode) version except that [CMASK](#cmask) is shifted four bit positions right and becomes F0H if a cell boundary is crossed.

<a name="179ch"></a>

    Address... 179CH

This is the [Multicolour Mode](#multicolour_mode) version of the routine at [16D8H](#16d8h). It is identical to the [Graphics Mode](#graphics_mode) version except that [CMASK](#cmask) is shifted four bit positions left and becomes 0FH if a cell boundary is crossed.

<a name="17ach"></a>

    Address... 17ACH

This is the [Multicolour Mode](#multicolour_mode) version of the [LEFTC](#leftc) standard routine. It is identical to the [Graphics Mode](#graphics_mode) version except that [CMASK](#cmask) is shifted four bit positions left and becomes 0FH if a cell boundary is crossed.

<a name="17c6h"></a>

    Address... 17C6H

This is the [Multicolour Mode](#multicolour_mode) version of the [TDOWNC](#tdownc) standard routine. It is identical to the [Graphics Mode](#graphics_mode) version except that the bottom boundary address is 0500H instead of 1700H. There is a bug in this routine which will cause it to behave unpredictably if [MLTCGP](#mltcgp), the Character Pattern Table base address, is changed from its normal value of zero. There should be an `EX DE,HL` instruction inserted at address 17CEH.

If the Character Pattern Table base is increased the routine will think it has reached the bottom of the screen when it actually has not. This routine is used by the "`PAINT`" statement so the following demonstrates the fault:

```
10 BASE(17)=&H1000
20 SCREEN 3
30 PSET(200,0)
40 DRAW"D180L100U180R100"
50 PAINT(150,90)
60 GOTO 60
```

</a>

<a name="17dch"></a>

    Address... 17DCH

This is the [Multicolour Mode](#multicolour_mode) version of the [DOWNC](#downc) standard routine, it is identical to the [Graphics Mode](#graphics_mode) version.

<a name="17e3h"></a>

    Address... 17E3H

This is the [Multicolour Mode](#multicolour_mode) version of the [TUPC](#tupc) standard routine. It is identical to the [Graphics Mode](#graphics_mode) version except that is has a bug as above, this time there should be an `EX DE,HL` instruction at address 17EBH.

If the Character Pattern Table base address is increased the routine will think it is within the table when it has actually exceeded the top edge of the screen. This may be demonstrated by removing the "`R100`" part of Line 40 in the previous program.

<a name="17f8h"></a>

    Address... 17F8H

This is the [Multicolour Mode](#multicolour_mode) version of the [UPC](#upc) standard routine, it is identical to the [Graphics Mode](#graphics_mode) version.

<a name="1809h"></a><a name="nsetcx"></a>

```
Address... 1809H
Name...... NSETCX
Entry..... HL=Pixel fill count
Exit...... None
Modifies.. AF, BC, DE, HL, EI
```

Standard routine to set the colour of multiple pixels horizontally rightwards from the current pixel physical address. Although its function can be duplicated by the [SETC](#setc) and [RIGHTC](#rightc) standard routines this would result in significantly slower operation. The supplied pixel count should be chosen so that the right-hand edge of the screen is not passed as this will produce anomalous behaviour. The current pixel physical address is unchanged by this routine.

In [Graphics Mode](#graphics_mode) [CMASK](#cmask) is first examined to determine the number of pixels to the right within the current character cell. Assuming the fill count is large enough these are then set ([186CH](#186ch)). The remaining fill count is divided by eight to determine the number of whole character cells. Successive bytes in the Character Pattern Table are then zeroed and the corresponding bytes in the Colour Table set from [ATRBYT](#atrbyt) to fill these whole cells. The remaining fill count is then converted to a bit mask, using the seven byte table at 185DH, and these pixels are set ([186CH](#186ch)).

In [Multicolour Mode](#multicolour_mode) control transfers to a separate routine ([18BBH](#18bbh)).

<a name="186ch"></a>

    Address... 186CH

This routine sets up to eight pixels within a cell to a specified colour in [Graphics Mode](#graphicsmod). [ATRBYT](#atrbyt) contains the colour code, register pair HL the address of the relevant byte in the Character Pattern Table and register A a bit mask, 11100000 for example, where every 1 specifies a bit to be set.

If [ATRBYT](#atrbyt) matches the existing 1 pixel colour in the corresponding Colour Table byte then each specified bit is set to 1 in the Character Pattern Table byte. If [ATRBYT](#atrbyt) matches the existing 0 pixel colour in the corresponding Colour Table byte then each specified bit is set to 0 in the Character Pattern Table byte.

If [ATRBYT](#atrbyt) does not match either of the existing colours in the Colour Table Byte then normally each specified bit is set to 1 in the Character Pattern Table byte and the 1 pixel colour changed in the Colour Table byte. However if this would result in all bits being set to 1 in the Character Pattern Table byte then each specified bit is set to 0 and the 0 pixel colour changed in the Colour Table byte.

<a name="18bbh"></a>

    Address... 18BBH

This is the [Multicolour Mode](#multicolour_mode) version of the [NSETCX](#nsetcx) standard routine. The [SETC](#setc) and [RIGHTC](#rightc) standard routines are called until the fill count is exhausted. Speed of operation is not so important in [Multicolour Mode](#multicolour_mode) because of the lower screen resolution and the consequent reduction in the number of operations required.

<a name="18c7h"></a><a name="gtaspc"></a>

```
Address... 18C7H
Name...... GTASPC
Entry..... None
Exit...... DE=ASPCT1, HL=ASPCT2
Modifies.. DE, HL
```

Standard routine to return the "`CIRCLE`" statement default aspect ratios.

<a name="18cfh"></a><a name="pntini"></a>

```
Address... 18CFH
Name...... PNTINI
Entry..... A=Boundary colour (0 to 15)
Exit...... Flag C if illegal colour
Modifies.. AF
```

Standard routine to set the boundary colour for the "`PAINT`" statement. In [Multicolour Mode](#multicolour_mode) the supplied colour code is placed in [BDRATR](#bdratr). In [Graphics Mode](#graphics_mode) [BDRATR](#bdratr) is copied from [ATRBYT](#atrbyt) as it is not possible to have separate paint and boundary colours.

<a name="18e4h"></a><a name="scanr"></a>

```
Address... 18E4H
Name...... SCANR
Entry..... B=Fill switch, DE=Skip count
Exit...... DE=Skip remainder, HL=Pixel count
Modifies.. AF, BC, DE, HL, EI
```

Standard routine used by the "`PAINT`" statement handler to search rightwards from the current pixel physical address until a colour code equal to [BDRATR](#bdratr) is found or the edge of the screen is reached. The terminating position becomes the current pixel physical address and the initial position is returned in [CSAVEA](#csavea) and [CSAVEM](#csavem). The size of the traversed region is returned in register pair HL and [FILNAM](#filnam)+1. The traversed region is normally filled in but this can be inhibited, in [Graphics Mode](#graphics_mode) only, by using an entry parameter of zero in register B. The skip count in register pair DE determines the maximum number of pixels of the required colour that may be ignored from the initial starting position. This facility is used by the "`PAINT`" statement handler to search for gaps in a horizontal boundary blocking its upward progress.

<a name="197ah"></a><a name="scanl"></a>

```
Address... 197AH
Name...... SCANL
Entry..... None
Exit...... HL=Pixel count
Modifies.. AF, BC, DE, HL, EI
```

Standard routine to search leftwards from the current pixel physical address until a colour code equal to [BDRATR](#bdratr) is found or the edge of the screen is reached. The terminating position becomes the current pixel physical address and the size of the traversed region is returned in register pair HL. The traversed region is always filled in.

<a name="19c7h"></a>

    Address... 19C7H

This routine is used by the [SCANL](#scanl) and [SCANR](#scanr) standard routines to check the current pixel's colour against the boundary colour in [BDRATR](#bdratr).

<a name="19ddh"></a><a name="tapoof"></a>

```
Address... 19DDH
Name...... TAPOOF
Entry..... None
Exit...... None
Modifies.. EI
```

Standard routine to stop the cassette motor after data has been written to the cassette. After a delay of 550 ms, on MSX machines with one wait state, control drops into the [TAPIOF](#tapiof) standard routine.

<a name="19e9h"></a><a name="tapiof"></a>

```
Address... 19E9H
Name...... TAPIOF
Entry..... None
Exit...... None
Modifies.. EI
```

Standard routine to stop the cassette motor after data has been read from the cassette. The motor relay is opened via the [PPI Mode Port](#ppi_mode_port). Note that interrupts, which must be disabled during cassette data transfers for timing reasons, are enabled as this routine terminates.

<a name="19f1h"></a><a name="tapoon"></a>

```
Address... 19F1H
Name...... TAPOON
Entry..... A=Header length switch
Exit...... Flag C if CTRL-STOP termination
Modifies.. AF, BC, HL, DI
```

Standard routine to turn the cassette motor on, wait 550 ms for the tape to come up to speed and then write a header to the cassette. A header is a burst of HI cycles written in front of every data block so the baud rate can be determined when the data is read back.

The length of the header is determined by the contents of register A: 00H=Short header, NZ=Long header. The BASIC cassette statements "`SAVE`", "`CSAVE`" and "`BSAVE`" all generate a long header at the start of the file, in front of the identification block, and thereafter use short headers between data blocks. The number of cycles in the header is also modified by the current baud rate so as to keep its duration constant:

```
1200 Baud SHORT ... 3840 Cycles ... 1.5 Seconds
1200 Baud LONG ... 15360 Cycles ... 6.1 Seconds
2400 Baud SHORT ... 7936 Cycles ... 1.6 Seconds
2400 Baud LONG ... 31744 Cycles ... 6.3 Seconds
```

After the motor has been turned on and the delay has expired the contents of [HEADER](#header) are multiplied by two hundred and fifty-six and, if register A is non-zero, by a further factor of four to produce the cycle count. HI cycles are then generated ([1A4DH](#1a4dh)) until the count is exhausted whereupon control transfers to the [BREAKX](#breakx) standard routine. Because the CTRL-STOP key is only examined at termination it is impossible to break out part way through this routine.

<a name="1a19h"></a><a name="tapout"></a>

```
Address... 1A19H
Name...... TAPOUT
Entry..... A=Data byte
Exit...... Flag C if CTRL-STOP termination
Modifies.. AF, B, HL
```

Standard routine to write a single byte of data to the cassette. The MSX ROM uses a software driven FSK (Frequency Shift Keyed) method for storing information on the cassette. At the 1200 baud rate this is identical to the Kansas City Standard used by the BBC for the distribution of BASICODE programs.

At 1200 baud each 0 bit is written as one complete 1200 Hz LO cycle and each 1 bit as two complete 2400 Hz HI cycles. The data rate is thus constant as 0 and 1 bits have the same duration. When the 2400 baud rate is selected the two frequencies change to 2400 Hz and 4800 Hz but the format is otherwise unchanged.

A byte of data is written with a 0 start bit ([1A50H](#1a50h)), eight data bits with the least significant bit first, and two 1 stop bits ([1A40H](#1a40h)). At the 1200 baud rate a single byte will have a nominal duration of 11 x 833 µs = 9.2 ms. After the stop bits have been written control transfers to the [BREAKX](#breakx) standard routine to check the CTRL-STOP key. The byte 43H is shown below as it would be written to cassette:

<a name="figure39b"></a>![][CH04F39b]

**Figure 39:** Cassette Data Byte

It is important not to leave too long an interval between bytes when writing data as this will increase the error rate. An inter-byte gap of 80 µs, for example, produces a read failure rate of approximately twelve percent. If a substantial amount of processing is required between each byte then buffering should be used to lump data into headered blocks. The BASIC "`SAVE`" format is of this type.

<a name="1a39h"></a>

    Address... 1A39H

This routine writes a single LO cycle with a length of approximately 816 µs to the cassette. The length of each half of the cycle is taken from [LOW](#low) and control transfers to the general cycle generator ([1A50H](#1a50h)).

<a name="1a40h"></a>

    Address... 1A40H

This routine writes two HI cycles to the cassette. The first cycle is generated ([1A4DH](#1a4dh)) followed by a 17 µs delay and then the second cycle ([1A4DH](#1a4dh)).

<a name="1a4dh"></a>

    Address... 1A4DH

This routine writes a single HI cycle with a length of approximately 396 µs to the cassette. The length of each half of the cycle is taken from [HIGH](#high) and control drops into the general cycle generator.

<a name="1a50h"></a>

    Address... 1A50H

This routine writes a single cycle to the cassette. The length of the cycle's first half is supplied in register L and its second half in register H. The first length is counted down and then the Cas Out bit set via the [PPI Mode Port](#ppi_mode_port). The second length is counted down and the Cas Out bit reset.

On all MSX machines the Z80 runs at a clock frequency of 3.579545 MHz (280 ns) with one wait state during the M1 cycle. As this routine counts every 16T states each unit increment in the length count represents a period of 4.47 µs. There is also a fixed overhead of 20.7 µs associated with the routine whatever the length count.

<a name="1a63h"></a><a name="tapion"></a>

```
Address... 1A63H
Name...... TAPION
Entry..... None
Exit...... Flag C if CTRL-STOP termination
Modifies.. AF, BC, DE, HL, DI
```

Standard routine to turn the cassette motor on, read the cassette until a header is found and then determine the baud rate. Successive cycles are read from the cassette and the length of each one measured ([1B34H](#1b34h)). When 1,111 cycles have been found with less than 35 µs variation in their lengths a header has been located.

The next 256 cycles are then read ([1B34H](#1b34h)) and averaged to determine the cassette HI cycle length. This figure is multiplied by 1.5 and placed in [LOWLIM](#lowlim) where it defines the minimum acceptable length of a 0 start bit. The HI cycle length is placed in [WINWID](#winwid) and will be used to discriminate between LO and HI cycles.

<a name="1abch"></a><a name="tapin"></a>

```
Address... 1ABCH
Name...... TAPIN
Entry..... None
Exit...... A=Byte read, Flag C if CTRL-STOP or I/O error
Modifies.. AF, BC, DE, L
```

Standard routine to read a byte of data from the cassette. The cassette is first read continuously until a start bit is found. This is done by locating a negative transition, measuring the following cycle length ([1B1FH](#1b1fh)) and comparing this to see if it is greater than [LOWLIM](#lowlim).

Each of the eight data bits is then read by counting the number of transitions within a fixed period of time ([1B03H](#1b03h)). If zero or one transitions are found it is a 0 bit, if two or three are found it is a 1 bit. If more than three transitions are found the routine terminates with Flag C as this is presumed to be a hardware error of some sort. After the value of each bit has been determined a further one or two transitions are read (1B23H) to retain synchronization. With an odd transition count one more will be read, with an even transition count two more.

<a name="1b03h"></a>

    Address... 1B03H

This routine is used by the [TAPIN](#tapin) standard routine to count the number of cassette transitions within a fixed period of time. The window duration is contained in [WINWID](#winwid) and is approximately 1.5 times the length of a HI cycle as shown below:

<a name="figure40"></a>![][CH04F40]

**Figure 40:** Cassette Window

The Cas Input bit is continuously sampled via PSG [Register 14](#register_14) and compared with the previous reading held in register E. Each time a change of state is found register C is incremented. The sampling rate is once every 17.3 µs so the value in [WINWID](#winwid), which was determined by the [TAPION](#tapion) standard routine with a count rate of 11.45 µs, is effectively multiplied one and a half times.

<a name="1b1fh"></a>

    Address... 1B1FH

This routine measures the time to the next cassette input transition. The Cassette Input bit is continuously sampled via PSG [Register 14](#register_14) until it changes from the state supplied in register E. The state flag is then inverted and the duration count returned in register C, each unit increment represents a period of 11.45 µs.

<a name="1b34h"></a>

    Address... 1B34H

This routine measures the length of a complete cassette cycle from negative transition to negative transition. The Cassette Input bit is sampled via PSG [Register 14](#register_14) until it goes to zero. The transition flag in register E is set to zero and the time to the positive transition measured (1B23H). The time to the negative transition is then measured (1B25H) and the total returned in register C.

<a name="1b45h"></a><a name="outdo"></a>

```
Address... 1B45H
Name...... OUTDO
Entry..... A=Character to output
Exit...... None
Modifies.. EI
```

Standard routine used by the BASIC Interpreter to output a character to the current device. The [ISFLIO](#isflio) standard routine is first used to check whether output is currently directed to an I/O buffer, if so control transfers to the sequential output driver ([6C48H](#6c48h)) via the [CALBAS](#calbas) standard routine. If [PRTFLG](#prtflg) is zero control transfers to the [CHPUT](#chput) standard routine to output the character to the screen. Assuming the printer is active [RAWPRT](#rawprt) is checked. If this is non-zero the character is passed directly to the printer ([1BABH](#1babh)), otherwise control drops into the [OUTDLP](#outdlp) standard routine.

<a name="1b63h"></a><a name="outdlp"></a>

```
Address... 1B63H
Name...... OUTDLP
Entry..... A=Character to output
Exit...... None
Modifies.. EI
```

Standard routine to output a character to the printer. If the character is a TAB code (09H) spaces are issued to the [OUTDLP](#outdlp) standard routine until [LPTPOS](#lptpos) is a multiple of eight (0, 8, 16 etc.). If the character is a CR code (0DH) [LPTPOS](#lptpos) is zeroed if it is any other control code [LPTPOS](#lptpos) is unaffected, if it is a displayable character [LPTPOS](#lptpos) is incremented.

If [NTMSXP](#ntmsxp) is zero, meaning an MSX-specific printer is connected, the character is passed directly to the printer ([1BABH](#1babh)). Assuming a normal printer is connected the [CNVCHR](#cnvchr) standard routine is used to check for graphic characters. If the character is a header code (01H) the routine terminates with no action. If it is a converted graphic character it is replaced by a space, all other characters are passed to the printer (1BACH).

<a name="1b97h"></a>

    Address... 1B97H

This twenty byte table is used by the keyboard decoder to find the correct routine for a given key number:

|KEY NUMBER  |TO     |FUNCTION
|------------|:-----:|------------------
|00H to 2FH  |0F83H  |Rows 0 to 5
|30H to 32H  |0F10H  |SHIFT, CTRL, GRAPH
|33H         |0F36H  |CAP
|34H         |0F10H  |CODE
|35H to 39H  |0FC3H  |F1 to F5
|3AH to 3BH  |0F10H  |ESC, TAB
|3CH         |0F46H  |STOP
|3DH to 40H  |0F10H  |BS, CR, SEL, SPACE
|41H         |0F06H  |HOME
|42H to 57H  |0F10H  |INS, DEL, CURSOR

</a>

<a name="1babh"></a>

    Address... 1BABH

This routine is used by the [OUTDLP](#outdlp) standard routine to pass a character to the printer. It is sent via the [LPTOUT](#lptout) standard routine, if this returns Flag C control transfers to the "`Device I/O error`" generator ([73B2H](#73b2h)) via the [CALBAS](#calbas) standard routine.

<a name="1bbfh"></a>

    Address... 1BBFH

The following 2 KB contains the power-up character set. The first eight bytes contain the pattern for character code 00H, the second eight bytes the pattern for character code 01H and so on to character code FFH.

<a name="23bfh"></a><a name="pinlin"></a>

```
Address... 23BFH
Name...... PINLIN
Entry..... None
Exit...... HL=Start of text, Flag C if CTRL-STOP termination
Modifies.. AF, BC, DE, HL, EI
```

Standard routine used by the BASIC Interpreter Mainloop to collect a logical line of text from the console. Control transfers to the [INLIN](#inlin) standard routine just after the point where the previous line has been cut (23E0H).

<a name="23cch"></a><a name="qinlin"></a>

```
Address... 23CCH
Name...... QINLIN
Entry..... None
Exit...... HL=Start of text, Flag C if CTRL-STOP termination
Modifies.. AF, BC, DE, HL, EI
```

Standard routine used by the "`INPUT`" statement handler to collect a logical line of text from the console. The characters "`? `" are displayed via the [OUTDO](#outdo) standard routine and control drops into the [INLIN](#inlin) standard routine.

<a name="23d5h"></a><a name="inlin"></a>

```
Address... 23D5H
Name...... INLIN
Entry..... None
Exit...... HL=Start of text, Flag C if CTRL-STOP termination
Modifies.. AF, BC, DE, HL, EI
```

Standard routine used by the "`LINE INPUT`" statement handler to collect a logical line of text from the console. Characters are read from the keyboard until either the CR or CTRL-STOP keys are pressed. The logical line is then read from the screen character by character and placed in the Workspace Area text buffer [BUF](#buf).

The current screen coordinates are first taken from [CSRX](#csrx) and [CSRY](#csry) and placed in [FSTPOS](#fstpos). The screen row immediately above the current one then has its entry in [LINTTB](#linttb) made non-zero ([0C29H](#0c29h)) to stop it extending logically into the current row.

Each keyboard character read via the [CHGET](#chget) standard routine is checked (0919H) against the editing key table at [2439H](#2439h). Control then transfers to one of the editing routines or to the default key handler ([23FFH](#23ffh)) as appropriate. This process continues until Flag C is returned by the CTRL-STOP or CR routines. Register pair HL is then set to point to the start of [BUF](#buf) and the routine terminates. Note that the carry, flag is cleared when Flag NZ is also returned to distinguish between a CR or protected CTRL-STOP termination and a normal CTRL-STOP termination.

<a name="23ffh"></a>

    Address... 23FFH

This routine processes all characters for the [INLIN](#inlin) standard routine except the special editing keys. If the character is a TAB code (09H) spaces are issued ([23FFH](#23ffh)) until [CSRX](#csrx) is a multiple of eight plus one (columns 1, 9, 17, 25, 33). If the character is a graphic header code (01H) it is simply echoed to the [OUTDO](#outdo) standard routine. All other control codes smaller than 20H are echoed to the [OUTDO](#outdo) standard routine after which [INSFLG](#insflg) and [CSTYLE](#cstyle) are zeroed. For the displayable characters [INSFLG](#insflg) is first checked and a space inserted ([24F2H](#24f2h)) if applicable before the character is echoed to the [OUTDO](#outdo) standard routine.

<a name="2439h"></a>

    Address... 2439H

This table contains the special editing keys recognized by the [INLIN](#inlin) standard routine together with the relevant addresses:

|CODE |TO    |FUNCTION
|:---:|:----:|----------------------------
|08H  |2561H |BS, backspace
|12H  |24E5H |INS, toggle insert mode
|1BH  |23FEH |ESC, no action
|02H  |260EH |CTRL-B, previous word
|06H  |25F8H |CTRL-F, next word
|0EH  |25D7H |CTRL-N, end of logical line
|05H  |25B9H |CTRL-E, clear to end of line
|03H  |24C5H |CTRL-STOP, terminate
|0DH  |245AH |CR, terminate
|15H  |25AEH |CTRL-U, clear line
|7FH  |2550H |DEL, delete character

</a>

<a name="245ah"></a>

    Address... 245AH

This routine performs the CR operation for the [INLIN](#inlin) standard routine. The starting coordinates of the logical line are found ([266CH](#266ch)) and the cursor removed from the screen ([0A2EH](#0a2eh)). Up to 254 characters are then read from the VDP VRAM ([0BD8H](#0bd8h)) and placed in [BUF](#buf). Any null codes (00H) are ignored, any characters smaller than 20H are replaced by a graphic header code (01H) and the character itself with 40H added. As the end of each physical row is reached [LINTTB](#linttb) is checked ([0C1DH](#0c1dh)) to see whether the logical line extends to the next physical row. Trailing spaces are then stripped from [BUF](#buf) and a zero byte added as an end of text marker. The cursor is restored to the screen ([09E1H](#09e1h)) and its coordinates set to the last physical row of the logical line via the [POSIT](#posit) standard routine. A LF code is issued to the [OUTDO](#outdo) standard routine, [INSFLG](#insflg) is zeroed and the routine terminates with a CR code (0DH) in register A and Flag NZ,C. This CR code will be echoed to the screen by the [INLIN](#inlin) standard routine mainloop just before it terminates.

<a name="24c5h"></a>

    Address... 24C5H

This routine performs the CTRL-STOP operation for the [INLIN](#inlin) standard routine. The last physical row of the logical line is found by examining [LINTTB](#linttb) ([0C1DH](#0c1dh)), [CSTYLE](#cstyle) is zeroed, a zero byte is placed at the start of [BUF](#buf) and all music variables are cleared via the [GICINI](#gicini) standard routine. [TRPTBL](#trptbl) is then examined (0454H) to see if an "`ON STOP`" statement is active, if so the cursor is reset (24AFH) and the routine terminates with Flag NZ,C. [BASROM](#basrom) is then checked to see whether a protected ROM is running, if so the cursor is reset (24AFH) and the routine terminates with Flag NZ,C. Otherwise the cursor is reset (24B2H) and the routine terminates with Flag Z,C.

<a name="24e5h"></a>

    Address... 24E5H

This routine performs the INS operation for the [INLIN](#inlin) standard routine. The current state of [INSFLG](#insflg) is inverted and control terminates via the [CSTYLE](#cstyle) setting routine (242CH).

<a name="24f2h"></a>

    Address... 24F2H

This routine inserts a space character for the default key section of the [INLIN](#inlin) standard routine. The cursor is removed ([0A2EH](#0a2eh)) and the current cursor coordinates taken from [CSRX](#csrx) and [CSRY](#csry). The character at this position is read from the VDP VRAM ([0BD8H](#0bd8h)) and replaced with a space ([0BE6H](#0be6h)). Successive characters are then copied one column position to the right until the end of the physical row is reached.

At this point [LINTTB](#linttb) is examined ([0C1DH](#0c1dh)) to determine whether the logical line is extended, if so the process continues on the next physical row. Otherwise the character taken from the last column position is examined, if this is a space the routine terminates by replacing the cursor ([09E1H](#09e1h)). Otherwise the physical row's entry in [LINTTB](#linttb) is zeroed to indicate an extended logical line. The number of the next physical row is compared with the number of rows on the screen ([0C32H](#0c32h)). If the next row is the last one the screen is scrolled up (0A88H), otherwise a blank row is inserted (0AB7H) and the copying process continues.

<a name="2550h"></a>

    Address... 2550H

This routine performs the DEL operation for the [INLIN](#inlin) standard routine. If the current cursor position is at the rightmost column and the logical line is not extended no action is taken other than to write a space to the VDP VRAM (2595H). Otherwise a RIGHT code (1CH) is issued to the [OUTDO](#outdo) standard routine and control drops into the BS routine.

<a name="2561h"></a>

    Address... 2561H

This routine performs the BS operation for the [INLIN](#inlin) standard routine. The cursor is first removed ([0A2EH](#0a2eh)) and the cursor column coordinate decremented unless it is at the leftmost position and the previous row is not extended. Characters are then read from the VDP VRAM ([0BD8H](#0bd8h)) and written back one position to the left ([0BE6H](#0be6h)) until the end of the logical line is reached. At this point a space is written to the VDP VRAM ([0BE6H](#0be6h)) and the cursor character is restored ([09E1H](#09e1h)).

<a name="25aeh"></a>

    Address... 25AEH

This routine performs the CTRL-U operation for the [INLIN](#inlin) standard routine. The cursor is removed ([0A2EH](#0a2eh)) and the start of the logical line located ([266CH](#266ch)) and placed in [CSRX](#csrx) and [CSRY](#csry). The entire logical line is then cleared (25BEH).

<a name="25b9h"></a>

    Address... 25B9H

This routine performs the CTRL-E operation for the [INLIN](#inlin) standard routine. The cursor is removed ([0A2EH](#0a2eh)) and the remainder of the physical row cleared ([0AEEH](#0aeeh)). This process is repeated for successive physical rows until the end of the logical line is found in [LINTBB](#lintbb) ([0C1DH](#0c1dh)). The cursor is then restored ([09E1H](#09e1h)), [INSFLG](#insflg) zeroed and [CSTLYE](#cstlye) reset to a block cursor (242DH).

<a name="25d7h"></a>

    Address... 25D7H

This routine performs the CTRL-N operation for the [INLIN](#inlin) standard routine. The cursor is removed ([0A2EH](#0a2eh)) and the last physical row of the logical line found by examination of [LINTTB](#linttb) ([0C1DH](#0c1dh)). Starting at the rightmost column of this physical row characters are read from the VDP VRAM ([0BD8H](#0bd8h)) until a non-space character is found. The cursor coordinates are then set one column to the right of this position ([0A5BH](#0a5bh)) and the routine terminates by restoring the cursor (25CDH).

<a name="25f8h"></a>

    Address... 25F8H

This routine performs the CTRL-F operation for the [INLIN](#inlin) standard routine. The cursor is removed ([0A2EH](#0a2eh)) and moved successively right ([2624H](#2624h)) until a non-alphanumeric character is found. The cursor is then moved successively right ([2624H](#2624h)) until an alphanumeric character is found. The routine terminates by restoring the cursor (25CDH).

<a name="260eh"></a>

    Address... 260EH

This routine performs the CTRL-B operation for the [INLIN](#inlin) standard routine. The cursor is removed ([0A2EH](#0a2eh)) and moved successively left ([2634H](#2634h)) until an alphanumeric character is found. The cursor is then moved successively left ([2634H](#2634h)) until a non-alphanumeric character is found and then moved one position right ([0A5BH](#0a5bh)). The routine terminates by restoring the cursor (25CDH).

<a name="2624h"></a>

    Address... 2624H

This routine moves the cursor one position right ([0A5BH](#0a5bh)), loads register D with the rightmost column number, register E with the bottom row number and then tests for an alphanumeric character at the cursor position (263DH).

<a name="2634h"></a>

    Address... 2634H

This routine moves the cursor one position left ([0A4CH](#0a4ch)), loads register D with the leftmost column number and register E with the top row number. The current cursor coordinates are compared with these values and the routine terminates Flag Z if the cursor is at this position. Otherwise the character at this position is read from the VDP VRAM ([0BD8H](#0bd8h)) and checked to see if it is alphanumeric. If so the routine terminates Flag NZ,C otherwise it terminates Flag NZ,NC.

The alphanumeric characters are the digits "0" to "9" and the letters "A" to "Z" and "a" to "z". Also included are the graphics characters 86H to 9FH and A6H to FFH, these were originally Japanese letters and should have been excluded during the conversion to the UK ROM.

<a name="266ch"></a>

    Address... 266CH

This routine finds the start of a logical line and returns its screen coordinates in register pair HL. Each physical row above the current one is checked via the [LINTTB](#linttb) table ([0C1DH](#0c1dh)) until a non-extended row is found. The row immediately below this on the screen is the start of the logical line and its row number is placed in register L. This is then compared with [FSTPOS](#fstpos), which contains the row number when the [INLIN](#inlin) standard routine was first entered, to see if the cursor is still on the same line. If so the column coordinate in register H is set to its initial position from [FSTPOS](#fstpos). Otherwise register H is set to the leftmost position to return the whole line.

<a name="2680h"></a>
<a name="2683h"></a>
<a name="2686h"></a>
<a name="2689h"></a>

```
Address...2680H, JP to power-up initialize routine (7C76H).
Address...2683H, JP to the SYNCHR standard routine (558CH).
Address...2686H, JP to the CHRGTR standard routine (4666H).
Address...2689H, JP to the GETYPR standard routine (5597H).
```

<br><br><br>

<a name="chapter_5"></a>
# 5. ROM BASIC Interpreter

Microsoft BASIC has evolved over the years to its present position as the industry standard. It was originally written for the 8080 Microprocessor and even the MSX version is held in 8080 Assembly Language form. This process of continuous development means that there are less Z80-specific instructions than would be expected in a more modern program. It also means that numerous changes have been made and the result is a rather convoluted program. The structure of the Interpreter makes it unlikely that an application program will be able to use its many facilities. However most programs will need to cooperate with it to some extent so this chapter gives a detailed description of its operation.

There are four readily identifiable areas of importance within the Interpreter, the one most familiar to any user is the Mainloop ([4134H](#4134h)). This collects numbered lines of text from the console and places them in order in the Program Text Area of memory until a direct statement is received.

The Runloop ([4601H](#4601h)) is responsible for the execution of a program. It examines the first token of each program line and calls the appropriate routine to process the remainder of the statement. This continues until no more program text remains, control then returns to the Mainloop.

The analysis of numeric or string operands within a statement is performed by the Expression Evaluator ([4C64H](#4c64h)). Each expression is composed of factors, in turn analyzed by the Factor Evaluator ([4DC7H](#4dc7h)), which are linked together by dyadic infix operators. As there are several types of operand, notably line numbers, which cannot form part of an expression in Microsoft BASIC the term "evaluated" is only used to refer to those that can. Otherwise a term such as "computed" will be used.

One point to note when examining the Interpreter in detail is that it contains a lot of trick code. The writers seem particularly fond of jumping into the middle of instructions to provide multiple entry points to a routine. As an example take the instruction:

    3E D1       Normal: LD   A,0D1H

When encountered in the usual way this will of course load the accumulator with the value D1H. However if it is entered at "Normal" then it will be executed as a `POP DE` instruction. The Interpreter has many similarly obscure sections.

<a name="268ch"></a>

    Address... 268CH

This routine is used by the Expression Evaluator to subtract two double precision operands. The first operand is contained in [DAC](#dac) and the second in [ARG](#arg), the result is returned in [DAC](#dac). The second operand's mantissa sign is inverted and control drops into the addition routine.

<a name="269ah"></a>

    Address... 269AH

This routine is used by the Expression Evaluator to add two double precision operands. The first operand is contained in [DAC](#dac) and the second in [ARG](#arg), the result is returned in [DAC](#dac). If the second operand is zero the routine terminates with no action, if the first operand is zero the second operand is copied to [DAC](#dac) ([2F05H](#2f05h)) and the routine terminates. The two exponents are compared, if they differ by more than 10^15 the routine terminates with the larger operand as the result. Otherwise the difference between the two exponents is used to align the mantissae by shifting the smaller one rightwards ([27A3H](#27a3h)), for example:

```
19.2100 = .1921*10^2 = .192100
+ .7436 = .7436*10^0 = .007436
```

If the two mantissa signs are equal the mantissae are then added ([2759H](#2759h)), if they are different the mantissae are subtracted ([276BH](#276bh)). The exponent of the result is simply the larger of the two original exponents. If an overflow was produced by addition the result mantissa is shifted right one digit (27DBH) and the exponent incremented. If leading zeroes were produced by subtraction the result mantissa is renormalized by shifting left ([2797H](#2797h)). The guard byte is then examined and the result rounded up if the fifteenth digit is equal to or greater than five.

<a name="2759h"></a>

    Address... 2759H

This routine adds the two double precision mantissae contained in [DAC](#dac) and [ARG](#arg) and returns the result in [DAC](#dac). Addition commences at the least significant positions, [DAC](#dac)+7 and [ARG](#arg)+7, and proceeds two digits at a time for the seven bytes.

<a name="276bh"></a>

    Address... 276BH

This routine subtracts the two double precision mantissae contained in [DAC](#dac) and [ARG](#arg) and returns the result in [DAC](#dac). Subtraction commences at the guard bytes, [DAC](#dac)+8 and [ARG](#arg)+8, and proceeds two digits at a time for the eight bytes. If the result underflows it is corrected by subtracting it from zero and inverting the mantissa sign, for example:

    0.17-0.85 = 0.32 = -0.68

</a>

<a name="2797h"></a>

    Address... 2797H

This routine shifts the double precision mantissa contained in [DAC](#dac) one digit left.

<a name="27a3h"></a>

    Address... 27A3H

This routine shifts a double precision mantissa right. The number of digits to shift is supplied in register A, the address of the mantissa's most significant byte is supplied in register pair HL. The digit count is first divided by two to separate the byte and digit counts. The required number of whole bytes are then shifted right and the most significant bytes zeroed. If an odd number of digits was specified the mantissa is then shifted a further one digit right.

<a name="27e6h"></a>

    Address... 27E6H

This routine is used by the Expression Evaluator to multiply two double precision operands. The first operand is contained in [DAC](#dac) and the second in [ARG](#arg), the result is returned in [DAC](#dac). If either operand is zero the routine terminates with a zero result ([2E7DH](#2e7dh)). Otherwise the two exponents are added to produce the result exponent. If this is smaller than 10^-63 the routine terminates with a zero result, if it is greater than 10^63 an "`Overflow error`" is generated ([4067H](#4067h)). The two mantissa signs are then processed to yield the sign of the result, if they are the same the result is positive, if they differ it is negative.

Even though the mantissae are in BCD format they are multiplied using the normal binary add and shift method. To accomplish this the first operand is successively multiplied by two ([288AH](#288ah)) to produce the constants X\*80, X\*40, X\*20, X\*10, X\*8, X\*4, X\*2, and X in the [HOLD8](#hold8) buffer. The second operand remains in [ARG](#arg) and [DAC](#dac) is zeroed to function as the product accumulator. Multiplication proceeds by taking successive pairs of digits from the second operand starting with the least significant pair. For each 1 bit in the digit pair the appropriate multiple of the first operand is added to the product. As an example the single multiplication 1823\*96 would produce:

    1823*10010110=(1823*80)+(1823*10)+(1823*4)+(1823*2)

As each digit pair is completed the product is shifted two digits right. When all seven digit pairs have been processed the routine terminates by renormalizing and rounding up the product (26FAH).

The time required for a multiplication depends largely upon the number of 1 bits in the second operand. The worst case, when all the digits are sevens, can take up to 11 ms compared to the average of approximately 7 ms.

<a name="288ah"></a>

    Address... 288AH

This routine doubles a double precision mantissa three successive times to produce the products X\*2, X\*4 and X\*8. The address of the mantissa's least significant byte is supplied in register pair DE. The products are stored at successively lower addresses commencing immediately below the operand.

<a name="289fh"></a>

    Address... 289FH

This routine is used by the Expression Evaluator to divide two double precision operands. The first operand is contained in [DAC](#dac) and the second in [ARG](#arg), the result is returned in [DAC](#dac). If the first operand is zero the routine terminates with a zero result if the second operand is zero a "`Division by zero`" error is generated ([4058H](#4058h)). Otherwise the two exponents are subtracted to produce the result exponent and the two mantissa signs processed to yield the sign of the result. If they are the same the result is positive, if they differ it is negative.

The mantissae are divided using the normal long division method. The second operand is repeatedly subtracted from the first until underflow to produce a single digit of the result. The second operand is then added back to restore the remainder (2761H), the digit is stored in [HOLD](#hold) and the first operand is shifted one digit left. When the first operand has been completely shifted out the result is copied from [HOLD](#hold) to [DAC](#dac) then renormalized and rounded up (2883H). The time required for a division reaches a maximum of approximately 25 ms when the first operand is composed largely of nines and the second operand of ones. This will require the greatest number of subtractions.

<a name="2993h"></a>

    Address... 2993H

This routine is used by the Factor Evaluator to apply the "`COS`" function to a double precision operand contained in [DAC](#dac). The operand is first multiplied ([2C3BH](#2c3bh)) by 1/(2\*PI) so that unity corresponds to a complete 360 degree cycle. The operand then has 0.25 (90 degrees) subtracted ([2C32H](#2c32h)), its mantissa sign is inverted (2E8DH) and control drops into the "`SIN`" routine.

<a name="29ach"></a>

    Address... 29ACH

This routine is used by the Factor Evaluator to apply the "`SIN`" function to a double precision operand contained in [DAC](#dac). The operand is first multiplied ([2C3BH](#2c3bh)) by 1/(2\*PI) so that unity corresponds to a complete 360 degree cycle. As the function is periodic only the fractional part of the operand is now required. This is extracted by pushing the operand ([2CCCH](#2ccch)) obtaining the integer part ([30CFH](#30cfh)) and copying it to [ARG](#arg) ([2C4DH](#2c4dh)), popping the whole operand to [DAC](#dac) ([2CE1H](#2ce1h)) and then subtracting the integer part ([268CH](#268ch)).

The first digit of the mantissa is then examined to determine the operand's quadrant. If it is in the first quadrant it is unchanged. If it is in the second quadrant it is subtracted from 0.5 (180 degrees) to reflect it about the Y axis. If it is in the third quadrant it is subtracted from 0.5 (180 degrees) to reflect it about the X axis. If it is in the fourth quadrant 1.0 (360 degrees) is subtracted to reflect it about both axes. The function is then computed by polynomial approximation ([2C88H](#2c88h)) using the list of coefficients at 2DEFH. These are the first eight terms in the Taylor series X-(X^3/3!)+(X^5/5!)-(X^7/7!) ... with the coefficients multiplied by successive factors of 2\*PI to compensate for the initial scaling.

<a name="29fbh"></a>

    Address... 29FBH

This routine is used by the Factor Evaluator to apply the "`TAN`" function to a double precision operand contained in [DAC](#dac). The function is computed using the trigonometric identity TAN(X) = SIN(X)/COS(X).

<a name="2a14h"></a>

    Address... 2A14H

This routine is used by the Factor Evaluator to apply the "`ATN`" function to a double precision operand contained in [DAC](#dac). The function is computed by polynomial approximation ([2C88H](#2c88h)) using the list of coefficients at 2E30H. These are the first eight terms in the Taylor series X-(X^3/3)+(X^5/5)-(X^7/7) ... with the coefficients modified slightly to telescope the series.

<a name="2a72h"></a>

    Address... 2A72H

This routine is used by the Factor Evaluator to apply the "`LOG`" function to a double precision operand contained in [DAC](#dac). The function is computed by polynomial approximation using the list of coefficients at 2DA5H.

<a name="2affh"></a>

    Address... 2AFFH

This routine is used by the Factor Evaluator to apply the "`SQR`" function to a double precision operand contained in [DAC](#dac). The function is computed using the Newton-Raphson process, an equivalent BASIC program is:

```
10 INPUT"NUMBER";X
20 GUESS=10
30 FOR N=1 To 7
40 GUESS=(GUESS+X/GUESS)/2
50 NEXT N
60 PRINT GUESS
70 PRINT SQR(X)
```

The above program uses a fixed initial guess. While this is accurate over a limited range maximum accuracy will only be attained if the initial guess is near the root. The method used by the ROM is to halve the exponent, with rounding up, and then to divide the first two digits of the operand by four and increment the first digit.

<a name="2b4ah"></a>

    Address... 2B4AH

This routine is used by the Factor Evaluator to apply the "`EXP`" function to a double precision operand contained in [DAC](#dac). The operand is first multiplied by 0.4342944819, which is LOG(e) to Base 10, so that the problem becomes computing 10^X rather than e^X. This results in considerable simplification as the integer part can be dealt with easily. The function is then computed by polynomial approximation using the list of coefficients at 2D6BH.

<a name="2bdfh"></a>

    Address... 2BDFH

This routine is used by the Factor Evaluator to apply the "`RND`" function to a double precision operand contained in [DAC](#dac). If the operand is zero the current random number is copied to [DAC](#dac) from [RNDX](#rndx) and the routine terminates. If the operand is negative it is copied to [RNDX](#rndx) to set the current random number. The new random number is produced by copying [RNDX](#rndx) to [HOLD](#hold), the constant at 2CF9H to [ARG](#arg), the constant at 2CF1H to [DAC](#dac) and then multiplying (282EH). The fourteen least significant digits of the double length product are copied to [RNDX](#rndx) to form the mantissa of the new random number. The exponent byte in [DAC](#dac) is set to 10^0 to return a value in the range 0 to 1.

<a name="2c24h"></a>

    Address... 2C24H

This routine is used by the "`NEW`", "`CLEAR`" and "`RUN`" statement handlers to initialize [RNDX](#rndx) with the constant at 2D01H.

<a name="2c2ch"></a>

    Address... 2C2CH

This routine adds the constant whose address is supplied in register pair HL to the double precision operand contained in [DAC](#dac).

<a name="2c32h"></a>

    Address... 2C32H

This routine subtracts the constant whose address is supplied in register pair HL from the double precision operand contained in [DAC](#dac).

<a name="2c3bh"></a>

    Address... 2C3BH

This routine multiplies the double precision operand contained in [DAC](#dac) by the constant whose address is supplied in register pair HL.

<a name="2c41h"></a>

    Address... 2C41H

This routine divides the double precision operand contained in [DAC](#dac) by the constant whose address is supplied in register pair HL.

<a name="2c47h"></a>

    Address... 2C47H

This routine performs the relation operation on the double precision operand contained in [DAC](#dac) and the constant whose address is supplied in register pair HL.

<a name="2c4dh"></a>

    Address... 2C4DH
This routine copies an eight byte double precision operand from [DAC](#dac) to [ARG](#arg).

<a name="2c59h"></a>

    Address... 2C59H

This routine copies an eight byte double precision operand from [ARG](#arg) to [DAC](#dac).

<a name="2c6fh"></a>

    Address... 2C6FH

This routine exchanges the eight bytes in [DAC](#dac) with the eight bytes currently on the bottom of the Z80 stack.

<a name="2c80h"></a>

    Address... 2C80H

This routine inverts the mantissa sign of the operand contained in [DAC](#dac) (2E8DH). The same address is then pushed onto the stack to restore the sign when the caller terminates.

<a name="2c88h"></a>

    Address... 2C88H

This routine generates an odd series based on the double precision operand contained in [DAC](#dac). The series is of the form:

    X^1*(Kn)+X^3*(Kn-1)+x^5*(Kn-2)+X^5*(Kn-3) ...

The address of the coefficient list is supplied in register pair HL. The first byte of the list contains the coefficient count, the double precision coefficients follow with K1 first and Kn last. The even series is generated ([2C9AH](#2c9ah)) and multiplied ([27E6H](#27e6h)) by the original operand.

<a name="2c9ah"></a>

    Address... 2C9AH

This routine generates an even series based on the double precision operand contained in [DAC](#dac). The series is of the form:

    X^0*(Kn)+x^2*(Kn-1)+x^4*(Kn-2)+x^6*(Kn-3) ...

The address of the coefficient list is supplied in register pair HL. The first byte of the list contains the coefficient count, the double precision coefficients follow with K1 first and Kn last. The method used to compute the polynomial is known as Horner's method. It only requires one multiplication and one addition per term, the BASIC equivalent is:

```
10 X=X*X
20 PRODUCT=0
30 RESTORE 100
40 READ COUNT
50 FOR N=1 TO COUNT
60 READ K
70 PRODUCT= ( PRODUCT*X ) +K
80 NEXT N
90 END
100 DATA 8
110 DATA Kn-7
120 DATA Kn-6
130 DATA Kn-5
140 DATA Kn-4
150 DATA Kn-3
160 DATA Kn-2
170 DATA Kn-1
180 DATA Kn
```

The polynomial is processed from the final coefficient through to the first coefficient so that the partial product can be used to save unnecessary operations.

<a name="2cc7h"></a>

    Address... 2CC7H

This routine pushes an eight byte double precision operand from [ARG](#arg) onto the Z80 stack.

<a name="2ccch"></a>

    Address... 2CCCH

This routine pushes an eight byte double precision operand from [DAC](#dac) onto the Z80 stack.

<a name="2cdch"></a>

    Address... 2CDCH

This routine pops an eight byte double precision operand from the Z80 stack into [ARG](#arg).

<a name="2ce1h"></a>

    Address... 2CE1H

This routine pops an eight byte double precision operand from the Z80 stack into [DAC](#dac).

<a name="2cf1h"></a>

    Address... 2CF1H

This table contains the double precision constants used by the math routines. The first three constants have zero in the exponent position as they are in a special intermediate form used by the random number generator.

|ADDRESS|CONSTANT           |           |ADDRESS|CONSTANT           |   |
|-------|-------------------|-----------|-------|-------------------|---|
|2CF1H  |.14389820420821    |RND        |2DAEH  |6.2503651127908    |   |
|2CF9H  |.21132486540519    |RND        |2DB6H  |-13.682370241503   |   |
|2D01H  |.40649651372358    |           |2DBEH  |8.5167319872389    |   |
|2D09H  |.43429448190324    |LOG(e)     |2DC6H  |5                  |LOG|
|2D11H  |.50000000000000    |           |2DC7H  |1.0000000000000    |   |
|2D13H  |.00000000000000    |           |2DCFH  |-13.210478350156   |   |
|2D1BH  |1.0000000000000    |           |2DD7H  |47.925256043873    |   |
|2D23H  |.25000000000000    |           |2DDFH  |-64.906682740943   |   |
|2D2BH  |3.1622776601684    |SQR(10)    |2DE7H  |29.415750172323    |   |
|2D33H  |.86858896380650    |2^LOG(e)   |2DEFH  |8                  |SIN|
|2D3BH  |2.3025850929940    |1/LOG(e)   |2DF0H  |-.69215692291809   |   |
|2D43H  |1.5707963267949    |PI/2       |2DF8H  | 3.8172886385771   |   |
|2D4BH  |.26794919243112    |TAN(PI/12) |2E00H  |-15.094499474801   |   |
|2D53H  |1.7320508075689    |TAN(PI/3)  |2E08H  | 42.058689667355   |   |
|2D5BH  |.52359877559830    |PI/6       |2E10H  |-76.705859683291   |   |
|2D63H  |.15915494309190    |1/(2^PI)   |2E18H  | 81.605249275513   |   |
|2D6BH  |4                  |EXP        |2E20H  |-41.341702240398   |   |
|2D6CH  |1.0000000000000    |           |2E28H  | 6.2831853071796   |   |
|2D74H  |159.37415236031    |           |2E30H  |8                  |ATN|
|2D7CH  |2709.3169408516    |           |2E31H  |-.05208693904000   |   |
|2D84H  |4497.6335574058    |           |2E39H  |.07530714913480    |   |
|2D8CH  |3                  |EXP        |2E41H  |-.09081343224705   |   |
|2D8DH  |18.312360159275    |           |2E49H  |.11110794184029    |   |
|2D95H  |831.40672129371    |           |2E51H  |-.14285708554884   |   |
|2D9DH  |5178.0919915162    |           |2E59H  |.19999999948967    |   |
|2DA5H  |4                  |LOG        |2E61H  |-.33333333333160   |   |
|2DA6H  |-.71433382153226   |           |2E69H  |1.0000000000000    |   |

</a>

<a name="2e71h"></a>

    Address... 2E71H

This routine returns the mantissa sign of a Floating Point operand contained in [DAC](#dac). The exponent byte is tested and the result returned in register A and the flags:

```
Zero ....... A=00H, Flag Z,NC
Positive ... A=01H, Flag NZ,NC
Negative ... A=FFH, Flag NZ,C
```

</a>

<a name="2e7dh"></a>

    Address... 2E7DH

This routine simply zeroes the exponent byte in [DAC](#dac).

<a name="2e82h"></a>

    Address... 2E82H

This routine is used by the Factor Evaluator to apply the "`ABS`" function to an operand contained in [DAC](#dac). The operand's sign is first checked ([2EA1H](#2ea1h)), if it is positive the routine simply terminates. The operand's type is then checked via the [GETYPR](#getypr) standard routine. If it is a string a "`Type mismatch`" error is generated ([406DH](#406dh)). If it is an integer it is negated ([322BH](#322bh)). If it is a double precision or single precision operand the mantissa sign bit in [DAC](#dac) is inverted.

<a name="2e97h"></a>

    Address... 2E97H

This routine is used by the Factor Evaluator to apply the "`SGN`" function to an operand contained in [DAC](#dac). The operand's sign is checked ([2EA1H](#2ea1h)), extended into register pair HL and then placed in [DAC](#dac) as an integer:

```
Zero ....... 0000H
Positive ... 0001H
Negative ... FFFFH
```

</a>

<a name="2ea1h"></a>

    Address... 2EA1H

This routine returns the sign of an operand contained in [DAC](#dac). The operands type is first checked via the [GETYPR](#getypr) standard routine. If it is a string a "`Type mismatch`" error is generated ([406DH](#406dh)). If it is a single precision or double precision operand the mantissa sign is examined ([2E71H](#2e71h)). If it is an integer its value is taken from [DAC](#dac)+2 and translated into the flags shown at [2E71H](#2e71h).

<a name="2eb1h"></a>

    Address... 2EB1H

This routine pushes a four byte single precision operand from [DAC](#dac) onto the Z80 stack.

<a name="2ec1h"></a>

    Address... 2EC1H

This routine copies the contents of registers C, B, E and D to [DAC](#dac).

<a name="2ecch"></a>

    Address... 2ECCH

This routine copies the contents of [DAC](#dac) to registers C, B, E and D.

<a name="2ed6h"></a>

    Address... 2ED6H

This routine loads registers C, B, E and D from upwardly sequential locations starting at the address supplied in register pair HL.

<a name="2edfh"></a>

    Address... 2EDFH

This routine loads registers E, D, C and B from upwardly sequential locations starting at the address supplied in register pair HL.

<a name="2ee8h"></a>

    Address... 2EE8H

This routine copies a single precision operand from [DAC](#dac) to the address supplied in register pair HL.

<a name="2eefh"></a>

    Address... 2EEFH

This routine copies any operand from the address supplied in register pair HL to [ARG](#arg). The length of the operand is contained in [VALTYP](#valtyp): 2=Integer, 3=String, 4=Single Precision, 8=Double Precision.

<a name="2f05h"></a>

    Address... 2F05H

This routine copies any operand from [ARG](#arg) to [DAC](#dac). The length of the operand is contained in [VALTYP](#valtyp): 2=Integer, 3=String, 4=Single Precision, 8=Double Precision.

<a name="2f0dh"></a>

    Address... 2F0DH

This routine copies any operand from [DAC](#dac) to [ARG](#arg). The length of the operand is contained in [VALTYP](#valtyp): 2=Integer, 3=String, 4=Single Precision, 8=Double Precision.

<a name="2f21h"></a>

    Address... 2F21H

This routine is used by the Expression Evaluator to find the relation (<>=) between two single precision operands. The first operand is contained in registers C, B, E and D and the second in [DAC](#dac). The result is returned in register A and the flags:

```
Operand 1=Operand 2 ... A=00H, Flag Z,NC
Operand 1<Operand 2 ... A=01H, Flag NZ,NC
Operand 1>Operand 2 ... A=FFH, Flag NZ,C
```

It should be noted that for relational operators the Expression Evaluator regards maximally negative numbers as small and maximally positive numbers as large.

<a name="2f4dh"></a>

    Address... 2F4DH

This routine is used by the Expression Evaluator to find the relation (<>=) between two integer operands. The first operand is contained in register pair DE and the second in register pair HL. The results are as for the single precision version ([2F21H](#2f21h)).

<a name="2f83h"></a>

    Address... 2F83H

This routine is used by the Expression Evaluator to find the relation (<>=) between two double precision operands. The first operand is contained in [DAC](#dac) and the second in [ARG](#arg). The results are as for the single precision version ([2F21H](#2f21h)).

<a name="2f8ah"></a>

    Address... 2F8AH

This routine is used by the Factor Evaluator to apply the "`CINT`" function to an operand contained in [DAC](#dac). The operand type is first checked via the [GETYPR](#getypr) standard routine, if it is already integer the routine simply terminates. If it is a string a "`Type mismatch`" error is generated ([406DH](#406dh)). If it is a single precision or double precision operand it is converted to a signed binary integer in register pair DE ([305DH](#305dh)) and then placed in [DAC](#dac) as an integer. Out of range values result in an "`Overflow`" error ([4067H](#4067h)).

<a name="2fa2h"></a>

    Address... 2FA2H

This routine checks whether [DAC](#dac) contains the single precision operand -32768, if so it replaces it with the integer equivalent 8000H. This step is required during numeric input conversion ([3299H](#3299h)) because of the asymmetric integer number range.

<a name="2fb2h"></a>

    Address... 2FB2H

This routine is used by the Factor Evaluator to apply the "`CSNG`" function to an operand contained in [DAC](#dac). The operand's type is first checked via the [GETYPR](#getypr) standard routine, if it is already single precision the routine simply terminates. If it is a string a "`Type mismatch`" error is generated ([406DH](#406dh)). If it is double precision [VALTYP](#valtyp) is changed (3053H) and the mantissa rounded up from the seventh digit (2741H). If the operand is an integer it is converted from binary to a maximum of five BCD digits by successive divisions using the constants 10000, 1000, 100, 10, 1. These are placed in [DAC](#dac) to form the single precision mantissa. The exponent is equal to the number of significant digits in the mantissa. For example if there are five the exponent would be 10^5.

<a name="3030h"></a>

    Address... 3030H

This table contains the five constants used by the "`CSNG`" routine: -10000, -1000, -100, -10, -1

<a name="303ah"></a>

    Address... 303AH

This routine is used by the Factor Evaluator to apply the "`CDBL`" function to an operand contained in [DAC](#dac). The operand's type is first checked via the [GETYPR](#getypr) standard routine, if it is already double precision the routine simply terminates. If it is a string a "`Type mismatch`" error is generated ([406DH](#406dh)). If it is an integer it is first converted to single precision (2FC8H), the eight least significant digits are then zeroed and [VALTYP](#valtyp) set to 8.

<a name="3058h"></a>

    Address... 3058H

This routine checks that the current operand is a string type, if not a "`Type mismatch`" error is generated ([406DH](#406dh)).

<a name="305dh"></a>

    Address... 305DH

This routine is used by the "`CINT`" routine ([2F8AH](#2f8ah)) to convert a BCD single precision or double precision operand into a signed binary integer in register pair DE, it returns Flag C if an overflow has occurred. Successive digits are taken from the mantissa and added to the product starting with the most significant one. After each addition the product is multiplied by ten. The number of digits to process is determined by the exponent, for example five digits would be taken with an exponent of 10^5. Finally the mantissa sign is checked and the product negated (3221H) if necessary.

<a name="30beh"></a>

    Address... 30BEH

This routine is used by the Factor Evaluator to apply the "`FIX`" function to an operand contained in [DAC](#dac). The operand's type is first checked via the [GETYPR](#getypr) standard routine, if it is an integer the routine simply terminates. The mantissa sign is then checked ([2E71H](#2e71h)), if it is positive control transfers to the "`INT`" routine ([30CFH](#30cfh)). Otherwise the sign is inverted to positive, the "`INT`" function is performed ([30CFH](#30cfh)) and the sign restored to negative.

<a name="30cfh"></a>

    Address... 30CFH

This routine is used by the Factor Evaluator to apply the "`INT`" function to an operand contained in [DAC](#dac). The operand's type is first checked via the [GETYPR](#getypr) standard routine, if it is an integer the routine simply terminates. The number of fractional digits is determined by subtracting the exponent from the type's digit count, 6 for single precision, 14 for double precision.

If the mantissa sign is positive these fractional digits are simply zeroed. If the mantissa sign is negative each fractional digit is examined before it is zeroed. If all the digits were previously zero the routine simply terminates. Otherwise -1.0 is added to the operand by the single precision addition routine ([324EH](#324eh)) or the double precision addition routine ([269AH](#269ah)). It should be noted that an operand's type is not normally changed by the "`CINT`" function.

<a name="314ah"></a>

    Address... 314AH

This routine multiplies the unsigned binary integers in register pairs BC and DE, the result is returned in register pair DE. The standard shift and add method is used, the product is successively multiplied by two and register pair BC added to it for every 1 bit in register pair DE. The routine is used by the Variable search routine ([5EA4H](#5ea4h)) to compute an element's position within an Array, a "`Subscript out of range`" error is generated (601DH) if an overflow occurs.

<a name="3167h"></a>

    Address... 3167H

This routine is used by the Expression Evaluator to subtract two integer operands. The first operand is contained in register pair DE and the second in register pair HL, the result is returned in [DAC](#dac). The second operand is negated (3221H) and control drops into the addition routine.

<a name="3172h"></a>

    Address... 3172H

This routine is used by the Expression Evaluator to add two integer operands. The first operand is contained in register pair DE and the second in register pair HL, the result is returned in [DAC](#dac). The signed binary operands are normally just added and placed in [DAC](#dac). However, if an overflow has occurred both operands are converted to single precision (2FCBH) and control transfers to the single precision adder ([324EH](#324eh)). An overflow has occurred when both operands are of the same sign and the result is of the opposite sign, for example:

    30000+15000=-20536

</a>

<a name="3193h"></a>

    Address... 3193H

This routine is used by the Expression Evaluator to multiply two integer operands. The first operand is contained in register pair DE and the second in register pair HL, the result is returned in [DAC](#dac). The two operand signs are saved temporarily and both operands made positive ([3215H](#3215h)). Multiplication proceeds using the standard binary shift and add method with register pair HL as the product accumulator, register pair BC containing the first operand and register pair DE the second. If the product exceeds 7FFFH at any time during multiplication both operands are converted to single precision (2FCBH) and control transfers to the single precision multiplier ([325CH](#325ch)). Otherwise the initial signs are restored and, if they differ, the product negated before being placed in [DAC](#dac) as an integer (321DH).

<a name="31e6h"></a>

    Address... 31E6H

This routine is used by the Expression Evaluator to integer divide (\) two integer operands. The first operand is contained in register pair DE and the second in register pair HL, the result is returned in [DAC](#dac). If the second operand is zero a "`Division by zero`" error is generated ([4058H](#4058h)), otherwise the two operand signs are saved and both operands made positive ([3215H](#3215h)). Division proceeds using the standard binary shift and subtract method with register pair HL containing the remainder, register pair BC the second operand and register pair DE the first operand and the product. When division is complete the initial signs are restored and, if they differ, the product is negated before being placed in [DAC](#dac) as an integer (321DH).

<a name="3215h"></a>

    Address... 3215H

This routine is used to make two signed binary integers, in register pairs HL and DE, positive. Both the initial operand signs are returned as a flag in bit 7 of register B: 0=Same, 1=Different. Each operand is then examined and, if it is negative, made positive by subtracting it from zero.

<a name="322bh"></a>

    Address... 322BH

This routine is used by the "`ABS`" function to make a negative integer contained in [DAC](#dac) positive. The operand is taken from [DAC](#dac), negated and then placed back in [DAC](#dac) (3221H). If the operand's value is 8000H it is converted to single precision (2FCCH) as there is no integer of value +32768.

<a name="323ah"></a>

    Address... 323AH

This routine is used by the Expression Evaluator to "`MOD`" two integer operands. The first operand is contained in register pair DE and the second in register pair HL, the result is returned in [DAC](#dac). The sign of the first operand is saved and the two operands divided ([31E6H](#31e6h)). As the remainder is returned doubled by the division process register pair DE is shifted one place right to restore it. The sign of the first operand is then restored and, if it is negative, the remainder is negated before being placed in [DAC](#dac) as an integer (321DH).

<a name="324eh"></a>

    Address... 324EH

This routine is used by the Expression Evaluator to add two single precision operands. The first operand is contained in registers C, B, E, D and the second in [DAC](#dac), the result is returned in [DAC](#dac). The first operand is copied to [ARG](#arg) ([3280H](#3280h)), the second operand is converted to double precision (3042H) and control transfers to the double precision adder ([269AH](#269ah)).

<a name="3257h"></a>

    Address... 3257H

This routine is used by the Expression Evaluator to subtract two single precision operands. The first operand is contained in registers C, B, E, D and the second in [DAC](#dac), the result is returned in [DAC](#dac). The second operand is negated (2E8DH) and control transfers to the single precision adder ([324EH](#324eh)).

<a name="325ch"></a>

    Address... 325CH

This routine is used by the Expression Evaluator to multiply two single precision operands. The first operand is contained in registers C, B, E, D and the second in [DAC](#dac), the result is returned in [DAC](#dac). The first operand is copied to [ARG](#arg) ([3280H](#3280h)), the second operand is converted to double precision (3042H) and control transfers to the double precision multiplier ([27E6H](#27e6h)).

<a name="3265h"></a>

    Address... 3265H

This routine is used by the Expression Evaluator to divide two single precision operands. The first operand is contained in registers C, B, E, D and the second in [DAC](#dac), the result is returned in [DAC](#dac). The first and second operands are exchanged so that the first is in [DAC](#dac) and the second in the registers. The second operand is then copied to [ARG](#arg) ([3280H](#3280h)), the first operand is converted to double precision (3042H) and control transfers to the double precision divider ([289FH](#289fh)).

<a name="3280h"></a>

    Address... 3280H

This routine copies the single precision operand contained in registers C, B, E and D to [ARG](#arg) and then zeroes the four least significant bytes.

<a name="3299h"></a>

    Address... 3299H

This routine converts a number in textual form to one of the standard internal numeric types, it is used during tokenization and by the "`VAL`", "`INPUT`" and "`READ`" Statement handlers. On entry register pair HL points to the first character of the text string to be converted. On exit register pair HL points to the character following the string, the numeric operand is in [DAC](#dac) and the type code in [VALTYP](#valtyp). Examples of the three types are:

<a name="figure41"></a>![][CH05F41]

**Figure 41:** Numeric Types in DAC

An integer is a sixteen bit binary number in two's complement form, it is stored LSB first, MSB second at [DAC](#dac)+2. An integer can range from 8000H (-32768) to 7FFFH (+32767).

A floating point number consists of an exponent byte and a three or seven byte mantissa. The exponent is kept in signed binary form and can range from 01H (-63) through 40H (0) up to 7FH (+63), the special value of 00H is used for the number zero. These exponent values are for a normalized mantissa. The Interpreter presents exponent-form numbers to the user with a leading digit, this results in an asymmetric exponent range of E-64 to E+62. Bit 7 of the exponent byte holds the mantissa sign, 0 for positive and 1 for negative, the mantissa itself is kept in packed BCD form with two digits per byte. It should be noted that the Interpreter uses the contents of [VALTYP](#valtyp) to determine a number's type, not the format of the number itself.

Conversion starts by examining the first text character. If this is an "&" control transfers to the special radix conversion routine ([4EB8H](#4eb8h)), if it is a leading sign character it is temporarily saved. Successive numeric characters are then taken and added to the integer product with appropriate multiplications by ten as each new digit is found. If the value of the product exceeds 32767, or a decimal point is found, the product is converted to single precision and any further characters placed directly in [DAC](#dac). If a seventh digit is found the product is changed to double precision, if more than fourteen digits are found the excess digits are read but ignored.

Conversion ceases when a non-numeric character is found. If this a type definition character ("%", "#" or "!") the appropriate conversion routine is called and control transfers to the exit point (331EH). If it is an exponent prefix ("E", "e", "D" or "d") one of the conversion routines will also be used and then the following digits converted to a binary exponent in register E. At the exit point (331EH) the product's type is checked via the [GETYPR](#getypr) standard routine. If it is single precision or double precision the exponent is calculated by first subtracting the fractional digit count, in register B, from the total digit count, in register D, to produce the leading digit count. This is then added to any explicitly stated exponent, in register E, and placed at [DAC](#dac)+0 as the exponent.

The leading sign character is restored and the product negated if required (2E86H), if the product is integer the routine then terminates. If the product is single precision control terminates by checking for the special value of -32768 ([2FA2H](#2fa2h)). If the product is double precision control terminates by rounding up from the fifteenth digit (273CH).

<a name="340ah"></a>

    Address... 340AH

This routine is used by the error handler to display the message " in " ([6678H](#6678h)) followed by the line number supplied in register pair HL ([3412H](#3412h)).

<a name="3412h"></a>

    Address... 3412H

This routine displays the unsigned binary integer supplied in register pair HL. The operand is placed in [DAC](#dac) as an integer (2F99H), converted to text (3441H) and then displayed (6677H).

<a name="3425h"></a>

    Address... 3425H

This routine converts the numeric operand contained in [DAC](#dac) to textual form in [FBUFFR](#fbuffr). The address of the first character of the resulting text is returned in register pair HL, the text is terminated by a zero byte. The operand is first converted to double precision ([375FH](#375fh)). The BCD digits of the mantissa are then unpacked, converted to ASCII and placed in [FBUFFR](#fbuffr) (36B3H). The position of the decimal point is determined by the exponent, for example:

```
.999*10 ^ +2 = 99.9
.999*10 ^ +1 = 9.99
.999*10 ^ +0 = .999
.999*10 ^ -1 = .0999
```

If the exponent is outside the range 10^-1 to 10^14 the number is presented in exponential form. In this case the decimal point is placed after the first digit and the exponent is converted from binary and follows the mantissa.

An alternative entry point to the routine exists at 3426H for the "`PRINT USING`" statement handler. With this entry point the number of characters to prefix the decimal point is supplied in register B, the number of characters to point fix it in register C and a format byte in register A:

<a name="figure42"></a>![][CH05F42]

**Figure 42:** Format Byte

Operation in this mode is fairly similar to the normal mode but with the addition of extra facilities. Once the operand has been converted to double precision the exponential form will be assumed if bit 0 of the format byte is set. The mantissa is shifted to the right in [DAC](#dac) and rounded up to lose unwanted postfix digits ([377BH](#377bh)). As the mantissa is converted to ASCII (36B3H) commas will be inserted at the appropriate points if bit 6 of the format byte is set. During post-conversion formatting (351CH) unused prefix positions will be filled with asterisks if bit 5 is set, a pound prefix may be added by setting bit 4. Bit 3 enables the "+" sign for positive numbers if set, otherwise a space is used. Bit 2 places any sign at the front if reset and at the back if set.

The entry point to the routine at 3441H is used to convert unsigned integers, notably line numbers, to their textual form. For example 9000H, when treated as a normal integer, would be converted to -28672. By using this entry point 36864 would be produced instead. The operand is converted by successive division with the factors 10000, 1000, 100, 10 and 1 and the resulting digits placed in [FBUFFR](#fbuffr) (36DBH).

<a name="3710h"></a>

    Address... 3710H

This table contains the five constants used by the numeric output routine: 10000, 1000, 100, 10, 1.

<a name="371ah"></a>

    Address... 371AH

This routine is used by the "`BIN`$" function to convert a numeric operand contained in [DAC](#dac) to textual form. Register B is loaded with the group size (1) and control transfers to the general conversion routine (3724H).

<a name="371eh"></a>

    Address... 371EH

This routine is used by the "`OCT`$" function to convert a numeric operand contained in [DAC](#dac) to textual form. Register B is loaded with the group size (3) and control transfers to the general conversion routine (3724H).

<a name="3722h"></a>

    Address... 3722H

This routine is used by the "`HEX`$" function to convert a numeric operand contained in [DAC](#dac) to textual form. Register B is loaded with the group size (4) and the operand converted to a binary integer in register pair HL ([5439H](#5439h)). Successive groups of 1, 3 or 4 bits are shifted rightwards out of the operand, converted to ASCII digits and placed in [FBUFFR](#fbuffr). When the operand is all zeroes the routine terminates with the address of the first text character in register pair HL, the string is terminated with a zero byte.

<a name="3752h"></a>

    Address... 3752H

This routine is used during numeric output to return an operand's digit count in register B and the address of its least significant byte in register pair HL. For single precision B=6 and HL=[DAC](#dac)+3, for double precision B=14 and HL=[DAC](#dac)+7.

<a name="375fh"></a>

    Address... 375FH

This routine is used during numeric output to convert the numeric operand in [DAC](#dac) to double precision ([303AH](#303ah)).

<a name="377bh"></a>

    Address... 377BH

This routine is used during numeric output to shift the mantissa in [DAC](#dac) rightwards (27DBH), the inverse of the digit count is supplied in register A. The result is then rounded up from the fifteenth digit (2741H).

<a name="37a2h"></a>

    Address... 37A2H

This routine is used during numeric output to return the inverse of the fractional digit count in a floating point operand. This is computed by subtracting the exponent from the operand's digit count (6 or 14).

<a name="37b4h"></a>

    Address... 37B4H

This routine is used during numeric output to locate the last non-zero digit of the mantissa contained in [DAC](#dac). Its address is returned in register pair HL.

<a name="37c8h"></a>

    Address... 37C8H

This routine is used by the Expression Evaluator to exponentiate (^) two single precision operands. The first operand is contained in registers C, B, E, D and the second in [DAC](#dac), the result is returned in [DAC](#dac). The first operand is copied to [ARG](#arg) ([3280H](#3280h)), pushed onto the stack ([2CC7H](#2cc7h)) and exchanged with [DAC](#dac) ([2C6FH](#2c6fh)). The second operand is then popped into [ARG](#arg) and control drops into the double precision exponentiation routine.

<a name="37d7h"></a>

    Address... 37D7H

This routine is used by the Expression Evaluator to exponentiate (^) two double precision operands. The first operand is contained in [DAC](#dac) and the second in [ARG](#arg), the result is returned in [DAC](#dac). The result is usually computed using:

    X^P=EXP(P*LOG(X))

An alternative, much faster, method is possible if the power operand is an integer. This is tested for by extracting the integer part of the operand and comparing for equality with the original value ([391AH](#391ah)). A positive result to this test means that the faster method can be used, this is described below.

<a name="383fh"></a>

    Address... 383FH

This routine is used by the Expression Evaluator to exponentiate (^) two integer operands. The first operand is contained in register pair DE and the second in register pair HL, the result is returned in [DAC](#dac). The routine operates by breaking the problem down into simple multiplications:

    6^13=6^1101=(6^8)*(6^4)*(6^1)

As the power operand is in binary form a simple right shift is sufficient to determine whether a particular intermediate product needs to be included in the result. The intermediate products themselves are obtained by cumulative multiplication of the operand each time the computation loop is traversed. If the product overflows at any time it is converted to single precision. Upon completion the power operand is checked, if it is negative the product is reciprocated as X^-P=1/X^P.

<a name="390dh"></a>

    Address... 390DH

This routine is used during exponentiation to multiply two integers ([3193H](#3193h)), it returns Flag NZ if the result has overflowed to single precision.

<a name="391ah"></a>

    Address... 391AH

This routine is used during exponentiation to check whether a double precision power operand consists only of an integer part, if so it returns Flag NC.

<a name="392eh"></a>

    Address... 392EH

This table of addresses is used by the Interpreter Runloop to find the handler for a statement token. Although not part of the table the associated keywords are included below:

|TO     |STATEMENT  |TO     |SATEMENT   |TO     |STMT   |
|-------|-----------|-------|-----------|-------|-------|
|63EAH  |END        |00C3H  |CLS        |5B11H  |CIRCLE |
|4524H  |FOR        |51C9H  |WIDTH      |7980H  |COLOR  |
|6527H  |NEXT       |485DH  |ELSE       |5D6EH  |DRAW   |
|485BH  |DATA       |6438H  |TRON       |59C5H  |PAINT  |
|4B6CH  |INPUT      |6439H  |TROFF      |00C0H  |BEEP   |
|5E9FH  |DIM        |643EH  |SWAP       |73E5H  |PLAY   |
|4B9FH  |READ       |6477H  |ERASE      |57EAH  |PSET   |
|4880H  |LET        |49AAH  |ERROR      |57E5H  |PRESET |
|47E8H  |GOTO       |495DH  |RESUME     |73CAH  |SOUND  |
|479EH  |RUN        |53E2H  |DELETE     |79CCH  |SCREEN |
|49E5H  |IF         |49B5H  |AUTO       |7BE2H  |VPOKE  |
|63C9H  |RESTORE    |5468H  |RENUM      |7A48H  |SPRITE |
|47B2H  |GOSUB      |4718H  |DEFSTR     |7B37H  |VDP    |
|4821H  |RETURN     |471BH  |DEFINT     |7B5AH  |BASE   |
|485DH  |REM        |471EH  |DEFSNG     |55A8H  |CALL   |
|63E3H  |STOP       |4721H  |DEFDBL     |7911H  |TIME   |
|4A24H  |PRINT      |4B0EH  |LINE       |786CH  |KEY    |
|64AFH  |CLEAR      |6AB7H  |OPEN       |7E4BH  |MAX    |
|522EH  |LIST       |7C52H  |FIELD      |73B7H  |MOTOR  |
|6286H  |NEW        |775BH  |GET        |6EC6H  |BLOAD  |
|48E4H  |ON         |7758H  |PUT        |6E92H  |BSAVE  |
|401CH  |WAIT       |6C14H  |CLOSE      |7C16H  |DSKO$  |
|501DH  |DEF        |6B5DH  |LOAD       |7C1BH  |SET    |
|5423H  |POKE       |6B5EH  |MERGE      |7C20H  |NAME   |
|6424H  |CONT       |6C2FH  |FILES      |7C25H  |KILL   |
|6FB7H  |CSAVE      |7C48H  |LSET       |7C2AH  |IPL    |
|703FH  |CLOAD      |7C4DH  |RSET       |7C2FH  |COPY   |
|4016H  |OUT        |6BA3H  |SAVE       |7C34H  |CMD    |
|4A1DH  |LPRINT     |6C2AH  |LFILES     |7766H  |LOCATE |
|5229H  |LLIST      |       |           |       |       |

<a name="39deh"></a>

    Address... 39DEH

This table of addresses is used by the Factor Evaluator to find the handler for a function token. Although not part of the table the associated keywords are included with the addresses shown below:

|TO     |FUNCTION   |TO     |FUNCTION   |TO     |FUNCTION   |
|-------|-----------|-------|-----------|-------|-----------|
|6861H  |LEFT$      |4FCCH  |POS        |30BEH  |FIX        |
|6891H  |RIGHT$     |67FFH  |LEN        |7940H  |STICK      |
|689AH  |MID$       |6604H  |TR$        |794CH  |TRIG       |
|2E97H  |SGN        |68BBH  |VAL        |795AH  |PDL        |
|30CFH  |INT        |680BH  |ASC        |7969H  |PAD        |
|2E82H  |ABS        |681BH  |CHR$       |7C39H  |DSKF       |
|2AFFH  |SQR        |541CH  |PEEK       |6D39H  |FPOS       |
|2BDFH  |RND        |7BF5H  |VPEEK      |7C66H  |CVI        |
|29ACH  |SIN        |6848H  |SPACE$     |7C6BH  |CVS        |
|2A72H  |LOG        |7C70H  |OCT$       |7C70H  |CVD        |
|2B4AH  |EXP        |65FAH  |HEX$       |6D25H  |EOF        |
|2993H  |COS        |4FC7H  |LPOS       |6D03H  |LOC        |
|29FBH  |TAN        |6FFFH  |BIN$       |6D14H  |LOF        |
|2A14H  |ATN        |2F8AH  |CINT       |7C57H  |MKI$       |
|69F2H  |FRE        |2FB2H  |CSNG       |7C5CH  |MKS$       |
|4001H  |INP        |303AH  |CDBL       |7C61H  |MKD$       |

<a name="3a3eh"></a>

    Address... 3A3EH

This table of addresses is used during program tokenization as an index into the BASIC keyword table ([3A72H](#3a72h)). Each of the twenty six entries defines the starting address of one of the keyword sub-blocks. The first entry points to the keywords beginning with the letter "A", the second to those beginning with the letter "B" and so on.

```
3A72H ... A   3B9FH ... J    3C8EH ... S
3A88H ... B   3BA0H ... K    3CDBH ... T
3A9FH ... C   3BA8H ... L    3CF6H ... U
3AF3H ... D   3BE8H ... M    3CFFH ... V
3B2EH ... E   3C09H ... N    3D16H ... W
3B4FH ... F   3C18H ... O    3D20H ... X
3B69H ... G   3C2BH ... P    3D24H ... Y
3B7BH ... H   3C5DH ... Q    3D25H ... Z
3B80H ... I   3C5EH ... R
```

<a name="3a72h"></a>

    Address... 3A72H

This table contains the BASIC keywords and tokens. Each of the twenty-six blocks within the table contains all the keywords beginning with a particular letter, it is terminated with a zero byte. Each keyword is stored in plain text with bit 7 set to mark the last character, this is followed immediately by the associated token. The first character of the keyword need not be stored as this is implied by its position in the table' The keywords and tokens are listed below in full, note that the "J", "Q", "Y" and "Z" blocks are empty:

```
AUTO   A9H  DSKF   26H  LIST    93H  REM     8FH
AND    F6H  DRAW   BEH  LFILES  BBH  RESUME  A7H
ABS    06H  ELSE   A1H  LOG     0AH  RSET    B9H
ATN    0EH  END    81H  LOC     2CH  RIGHT$  02H
ASC    15H  ERASE  A5H  LEN     12H  RND     08H
ATTR$  E9H  ERROR  A6H  LEFT$   01H  RENUM   AAH
BASE   C9H  ERL    E1H  LOF     2DH  SCREEN  C5H
BSAVE  D0H  ERR    E2H  MOTOR   CEH  SPRITE  C7H
BLOAD  CFH  EXP    0BH  MERGE   B6H  STOP    90H
BEEP   C0H  EOF    2BH  MOD     FBH  SWAP    A4H
BIN$   1DH  EQV    F9H  MKI$    2EH  SET     D2H
CALL   CAH  FOR    82H  MKS$    2FH  SAVE    BAH
CLOSE  B4H  FIELD  B1H  MKD$    30H  SPC(    DFH
COPY   D6H  FILES  B7H  MID$    03H  STEP    DCH
CONT   99H  FN     DEH  MAX     CDH  SGN     04H
CLEAR  92H  FRE    0FH  NEXT    83H  SQR     07H
CLOAD  9BH  FIX    21H  NAME    D3H  SIN     09H
CSAVE  9AH  FPOS   27H  NEW     94H  STR$    13H
CSRLIN E8H  GOTO   89H  NOT     E0H  STRING$ E3H
CINT   1EH  GO TO  89H  OPEN    B0H  SPACE$  19H
CSNG   1FH  GOSUB  8DH  OUT     9CH  SOUND   C4H
CDBL   20H  GET    B2H  ON      95H  STICK   22H
CVI    28H  HEX$   1BH  OR      F7H  STRIG   23H
CVS    29H  INPUT  85H  OCT$    1AH  THEN    DAH
CVD    2AH  IF     8BH  OFF     EBH  TRON    A2H
COS    0CH  INSTR  E5H  PRINT   91H  TROFF   A3H
CHR$   16H  INT    05H  PUT     B3H  TAB(    DBH
CIRCLE BCH  INP    10H  POKE    98H  TO      D9H
COLOR  BDH  IMP    FAH  POS     11H  TIME    CBH
CLS    9FH  INKEY$ ECH  PEEK    17H  TAN     0DH
CMD    D7H  IPL    D5H  PSET    C2H  USING   E4H
DELETE A8H  KILL   D4H  PRESET  C3H  USR     DDH
DATA   84H  KEY    CCH  POINT   EDH  VAL     14H
DIM    86H  LPRINT 9DH  PAINT   BFH  VARPTR  E7H
DEFSTR ABH  LLIST  9EH  PDL     24H  VDP     C8H
DEFINT ACH  LPOS   1CH  PAD     25H  VPOKE   C6H
DEFSNG ADH  LET    88H  PLAY    C1H  VPEEK   18H
DEFDBL AEH  LOCATE D8H  RETURN  8EH  WIDTH   A0H
DSKO$  D1H  LINE   AFH  READ    87H  WAIT    96H
DEF    97H  LOAD   B5H  RUN     8AH  XOR     F8H
DSKI$  EAH  LSET   B8H  RESTORE 8CH
```

</a>

<a name="3d26h"></a>

    Address... 3D26H

This twenty-one byte table is used by the Interpreter during program tokenization. It contains the ten single character keywords and their tokens:

```
+ ... F1H    * ... F3H   ^ ... F5H    ' ... E6H = ... EFH
- ... F2H    / ... F4H   \ ... FCH    > ... EEH < ... F0H
```

</a>

<a name="3d3bh"></a>

    Address... 3D3BH

This table is used by the Expression Evaluator to determine the precedence level for a given infix operator, the higher the table value the greater the operator's precedence. Not included are the precedences for the relational operators (64H), the "`NOT`" operator (5AH) and the negation operator (7DH), these are defined directly by the Expression and Factor Evaluators.

```
79H ... +       46H ... OR
79H ... -       3CH ... XOR
7CH ... *       32H ... EQV
7CH ... /       28H ... IMP
7FH ... ^       7AH ... MOD
50H ... AND     7BH ... \
```

</a>

<a name="3d47h"></a>

    Address... 3D47H

This table is used to convert the result of a user defined function to the same type as the Variable used in the function definition. It contains the addresses of the type conversion routines:

```
303AH ... CDBL
0000H ... Not used
2F8AH ... CINT
3058H ... Check string type
2FB2H ... CSNG
```

</a>

<a name="3d51h"></a>

    Address... 3D51H

This table of addresses is used by the Expression Evaluator to find the handler for a particular infix math operator when both operands are double precision:

```
269AH ... +
268CH ... -
27E6H ... *
289FH ... /
37D7H ... ^
2F83H ... Relation
```

</a>

<a name="3d5dh"></a>

    Address... 3D5DH

This table of addresses is used by the Expression Evaluator to find the handler for a particular infix math operator when both operands are single precision:

```
324EH ... +
3257H ... -
325CH ... *
3267H ... /
37C8H ... ^
2F21H ... Relation
```

</a>

<a name="3d69h"></a>

    Address... 3D69H

This table of addresses is used by the Expression Evaluator to find the handler for a particular infix math operator when both operands are integer:

```
3172H ... +
3167H ... -
3193H ... *
4DB8H ... /
383FH ... ^
2F4DH ... Relation
```

</a>

<a name="3d75h"></a>

    Address... 3D75H

This table contains the Interpreter error messages, each one is stored in plain text with a zero byte terminator. The associated error codes are shown below for reference only, they do not form part of the table:

```
01 NEXT without FOR             19 Device I/O error
02 Syntax error                 20 Verify error
03 RETURN without GOSUB         21 No RESUME
04 Out of DATA                  22 RESUME without error
05 Illegal function call        23 Unprintable error
06 Overflow                     24 Missing operand
07 Out of memory                25 Line buffer overflow
08 Undefined line number        50 FIELD overflow
09 Subscript out of range       51 Internal error
10 Redimensioned array          52 Bad file number
11 Division by zero             53 File not found
12 Illegal direct               54 File already open
13 Type mismatch                55 Input past end
14 Out of string space          56 Bad file name
15 String too long              57 Direct statement in file
16 String formula too complex   58 Sequential I/O only
17 Can't CONTINUE               59 File not OPEN
18 Undefined user function
```

</a>

<a name="3fd2h"></a>

    Address... 3FD2H

This is the plain text message "` in `" terminated by a zero byte.

<a name="3fd7h"></a>

    Address... 3FD7H

This is the plain text message "`Ok`", CR, LF terminated by a zero byte.

<a name="3fdch"></a>

    Address... 3FDCH

This is the plain text message "`Break`" terminated by a zero byte.

<a name="3fe2h"></a>

    Address... 3FE2H

This routine searches the Z80 stack for the "`FOR`" loop parameter block whose loop Variable address is supplied in register pair DE. The search is started four bytes above the current Z80 SP to allow for the caller's return address and the Runloop return address. If no "`FOR`" token (82H) exists the routine terminates Flag NZ, if one is found the loop Variable address is taken from the parameter block and checked. The routine terminates Flag Z upon a successful match with register pair HL pointing to the type byte of the parameter block. Otherwise the search moves up twenty-two bytes to the start of the next parameter block.

<a name="4001h"></a>

    Address... 4001H

This routine is used by the Factor Evaluator to apply the "`INP`" function to an operand contained in [DAC](#dac). The port number is checked ([5439H](#5439h)), the port read and the result placed in [DAC](#dac) as an integer (4FCFH).

<a name="400bh"></a>

    Address... 400BH

This routine first evaluates an operand in the range -32768 to +65535 ([542FH](#542fh)) and places it in register pair BC. After checking for a comma, via the [SYNCHR](#synchr) standard routine, it evaluates a second operand in the range 0 to 255 (521CH) and places this in register A.

<a name="4016h"></a>

    Address... 4016H

This is the "`OUT`" statement handler. The port number and data byte are evaluated ([400BH](#400bh)) and the data byte written to the relevant Z80 port.

<a name="401ch"></a>

    Address... 401CH

This is the "`WAIT`" statement handler. The port number and "`AND`" operands are first evaluated ([400BH](#400bh)) followed by the optional "`XOR`" operand (521CH). The port is then repeatedly read and the operands applied, XOR then AND, until a non-zero result is obtained. Contrary to the information given in some MSX manuals the loop can be broken by the CTRL-STOP key as the [CKCNTC](#ckcntc) standard routine is called from inside it.

<a name="4039h"></a>

    Address... 4039H

This routine is used by the Runloop when it encounters the end of the program text while in program mode. [ONEFLAG](#oneflag) is checked to see whether it still contains an active error code. If so a "`No RESUME`" error is generated, otherwise program termination continues normally (6401H). The idea behind this routine is to catch any "`ON ERROR`" handlers without a "`RESUME`" statement at the end.

<a name="404fh"></a>

    Address... 404FH

This routine is used by the "`READ`" statement handler when an error is found in a "`DATA`" statement. The line number contained in [DATLIN](#datlin) is copied to [CURLIN](#curlin) so the error handler will flag the "`DATA`" line as the illegal statement rather than the program line. Control then drops into the "`Syntax error`" generator.

<a name="4055h"></a>
<a name="4058h"></a>
<a name="405bh"></a>
<a name="405eh"></a>
<a name="4061h"></a>
<a name="4064h"></a>
<a name="4067h"></a>
<a name="406ah"></a>
<a name="406dh"></a>

    Address... 4055H

This is a group of nine error generators, register E is loaded with the relevant error code and control drops into the error handler:

|ADDRESS|ERROR
|-------|-----------------------
|4055H  |Syntax error
|4058H  |Division by zero
|405BH  |NEXT without FOR
|405EH  |Redimensioned array
|4061H  |Undefined user function
|4064H  |RESUME without error
|4067H  |Overflow error
|406AH  |Missing operand
|406DH  |Type mismatch

</a>

<a name="406fh"></a>

    Address... 406FH

This is the Interpreter error handler, all error generators transfer to here with an error code in register E. [VLZADR](#vlzadr) is first checked to see if the "`VAL`" statement handler has changed the program text, if so the original character is restored from [VLZDAT](#vlzdat). The current line number is then copied from [CURLIN](#curlin) to [ERRLIN](#errlin) and [DOT](#dot) and the Z80 stack is restored from [SAVSTK](#savstk) (62F0H). The error code is placed in [ERRFLG](#errflg), for use by the "`ERR`" function, and the current program text position copied from [SAVTXT](#savtxt) to [ERRTXT](#errtxt) for use by the "`RESUME`" statement handler. The error line number and program text position are also copied to [OLDLIN](#oldlin) and [OLDTXT](#oldtxt) for use by the "`CONT`" statement handler. [ONELIN](#onelin) is then checked to see if a previous "`ON ERROR`" statement has been executed. If so, and providing no error code is already active, control transfers to the Runloop (4620H) to execute the BASIC error recovery statements.

Otherwise the error code is used to count through the error message table at [3D75H](#3d75h) until the required one is reached. A CR,LF is issued ([7323H](#7323h)) and the screen forced back to text mode via the [TOTEXT](#totext) standard routine. A BELL code is then issued and the error message displayed ([6678H](#6678h)). Assuming the Interpreter is in program mode, rather than direct mode, this is followed by the line number ([340AH](#340ah)) and control drops into the "`OK`" point.

<a name="411fh"></a>

    Address... 411FH

This is the re-entry point to the Interpreter Mainloop for a terminating program. The screen is forced to text mode via the [TOTEXT](#totext) standard routine, the printer is cleared ([7304H](#7304h)) and I/O buffer 0 closed (6D7BH). A CR,LF is then issued to the screen ([7323H](#7323h)), the message "`OK`" is displayed ([6678H](#6678h)) and control drops into the Mainloop.

<a name="4134h"></a>

    Address... 4134H

This is the Interpreter Mainloop. [CURLIN](#curlin) is first set to FFFFH to indicate direct mode and [AUTFLG](#autflg) checked to see if "`AUTO`" mode is on. If so the next line number is taken from [AUTLIN](#autlin) and displayed ([3412H](#3412h)). The Program Text Area is then searched to see if this line already exists ([4295H](#4295h)) and either an asterisk or space displayed accordingly.

The [ISFLIO](#isflio) standard routine is then used to determine whether a "`LOAD`" statement is active. If so the program line is collected from the cassette ([7374H](#7374h)), otherwise it is taken from the console via the [PINLIN](#pinlin) standard routine. If the line is empty or the CTRL-STOP key has been pressed control transfers back to the start of the Mainloop ([4134H](#4134h)) with no further action. If the line commences with a line number this is converted to an unsigned integer in register pair DE (4769H). The line is then converted to tokenized form and placed in [KBUF](#kbuf) ([42B2H](#42b2h)). If no line number was found at the start of the line control then transfers to the Runloop ([6D48H](#6d48h)) to execute the statement.

Assuming the line commences with a line number it is tested to see if it is otherwise empty and the result temporarily saved. The line number is copied to [DOT](#dot) and [AUTLIN](#autlin) increased by the contents of [AUTINC](#autinc), if [AUTLIN](#autlin) now exceeds 65530 the "`AUTO`" mode is turned off. The Program Text Area is then searched ([4295H](#4295h)) to find a matching line number or, failing this, the position of the next highest line number. If no matching line number is found and the line is empty and "`AUTO`" mode is off an "`Undefined line number`" error is generated ([481CH](#481ch)). If a matching line number is found and the line is empty and "`AUTO`" mode is on the Mainloop simply skips to the next statement (4237H).

Otherwise any pointers in the Program Text Area are converted back to line numbers (54EAH) and any existing program line deleted (5405H). Assuming the new program line is non-empty the Program Text Area is opened up by the required amount ([6250H](#6250h)) and the tokenized program line copied from [KBUF](#kbuf).

The Program Text Area links are then recalculated (4257H), the Variable Storage Areas are cleared ([629AH](#629ah)) and control transfers back to the start of the Mainloop.

<a name="4253h"></a>

    Address... 4253H

This routine recalculates the Program Text Area links after a program modification. The first two bytes of each program line contain the starting address of the following line, this is called the link. Although the link increases the amount of storage required per program line it greatly reduces the time required by the Interpreter to locate a given line.

An example of a typical program line is shown below, in this case the line "`10 PRINT 9`" situated at the start of the Program Text Area (8001H):

<a name="figure43"></a>![][CH05F43]

**Figure 43:** Program Line

In the above example the link is stored in Z80 word order (LSB,MSB) and is immediately followed by the binary line number, also in word order. The statement itself is composed of a "`PRINT`" token (91H), a single space, the number nine and the end of line character (00H). Further details of the storage format can be found in the tokenizing routine ([42B2H](#42b2h)).

Each link is recalculated simply by scanning through the line until the end of line character is found. The process is complete when the end of the Program Storage Area, marked by the special link of 0000H, is reached.

<a name="4279h"></a>

    Address... 4279H

This routine is used by the "`LIST`" statement handler to collect up to two line number operands from the program text. If the first line number is present it is converted to an unsigned integer in register pair DE ([475FH](#475fh)), if not a default value of 0000H is returned. If the second line number is present it must be preceded by a "-" token (F2H) and is returned on the Z80 stack, if not a default value of 65530 is returned. Control then drops into the program text search routine to find the first referenced program line.

<a name="4295h"></a>

    Address... 4295H

This routine searches the Program Text Area for the program line whose line number is supplied in register pair DE. Starting at the address contained in [TXTTAB](#txttab) each program line is examined for a match. If an equal line number is found the routine terminates with Flag Z,C and register pair BC pointing to the start of the program line. If a higher line number is found the routine terminates Flag NZ,NC and if the end link is reached the routine terminates Flag Z,NC.

<a name="42b2h"></a>

    Address... 42B2H

This routine is used by the Interpreter Mainloop to tokenize a line of text. On entry register pair HL points to the first text character in [BUF](#buf). On exit the tokenized line is in [KBUF](#kbuf), register pair BC holds its length and register pair HL points to its start.

Except after opening quotes or after the "`REM`", "`CALL`" or "`DATA`" keywords any string of characters matching a keyword is replaced by that keyword's token. Lower case alphabetics are changed to upper case for keyword comparison. The character "`?`" is replaced by the "`PRINT`" token (91H) and the character "'" by ":" (3AH), "`REM`" token (8FH), "'" token (E6H). The "`ELSE`" token (A1H) is preceded by a statement separator (3AH). Any other miscellaneous characters in the text are copied without alteration except that lower case alphabetics are converted to upper case. Those tokens smaller than 80H, the function tokens, cannot be stored directly in [KBUF](#kbuf) as they will conflict with ordinary text. Instead the sequence FFH, token+80H is used.

Numeric constants are first converted into one of the standard types in [DAC](#dac) ([3299H](#3299h)). They are then stored in one of several ways depending upon their type and magnitude, the general idea being to minimize memory usage:

```
0BH LSB MSB ................... Octal number
0CH LSB MSB ................... Hex number
11H to 1AH .................... Integer 0 to 9
0FH LSB ....................... Integer 10 to 255
1CH LSB MSB ................... Integer 256 to 32767
1DH EE DD DD DD ............... Single Precision
1FH EE DD DD DD DD DD DD DD ... Double Precision
```

There is no specific token for binary numbers, these are left as character strings. This would appear to be a legacy from earlier versions of Microsoft BASIC. Any sign prefixing a number is regarded as an operator and is stored as a separate token, negative numbers are not produced during tokenization. As double precision numbers occupy so much space a line containing too many, for example PRINT 1#,1#,1# etc. may cause [KBUF](#kbuf) to fill up. If this happens a "`Line buffer overflow`" error is generated.

Any number following one of the keyword tokens in the table at [43B5H](#43b5h) is considered to be a line number operand and is stored with a different token:

```
0DH LSB MSB ................... Pointer
0EH LSB MSB ................... Line number
```

During tokenization only the normal type (0EH) is generated, when a program actually runs these line number operands are converted to the address pointer type (0DH).

<a name="43b5h"></a>

    Address... 43B5H

This table of tokens is used during tokenization to check for the keywords which take line number operands. The keywords themselves are listed below:

```
RESTORE    RUN
AUTO       LIST
RENUM      LLIST
DELETE     GOTO
RESUME     RETURN
ERL        THEN
ELSE       GOSUB
```

</a>

<a name="4524h"></a>

    Address... 4524H

This is the "`FOR`" statement handler. The loop Variable is first located and assigned its initial value by the "`LET`" handler ([4880H](#4880h)), the address of the loop Variable is returned in register pair DE. The end of the statement is found ([485BH](#485bh)) and its address placed in [ENDFOR](#endfor). The Z80 stack is then searched (3FE6H) for any parameter blocks using the same loop Variable. For each one found the current [ENDFOR](#endfor) address is compared with that of the parameter block, if there is a match that section of the stack is discarded. This is done in case there are any incomplete loops as a result of a "`GOTO`" back to the "`FOR`" statement from inside the loop.

The termination operand and optional "`STEP`" operand are then evaluated and converted to the same type as the loop Variable. After checking that stack space is available ([625EH](#625eh)) a twenty-five byte parameter block is pushed onto the Z80 stack. This is made up of the following:

```
2 bytes ... ENDFOR address
2 bytes ... Current line number
8 bytes ... Loop termination value
8 bytes ... STEP value
1 byte  ... Loop type
1 byte  ... STEP direction
2 bytes ... Address of loop Variable
1 byte  ... FOR token (82H)
```

The parameter block remains on the stack for use by the "`NEXT`" statement handler until termination is reached, it is then discarded. The size of the block remains constant even though, for integer and single precision loop Variables, the full eight bytes are not required for the termination and STEP values. In these cases the least significant bytes are packed out with garbage.

It should be noted that the type of arithmetic operation performed by the "`NEXT`" statement handler, and hence the loop execution speed, depends entirely upon the loop Variable type and not the operand types. For the fastest program execution integer type Variables, N% for example, should be used.

<a name="4601h"></a>

    Address... 4601H

This is the Runloop, each statement handler returns here upon completion so the Interpreter can proceed to the next statement. The current Z80 SP is copied to [SAVSTK](#savstk) for error recovery purposes and the CTRL-STOP key checked via the [ISCNTC](#iscntc) standard routine. Any pending interrupts are processed ([6389H](#6389h)) and the current program text position, held in register pair HL throughout the Interpreter, is copied to [SAVTXT](#savtxt).

The current program character is then examined, if this is a statement separator (3AH) control transfers immediately to the execution point ([4640H](#4640h)). If it is anything else but an end of line character (00H) a "`Syntax error`" is generated ([4055H](#4055h)) as there is spurious text at the end of the statement. Register pair HL is advanced to the first character of the new program line and the link examined, if this is zero the program is terminated ([4039H](#4039h)). Otherwise the line number is taken from the new line and placed in [CURLIN](#curlin). If [TRCFLG](#trcflg) is non-zero the line number is displayed ([3412H](#3412h)) enclosed by square brackets, control then drops into the execution point.

<a name="4640h"></a>

    Address... 4640H

This is the Runloop execution point. A return to the start of the Runloop ([4601H](#4601h)) is pushed onto the Z80 stack and the first character taken from the new statement via the [CHRGTR](#chrgtr) standard routine. If it is an underline character (5FH) control transfers to the "`CALL`" statement handler (55A7H). If it is smaller than 81H, the smallest statement token, control transfers to the "`LET`" handler ([4880H](#4880h)). If it is larger than D8H, the largest statement token, it is checked to see if it is one of the function tokens allowed as a statement ([51ADH](#51adh)). Otherwise the handler address is taken from the table at [392EH](#392eh) and pushed onto the stack. Control then drops into the [CHRGTR](#chrgtr) standard routine to fetch the next program character before control transfers to the statement handler.

<a name="4666h"></a><a name="chrgtr"></a>

```
Address... 4666H
Name...... CHRGTR
Entry..... HL points to current program character
Exit...... A=Next program character
Modifies.. AF, HL
```

Standard routine to fetch the next character from the program text. Register pair HL is incremented and the character placed in register A. If it is a space, TAB code (09H) or LF code (0AH) it is skipped over. If it is a statement separator (3AH) or end of line character (00H) the routine terminates with Flag Z,NC. If it is a digit from "0" to "9" the routine terminates with Flag NZ,C. If it is any other character apart from the numeric prefix tokens the routine terminates Flag NZ,NC. If the character is one of the numeric prefix tokens then it is placed in [CONSAV](#consav) and the operand copied to [CONLO](#conlo). The type code is placed in [CONTYP](#contyp) and the address of the trailing program character in [CONTXT](#contxt).

<a name="46e8h"></a>

    Address... 46E8H

This routine is used by the Factor Evaluator and during detokenization to recover a numeric operand when one of the prefix tokens is returned by the [CHRGTR](#chrgtr) standard routine. The prefix token is first taken from [CONSAV](#consav), if it is anything but a line number or pointer token the operand is copied from [CONLO](#conlo) to [DAC](#dac) and the type code copied from [CONTYP](#contyp) to [VALTYP](#valtyp). If it is a line number it is converted to single precision and placed in [DAC](#dac) (3236H). If it is a pointer the original line number is recovered from the referenced program line, converted to single precision and placed in [DAC](#dac) (3236H).

<a name="4718h"></a>

    Address... 4718H

This is the "`DEFSTR`" statement handler. Register E is loaded with the string type code (03H) and control drops into the general type definition routine.

<a name="471bh"></a>

    Address... 471BH

This is the "`DEFINT`" statement handler. Register E is loaded with the integer type code (02H) and control drops into the general type definition routine.

<a name="471eh"></a>

    Address... 471EH

This is the "`DEFSNG`" statement handler. Register E is loaded with the single precision type code (04H) and control drops into the general type definition routine.

<a name="4721h"></a>

    Address... 4721H

This is the "`DEFDBL`" statement handler. Register E is loaded with the double precision type code (08H) and the first range definition character checked ([64A7H](#64a7h)). If this is not upper case alphabetic a "`Syntax error`" is generated ([4055H](#4055h)). If a "-" token (F2H) follows the second range definition character is taken and checked ([64A7H](#64a7h)), the difference between the two determines the number of entries in [DEFTBL](#deftbl) that are filled with the type code.

<a name="4755h"></a>

    Address... 4755H

This routine evaluates an operand and converts it to an integer in register pair DE (520FH). If the operand is negative an "`Illegal function call`" error is generated.

<a name="475fh"></a>

    Address... 475FH

This routine is used by the statement handlers shown in the table at [43B5H](#43b5h) to collect a single line number operand from the program text and convert it to an unsigned integer in register pair DE. If the first character in the text is a "." (2EH) the routine terminates with the contents of [DOT](#dot). If it is one of the line number tokens (0DH or 0EH) the routine terminates with the contents of [CONLO](#conlo). Otherwise successive digits are taken and added to the product, with appropriate multiplications by ten, until a non-numeric character is found.

<a name="479eh"></a>

    Address... 479EH

This is the "`RUN`" statement handler. If no line number operand is present in the program text the system is cleared ([629AH](#629ah)) and control returns to the Runloop with register pair HL pointing to the start of the Program Storage Area. If a line number operand is present the system is cleared (62A1H) and control transfers to the "`GOTO`" statement handler (47E7H). Otherwise a following filename is assumed, for example `RUN "CAS:FILE"`, and control transfers to the "`LOAD`" statement handler ([6B5BH](#6b5bh));

<a name="47b2h"></a>

    Address... 47B2H

This is the "`GOSUB`" statement handler. After checking that stack space is available ([625EH](#625eh)) the line number operand is collected and placed in register pair DE (4769H). The seven byte parameter block is then pushed onto the stack and control transfers to the "`GOTO`" handler (47EBH). The parameter block is made up of the following:

```
2 bytes ... End of statement address
2 bytes ... Current line number
2 bytes ... 0000H
1 byte  ... GOSUB token (8DH)
```

The parameter block remains on the stack until a "`RETURN`" statement is executed. It is then used to determine the original program text position after which it is discarded.

<a name="47cfh"></a>

    Address... 47CFH

This routine is used by the Runloop interrupt processor ([6389H](#6389h)) to create a "`GOSUB`" type parameter block on the Z80 stack. An interrupt block is identical to a normal block except that the two zero bytes shown above are replaced by the address of the device's entry in [TRPTBL](#trptbl). This address will be used by the "`RETURN`" statement handler to update the device's interrupt status once a subroutine has terminated. After pushing the parameter block control transfers to the Runloop to execute the program line whose address is supplied in register pair DE.

<a name="47e8h"></a>

    Address... 47E8H

This is the "`GOTO`" statement handler. The line number operand is collected (4769H) and placed in register pair HL. If it is a pointer control transfers immediately to the Runloop to begin execution at the new program text position. Otherwise the line number is compared with the current line number to determine the starting position for the program text search. If it is greater the search starts from the end of this line (4298H), if it is smaller it starts from the beginning of the Program Text Area ([4295H](#4295h)). If the referenced line cannot be found an "`Undefined line number`" error is generated ([481CH](#481ch)). Otherwise the line number operand is replaced by the referenced program line's address and its token changed to the pointer type (5583H). Control then transfers to the Runloop to execute the referenced program line.

<a name="481ch"></a>

    Address... 481CH

This is the "`Undefined line number`" error generator.

<a name="4821h"></a>

    Address... 4821H

This is the "`RETURN`" statement handler. A dummy loop Variable address is placed in register pair DE and the Z80 stack searched ([3FE2H](#3fe2h)) to find the first parameter block not belonging to a "`FOR`" loop, this section of stack is then discarded. If no "`GOSUB`" token (8DH) is found at this point a "`RETURN without GOSUB`" error is generated.

The next two bytes are then taken from the block, if they are non-zero the block was generated by an interrupt and the temporary "`STOP`" condition is removed ([633EH](#633eh)). The program text is then examined, if anything follows the "`RETURN`" token itself it is assumed to be a line number operand and control transfers to the "`GOTO`" handler ([47E8H](#47e8h)). Otherwise the old line number and program text address are taken from the block and control returns to the Runloop.

<a name="485bh"></a>

    Address... 485BH

This is the "`DATA`" statement handler. The program text is skipped over until a statement separator (3AH) or end of line character (00H) is found. This routine is also the "`REM`" and "`ELSE`" statement handler via the entry point at 485DH, in this case only the end of line character acts as a terminator.

<a name="4880h"></a>

    Address... 4880H

This is the "`LET`" statement handler. The Variable is first located ([5EA4H](#5ea4h)), its address saved in [TEMP](#temp) and the operand evaluated ([4C64H](#4c64h)). If necessary the operand's type is then changed to match that of the Variable (517AH). Assuming the operand is one of the three numeric types it is simply copied from [DAC](#dac) to the Variable in the Variable Storage Area (2EF3H). If the operand is a string type the address of the string body is taken from the descriptor and checked. If it is in [KBUF](#kbuf), as would be the case for an explicit string in a direct statement, the body is first copied to the String Storage Area and a new descriptor created (6611H). The descriptor is then freed from [TEMPST](#tempst) (67EEH) and copied to the Variable in the Variable Storage Area (2EF3H).

<a name="48e4h"></a>

    Address... 48E4H

This is the "`ON ERROR`", "`ON DEVICE GOSUB`" and "`ON EXPRESSION`" statement handler. If the next program text character is not an "`ERROR`" token (A6H) control transfers to the "`ON DEVICE GOSUB`" and "`ON EXPRESSION`" handler ([490DH](#490dh)). The program text is checked to ensure that a "`GOTO`" token (89H) follows and then the line number operand collected (4769H). The program text is searched to obtain the address of the referenced line (4293H) and this is placed in [ONELIN](#onelin). If the line number operand is non-zero the routine then terminates. If the line number operand is zero [ONEFLG](#oneflg) is checked to see if an error situation already exists (implying that the statement is inside a BASIC error recovery routine). If so control transfers to the error handler (4096H) to force an immediate error, otherwise the routine terminates normally.

<a name="490dh"></a>

    Address... 490DH

This is the "`ON DEVICE GOSUB`" and "`ON EXPRESSION`" statement handler. If the next program text character is not a device token ([7810H](#7810h)) control transfers to the "`ON EXPRESSION`" handler ([4943H](#4943h)). After checking the program text for a "`GOSUB`" token (8DH) each of the line number operands required for a particular device is collected in turn (4769H). Assuming a given line number operand is non-zero the program text is searched to find the address of the referenced line (4293H) and this is placed in the device's entry in [TRPTBL](#trptbl) ([785CH](#785ch)). The routine terminates when no more line number operands are found.

<a name="4943h"></a>

    Address... 4943H

This is the "`ON EXPRESSION`" statement handler. The operand is evaluated (521CH) and the following "`GOSUB`" token (8DH) or "`GOTO`" token (89H) placed in register A. The operand is then used to count along the program text until register pair HL points to the required line number operand. Control then transfers back to the Runloop execution point (4646H) to decode the "`GOSUB`" or "`GOTO`" token.

<a name="495dh"></a>

    Address... 495DH

This is the "`RESUME`" statement handler. [ONEFLG](#oneflg) is first checked to make sure that an error condition already exists, if not a "`RESUME without error`" is generated ([4064H](#4064h)). If a non- zero line number operand follows control transfers to the "`GOTO`" handler (47EBH). If a "`NEXT`" token (83H) follows the position of the error is restored from [ERRTXT](#errtxt) and [ERRLIN](#errlin), the start of the next statement is found ([485BH](#485bh)) and the routine terminates. If there is no line number operand or if it is zero the position of the error is found from [ERRTXT](#errtxt) and [ERRLIN](#errlin) and the routine terminates.

<a name="49aah"></a>

    Address... 49AAH

This is the "`ERROR`" statement handler. The operand is evaluated and placed in register E (521CH). If it is zero an "`Illegal function call`" error is generated (475AH), otherwise control transfers to the error handler ([406FH](#406fh)).

<a name="49b5h"></a>

    Address... 49B5H

This is the "`AUTO`" Statement handler. The optional start and increment line number operands, both with a default value of ten, are collected ([475FH](#475fh)) and placed in [AUTLIN](#autlin) and [AUTINC](#autinc). After making [AUTFLG](#autflg) non-zero the Runloop return is destroyed and control transfers directly to the Mainloop ([4134H](#4134h)).

<a name="49e5h"></a>

    Address... 49E5H

This is the "`IF`" statement handler. The operand is evaluated ([4C64H](#4c64h)) and, after checking for a "`GOTO`" token (89H) or "`THEN`" token (DAH), its sign is tested ([2EA1H](#2ea1h)). If the operand is non- zero (true) the following text is executed either by an immediate transfer to the Runloop (4646H) or, for a line number operand, the "`GOTO`" handler ([47E8H](#47e8h)). If the operand is zero (false) the statement text is scanned ([485BH](#485bh)) until an "`ELSE`" token (A1H) is found not balanced by an "`IF`" token (8BH) and execution re-commences.

<a name="4a1dh"></a>

    Address... 4A1DH

This is the "`LPRINT`" statement handler. [PRTFLG](#prtflg) is set to 01H, to direct output to the printer, and control transfers to the "`PRINT`" handler (4A29H).

<a name="4a24h"></a>

    Address... 4A24H

This is the "`PRINT`" statement handler. The program text is first checked for a trailing buffer number and, if necessary, [PTRFIL](#ptrfil) set to direct output to the required I/O buffer ([6D57H](#6d57h)). If no more program text exists a CR,LF is issued (7328H) and the routine terminates ([4AFFH](#4affh)). Otherwise successive characters are taken from the program text and analyzed. If a "`USING`" token (E4H) is found control transfers to the "`PRINT USING`" handler ([60B1H](#60b1h)). If a ";" character is found control just transfers back to the start to fetch the next item (4A2EH). If a comma is found sufficient spaces are issued to bring the current print position, from [TTYPOS](#ttypos), [LPTPOS](#lptpos) or an I/O buffer FCB, to an integral multiple of fourteen. If output is directed to the screen and the print position is equal to or greater than the contents of [CLMLST](#clmlst) or if output is directed to the printer and it is equal to or greater than 238 then a CR,LF is issued instead (7328H). If a "`SPC(`" token (DFH) is found the operand is evaluated ([521BH](#521bh)) and the required number of spaces are output. If a "`TAB(`" token (DBH) is found the operand is evaluated ([521BH](#521bh)) and sufficient spaces issued to bring the current print position, from [TTYPOS](#ttypos), [LPTPOS](#lptpos) or an I/O buffer FCB, to the required point.

If none of these characters is found the program text contains a data item which is then evaluated ([4C64H](#4c64h)). If the operand is a string it is simply displayed (667BH). If it is numeric it is first converted to text in [FBUFFR](#fbuffr) ([3425H](#3425h)) and a string descriptor created (6635H). If output is directed to an I/O buffer the resulting string is then displayed (667BH). If output is directed to the screen or printer the current print position, from [TTYPOS](#ttypos) or [LPTPOS](#lptpos), is compared with the line length and a CR,LF issued (7328H) if the output will not fit on the line. The maximum line length is 255 for the printer and is taken from [LINLEN](#linlen) for the screen. Once the string has been displayed control transfers back to the start of the handler.

<a name="4affh"></a>

    Address... 4AFFH

This routine zeroes [PRTFLG](#prtflg) and [PTRFIL](#ptrfil) to return the Interpreter's output to the screen.

<a name="4b0eh"></a>

    Address... 4B0EH

This is the "`LINE INPUT`", "`LINE INPUT#`" and "`LINE`" statement handler. If the following program text character is anything other than an "`INPUT`" token (85H) control transfers to the "`LINE`" statement handler ([58A7H](#58a7h)). If the following program text character is a "#" (23H) control transfers to the "`LINE INPUT#`" statement handler ([6D8FH](#6d8fh)).

Any following prompt string is evaluated and displayed (4B7BH) and the Variable located ([5EA4H](#5ea4h)) and checked to ensure that it is a string type ([3058H](#3058h)). The line of text is collected from the console via the [INLIN](#inlin) standard routine, if Flag C (CTRL-STOP) is returned control transfers to the "`STOP`" statement handler (63FEH). Otherwise the input string is analyzed and a descriptor created (6638H), control then transfers to the "`LET`" statement handler for assignment (4892H). It should be noted that the screen is not forced to text mode before the input is collected.

<a name="4b3ah"></a>

    Address... 4B3AH

This is the plain text message "`?Redo from start`", CR, LF terminated by a zero byte.

<a name="4b4dh"></a>

    Address... 4B4DH

This routine is used by the "`READ/INPUT`" statement handler if it has failed to convert a data item to numeric form. If in "`READ`" mode ([FLGINP](#flginp) is non-zero) a "`Syntax error`" is generated ([404FH](#404fh)). Otherwise the message "`?Redo from start`" is displayed ([6678H](#6678h)) and control returns to the statement handler.

<a name="4b62h"></a><a name="input#"></a>

    Address... 4B62H

This is the "`INPUT#`" Statement handler. The buffer number is evaluated and [PTRFIL](#ptrfil) set to direct input from the required I/O buffer (6D55H), control then transfers to the combined "`READ/INPUT`" statement handler (4B9BH).

<a name="4b6ch"></a><a name="input"></a>

    Address... 4B6CH

This is the "`INPUT`" statement handler. If the next program text character is a "#" control transfers to the "`INPUT#`" statement handler ([4B62H](#4b62h)). Otherwise the screen is forced to text mode, via the [TOTXT](#totxt) standard routine, and any prompt string analyzed ([6636H](#6636h)) and displayed (667BH). A question mark is then displayed and a line of text collected from the console via the [QINLIN](#qinlin) standard routine. If this returns Flag C (CTRL-STOP) control transfers to the "`STOP`" handler (63FEH). If the first character in [BUF](#buf) is zero (null input) the handler terminates by skipping to the end of the statement (485AH), otherwise control drops into the combined "`READ/INPUT`" handler.

<a name="4b9fh"></a><a name="read"></a>

    Address... 4B9FH

This is the "`READ`" statement handler, a large section is also used by the "`INPUT`" and "`INPUT#`" statements so the structure is rather awkward. Each Variable found in the program text is located in turn ([5EA4H](#5ea4h)), for each one the corresponding data item is obtained and assigned to the Variable by the "`LET`" handler (4893H). When in "`READ`" mode the data items are taken from the program text using the initial contents of [DATPTR](#datptr) ([4C40H](#4c40h)). When in "`INPUT`" or "`INPUT#`" mode the data items are taken from the text buffer [BUF](#buf).

If the data items are exhausted in "`READ`" mode an "`Out of DATA`" error is generated. If they are exhausted in "`INPUT`" mode two question marks are displayed and another line fetched from the console via the [QINLIN](#qinlin) standard routine. If they are exhausted in "`INPUT#`" mode another line of text is copied to [BUF](#buf) from the relevant I/O buffer ([6D83H](#6d83h)). If the Variable list is exhausted while in "`INPUT`" mode the message "`Extra ignored`" is displayed ([6678H](#6678h)) and the handler terminates ([4AFFH](#4affh)). In "`INPUT#`" mode no message is displayed while in "`READ`" mode control terminates by updating [DATPTR](#datptr) (63DEH). If a data item cannot be converted to numeric form ([3299H](#3299h)) to match a numeric Variable control transfers to the "`?Redo from start`" routine ([4B4DH](#4b4dh)).

<a name="4c2fh"></a>

    Address... 4C2FH

The is the plain text message "`?Extra ignored`", CR, LF terminated by a zero byte.

<a name="4c40h"></a>

    Address... 4C40H

This routine is used by the "`READ`" handler to locate the next "`DATA`" statement in the program text, the address to start from is supplied in register pair HL. Each program statement is examined until a "`DATA`" token (84H) is found whereupon the routine terminates (4BD1H). If the end link is reached an "`Out of DATA`" error is generated. As the search proceeds the line number of each program line is placed in [DATLIN](#datlin) for use by the error handler.

<a name="4c5fh"></a>

    Address... 4C5FH

This routine checks that the next character in the program text is the "=" token (EFH) and then drops into the Expression Evaluator. When entered at 4C62H it checks for "(".

<a name="4c64h"></a>

    Address... 4C64H

This is the Expression Evaluator. On entry register pair HL points to the first character of the expression to be evaluated. On exit register pair HL points to the character following the expression, the result is in [DAC](#dac) and the type code in [VALTYP](#valtyp). For a string result the address of the string descriptor is returned at [DAC](#dac)+2. The descriptor itself comprising a single byte for the string length and two bytes for its address, will be in [TEMPST](#tempst) or inside a string Variable.

An expression is a list of factors ([4DC7H](#4dc7h)) linked together by operators with differing precedence levels. To process such an expression correctly the Expression Evaluator must be able to temporarily stack an intermediate result, if the next operator has a higher precedence than the current operator, and start afresh on a new calculation. It therefore has two basic operations, STACK and APPLY. For example:

```
3+250\2^2*3^3+1,

STACK:    3+        (\ follows)
STACK:    250\      (^ follows)
APPLY:    2^2=4     (* follows)
STACK:    4*        (^ follows)
APPLY:    3^3=27    (+ follows)
APPLY:    4*27=108  (+ follows)
APPLY:    250\108=2 (+ follows)
APPLY:    3+2=5     (+ follows)
APPLY:    5+1=6     (, follows)
```

Evaluation terminates when the next operator has a precedence equal to or lower than the initial precedence and the stack is empty. The expression delimiter, shown as a comma in the example, is regarded as having a precedence of zero and so will always halt evaluation. Normally the Expression Evaluator starts off with an initial precedence of zero but the entry point at 4C67H may be used to supply an alternative value in register D. This facility is used by the Factor Evaluator to restrict the range of evaluation when applying the monadic negation and "`NOT`" operators.

<a name="4d22h"></a>

    Address... 4D22H

This routine is used by the Expression Evaluator to apply an infix math operator (+-\*/ ) to a pair of numeric operands. There are separate routines for the relational operators ([4F57H](#4f57h)) and the logical operators ([4F78H](#4f78h)). The first operand, its type code, and the operator token are supplied on the Z80 stack, the second operand and its type code are supplied in [DAC](#dac) and [VALTYP](#valtyp). The types of both operands are first compared, if they differ the lowest precision operand is converted to match the higher. The operands are then moved to the positions required by the math routines. For integers the first operand is placed in register pair DE and the second in register pair HL. For single precision the first operand is placed in registers C, B, E, D and the second in [DAC](#dac). For double precision the first operand is placed in [DAC](#dac) and the second in [ARG](#arg). The operator token is then used to obtain the required address from the table at 3D51H, 3D5DH or 3D69H, depending upon the operand type, and control transfers to the relevant math routine.

<a name="4db8h"></a>

    Address... 4DB8H

This routine is used by the Expression Evaluator to divide two integer operands. The first operand is contained in register pair DE and the second in register pair HL, the result is returned in [DAC](#dac). Both operands are converted to single precision (2FCBH) and control transfers to the single precision division routine ([3265H](#3265h)).

<a name="4dc7h"></a>

    Address... 4DC7H

This is the Factor Evaluator. On entry register pair HL points to the character before the factor to be evaluated. On exit register pair HL points to the character following the factor, the result is in [DAC](#dac) and the type code in [VALTYP](#valtyp). A factor may be one of the following:

1. A numeric or string constant
2. A numeric or string Variable
3. A function
4. A monadic operator (+-NOT)
5. A parenthesized expression

The first character is taken from the program text via the [CHRGTR](#chrgtr) standard routine and examined. If it is an end of Statement character a "`Missing operand`" error is generated ([406AH](#406ah)). If it is an ASCII digit it is converted from textual form to one of the standard numeric types in [DAC](#dac) ([3299H](#3299h)).

If it is upper case alphabetic (64A8H) it is a Variable and its current value is returned ([4E9BH](#4e9bh)). If it is a numeric token the number is copied from [CONLO](#conlo) to [DAC](#dac) (46B8H). If it is one of the FFH prefixed function tokens shown in the table at 39DEH it is decoded to transfer control to the relevant function handler (4ECFH). If it is the monadic "+" operator it is simply skipped over, only the monadic "-" operator ([4E8DH](#4e8dh)) and monadic "`NOT`" operator ([4F63H](#4f63h)) require any action.

If it is an opening quote the following explicit string is analyzed and a descriptor created ([6636H](#6636h)). If it is an "&" it is a non-decimal numeric constant and it is converted to one of the standard numeric types in [DAC](#dac) ([4EB8H](#4eb8h)). If it is not one of the functions shown below then it must be a parenthesized expression (4E87H), otherwise a "`Syntax error`" is generated. The following function tokens are tested for directly and control transferred to the address shown:

```
ERR .... 4DFDH   ATTR$ .... 7C43H
ERL .... 4E0BH   VARPTR ... 4E41H
POINT .. 5803H   USR....... 4FD5H
TIME ... 7900H   INSTR .... 68EBH
SPRITE . 7A84H   INKEY$ ... 7347H
VDP .... 7B47H   STRING$ .. 6829H
BASE ... 7BCBH   INPUT$ ... 6C87H
PLAY ... 791BH   CSRLIN ... 790AH
DSKI$ .. 7C3EH   FN ....... 5040H
```

</a>

<a name="4dfdh"></a>

    Address... 4DFDH

This routine is used by the Factor Evaluator to apply the "`ERR`" function. The contents of [ERRFLG](#errflg) are placed in [DAC](#dac) as an integer (4FCFH).

<a name="4e0bh"></a>

    Address... 4E0BH

This routine is used by the Factor Evaluator to apply the "`ERL`" function. The contents of [ERRLIN](#errlin) are copied to [DAC](#dac) as a single precision number (3236H).

<a name="4e41h"></a>

    Address... 4E41H

This routine is used by the Factor Evaluator to apply the "`VARPTR`" function. If the function token is followed by a "#" the buffer number is evaluated ([521BH](#521bh)), the I/O buffer FCB located ([6A6DH](#6a6dh)) and its address placed in [DAC](#dac) as an integer (2F99H). Otherwise the Variable is located (5F5DH) and its address placed in [DAC](#dac) as an integer (2F99H).

<a name="4e8dh"></a>

    Address... 4E8DH

This routine is used by the Factor Evaluator to apply the monadic "-" operator. Register D is set to a precedence value of 7DH, the factor evaluated (4C67H) and then negated (2E86H).

<a name="4e9bh"></a>

    Address... 4E9BH

This routine is used by the Factor Evaluator to return the current value of a Variable. The Variable is first located ([5EA4H](#5ea4h)). If it is a string Variable its address is placed in [DAC](#dac) to point to the descriptor. Otherwise the contents of the Variable are copied to [DAC](#dac) (2F08).

<a name="4ea9h"></a>

    Address... 4EA9H

This routine returns the single character pointed to by register pair HL in register A, if it is a lower case alphabetic it converts it to upper case.

<a name="4eb8h"></a>

    Address... 4EB8H

This routine is used by the Factor Evaluator and the numeric input routine ([3299H](#3299h)) to convert an ampersand ("&") Prefixed number from textual form to an integer in [DAC](#dac). As each legal character is found the product is multiplied by 2, 8 or 16, depending upon the character which initially followed the ampersand, and the new digit added to it. If the product overflows an "`Overflow`" error is generated ([4067H](#4067h)). The routine terminates when an unacceptable character is found.

<a name="4efch"></a>

    Address... 4EFCH

This routine is used by the Factor Evaluator to process the FFH prefixed function tokens. If the token is either "`LEFT$`", "`RIGHT$`" or "`MID$`" the string operand is evaluated (4C62H), the address of its descriptor pushed onto the Z80 stack and the following numeric operand also evaluated (521CH) and stacked. Otherwise the function's parenthesized operand is evaluated (4E87H) and, for "`SQR`", "`RND`", "`SIN`", "`LOG`", "`EXP`", "`COS`", "`TAN`" or "`ATN`" only, converted to double precision ([303AH](#303ah)). The function token is then used to obtain the required address from the table at 39DEH and control transfers to the function handler.

<a name="4f47h"></a>

    Address... 4F47H

This routine is used by the numeric input conversion routine ([3299H](#3299h)) to test for a "+" or "-" character or token. It returns register D=0 for positive and register D=FFH for negative.

<a name="4f57h"></a>

    Address... 4F57H

This routine is used by the Expression Evaluator to apply a relational operator (<>= or combinations) to a pair of operands. If the operands are numeric the Expression Evaluator first uses the math operator routine ([4D22H](#4d22h)) to apply the general relation operation to the operands. If the operands are strings the string comparison routine ([65C8H](#65c8h)) is used first. When control arrives here the relation result is in register A and the Z80 Flags:

```
Operand 1=Operand 2 ... A=00H, Flag Z,NC
Operand 1<Operand 2 ... A=01H, Flag NZ,NC
Operand 1>Operand 2 ... A=FFH, Flag NZ,C
```

The Expression Evaluator also supplies a bit mask defining the original operators on the Z80 stack. This has a 1 in each position if the associated operation is required: 00000<=>. The mask is applied to the relation result producing zero if none of the conditions is satisfied. This is then placed in [DAC](#dac) as a true (-1) or false (0) integer (2E9AH).

<a name="4f63h"></a>

    Address... 4F63H

This routine is used by the Factor Evaluator to apply the monadic "`NOT`" operator. Register D is set to an initial precedence level of 5AH and the expression evaluated (4C67H) and converted to an integer ([2F8AH](#2f8ah)). It is then inverted and restored to [DAC](#dac).

<a name="4f78h"></a>

    Address... 4F78H

This routine is used by the Expression Evaluator to apply a logical operator ("`OR`", "`AND`", "`XOR`", "`EQV`" and "`IMP`") or the "`MOD`" and "\" operators to a pair of numeric operands. The first operand, which has already been converted to an integer, is supplied on the Z80 stack and the second is supplied in [DAC](#dac). The operator token (actually its precedence level) is supplied in register B. After converting the second operand to an integer ([2F8AH](#2f8ah)) the operator is examined. There are separate routines for "`MOD`" ([323AH](#323ah)) and "\" ([31E6H](#31e6h)) but the logical operators are processed locally using the corresponding Z80 logical instructions on register pairs DE and HL. The result is stored in [DAC](#dac) as an integer (2F99H).

<a name="4fc7h"></a>

    Address... 4FC7H

This routine is used by the Factor Evaluator to apply the "`LPOS`" function to an operand contained in [DAC](#dac). The contents of [LPTPOS](#lptpos) are placed in [DAC](#dac) as an integer (4FCFH).

<a name="4fcch"></a>

    Address... 4FCCH

This routine is used by the Factor Evaluator to apply the "`POS`" function to an operand contained in [DAC](#dac). The contents of [TTYPOS](#ttypos) are placed in [DAC](#dac) as an integer (2F99).

<a name="4fd5h"></a>

    Address... 4FD5H

This routine is used by the Factor Evaluator to apply the "`USR`" function. The user number is collected directly from the program text, it cannot be an expression, and the associated address taken from [USRTAB](#usrtab) (4FF4H). The following parenthesized operand is then evaluated (4E87H) and left in [DAC](#dac) as the passed parameter. If it is a string type its storage is freed (67D3H). The current program text position is pushed onto the Z80 stack followed by a return to 3297H, the routine at this address will restore the program text position after the user function has terminated. Control then transfers to the user address with register pair HL pointing to the first byte of [DAC](#dac) and the type code, from [VALTYP](#valtyp), in register A. Additionally, for a string parameter, the descriptor address is taken from [DAC](#dac) and placed in register pair DE.

The user routine may modify any register except the Z80 SP and should terminate with a RET instruction, interrupts may be left disabled if necessary as the Runloop will re-enable them. Any numeric parameter to be returned to the Interpreter should be placed in [DAC](#dac). Strictly speaking this should be the same numeric type as the passed parameter, however if [VALTYP](#valtyp) is modified the Interpreter will always accept it.

Returning a string type is more difficult. Using the same method as the Factor Evaluator string functions, which involves copying the string to the String Storage Area and pushing a new descriptor onto [TEMPST](#tempst), is complicated and vulnerable to changes in the MSX system. A simpler and more reliable method is to use the passed parameter to create the space for the result. This should not be an explicitly stated string as the program text will have to be modified, instead an implicit parameter should be used. This must be done with care however, it is very easy to gain the impression that the Interpreter has accepted the string when in fact it has not. Take the following example which does nothing but return the passed parameter:

```
10 POKE &H9000,&HC9
20 DEFUSR=&H9000
30 A$=USR(STRING$(12,"!"))
40 PRINT A$
50 B$=STRING$(9,"X")
60 PRINT A$
```

At first it seems that the passed string has been correctly assigned to A$. When line 60 is reached however it becomes apparent that A$ has been corrupted by the subsequent assignment of a string to B$. What has happened is that the temporary storage allocated to the passed parameter was reclaimed from the String Storage Area before control transferred to the user routine. This region was then used to store the string belonging to B$ thus modifying A$.

This situation can be avoided by assigning the parameter to a Variable beforehand and then passing the Variable, for example:

```
10 A$=STRING$(12,"!")
20 A$=USR(A$)
```

Line 10 results in twelve bytes of the String Storage Area being permanently allocated to A$. When the user function is entered the descriptor, which is pointed to by register pair DE, will contain the starting address of the twelve byte region where the result should be placed. If the returned string is shorter than the passed one the length byte of the descriptor may be changed without any side effects. For further details on string storage see the garbage collector ([66B6H](#66b6h)).

A point worth noting is that a "`CLEAR`" operation is not strictly necessary before a machine language program is loaded. The region between the top of the Array Storage Area and the base of the Z80 stack is never used by the Interpreter. A program can exist in this region provided that the two enclosing areas do not overlap it.

<a name="500eh"></a><a name="defusr"></a>

    Address... 500EH

This is the "`DEFUSR`" statement handler. The user number is collected directly from the program text, it cannot be an expression, and the associated entry in [USRTAB](#usrtab) located (4FF4H). The address operand is then evaluated ([542FH](#542fh)) and placed in [USRTAB](#usrtab).

<a name="501dh"></a><a name="def fn"></a>

    Address... 501DH

This is the "`DEF FN`" and "`DEFUSR`" statement handler. If the following character is a "`USR`" token (DDH) control transfers to the "`DEFUSR`" statement handler ([500EH](#500eh)), otherwise the program text is checked for a trailing "`FN`" token (DEH). The function name Variable is located ([51A1H](#51a1h)) and, after checking that the Interpreter is in program mode ([5193H](#5193h)), the current program text position is placed there. Each of the Variables in the formal parameter list is then located in succession ([5EA4H](#5ea4h)), this is simply to ensure that they are created. The routine terminates by skipping over the remainder of the statement ([485BH](#485bh)) as the function body is not required at this time.

<a name="5040h"></a>

    Address... 5040H

This routine is used by the Factor Evaluator to apply the "`FN`" function. The function name Variable is first located ([51A1H](#51a1h)) to obtain the address of the function definition in the program text. Each formal Variable from the function definition is located in turn ([5EA4H](#5ea4h)) and its address pushed onto the Z80 stack. As each one is found the corresponding actual parameter is evaluated ([4C64H](#4c64h)) and pushed onto the stack with it. If necessary the type of the actual parameter is converted to match that of the formal parameter (517AH)'

When both lists are exhausted each formal Variable address and actual parameter are popped from the stack in turn. Each Variable is then copied from the Variable Storage Area to [PARM2](#parm2) with its value replaced by the actual parameter. It should be noted that, because [PARM2](#parm2) is only a hundred bytes long, a maximum of nine double precision parameters is allowed. When all the actual parameters have been copied to [PARM2](#parm2) the entire contents of [PARM1](#parm1) (the current parameter area) are pushed onto the Z80 stack and [PARM2](#parm2) is copied to [PARM1](#parm1) (518EH). Register pair HL is then set to the start of the function body in the program text and the expression is evaluated ([4C5FH](#4c5fh)). The old contents of [PARM1](#parm1) are popped from the stack and restored. Finally the result of the evaluation is type converted if necessary to match the function name type (517AH).

A user defined function differs from a normal expression in only one respect, it has its own set of local Variables. These Variables are created in [PARM1](#parm1) when the function is invoked and disappear when it terminates. When a normal Variable search is initiated by the Expression Evaluator the region examined is the Variable Storage Area. However, if [NOFUNS](#nofuns) is non-zero, indicating at least one active user function, [PARM1](#parm1) will be searched instead, only if this fails will the search move on to the global Variables in the Variable Storage Area. Using a local Variable area specific to each invocation of a function means that the same Variable names can be used throughout without the Variables overwriting each other or the global Variables.

It is worth noting that a user defined function is slower than an inline expression or even a subroutine. The search carried out to find the function name Variable, plus the large amount of stacking and destacking, are significant overheads.

<a name="5189h"></a>

    Address... 5189H

This routine moves a block of memory from the address pointed to by register pair DE to that pointed to by register pair HL, register pair BC defines the length.

<a name="5193h"></a>

    Address... 5193H

This routine generate an "`Illegal direct`" error if [CURLIN](#curlin) shows the Interpreter to be in direct mode.

<a name="51a1h"></a>

    Address... 51A1H

This routine checks the program text for an "`FN`" token (DEH) and then creates the function name Variable (5EA9H). These are distinguished from ordinary Variables by having bit 7 set in the first character of the Variable's name.

<a name="51adh"></a>

    Address... 51ADH

Control transfers to this routine from the Runloop execution point ([4640H](#4640h)) if a token greater than D8H is found at the start of a statement. If the token is not an FFH prefixed function token a "`Syntax error`" is generated ([4055H](#4055h)). If the function token is one of those which double as statements control transfers to the relevant handler, otherwise a "`Syntax error`" is generated. The statements in question are "`MID$`" ([696EH](#696eh)), "`STRIG`" ([77BFH](#77bfh)) and "`INTERVAL`" ([77B1H](#77b1h)). There is actually no separate token for "`INTERVAL`", the "`INT`" token (85H) suffices with the remaining characters being checked by the statement handler.

<a name="51c9h"></a><a name="width"></a>

    Address... 51C9H

This is the "`WIDTH`" statement handler. The operand is evaluated (521CH) and its magnitude checked. If it is zero or greater than thirty-two or forty, depending upon the screen mode held in [OLDSCR](#oldscr) an "`Illegal function call`" error is generated (475AH). If it is the same as the current contents of [LINLEN](#linlen) the routine terminates with no further action. Otherwise the current screen is cleared with a FORMFEED control code (0CH) via the [OUTDO](#outdo) standard routine in case the screen is to be made smaller. The operand is then placed in [LINLEN](#linlen) and either [LINL32](#linl32) or [LINL40](#linl40), depending upon the screen mode held in [OLDSCR](#oldscr), and the screen cleared again in case it has been made larger. Because the line length variable to be changed is selected by [OLDSCR](#oldscr), rather than [SCRMOD](#scrmod), the width can still be changed even if the screen is currently in [Graphics Mode](#graphics_mode) or [Multicolour Mode](#multicolour_mode). In this case the change is effective when a return is made to the Interpreter Mainloop or an "`INPUT`" statement is executed.

<a name="520eh"></a>

    Address... 520EH

This routine evaluates the next expression in the program text ([4C64H](#4c64h)), converts it to an integer ([2F8AH](#2f8ah)) and places the result in register pair DE. The magnitude and sign of the MSB are then tested and the routine terminates.

<a name="521bh"></a>

    Address... 521BH

This routine evaluates the next operand in the program text ([4C64H](#4c64h)) and converts it to an integer (5212H). If the operand is greater than 255 an "`Illegal function call`" error is generated (475AH).

<a name="5229h"></a><a name="llist"></a>

    Address... 5229H

This is the "`LLIST`" statement handler. [PRTFLG](#prtflg) is set to 01H, to direct output to the printer, and control drops into the "`LIST`" statement handler.

<a name="522eh"></a><a name="list"></a>

    Address... 522EH

This is the "`LIST`" statement handler. The optional start and termination line number operands are collected and the starting position found in the program text ([4279H](#4279h)). Successive program lines are listed until the end link is found, the CTRL-STOP key is pressed or the termination line number is reached, control then transfers directly to the Mainloop "`OK`" point ([411FH](#411fh)). Each program line is listed by displaying its line number ([3412H](#3412h)), detokenizing ([5284H](#5284h)) and displaying (527BH) the line itself and then issuing a CR,LF (7328H).

<a name="5284h"></a>

    Address... 5284H

This routine is used by the "`LIST`" statement handler to convert a tokenized program line to textual form. On entry register pair HL points to the first character of the tokenized line. On exit the line of text is in [BUF](#buf) and is terminated by a zero byte.

Any normal or FFH prefixed token is converted to the corresponding keyword by a simple linear search of the tokens in the table at 3A72H. Exceptions are made if either an opening quote character, a "`REM`" token, or a "`DATA`" token has previously been found. Normally these tokens will be followed by plain text anyway, the check is made to stop graphics characters being interpreted as tokens. The three byte sequence ":" (3AH), "`REM`" token (8FH), " " token (E6H) is converted to the single " " character (27H) and the statement separator (3AH) preceding an "`ELSE`" token (A1H) is scrubbed out.

If one of the numeric tokens is found its value and type are first copied from [CONLO](#conlo) and [CONTYP](#contyp) to [DAC](#dac) and [VALTYP](#valtyp) ([46E8H](#46e8h)). It is then converted to textual form in [FBUFFR](#fbuffr) by the decimal ([3425H](#3425h)), octal ([371EH](#371eh)) or hex ([3722H](#3722h)) conversion routines. For octal and hex types the number is prefixed by an ampersand and an "`O`" or "`H`" letter. A type suffix, "'" or "#", is added to single precision or double precision numbers only if there is no decimal part and no exponent part ("`E`" or "`D`").

<a name="53e2h"></a><a name="delete"></a>

    Address... 53E2H

This is the "`DELETE`" statement handler. The optional start and termination line number operands are collected and the starting position found in the program text ([4279H](#4279h)). If any pointers exist in the program text they are converted back to line numbers (54EAH). The terminating program line is found by a search of the program text ([4295H](#4295h)), if this address is smaller than that of the starting program line an "`Illegal function call`" error is generated (475AH), otherwise the message "`OK`" is displayed ([6678H](#6678h)). The block of memory from the end of the terminating line to the start of the Variable Storage Area is copied down to the beginning of the starting line and [VARTAB](#vartab), [ARYTAB](#arytab) and [STREND](#strend) are reset to the new (lower) end of the program text. Control then transfers directly to the end of the Mainloop (4237H) to reset the remaining pointers and to relink the Program Text Area. Note that, because control does not return to the normal "`OK`" point, the screen will not be returned to text mode. If the screen is in [Graphics Mode](#graphics_mode) or [Multicolour mode](#multicolour_mode) when a "`DELETE`" is executed, which is admittedly rather unlikely, the system will crash.

<a name="541ch"></a>

    Address... 541CH

This routine is used by the Factor Evaluator to apply the "`PEEK`" function to an operand contained in [DAC](#dac). The address operand is checked ([5439H](#5439h)) then the byte read from memory and placed in [DAC](#dac) as an integer (4FCFH).

<a name="5423h"></a><a name="poke"></a>

    Address... 5423H

This is the "`POKE`" statement handler. The address operand is evaluated ([542FH](#542fh)) then the data operand evaluated (521CH) and written to memory.

<a name="542fh"></a>

    Address... 542FH

This routine evaluates the next operand in the program text ([4C64H](#4c64h)) and places it in register pair DE as an integer ([5439H](#5439h)).

<a name="5439h"></a>

    Address... 5439H

This routine converts the numeric operand contained in [DAC](#dac) into an integer in register pair HL. The operand must be in the range -32768 to +65535 and is normally an address as required by "`POKE`", "`PEEK`", "`BLOAD`", etc. The operand's type is first checked via the [GETYPR](#getypr) standard routine, if it is already an integer it is simply placed in register pair HL ([2F8AH](#2f8ah)). Assuming the operand is single precision or double precision its sign is checked, if it is negative it is converted to integer ([2F8AH](#2f8ah)). Otherwise it is converted to single precision ([2FB2H](#2fb2h)) and its magnitude checked ([2F21H](#2f21h)). If it is greater than 32767 and smaller than 65536 then -65536 is added ([324EH](#324eh)) before it is converted to integer ([2F8AH](#2f8ah)).

<a name="5468h"></a><a name="renum"></a>

    Address... 5468H

This is the "`RENUM`" statement handler. If a new initial line number operand exists it is collected ([475FH](#475fh)), otherwise a default value of ten of taken. If an old initial line number operand exists it is collected ([475FH](#475fh)), otherwise a default value of zero is taken. If an increment line number operand exists it is collected (4769H), otherwise a default value of ten is taken.

The program text is then searched for existing line numbers equal to or greater than the new initial line number ([4295H](#4295h)) and the old initial line number ([4295H](#4295h)), an "`Illegal function call`" error is generated (475AH) if the new address is smaller than the old address. This is to catch any attempt to renumber high program lines down to existing low ones.

A dummy renumbering run of the program text is first carried out to check than no new line number will be generated with a value greater than 65529. This must be done as an error midway through the conversion would leave the program text in a confused state. Assuming all is well any line number operands in the program text are converted to pointers ([54F6H](#54f6h)). This neatly solves the problem of line number references, `GOTO 50` for example, as the program text is not moved during renumbering. Starting at the old initial program text position each existing program line number is replaced with its new value. When the end link is reached any program text pointers are converted back to line number operands (54F1H) and control transfers directly to the Mainloop "`OK`" point (411EH).

<a name="54f6h"></a>

    Address... 54F6H

When entered at 54F6H this routine converts every line number operand in the program text to a pointer. When entered at 54F7H it performs the reverse operation and converts every pointer in the program text back to a line number operand. Starting at the beginning of the Program Text Area each line is examined for a pointer token (0DH) or a line number operand token (0EH) depending upon the mode. In pointer to line number operand mode the pointer is replaced by the line number from the referenced program line and the token changed to 0EH. In line number operand to pointer mode the program text is searched ([4295H](#4295h)) to find the relevant line, its address replaces the line number operand and the token is changed to 0DH. If the search is unsuccessful a message of the form "`Undefined line NNNN in NNNN`" is displayed ([6678H](#6678h)) and the conversion process continues. A special check is made for the "`ON ERROR GOTO 0`" statement, to prevent the generation of a spurious error message, but no check is made for the similar "`RESUME 0`" statement. In this case an error message will be displayed, this should be ignored.

<a name="555ah"></a>

    Address... 555AH

This is the plain text message "`Undefined line `" terminated by a zero byte.

<a name="558ch"></a><a name="synchr"></a>

```
Address... 558CH
Name...... SYNCHR
Entry..... HL points to character to check
Exit...... A=Next program character
Modifies.. AF, HL
```

Standard routine to check the current program text character, whose address is supplied in register pair HL, against a reference character. The reference character is supplied as a single byte immediately following the `CALL` or `RST` instruction, for example:

```
RST 08H
DEFB ","
```

If the characters do not match a "`Syntax error`" is generated ([4055H](#4055h)), otherwise control transfers to the [CHRGTR](#chrgtr) standard routine to fetch the next program character ([4666H](#4666h)).

<a name="5597h"></a><a name="getypr"></a>

```
Address... 5597H
Name...... GETYPR
Entry..... None
Exit...... AF=Type
Modifies.. AF
```

Standard routine to return the type of the current operand, determined by [VALTYP](#valtyp), as follows:

```
Integer..............A=FFH, Flag M,NZ,C
String...............A=00H, Flag P,Z,C
Single Precision ... A=01H, Flag P,NZ,C
Double Precision ... A=05H, Flag P,NZ,NC
```

</a>

<a name="55a8h"></a><a name="call"></a>

    Address... 55A8H

This is the "`CALL`" statement handler. The extended statement name, which is an unquoted string up to fifteen characters long terminated by a "(", ":" or end of line character (00H), is first copied from the program text to [PROCNM](#procnm), any unused bytes are zero filled. Bit 5 of each entry in [SLTATR](#sltatr) is then examined for an extension ROM with a statement handler. If a suitable ROM is found its position in [SLTATR](#sltatr) is converted to a Slot ID in register A and a ROM base address in register H ([7E2AH](#7e2ah)). The statement handler address is read from ROM locations four and five ([7E1AH](#7e1ah)) and placed in register pair IX. The Slot ID is placed in the high byte of register pair IY and the ROM statement handler called via the [CALSLT](#calslt) standard routine.

The ROM will examine the statement name and return Flag C if it does not recognize it, otherwise it performs the required operation. If the ROM call fails the search of [SLTATR](#sltatr) continues until the table is exhausted whereupon a "`Syntax error`" is generated ([4055H](#4055h)). If the ROM call is successful the handler terminates.

<a name="55f8h"></a>

    Address... 55F8H

This routine is used by the device name parser ([6F15H](#6f15h)) when it cannot recognize a device name found in the program text. Upon entry register pair HL points to the first character of the name and register B holds its length. The name is first copied to [PROCNM](#procnm) and terminated by a zero byte. Bit 6 of each entry in [SLTATR](#sltatr) is then examined for an extension ROM with a device handler. If a suitable ROM is found its position in [SLTATR](#sltatr) is converted to a Slot ID in register A and a ROM base address in register H ([7E2AH](#7e2ah)). The device handler address is read from ROM locations six and seven ([7E1AH](#7e1ah)) and placed in register pair IX. The Slot ID is placed in the high byte of register pair IY, the unknown device code (FFH) in register A and the ROM device handler called via the [CALSLT](#calslt) standard routine.

The ROM will examine the device name and return Flag C if it does not recognize it, otherwise it returns its own internal code from zero to three. If the ROM call fails the search of [SLTATR](#sltatr) continues until the table is exhausted whereupon a "`Bad file name`" error is generated ([6E6BH](#6e6bh)). If the ROM call is successful the ROM's internal code is added to its [SLTATR](#sltatr) position, multiplied by a factor of four, to produce a global device code' The base code for each entry in [SLTATR](#sltatr) is shown below in hexadecimal. The "SS" and "PS" markers show the corresponding Secondary and Primary Slot numbers, each slot is composed of four pages:

<a name="figure44"></a>![][CH05F44]

**Figure 44:** Device Codes

The global device code is used by the Interpreter until the time comes for the ROM to perform an actual device operation. It is then converted back into the ROM's Slot ID, base address and internal device code to perform the ROM access. Note that the codes from 0 to 8 are reserved for disk drive identifiers and those from FCH to FFH for the standard devices GRP, CRT, LPT and CAS. With the current MSX hardware structure these codes correspond to physically improbable ROM configurations and are therefore safe to be used for specific purposes by the Interpreter.

<a name="564ah"></a>

    Address... 564AH

This routine is used by the function dispatcher ([6F8FH](#6f8fh)) when it encounters a device code not belonging to one of the standard devices. The device code is first converted to a [SLTATR](#sltatr) position and then to a Slot ID in register A and ROM base address in register H (7E2DH). The ROM device handler address is read from ROM locations six and seven ([7E1AH](#7e1ah)) and placed in register pair IX. The Slot ID is placed in the high byte of register pair IY, the ROM's internal device code in DEVICE and the ROM device handler called via the [CALSLT](#calslt) standard routine.

<a name="566ch"></a>

    Address... 566CH

This entry point to the macro language parser is used by the "`DRAW`" statement handler, a later entry point ([56A2H](#56a2h)) is used by the "`PLAY`" statement handler. The command string is evaluated ([4C64H](#4c64h)) and its storage freed ([67D0H](#67d0h)). After pushing a zero termination block onto the Z80 stack the length and address of the string body are placed in [MCLLEN](#mcllen) and [MCLPTR](#mclptr) and control drops into the parser mainloop.

<a name="56a2h"></a>

    Address... 56A2H

This is the macro language parser mainloop, it is used to process the command string associated with a "`DRAW`" or "`PLAY`" statement' On entry the string length is in [MCLLEN](#mcllen), the string address is in [MCLPTR](#mclptr) and the address of the relevant command table is in [MCLTAB](#mcltab). The command tables contain the legal command letters, together with the associated command handler addresses, for each statement. The "`DRAW`" table is at 5D83H and the "`PLAY`" table at 752EH.

The parser mainloop first fetches the next character from the command string ([56EEH](#56eeh)). If there are no more characters left the next string descriptor is popped from the stack (568CH). If this is zero the parser terminates (5709H) if [MCLFLG](#mclflg) shows a "`DRAW`" statement to be active, otherwise control transfers back to the "`PLAY`" statement handler (7494H).

Assuming a command character exists the current command table is searched to check its legality, if no match is found an "`Illegal function call`" error is generated (475AH). The command table entry is then examined, if bit 7 is set the command takes an optional numeric parameter. If this is present it is collected and placed in register pair DE (571CH), otherwise a default value of one is taken. After pushing a return to the start of the parser mainloop onto the Z80 stack control transfers to the command handler at the address taken from the command table.

<a name="56eeh"></a>

    Address... 56EEH

This routine is used by the macro language parser to fetch the next character from the command string. If [MCLLEN](#mcllen) is zero the routine terminates with Flag Z, there are no characters left. Otherwise the next character is taken from the address contained in [MCLPTR](#mclptr) and returned in register A, if the character is lower case it is converted to upper case. [MCLPTR](#mclptr) is then incremented and [MCLLEN](#mcllen) decrement Ed.

<a name="570bh"></a>

    Address... 570BH

This routine is used by the macro language parser to return an unwanted character to the command string. [MCLLEN](#mcllen) is incremented and [MCLPTR](#mclptr) decremented.

<a name="5719h"></a>

    Address... 5719H

This routine is used by the macro language parser to collect a numeric parameter from the command string. The result is a signed integer and is returned in register pair DE, it cannot be an expression. The first character is taken and examined, if it is a "+" it is ignored and the next character taken ([5719H](#5719h)). If it is a "-" a return is set up to the negation routine (5795H) and the next character taken ([5719H](#5719h)). If it is an "=" the value of the following Variable is returned ([577AH](#577ah)). Otherwise successive characters are taken and a binary product accumulated until a non-numeric character is found.

<a name="575ah"></a>

    Address... 575AH

This routine is used by the macro language parser "=" and "X" handlers. The Variable name is copied to [BUF](#buf) until the ";" delimiter is found, if this takes more than thirty-nine characters to find an "`Illegal function call`" error is generated (475AH). Otherwise control transfers to the Factor Evaluator Variable handler ([4E9BH](#4e9bh)) and the Variable contents are returned in [DAC](#dac).

<a name="577ah"></a>

    Address... 577AH

This routine is used by the macro language parser to process the "=" character in a command parameter. The Variable's value is obtained ([575AH](#575ah)), converted to an integer ([2F8AH](#2f8ah)) and placed in register pair DE.

<a name="5782h"></a>

    Address... 5782H

This routine is used by the macro language parser to process the "X" command. The Variable is processed ([575AH](#575ah)) and, after checking that stack space is available ([625EH](#625eh)), the current contents of [MCLLEN](#mcllen) and [MCLPTR](#mclptr) are stacked. Control then transfers to the parser entry point (5679H) to obtain the Variable's descriptor and process the new command string.

<a name="579ch"></a>

    Address... 579CH

This routine is used by various graphics statements to evaluate a coordinate pair in the program text. The coordinates must be parenthesized with a comma separating the component operands. If the coordinate pair is preceded by a "`STEP`" token (DCH) each component value is added to the corresponding component of the current graphics coordinates in [GRPACX](#grpacx) and [GRPACY](#grpacy), otherwise the absolute values are returned. The X coordinate is returned in [GRPACX](#grpacx), [GXPOS](#gxpos) and register pair BC. The Y coordinate is returned in [GRPACY](#grpacy), [GYPOS](#gypos) and register pair DE.

There are two entry points to the routine, the one which is used depends on whether the caller is expecting more than one coordinate pair. The "`LINE`" statement, for example, expects two coordinate pairs the first of which is the more flexible. The entry point at 579CH is used to collect the first coordinate pair and will accept the characters "-" or "@-" as representing the current graphics coordinates. The entry point at 57ABH is used for the second coordinate pair and requires an explicit operand.

<a name="57e5h"></a><a name="preset"></a>

    Address... 57E5H

This is the "`PRESET`" statement handler. The current background colour is taken from [BAKCLR](#bakclr) and control drops into the "`PSET`" handler.

<a name="57eah"></a><a name="pset"></a>

    Address... 57EAH

This is the "`PSET`" statement handler. After the coordinate pair has been evaluated (57ABH) the current foreground colour is taken from [FORCLR](#forclr) and used as the default when setting the ink colour ([5850H](#5850h)). The current graphics coordinates are converted to a physical address, via the [SCALXY](#scalxy) and [MAPXYC](#mapxyc) standard routines, and the colour of the current pixel set via the [SETC](#setc) standard routine.

<a name="5803h"></a>

    Address... 5803H

This routine is used by the Factor Evaluator to apply the "`POINT`" function. The current contents of [CLOC](#cloc), [CMASK](#cmask), [GYPOS](#gypos), [GXPOS](#gxpos), [GRPACY](#grpacy) and [GRPACX](#grpacx) are stacked and the coordinate pair operand evaluated (57ABH). The colour of the new pixel is read via the [SCALXY](#scalxy), [MAPXYC](#mapxyc) and [READC](#readc) standard routines and placed in [DAC](#dac) as an integer (2F99H), the old coordinate values are then popped and restored. Note that a value of -1 is returned if the point coordinates are outside the screen.

<a name="5850h"></a>

    Address... 5850H

This graphics routine is used to evaluate an optional colour operand in the program text and to make it the current ink colour. After checking the screen mode ([59BCH](#59bch)) the colour operand is evaluated (521CH) and placed in [ATRBYT](#atrbyt). If no operand exists the colour code supplied in register A is placed in [ATRBYT](#atrbyt) instead.

<a name="5871h"></a>

    Address... 5871H

This graphics routine returns the difference between the contents of [GXPOS](#gxpos) and register pair BC in register pair HL. If the result is negative ([GXPOS](#gxpos)\<BC) it is negated to produce the absolute magnitude and Flag C is returned.

<a name="5883h"></a>

    Address... 5883H

This graphics routine returns the difference between the contents of [GYPOS](#gypos) and register pair DE in register pair HL. If the result is negative ([GYPOS](#gypos)\<DE) it is negated to produce the absolute magnitude and Flag C is returned.

<a name="588eh"></a>

    Address... 588EH

This graphics routine swaps the contents of [GYPOS](#gypos) and register pair DE.

<a name="5898h"></a>

    Address... 5898H

This graphics routine first swaps the contents of [GYPOS](#gypos) and register pair DE ([588EH](#588eh)) then swaps the contents of [GXPOS](#gxpos) and register pair BC. When entered at 589BH only the second operation is performed.

<a name="58a7h"></a><a name="line"></a>

    Address... 58A7H

This is the "`LINE`" statement handler. The first coordinate pair (X1,Y1) is evaluated ([579CH](#579ch)) and placed in register pairs BC,DE. After checking for the "-" token (F2H) the second coordinate pair (X2,Y2) is evaluated (57ABH) and left in [GRPACX](#grpacx), [GRPACY](#grpacy) and [GXPOS](#gxpos), [GYPOS](#gypos). After setting the ink colour (584DH) the program text is checked for a following "B" or "BF" option and either the box ([5912H](#5912h)), boxfill ([58BFH](#58bfh)) or linedraw ([58FCH](#58fch)) operation performed. None of these operations affects the current graphics coordinates in [GRPACX](#grpacx) and [GRPACY](#grpacy), these are left at X2,Y2.

<a name="58bfh"></a>

    Address... 58BFH

This routine performs the boxfill operation. Given that the supplied coordinate pairs define diagonally opposed points of the box two quantities must be derived from them. The horizontal size of the box is obtained from the difference between X1 and X2, this gives the number of pixels to set per row. The vertical size is obtained from the difference between Y1 and Y2 giving the number of rows required. Starting at the physical address of X1,Y1, and moving successively lower via the [DOWNC](#downc) standard routine, the required number of pixel rows are filled in by repeated use of the [NSETCX](#nsetcx) standard routine.

<a name="58fch"></a>

    Address... 58FCH

This routine performs the linedraw operation. After drawing the line ([593CH](#593ch)) [GXPOS](#gxpos) and [GYPOS](#gypos) are reset to X2,Y2 from [GRPACX](#grpacx) and [GRPACY](#grpacy).

<a name="5912h"></a>

    Address... 5912H

This routine performs the box operation. The box is produced by drawing a line ([58FCH](#58fch)) between each of the four corner points. The coordinates of each corner are derived from the initial operands by interchanging the relevant component of the pair. The drawing sequence is:

1. X1,Y2 to X2,Y2
2. X1,Y1 to X2,Y1
3. X2,Y1 to X2,Y2
4. X1,Y1 to X1,Y2

</a>

<a name="593ch"></a>

    Address... 593CH

This routine draws a line between the points X1,Y1, supplied in register pairs BC and DE and X2,Y2, supplied in [GXPOS](#gxpos) and [GYPOS](#gypos). The operation of the drawing mainloop (5993H) is best illustrated by an example, say LINE(0,0)-(10,4). To reach the end point of the line from its start ten horizontal steps (X2- X1) and four downward steps (Y2-Y1) must be taken altogether. The best approximation to a straight line therefore requires two and a half horizontal steps for every downward step (X2-X1/Y2-Y1). While this is impossible in practice, as only integral steps can be taken, the correct ratio can be achieved on average.

The method employed is to add the Y difference to a counter each time a rightward step is taken. When the counter exceeds the value of the X difference it is reset and one downward step is taken, this is in effect an integer division of the two difference values. Sometimes downward steps will be produced every two rightward steps and sometimes every three rightward steps. The average, however, will be one downward step every two and a half rightward steps. An equivalent BASIC program is shown below with a slightly offset BASIC line for comparison:

```
10 SCREEN 0
20 INPUT"START X,Y";X1,Y1
30 INPUT"END X,Y",X2,Y2
40 SCREEN 2
50 X=X1:Y=Y1:L=X2-X1:S=Y2-Y1:CTR=L/2
60 PSET(X,Y)
70 CTR=CTR+S:IF CTR<L THEN 90
80 CTR=CTR-L:Y=Y+1
90 X=X+1:IF X<=X2 THEN 60
100 LINE(X1,Y1+5)-(X2,Y2+5)
110 GOTO 110
```

The above example suffers from three limitations. The line must slope downwards, it must slope to the right and the slope cannot exceed forty-five degrees from the horizontal (one downward step for one rightward step).

The routine overcomes the first limitation by examining the Y1 and Y2 coordinates before drawing commences. If Y2 is greater than or equal to Y1, showing the line to slope upwards or to be horizontal, both coordinate pairs are exchanged. The line is now sloping downwards and will be drawn from the end point to the start.

The second limitation is overcome by examining X1 and X2 beforehand to determine which way the line is sloping. If X2 is greater than or equal to X1 the line slopes to the right and a Z80 JP to the [RIGHTC](#rightc) standard routine is placed in [MINUPD](#minupd)/[MAXUPD](#maxupd) (see below) for use by the drawing mainloop, otherwise a JP to the [LEFTC](#leftc) standard routine is placed there.

The third limitation is overcome by comparing the X coordinate difference to the Y coordinate difference before drawing to determine the slope steepness. If X2-X1 is smaller than Y2-Y1 the slope of the line is less than forty-five degrees from the horizontal. The simple method shown above for LINE(0,0)-(10,4) will not work for slopes greater than forty- five degrees as the maximum rate of descent is achieved when one downward step is taken for every horizontal step. It will work however if the step directions are exchanged. Thus LINE(0,0)-(4,10) requires one rightward step for every two and a half downward steps. [MINUPD](#minupd) holds a Z80 JP to the "normal" step direction standard routine for the drawing mainloop and [MAXUPD](#maxupd) holds a JP to the "slope" step direction standard routine. For shallow angles [MINUPD](#minupd) will vector to [DOWNC](#downc) and [MAXUPD](#maxupd) to [LEFTC](#leftc) or [RIGHTC](#rightc). For steep angles [MINUPD](#minupd) will vector to [LEFTC](#leftc) or [RIGHTC](#rightc) and [MAXUPD](#maxupd) to [DOWNC](#downc). For steep angles the counter values must also be exchanged, the X difference must now be added to the counter and the Y difference used as the counter limit. The variables [MINDEL](#mindel) and [MAXDEL](#maxdel) are used by the drawing mainloop to hold these counter values, [MINDEL](#mindel) holds the smaller end point difference and [MAXDEL](#maxdel) the larger.

An interesting point is that the reference counter, held in CTR in the above program and in register pair DE in the ROM, is preloaded with half the largest end point difference rather than being set to zero. This has the effect of splitting the first "stair" in the line into two sections, one at the start of the line and one at its end, and improving the line's appearance.

<a name="59b4h"></a>

    Address... 59B4H

This graphics routine shifts the contents of register pair DE one bit to the right.

<a name="59bch"></a>

    Address... 59BCH

This routine generates an "`Illegal function call`" error (475AH) if the screen is not in [Graphics Mode](#graphics_mode) or [Multicolour Mode](#multicolour_mode).

<a name="59c5h"></a><a name="paint"></a>

    Address... 59C5H

This is the "`PAINT`" statement handler. The starting coordinate pair is evaluated ([579CH](#579ch)), the ink colour set (584DH) and the optional boundary colour operand evaluated (521CH) and placed in [BDRATR](#bdratr). The starting coordinate pair is checked to ensure that it is within the screen ([5E91H](#5e91h)) and is made the current pixel physical address by the [MAPXYC](#mapxyc) standard routine. The distance to the right hand boundary is then measured ([5ADCH](#5adch)) and, if it is zero, the handler terminates. Otherwise the distance to the left hand boundary is measured ([5AEDH](#5aedh)) and the sum of the two placed in register pair DE as the zone width. The current position is then stacked twice (5ACEH), first with a termination flag (00H) and then with a down direction flag (40H). Control then transfers to the paint mainloop ([5A26H](#5a26h)) with an up direction flag (C0H) in register B.

<a name="5a26h"></a>

    Address... 5A26H

This is the paint mainloop. The zone width is held in register pair DE, the paint direction, up or down, in register B and the current pixel physical address is that of the pixel adjacent to the left hand boundary. A vertical step is taken to the next line, via the [TUPC](#tupc) or [TDOWNC](#tdownc) standard routines, and the distance to the right hand boundary measured ([5ADCH](#5adch)). The distance to the left hand boundary is then measured and the line between the boundaries filled in ([5AEDH](#5aedh)). If no change is found in the position of either boundary control transfers to the start of the mainloop to continue painting in the same direction. If a change is found an inflection has occurred and the appropriate action must be taken.

There are four types of inflection, LH or RH incursive, where the relevant boundary moves inward, and LH or RH excursive, where it moves outward. An example of each type is shown below with numbered zones indicating the order of painting during upward movement. A secondary zone is shown within each inflective region for completeness:

<a name="figure45"></a>![][CH05F45]

**Figure 45:** Boundary Inflections

A LH excursion has occurred when the distance to the left hand boundary is non-zero, a RH excursion has occurred when the current zone width is greater than that of the previous line. Unless the excursion is less than two pixels, in which case it will be ignored, the current position (the bottom left of zone 3 in figure 45) is stacked ([5AC2H](#5ac2h)), the paint direction reversed and painting restarts at the top left of the excursive region .

A RH incursion has occurred when the current zone width is smaller than that of the previous line. If the incursion is total, that is the current zone width is zero, a dead end has been reached and the last position and direction are popped (5AIFH) and painting restarts at that point. Otherwise the current position and direction are stacked ([5AC2H](#5ac2h)) and painting restarts at the bottom left of the incursive region.

A LH incursion is dealt with automatically during the search for the right hand boundary and requires no explicit action by the paint mainloop.

<a name="5ac2h"></a>

    Address... 5AC2H

This routine is used by the "`PAINT`" statement handler to save the current paint position and direction on the Z80 stack. The six byte parameter block is made up of the following:

```
2 bytes ... Current contents of CLOC
1 byte  ... Current direction
1 byte  ... Current contents of CMASK
2 bytes ... Current zone width
```

After the parameters have been stacked a check is made that sufficient stack space still exists ([625EH](#625eh)).

<a name="5adch"></a>

    Address... 5ADCH

This routine is used by the "`PAINT`" statement handler to locate the right hand boundary. The zone width of the previous line is passed to the [SCANR](#scanr) standard routine in register pair DE, this determines the maximum number of boundary colour pixels that may initially be skipped over. The returned skip count remainder is placed in [SKPCNT](#skpcnt) and the number of non-boundary colour pixels traversed in [MOVCNT](#movcnt).

<a name="5aedh"></a>

    Address... 5AEDH

This routine is used by the "`PAINT`" statement handler to locate the left hand boundary. The end point of the right hand boundary search is temporarily saved and the starting point taken from [CSAVEA](#csavea) and [CSAVEM](#csavem) and made the current pixel physical address. The left hand boundary is then located via the [SCANL](#scanl) standard routine, which also fills in the entire zone, and the right hand end point recovered and placed in [CSAVEA](#csavea) and [CSAVEM](#csavem).

<a name="5b0bh"></a>

    Address... 5B0BH

This routine is used by the "`CIRCLE`" statement handler to negate the contents of register pair DE.

<a name="5b11h"></a><a name="circle"></a>

    Address... 5B11H

This is the "`CIRCLE`" statement handler. After evaluating the centre coordinate pair ([579CH](#579ch)) the radius is evaluated (520FH), multiplied ([325CH](#325ch)) by SIN(PI/4) and placed in [CNPNTS](#cnpnts). The ink colour is set (584DH), the start angle evaluated ([5D17H](#5d17h)) and placed in [CSTCNT](#cstcnt) and the end angle evaluated ([5D17H](#5d17h)) and placed in [CENCNT](#cencnt). If the end angle is smaller than the start angle the two values are swapped and [CPLOTF](#cplotf) is made non-zero. The aspect ratio is evaluated ([4C64H](#4c64h)) and, if it is greater than one, its reciprocal is taken (3267H) and [CSCLXY](#csclxy) is made non-zero to indicate an X axis squash. The aspect ratio is multiplied ([325CH](#325ch)) by 256, converted to an integer ([2F8AH](#2f8ah)) and placed in [ASPECT](#aspect) as a single byte binary fraction. Register pairs HL and DE are set to the starting position on the circle perimeter (X=RADIUS,Y=0) and control drops into the circle mainloop.

<a name="5bbdh"></a>

    Address... 5BBDH

This is the circle mainloop. Because of the high degree of symmetry in a circle it is only necessary to compute the coordinates of the arc from zero to forty-five degrees. The other seven segments are produced by rotation and reflection of these points. The parametric equation for a unit circle, with T the angle from zero to PI/4, is:

```
X=COS(T)
Y=SIN(T)
```

Direct computation using this equation, or the corresponding functional form X=SQR(1-Y^2), is too slow, instead the first derivative is used:

```
 dx
---- = -Y/X
 dy
```

Given that the starting position is known (X=RADIUS,Y=0), the X coordinate change for each unit Y coordinate change may be computed using the derivative. Furthermore, because graphics resolution is limited to one pixel, it is only necessary to know when the sum of the X coordinate changes reaches unity and then to decrement the X coordinate. Therefore:

```
Decrement X when (Y1/X)+(Y2/X)+(Y3/X)+... => 1
Therefore decrement when (Y1+Y2+Y3+...)/X => 1
Therefore decrement when     Y1+Y2+Y3+... => X
```

All that is required to identify an X coordinate change is to totalize the Y coordinate values from each step until the X coordinate value is exceeded. The circle mainloop holds the X coordinate in register pair HL, the Y coordinate in register pair DE and the running total in [CRCSUM](#crcsum). An equivalent BASIC program for a circle of arbitrary radius 160 pixels is:

```
10 SCREEN 2
20 X=160:Y=0:CRCSUM=0
30 PSET(X,191-Y)
40 CRCSUM=CRCSUM+Y :Y=Y+1
50 IF CRCSUM<X THEN 30
60 CRCSUM=CRCSUM-X:X=X-1
70 IF X>Y THEN 30
80 CIRCLE(0,191),155
90 GOTO 90
```

The coordinate pairs generated by the mainloop are those of a "virtual" circle, such tasks as axial reflection, elliptic squash and centre translation are handled at a lower level ([5C06H](#5c06h)).

<a name="5c06h"></a>

    Address... 5C06H

This routine is used to by the circle mainloop to convert a coordinate pair, in register pairs HL and DE, into eight symmetric points on the screen. The Y coordinate is initially negated ([5B0BH](#5b0bh)), reflecting it about the X axis, and the first four points produced by successive clockwise rotations through ninety degrees (5C48H). The Y coordinate is then negated again ([5B0BH](#5b0bh)) and a further four points produced (5C48H).

Clockwise rotation is performed by exchanging the X and Y coordinates and negating the new Y coordinate, thus a point (40,10) would become (10,-40). Assuming an aspect ratio of 0.5, for example, the complete sequence of eight points would therefore be:

1.  X,-Y\*0.5
2. -Y,-X\*0.5
3. -X, Y\*0.5
4.  Y, X\*0.5
5.  Y,-X\*0.5
6. -X,-Y\*0.5
7. -Y, X\*0.5
8.  X, Y\*0.5

It can be seen from the above that, ignoring the sign of the coordinates for the moment, there are only four terms involved. Therefore, rather than performing the relatively slow aspect ratio multiplication ([5CEBH](#5cebh)) for each point, the terms X\*0.5 and Y\*0.5 can be prepared in advance and the complete sequence generated by interchanging and negating the four terms. With the aspect ratio shown above the initial conditions are set up so that register pair HL=X, register pair DE=-Y\*0.5, CXOFF=Y and CYOFF=X\*0.5 and successive points are produced by the operations:

1. Exchange HL and CXOFF, negate HL.
2. Exchange DE and CYOFF, negate DE.

In parallel with the computation of each circle coordinate the number of points required to reach the start of the segment containing the point is kept in [CPCNT8](#cpcnt8). This will initially be zero and will increase by 2\*RADIUS\*SIN(PI/4) as each ninety degree rotation is made. As each of the eight points is produced its Y coordinate value is added to the contents of [CPCNT8](#cpcnt8) and compared to the start and end angles to determine the appropriate course of action. If the point is between the two angles and [CPLOTF](#cplotf) is zero, or if it is outside the angles and [CPLOTF](#cplotf) is non-zero, the coordinates are added to the circle centre coordinates (5CDCH) and the point set via the [SCALXY](#scalxy), [MAPXYC](#mapxyc) and [SETC](#setc) standard routines. If the point is equal to either of the two angles, and the associated bit is set in [CLINEF](#clinef), the coordinates are added to the circle centre coordinates (5CDCH) and a line drawn to the centre ([593CH](#593ch)). If none of these conditions is applicable no action is taken other than to proceed to the next point.

<a name="5cebh"></a>

    Address... 5CEBH

This routine multiplies the coordinate value supplied in register pair DE by the aspect ratio contained in [ASPECT](#aspect), the result is returned in register pair DE. The standard binary shift and add method is used but the operation is performed as two single byte multiplications to avoid overflow problems.

<a name="5d17h"></a>

    Address... 5D17H

This routine is used by the "`CIRCLE`" statement handler to convert an angle operand to the form required by the circle mainloop, the result is returned in register pair DE. While the method used is basically sound, and eliminates one trigonometric computation per angle, the results produced are inaccurate. This is demonstrated by the following example which draws a line to the true thirty degree point on a circle's perimeter:

```
10 SCREEN 2
20 PI = 4 * ATN(1)
30 CIRCLE(100,100),80,,PI/6
40 LINE(100,100)-(100+80*COS(PI/6),100-80*SIN(PI/6))
50 GOTO 50
```

The result that the routine should produce is the number of points that must be produced by the circle mainloop before the required angle is reached. This can be computed by first noting that there will be INT(ANGLE/(PI/4)) forty-five degree segments prior to the segment containing the required angle. Furthermore each forty-five segment will contain RADIUS\*SIN(PI/4) points as this is the value of the terminating Y coordinate. Therefore the number of points required to reach the start of the segment containing the angle is the product of these two numbers. The total count is produced by adding this figure to the number of points required to cover any remaining angle within the final segment, that is RADIUS\*SIN(REMAINING ANGLE) points.

Unfortunately the routine computes the number of points within a segment by linear approximation from the total segment size on the mistaken assumption that successive points subtend equal angles. Thus in the above example the point count computed for the angle is 30/45\*(80\*0.707107)=37 instead of the correct value of forty. The error produced by the routine is therefore at a maximum at the centre of each forty-five degree segment and reduces to zero at the end points.

<a name="5d6eh"></a><a name="draw"></a>

    Address... 5D6EH

This is the "`DRAW`" statement handler. Register pair DE is set to point to the command table at 5D83H and control transfers to the macro language parser ([566CH](#566ch)).

<a name="5d83h"></a>

    Address... 5D83H

This table contains the valid command letters and associated addresses for the "`DRAW`" statement commands. Those commands which takes a parameter, and consequently have bit 7 set in the table, are shown with an asterisk:

|CMD    |TO
|-------|-------
|U\*    |5DB1H
|D\*    |5DB4H
|L\*    |5DB9H
|R\*    |5DBCH
|M      |5DD8H
|E\*    |5DCAH
|F\*    |5DC6H
|G\*    |5DD1H
|H\*    |5DC3H
|A\*    |5E4EH
|B      |5E46H
|N      |5E42H
|X      |5782H
|C\*    |5E87H
|S\*    |5E59H

</a>

<a name="5db1h"></a>

    Address... 5DB1H

This is the "`DRAW`" statement "`U`" command handler. The operation of the "`D`", "`L`", "`R`", "`E`", "`F`", "`G`" and "`H`" commands is very similar so no separate description of their handlers is given. The optional numeric parameter is supplied by the macro language parser in register pair DE. This initial parameter is modified by a given handler into a horizontal offset in register pair BC and a vertical offset in register pair DE. For example if leftward or upward movement is required the parameter is negated ([5B0BH](#5b0bh)), if diagonal movement is required the parameter is duplicated so that equal horizontal and vertical offsets are produced. Once the offsets have been prepared control transfers to the line drawing routine (5DFFH).

<a name="5dd8h"></a>

    Address... 5DD8H

This is the "`DRAW`" statement "`M`" command handler. The character following the command letter is examined then the two parameters collected from the command string ([5719H](#5719h)). If the initial character is "+" or "-" the parameters are regarded as offsets and are scaled ([5E66H](#5e66h)), rotated through successive ninety degree steps as determined by [DRWANG](#drwang) and then added to the current graphics coordinates (5CDCH) to determine the termination point. If [DRWFLG](#drwflg) shows the "`B`" mode to be inactive a line is then drawn (5CCDH) from the current graphics coordinates to the termination point. If [DRWFLG](#drwflg) shows the "`N`" mode to be inactive the termination coordinates are placed in [GRPACX](#grpacx) and [GRPACY](#grpacy) to become the new current graphics coordinates. Finally [DRWFLG](#drwflg) is zeroed, turning the "`B`" and "`N`" modes off, and the handler terminates.

<a name="5e42h"></a>

    Address... 5E42H

This is the "`DRAW`" statement "`N`" command handler, [DRWFLG](#drwflg) is simply set to 40H.

<a name="5e46h"></a>

    Address... 5E46H

This is the "`DRAW`" statement "`B`" command handler, [DRWFLG](#drwflg) is simply set to 80H.

<a name="5e4eh"></a>

    Address... 5E4EH

This is the "`DRAW`" statement "`A`" command handler. The parameter is checked for magnitude and placed in [DRWANG](#drwang).

<a name="5e59h"></a>

    Address... 5E59H

This is the "`DRAW`" statement "`S`" command handler. The parameter is checked for magnitude and placed in [DRWSCL](#drwscl).

<a name="5e66h"></a>

    Address... 5E66H

This routine is used by the "`DRAW`" statement "`U`", "`D`", "`L`", "`R`", "`E`", "`F`", "`G`", "`H`" and "`M`" (in offset mode) command handlers to scale the offset supplied in register pair DE by the contents of [DRWSCL](#drwscl). Unless [DRWSCL](#drwscl) is zero, in which case the routine simply terminates, the offset is multiplied using repeated addition and then divided by four ([59B4H](#59b4h)). To eliminate scaling an "`S0`" or "`S4`" command should be used.

<a name="5e87h"></a>

    Address... 5E87H

This is the "`DRAW`" statement "`C`" command handler. The parameter is placed in [ATRBYT](#atrbyt) via the [SETATR](#setatr) standard routine. There is no check on the MSB of the parameter so illegal values such as "`C265`" will be accepted without an error message.

<a name="5e91h"></a>

    Address... 5E91H

This routine is used by the "`PAINT`" statement handler to check, via the [SCALXY](#scalxy) standard routine, that the coordinates in register pairs BC and DE are within the screen. If not an "`Illegal function call`" error is generated (475AH).

<a name="5e9fh"></a><a name="dim"></a>

    Address... 5E9FH

This is the "`DIM`" statement handler. A return is set up to 5E9AH, so that multiple Arrays can be processed, [DIMFLG](#dimflg) is made non-zero and control drops into the Variable search routine.

<a name="5ea4h"></a>

    Address... 5EA4H

This is the Variable search routine. On entry register pair HL points to the first character of the Variable name in the program text. On exit register pair HL points to the character following the name and register pair DE to the first byte of the Variable contents in the Variable Storage Area. The first character of the name is taken from the program text, checked to ensure that it is upper case alphabetic ([64A7H](#64a7h)) and placed in register C. The optional second character, with a default value of zero, is placed in register B, this character may be alphabetic or numeric. Any further alphanumeric characters are then simply skipped over. If a type suffix character ("%", "$", "!" or "#") follows the name this is converted to the corresponding type code (2, 3, 4 or 8) and placed in [VALTYP](#valtyp). Otherwise the Variable's default type is taken from [DEFTBL](#deftbl) using the first letter of the name to locate the appropriate entry.

[SUBFLG](#subflg) is then checked to determine how any parenthesized subscript following the name should be treated. This flag is normally zero but is modified by the "`ERASE`" (01H), "`FOR`" (64H), "`FN`" (80H) or "`DEF FN`" (80H) statement handlers to force a particular course of action. In the "`ERASE`" case control transfers straight to the Array search routine (5FE8H), no parenthesized subscript need be present. In the "`FOR`", "`FN`" and "`DEF FN`" cases control transfers straight to the simple Variable search routine ([5F08H](#5f08h)), no check is made for a parenthesized subscript. Assuming that the situation is normal the program text is checked for the characters "(" or "\[". If either is present control transfers to the Array search routine ([5FBAH](#5fbah)), otherwise control drops into the simple Variable search routine.

<a name="5f08h"></a>

    Address... 5F08H

This is the simple Variable search routine. There are four types of simple Variable each composed of a header followed by the Variable contents. The first byte of the header contains the type code and the next two bytes the Variable name. The contents of the Variable will be one of the three standard numeric forms or, for the string type, the length and address of the string. Each of the four types is shown below:

<a name="figure46"></a>![][CH05F46]

**Figure 46:** Simple Variables

[NOFUNS](#nofuns) is first checked to determine whether a user defined function is currently being evaluated. If so the search is carried out on the contents of [PARM1](#parm1) first of all, only if this fails will it move onto the main Variable Storage Area. A linear search method is used, the two name characters and type byte of each Variable in the storage area are compared to the reference characters and type until a match is found or the end of the storage area is reached. If the search is successful the routine terminates with the address of the first byte of the Variable contents in register pair DE. If the search is unsuccessful the Array Storage Area is moved upwards and the new Variable is added to the end of the existing ones and initialized to zero.

There are two exceptions to this automatic creation of a new Variable. If the search is being carried out by the "`VARPTR`" function, and this is determined by examining the return address, no Variable will be created. Instead the routine terminates with register pair DE set to zero (5F61H) causing a subsequent "`Illegal function call`" error. The second exception occurs when the search is being carried out by the Factor Evaluator, that is when the Variable is newly declared inside an expression. In this case [DAC](#dac) is zeroed for numeric types, and loaded with the address of a dummy zero length descriptor for a string type, thus returning a zero result (5FA7H). These actions are designed to prevent the Expression Evaluator creating a new Variable ("`VARPTR`") is the only function to take a Variable argument directly rather than via an expression and so requires separate protection). If this were not so then assignment to an Array, via the "`LET`" statement handler, would fail as any simple Variable created during expression evaluation would change the Array's address.

<a name="5fbah"></a>

    Address... 5FBAH

This is the Array search routine. There are four types of Array each composed of a header plus a number of elements. The first byte of the header contains the type code, the next two bytes the Array name and the next two the offset to the start of the following Array. This is followed by a single byte containing the dimensionality of the Array and the element count list. Each two byte element count contains the maximum number of elements per dimension. These are stored in reverse order with the first one corresponding to the last subscript. The contents of each Array element are identical to the contents of the corresponding simple Variable. The integer Array AB%(3,4) is shown below with each element identified by its subscripts, high memory is towards the top of the page:

<a name="figure47"></a>![][CH05F47]

**Figure 47:** Integer Array

Each subscript is evaluated, converted to an integer ([4755H](#4755h)) and pushed onto the Z80 stack until a closing parenthesis is found, it need not match the opening one. A linear search is then carried out on the Array Storage Area for a match with the two name characters and the type. If the search is successful [DIMFLG](#dimflg) is checked and a "`Redimensioned array`" error generated ([405EH](#405eh)) if it shows a "`DIM`" statement to be active. Unless an "`ERASE`" statement is active, in which case the routine terminates with register pair BC pointing to the start of the Array (3297H), the dimensionality of the Array is then checked against the subscript count and a "`Subscript out of range`" error generated if they fail to match. Assuming these tests are passed control transfers to the element address computation point (607DH).

If the search is unsuccessful and an "`ERASE`" statement is active an "`Illegal function call`" error is generated (475AH), otherwise the new Array is added to the end of the existing Array Storage Area. Initialization of the new Array proceeds by storing the two name characters, the type code and the dimensionality (the subscript count) followed by the element count for each dimension. If [DIMFLG](#dimflg) shows a "`DIM`" statement to be active the element counts are determined by the subscripts. If the Array is being created by default, with a statement such as "`A(1,2,3)=5`" for example, a default value of eleven is used. As each element count is stored the total size of the Array is accumulated in register pair DE by successive multiplications ([314AH](#314ah)) of the element counts and the element size (the Array type). After a check that this amount of memory is available (6267H) [STREND](#strend) is increased the new area is zeroed and the Array size is stored, in slightly modified form, immediately after the two name characters. Unless the Array is being created by default, in which case the element address must be computed, the routine then terminates.

This is the element address computation point of the Array search routine. The location of a particular element within an Array involves the multiplication ([314AH](#314ah)) of subscripts, element counts and element sizes. As there are a variety of ways this could be done the actual method used is best illustrated with an example. The location of element (1,2,3) in a 4\*5\*6 Array would initially be computed as (((3\*5)+2)\*4)+1. This is then multiplied by the element size (type) and added to the Array base address to obtain the address of the required element. The computation method is an optimized form which minimizes the number of steps needed, it is equivalent to evaluating (3\*(4\*5))+(2\*4)+(1). The element address is returned in register pair DE.

<a name="60b1h"></a>

    Address... 60B1H

This is the "`PRINT USING`" statement handler. Control transfers here from the general "`PRINT`" statement handler after the applicable output device has been set up. Upon termination control passes back to the general "`PRINT`" statement exit point ([4AFFH](#4affh)) to restore the normal video output. The format string is evaluated (4C65H) and the address and length of the string body obtained from the descriptor. The program text pointer is then temporarily saved. Each character of the format string is examined until one of the possible template characters is found. If the character does not belong in a template it is simply output via the [OUTDO](#outdo) standard routine. Once the start of a template is found this is scanned along until a non-template character is found. Control then passes to the numeric output routine (6192H) or the string output routine (6211H).

In either case the program text pointer is restored to register pair HL and the next operand evaluated ([4C64H](#4c64h)). For numeric output the information gained from the template scan is passed to the numeric conversion routine (3426H) in registers A, B and C and the resulting string displayed ([6678H](#6678h)). For string output the required character count is passed to the "`LEFT$`" statement handler (6868H) in register C and the resulting string displayed (667BH). For either type of output the program text and format string are then examined to determine whether there are any further characters. If no operands exist the handler terminates. If the format string has been exhausted then it is restarted from the beginning (60BFH), otherwise scanning continues from the current position for the next operand (60f6H).

<a name="6250h"></a>

    Address... 6250H

This routine is used by the Interpreter Mainloop and the Variable search routine to move a block of memory upwards. A check is first made to ensure that sufficient memory exists (6267H) and then the block of memory is moved. The top source address is supplied in register pair BC and the top destination address in register pair HL. Copying stops when the contents of register pair BC equal those of register pair DE.

<a name="625eh"></a>

    Address... 625EH

This routine is used to check that sufficient memory is available between the top of the Array Storage Area and the base of the Z80 stack. On entry register C contains the number of words the caller requires. If this would narrow the gap to less than two hundred bytes an "`Out of memory`" error is generated.

<a name="6286h"></a>

    Address... 6286H

This is the "`NEW`" statement handler. [TRCFLG](#trcflg), [AUTFLG](#autflg) and [PTRFLG](#ptrflg) are zeroed and the zero end link is placed at the start of the Program Text Area. [VARTAB](#vartab) is set to point to the byte following the end link and control drops into the run-clear routine.

<a name="629ah"></a>

    Address... 629AH

This routine is used by the "`NEW`", "`RUN`" and "`CLEAR`" statement handlers to initialize the Interpreter variables. All interrupts are cleared (636EH) and the default Variable types in [DEFTBL](#deftbl) set to double precision. [RNDX](#rndx) is reset ([2C24H](#2c24h)) and [ONEFLG](#oneflg), [ONELIN](#onelin) and [OLDTXT](#oldtxt) are zeroed. [MEMSIZ](#memsiz) is copied to [FRETOP](#fretop) to clear the String Storage Area and [DATPTR](#datptr) set to the start of the Program Text Area ([63C9H](#63c9h)). The contents of [VARTAB](#vartab) are copied into [ARYTAB](#arytab) and [STREND](#strend), to clear any Variables, all the I/O buffers are closed ([6C1CH](#6c1ch)) and [NLONLY](#nlonly) is reset. [SAVSTK](#savstk) and the Z80 SP are reset from [STKTOP](#stktop) and [TEMPPT](#temppt) is reset to the start of [TEMPST](#tempst) to clear any string descriptors. The printer is shut down ([7304H](#7304h)) and output restored to the screen ([4AFFH](#4affh)). Finally [PRMLEN](#prmlen), [NOFUNS](#nofuns), [PRMLN2](#prmln2), [FUNACT](#funact), [PRMSTK](#prmstk) and [SUBFLG](#subflg) are zeroed and the routine terminates.

<a name="631bh"></a>

    Address... 631BH

This routine is used by the "`DEVICE ON`" statement handlers to enable an interrupt source, the address of the relevant device's [TRPTBL](#trptbl). status byte is supplied in register pair HL. Interrupts are enabled by setting bit 0 of the status byte. Bits 1 and 2 are then examined and, if the device has been stopped and an interrupt has occurred, [ONGSBF](#ongsbf) is incremented (634FH) so that the Runloop will process it at the end of the statement. Finally bit 1 of the status byte is reset to release any existing stop condition.

<a name="632eh"></a>

    Address... 632EH

This routine is used by the "`DEVICE OFF`" statement handlers to disable an interrupt source, the address of the relevant device's [TRPTBL](#trptbl) status byte is supplied in register pair HL. Bits 0 and 2 are examined to determine whether an interrupt has occurred since the end of the last statement, if so [ONGSBF](#ongsbf) is decremented (6362H) to prevent the Runloop from picking it up. The status byte is then zeroed.

<a name="6331h"></a>

    Address... 6331H

This routine is used by the "`DEVICE STOP`" statement handlers to suspend processing of interrupts from an interrupt source, the address of the relevant device's [TRPTBL](#trptbl) status byte is supplied in register pair HL. Bits 0 and 2 are examined to determine whether an interrupt has occurred since the end of the last statement, if so [ONGSBF](#ongsbf) is decremented (6362H) to prevent the Runloop from picking it up. Bit 1 of the status byte is then set.

<a name="633eh"></a>

    Address... 633EH

This routine is used by the "`RETURN`" statement handler to release the temporary stop condition imposed during interrupt driven BASIC subroutines, the address of the relevant device's [TRPTBL](#trptbl) status byte is supplied in register pair HL. Bits 0, and 2 are examined to determine whether a stopped interrupt has occurred since the subroutine was first activated. If so [ONGSBF](#ongsbf) is incremented (634FH) so that the Runloop will pick it up at the end of the statement. Bit 1 of the status byte is then reset. It should be noted that any "`DEVICE STOP`" Statement within an interrupt driven subroutine will therefore be ineffective.

<a name="6358h"></a>

    Address... 6358H

This routine is used by the Runloop interrupt processor ([6389H](#6389h)) to clear an interrupt prior to activating the BASIC subroutine, the address of the relevant device's [TRPTBL](#trptbl) status byte is supplied in register pair HL. [ONGSBF](#ongsbf) is decremented and bit 2 of the status byte is reset.

<a name="636eh"></a>

    Address... 636EH

This routine is used by the run-clear routine ([629AH](#629ah)) to clear all interrupts. The seventy-eight bytes of [TRPTBL](#trptbl) and the ten bytes of [FNKFLG](#fnkflg) are zeroed.

<a name="6389h"></a>

    Address... 6389H

This is the Runloop interrupt processor. [ONEFLG](#oneflg) is first examined to determine whether an error condition currently exists. If so the routine terminates, no interrupts will be processed until the error clears. [CURLIN](#curlin) is then examined and, if the Interpreter is in direct mode, the routine terminates. Assuming all is well a search is made of the twenty-six status bytes in [TRPTBL](#trptbl) to find the first active interrupt. Note that devices near the start of the table will consequently have a higher priority than those lower down. When the first active status byte is found, that is one with bits 0 and 2 set, the associated address is taken from [TRPTBL](#trptbl) and placed in register pair DE. The interrupt is then cleared ([6358H](#6358h)) and the device stopped ([6331H](#6331h)) before control transfers to the "`GOSUB`" handler ([47CFH](#47cfh)).

<a name="63c9h"></a>

    Address... 63C9H

This is the "`RESTORE`" statement handler. If no line number operand exists [DATPTR](#datptr) is set to the start of the Program Storage Area. Otherwise the operand is collected (4769H), the program text searched to find the relevant line ([4295H](#4295h)) and its address placed in [DATPTR](#datptr).

<a name="63e3h"></a>

    Address... 63E3H

This is the "`STOP`" statement handler. If further text exists in the statement control transfers to the "`STOP ON/OFF/STOP`" statement handler ([77A5H](#77a5h)). Otherwise register A is set to 01H and control drops into the "`END`" statement handler.

<a name="63eah"></a>

    Address... 63EAH

This is the "`END`" statement handler. It is also used, with differing entry points, by the "`STOP`" statement and for CTRL- STOP and end of text program termination. [ONEFLG](#oneflg) is first zeroed and then, for the "`END`" statement only, all I/O buffers are closed ([6C1CH](#6c1ch)). The current program text position is placed in [SAVTXT](#savtxt) and [OLDTXT](#oldtxt) and the current line number in [OLDLIN](#oldlin) for use by any subsequent "`CONT`" statement. The printer is shut down ([7304H](#7304h)), a CR LF issued to the screen ([7323H](#7323h)) and register pair HL set to point to the "`Break`" message at 3FDCH. For the "`END`" statement and end of text cases control then transfers to the Mainloop "`OK`" point (411EH). For the CTRL-STOP case control transfers to the end of the error handler (40FDH) to display the "`Break`" message.

<a name="6424h"></a>

    Address... 6424H

This is the "`CONT`" statement handler. Unless they are zero, in which case a "`Can't CONTINUE`" error is generated, the contents of [OLDTXT](#oldtxt) are placed in register pair HL and those of [OLDLIN](#oldlin) in [CURLIN](#curlin). Control then returns to the Runloop to execute at the old program text position. A program cannot be continued after CTRL-STOP has been used to break from WITHIN a statement, via the [CKCNTC](#ckcntc) standard routine, rather than from between statements.

<a name="6438h"></a>

    Address... 6438H

This is the "`TRON`" statement handler, [TRCFLG](#trcflg) is simply made non-zero.

<a name="6439h"></a>

    Address... 6439H

This is the "`TROFF`" statement handler, [TRCFLG](#trcflg) is simply made zero.

<a name="643eh"></a>

    Address... 643EH

This is the "`SWAP`" statement handler. The first Variable is located ([5EA4H](#5ea4h)) and its contents copied to [SWPTMP](#swptmp). The location of this Variable and of the end of the Variable Storage Area are temporarily saved. The second Variable is then located ([5EA4H](#5ea4h)) and its type compared with that of the first. If the types fail to match a "`Type mismatch`" error is generated ([406DH](#406dh)). The current end of the Variable Storage Area is then compared with the old end and an "`Illegal function call`" error generated (475AH) if they differ. Finally the contents of the second Variable are copied to the location of the first Variable (2EF3H) and the contents of [SWPTMP](#swptmp) to the location of the second Variable (2EF3H).

The checks performed by the handler mean that the second Variable, if it is simple and not an Array, must always be in existence before a "`SWAP`" Statement is encountered or an error will be generated. The reason for this is that, supposing the first Variable was an Array, then the creation of a second (simple) Variable would move the Array Storage Area upwards invalidating its saved location. Note that the perfectly legal case of a simple first Variable and a newly created simple second Variable is also rejected.

<a name="6477h"></a>

    Address... 6477H

This is the "`ERASE`" statement handler. [SUBFLG](#subflg) is first set to 01H, to control the Variable search routine, and the Array located ([5EA4H](#5ea4h)). All the following Arrays are moved downward and [STREND](#strend) set to its new, lower value. The program text is then checked and, if a comma follows, control transfers back to the start of the handler.

<a name="64a7h"></a>

    Address... 64A7H

This routine checks whether the character whose address is supplied in register pair HL is upper case alphabetic, if so it returns Flag NC.

<a name="64afh"></a>

    Address... 64AFH

This is the "`CLEAR`" statement handler. If no operands are present control transfers to the run-clear routine (62A1H) to remove all current Variables. Otherwise the string space operand is evaluated (4756H) followed by the optional top of memory operand ([542FH](#542fh)). The top of memory value is checked and an "`Illegal function call`" error generated (475AH) if it is less than 8000H or greater than F380H. The space required by the I/O buffers (267 bytes each) and the String Storage Area is subtracted from the top of memory value and an "`Out of memory`" error generated (6275H) if there is less than 160 bytes remaining to the base of the Variable Storage Area. Assuming all is well [HIMEM](#himem), [MEMSIZ](#memsiz) and [STKTOP](#stktop) are set to their new values and the remaining storage pointers reset via the run- clear routine (62A1H). The I/O buffer storage is re-allocated ([7E6BH](#7e6bh)) and the handler terminates.

Unfortunately the computation of [MEMSIZ](#memsiz) and [STKTOP](#stktop), when a new top of memory is specified, is incorrect resulting in the top of the String Storage Area being set one byte too high. This can be seen with the following where an illegal string is accepted:

```
10 CLEAR 200,&HF380
20 A$=STRING$(201,"A")
30 PRINT FRE("")
```

Because there should be an extra DEC HL instruction at 64EBH the new values of [MEMSIZ](#memsiz) and [STKTOP](#stktop) are initially set one byte too high. When the run-clear routine is called [MEMSIZ](#memsiz) is copied into [FRETOP](#fretop), the top of the String Storage Area, which results in this being one byte too high as well. Although [MEMSIZ](#memsiz) and [STKTOP](#stktop) are correctly recomputed when the file pointers are reset, [FRETOP](#fretop) is left with its incorrect value. When the "`FRE`" statement is executed in line thirty, and string garbage collection initiated, [FRETOP](#fretop) is restored to its correct value but, because the string overflows the String Storage Area by one byte, the amount of free space displayed is -1 byte. To correctly set all the system pointers any alteration of the top of memory should be followed immediately by another "`CLEAR`" statement with no operands.

<a name="6520h"></a>

    Address... 6520H

This routine computes the difference between the contents of register pairs HL and DE. It is a duplicate of the short section of code from 64ECH to 64F1H and is completely unused.

<a name="6527h"></a>

    Address... 6527H

This is the "`NEXT`" statement handler. Assuming further text is present in the statement the loop Variable is located ([5EA4H](#5ea4h)), otherwise a default address of zero is taken. The stack is then searched for the corresponding "`FOR`" parameter block ([3FE2H](#3fe2h)). If no parameter block is found, or if a "`GOSUB`" parameter block is found first, a "`NEXT without FOR`" error is generated ([405BH](#405bh)). Assuming the parameter block is found the intervening section of stack, together with any "`FOR`" blocks it may contain, is discarded. The loop Variable type is then taken from the parameter block and examined to determine the precision required during subsequent operations.

The STEP value is taken from the parameter block and added (3172H, 324EH or 2697H) to the current contents of the loop Variable which is then updated. The new value is compared (2F4DH, 2F21H or 2F5CH) with the termination value from the parameter block to determine whether the loop has terminated (65B6H). The loop will terminate for a positive STEP if the new loop value is GREATER than the termination value. The loop will terminate for a negative step if the new loop value is LESS than the termination value. If the loop has not terminated the original program text position and line number are taken from the parameter block and control transfers to the Runloop (45FDH). If the loop has terminated the parameter block is discarded from the stack and, unless further program text is present in which control transfers back to the start of the handler, control transfers to the Runloop to execute the next statement ([4601H](#4601h)).

<a name="65c8h"></a>

    Address... 65C8H

This routine is used by the Expression Evaluator to find the relation (<>=) between two string operands. The address of the first string descriptor is supplied on the Z80 stack and the address of the second in [DAC](#dac). The result is returned in register A and the flags as for the numeric relation routines:

```
String 1=String 2 ... A=00H, Flag Z,NC
String 1<String 2 ... A=01H, Flag NZ,NC
String 1>String 2 ... A=FFH, Flag NZ,C
```

Comparison commences at the first character of each string and continues until the two characters differ or one of the strings is exhausted. Control then returns to the Expression Evaluator ([4F57H](#4f57h)) to place the true or false numeric result in [DAC](#dac).

<a name="65f5h"></a>

    Address... 65F5H

This routine is used by the Factor Evaluator to apply the "`OCT$`" function to an operand contained in [DAC](#dac). The number is first converted to textual form in [FBUFFR](#fbuffr) ([371EH](#371eh)) and then the result string is created (6607H).

<a name="65fah"></a>

    Address... 65FAH

This routine is used by the Factor Evaluator to apply the "`HEX$`" function to an operand contained in [DAC](#dac). The number is first converted to textual form in [FBUFFR](#fbuffr) ([3722H](#3722h)) and then the result string is created (6607H).

<a name="65ffh"></a>

    Address... 65FFH

This routine is used by the Factor Evaluator to apply the "`BIN$`" function to an operand contained in [DAC](#dac). The number is first converted to textual form in [FBUFFR](#fbuffr) ([371AH](#371ah)) and then the result string is created (6607H).

<a name="6604h"></a>

    Address... 6604H

This routine is used by the Factor Evaluator to apply the "`STR$`" function to an operand contained in [DAC](#dac). The number is first converted to textual form in [FBUFFR](#fbuffr) ([3425H](#3425h)) then analyzed to determine its length and address (6635H). After checking that sufficient space is available ([668EH](#668eh)) the string is copied to the String Storage Area (67C7H) and the result descriptor created ([6654H](#6654h)).

<a name="6627h"></a>

    Address... 6627H

This routine first checks that there is sufficient space in the String Storage Area for the string whose length is supplied in register A (668EH). The string length and the address where the string will be placed in the String Storage Area are then copied to [DSCTMP](#dsctmp).

<a name="6636h"></a>

    Address... 6636H

This routine is used by the Factor Evaluator to analyze the character string whose address is supplied in register pair HL. The character string is scanned until a terminating character (00H or ") is found. The length and starting address are then placed in [DSCTMP](#dsctmp) (662AH) and control drops into the descriptor creation routine.

<a name="6654h"></a>

    Address... 6654H

This routine is used by the string functions to create a result descriptor. The descriptor is copied from [DSCTMP](#dsctmp) to the next available position in [TEMPST](#tempst) and its address placed in [DAC](#dac). Unless [TEMPST](#tempst) is full, in which case a "`String formula too complex`" error is generated, [TEMPPT](#temppt) is increased by three bytes and the routine terminates.

<a name="6678h"></a>

    Address... 6678H

This routine displays the message, or string, whose address is supplied in register pair HL. The string is analyzed (6635H) and its storage freed (67D3H). Successive characters are then taken from the string and displayed, via the [OUTDO](#outdo) standard routine, until the string is exhausted.

<a name="668eh"></a>

    Address... 668EH

This routine checks that there is room in the String Storage Area to add the string whose length is supplied in register A. On exit register pair DE points to the starting address in the String Storage Area where the string should be placed. The length of the string is first subtracted from the current free location contained in [FRETOP](#fretop). This is then compared with [STKTOP](#stktop), the lowest allowable location for string storage, to determine whether there is space for the string. If so [FRETOP](#fretop) is updated with the new position and the routine terminates. If there is insufficient space for the string then garbage collection is initiated ([66B6H](#66b6h)) to try and eliminate any dead strings. If, after garbage collection, there is still not enough space an "`Out of string space`" error is generated.

<a name="66b6h"></a>

    Address... 66B6H

This is the string garbage collector, its function is to eliminate any dead strings from the String Storage Area. The basic problem with string Variables, as opposed to numeric ones, is that their lengths vary. If string bodies were stored with their Variables in the Variable Storage Area even such apparently simple statements as A$=A$+"X" would require the movement of thousands of bytes of memory and slow execution speeds dramatically. The method used by the Interpreter to overcome this problem is to keep the string bodies separate from the Variables. Thus strings are kept in the String Storage Area and each Variable holds a three byte descriptor containing the length and address of the associated string. Whenever a string is assigned to a Variable it is simply added to the heap of existing strings in the String Storage Area and the Variable's descriptor changed. No attempt is made to eliminate any previous string belonging to the Variable, by restructuring the heap, as this would wipe out any throughput gains.

If sufficient Variable assignments are made it is inevitable that the String Storage Area will fill up. In a typical program many of these strings will be unused, that is the result of previous assignments. Garbage collection is the process whereby these dead strings are removed. Every string Variable in memory, including Arrays and the local Variables present during evaluation of user defined functions, is examined until the one is found whose string is stored highest in the heap. This string is then moved to the top of the String Storage Area and the Variable contents modified to point to the new location. The owner of the next highest string is then found and the process repeated until every string belonging to a Variable has been compacted.

If a large number of Variables are present garbage collection may take an appreciable time. The process can be seen at work with the following program which repeatedly assigns the string "`AAAA`" to each element of the Array A$. The program will run at full speed for the first two hundred and fifty assignments and then pause to eliminate the fifty dead strings. A further fifty assignments can then be made before a further garbage collection is required:

```
10 CLEAR 1000
20 DIM A$(200)
30 FOR N=0 TO 200
40 A$(N)=STRING$(4,"A")
50 PRINT".";
60 NEXT N
70 GOTO 30
```

The String Storage Area is also used to hold the intermediate strings produced during expression evaluation. Because so many string functions take multiple arguments, "`MID$`" takes three for example, the management of intermediate results is a major problem. To deal with it a standardized approach to string results is taken throughout the Interpreter. A producer of a string simply adds the string body to the heap in the String Storage Area, adds the descriptor to the descriptor heap in [TEMPST](#tempst) and places the address of the descriptor in [DAC](#dac). It is up to the user of the result to free this storage ([67D0H](#67d0h)) once it has processed the string. This rule applies to all parts of the system, from the individual function handlers back through the Expression Evaluator to the statement handlers, with only two exceptions.

The first exception occurs when the Factor Evaluator finds an explicitly stated string, such as "`SOMETHING`" in the program text. In this case it is not necessary to copy the string to the String Storage Area as the original will suffice.

The second exception occurs when the Factor Evaluator finds a reference to a Variable. In this case it is not necessary to place a copy of the descriptor in [TEMPST](#tempst) as one already exists inside the Variable.

<a name="6787h"></a>

    Address... 6787H

This routine is used by the Expression Evaluator to concatenate two string operands. Control transfers here when a "+" token is found following a string operand so the first action taken is to fetch the second string operand via the Factor Evaluator ([4DC7H](#4dc7h)). The lengths are then taken from both string descriptors and added together to check the length of the combined string. If this is greater than two hundred and fifty-five characters a "`String too long`" error is generated. After checking that space is available in the String Storage Area ([6627H](#6627h)) the storage of both operands is freed (67D6H). The first string is then copied to the String Storage Area (67BFH) and followed by the second one (67BFH). The result descriptor is created ([6654H](#6654h)) and control transfers back to the Expression Evaluator (4C73H)'

<a name="67d0h"></a>

    Address... 67D0H

This routine frees any storage occupied by the string whose descriptor address is contained in [DAC](#dac). The address of the descriptor is taken from [DAC](#dac) and examined to determine whether it is that of the last descriptor in [TEMPST](#tempst) (67EEH), if not the routine terminates. Otherwise [TEMPPT](#temppt) is reduced by three bytes clearing this descriptor from [TEMPST](#tempst). The address of the string body is then taken from the descriptor and compared with [FRETOP](#fretop) to see if this is the lowest string in the String Storage Area, if not the routine terminates. Otherwise the length of the string is added to [FRETOP](#fretop), which is then updated with this new value, freeing the storage occupied by the string body.

<a name="67ffh"></a>

    Address... 67FFH

This routine is used by the Factor Evaluator to apply the "`LEN`" function to an operand contained in [DAC](#dac). The operand's storage is freed ([67D0H](#67d0h)) and the string length taken from the descriptor and placed in [DAC](#dac) as an integer (4FCFH).

<a name="680bh"></a>

    Address... 680BH

This routine is used by the Factor Evaluator to apply the "`ASC`" function to an operand contained in [DAC](#dac). The operand's storage is freed and the string length examined (6803H), if it is zero an "`Illegal function call`" error is generated (475AH). Otherwise the first character is. taken from the string and placed in [DAC](#dac) as an integer (4FCFH).

<a name="681bh"></a>

    Address... 681BH

This routine is used by the Factor Evaluator to apply the "`CHR$`" function to an operand contained in [DAC](#dac). After checking that sufficient space is available (6625H) the operand is converted to a single byte integer (521FH). This character is then placed in the String Storage Area and the result descriptor created ([6654H](#6654h)).

<a name="6829h"></a>

    Address... 6829H

This routine is used by the Factor Evaluator to apply the "`STRING$`" function. After checking for the open parenthesis character the length operand is evaluated and placed in register E (521CH). The second operand is then evaluated ([4C64H](#4c64h)). If it is numeric it is converted to a single byte integer (521FH) and placed in register A. If it is a string the first character is taken from it and placed in register A (680FH). Control then drops into the "`SPACE$`" function to create the result string.

<a name="6848h"></a>

    Address... 6848H

This routine is used by the Factor Evaluator to apply the "`SPACE$`" function to an operand contained in [DAC](#dac). The operand is first converted to a single byte integer in register E (521FH). After checking that sufficient space is available ([6627H](#6627h)) the required number of spaces are copied to the String Storage Area and the result descriptor created ([6654H](#6654h)).

<a name="6861h"></a>

    Address... 6861H

This routine is used by the Factor Evaluator to apply the "`LEFT$`" function. The first operand's descriptor address and the integer second operand are supplied on the Z80 stack. The slice size is taken from the stack ([68E3H](#68e3h)) and compared to the source string length. If the source string length is less than the slice size it replaces it as the length to extract. After checking that sufficient space is available ([668EH](#668eh)) the required number of characters are copied from the start of the source string to the String Storage Area (67C7H). The source string's storage is then freed (67D7H) and the result descriptor created ([6654H](#6654h)).

<a name="6891h"></a>

    Address... 6891H

This routine is used by the Factor Evaluator to apply the "`RIGHT$`" function. The first operand's descriptor address and the integer second operand are supplied on the Z80 stack. The slice size is taken from the stack ([68E3H](#68e3h)) and subtracted from the source string length to determine the slice starting position. Control then transfers to the "`LEFT$`" routine to extract the slice (6865H).

<a name="689ah"></a>

    Address... 689AH

This routine is used by the Factor Evaluator to apply the "`MID$`" function. The first operand's descriptor address and the integer second operand are supplied on the Z80 stack. The starting position is taken from the stack (68E6H) and checked, if it is zero an "`Illegal function call`" error is generated (475AH). The optional slice size is then evaluated ([69E4H](#69e4h)) and control transfers to the "`LEFT$`" routine to extract the slice (6869H).

<a name="68bbh"></a>

    Address... 68BBH

This routine is used by the Factor Evaluator to apply the "`VAL`" function to an operand contained in [DAC](#dac). The string length is taken from the descriptor (6803H) and checked, if it is zero it is placed in [DAC](#dac) as an integer (4FCFH). The length is then added to the starting address of the string body to give the location of the character immediately following it. This is temporarily replaced with a zero byte and the string is converted to numeric form in [DAC](#dac) ([3299H](#3299h)). The original character is then restored and the routine terminates. The temporary zero byte delimiter is necessary because strings are packed together in the String Storage Area, without it the numeric converter would run on into succeeding strings.

<a name="68e3h"></a>

    Address... 68E3H

This routine is used by the "`LEFT$`", "`MID$`" and "`RIGHT$`" function handlers to check that the next program text character is ")" and then to pop an operand from the Z80 stack into register pair DE.

<a name="68ebh"></a>

    Address... 68EBH

This routine is used by the Factor Evaluator to apply the "`INSTR`" function. The first operand, which may be the starting position or the source string, is evaluated (4C62H) and its type tested. If it is the source string a default starting position of one is taken. If it is the starting position operand its value is checked and the source string operand evaluated ([4C64H](#4c64h)). The pattern string is then evaluated ([4C64H](#4c64h)) and the storage of both operands freed ([67D0H](#67d0h)). The length of the pattern string is checked and, if zero, the starting position is placed in [DAC](#dac) (4FCFH). The pattern string is then checked against successive characters from the source string, commencing at the starting position, until a match is found or the source string is exhausted. With a successful search the character position of the substring is placed in [DAC](#dac) as an integer (4FCFH), otherwise a zero result is returned.

<a name="696eh"></a>

    Address... 696EH

This is the "`MID$`" statement handler. After checking for the open parenthesis character the destination Variable is located ([5EA4H](#5ea4h)) and checked to ensure that it is a string type ([3058H](#3058h)). The address of the string body is then taken from the Variable and examined to determine whether it is inside the Program Text Area, as would be the case for an explicitly stated string. If this is the case the string body is copied to the String Storage Area (6611H) and a new descriptor copied to the Variable (2EF3H). This is done to avoid modifying the program text. The starting position is then evaluated (521CH) and checked, if it is zero an "`Illegal function call`" error is generated (475AH). The optional slice length operand is evaluated ([69E4H](#69e4h)) followed by the replacement string (4C5FH) whose storage is then freed ([67D0H](#67d0h)). Characters are then copied from the replacement string to the destination string until either the slice length is completed or the replacement string is exhausted.

<a name="69e4h"></a>

    Address... 69E4H

This routine is used by various string functions to evaluate an optional operand (521CH) and return the result in register E. If no operand is present a default value of 255 is returned.

<a name="69f2h"></a>

    Address... 69F2H

This routine is used by the Factor Evaluator to apply the "`FRE`" function to an operand contained in [DAC](#dac). If the operand is numeric the single precision difference between the Z80 Stack Pointer and the contents of [STREND](#strend) is placed in [DAC](#dac) (4FC1H). If the operand is a string type its storage is freed (67D3H) and garbage collection initiated ([66B6H](#66b6h)). The single precision difference between the contents of [FRETOP](#fretop) and those of [STKTOP](#stktop) is then placed in [DAC](#dac) (4FC1H).

<a name="6a0eh"></a>

    Address... 6A0EH

This routine is used by the file I/O handlers to analyze a filespec such as "`A:FILENAME.BAS`". The filespec consists of three parts, the device, the filename and the type extension. On entry register pair HL points to the start of the filespec in the program text. On exit register D holds the device code, the filename is in positions zero to seven of [FILNAM](#filnam) and the type extension in positions eight to ten. Any unused positions are filled with spaces.

The filespec string is evaluated ([4C64H](#4c64h)) and its storage freed ([67D0H](#67d0h)), if the string is of zero length a "`Bad file name`" error is generated ([6E6BH](#6e6bh)). The device name is parsed ([6F15H](#6f15h)) and successive characters taken from the filespec and placed in [FILNAM](#filnam) until the string is exhausted, a "." character is found or [FILNAM](#filnam) is full. A "`Bad file name`" error is generated ([6E6BH](#6e6bh)) if the filespec contains any control characters, that is those whose value is smaller than 20H. If the filespec contains a type extension a "`Bad file name`" error is generated ([6E6BH](#6e6bh)) if it is longer than three characters or if the filename is longer than eight characters. If no type extension is present the filename may be any length, extra characters are simply ignored.

<a name="6a6dh"></a>

    Address... 6A6DH

This routine is used by the file I/O handlers to locate the I/O buffer FCB whose number is supplied in register A. The buffer number is first checked against [MAXFIL](#maxfil) and a "`Bad file number`" error generated ([6E7DH](#6e7dh)) if it is too large. Otherwise the required address is taken from the file pointer block and placed in register pair HL and the buffer's mode taken from byte 0 of the FCB and placed in register A.

<a name="6a9eh"></a>

    Address... 6A9EH

This routine is used by the file I/O handlers to evaluate an I/O buffer number and to locate its FCB. Any "#" character is skipped ([4666H](#4666h)) and the buffer number evaluated (521CH). The FCB is located ([6A6DH](#6a6dh)) and a "`File not open`" error generated ([6E77H](#6e77h)) if the buffer mode byte is zero. Otherwise the FCB address is placed in [PTRFIL](#ptrfil) to redirect the Interpreter's output.

<a name="6ab7h"></a>

    Address... 6AB7H

This is the "`OPEN`" statement handler. The filespec is analyzed ([6A0EH](#6a0eh)) and any following mode converted to the corresponding mode byte, these are: "`FOR INPUT`" (01H), "`FOR OUTPUT`" (02H) and "`FOR APPEND`" (08H). If no mode is explicitly stated random mode (04H) is assumed. The "`AS`" characters are checked and the buffer number evaluated (521CH), if this is zero a "`Bad file number`" error is generated ([6E7DH](#6e7dh)). The FCB is then located ([6A6DH](#6a6dh)) and a "`File already open`" error generated ([6E6EH](#6e6eh)) if the buffer's mode byte is anything other than zero. The device code is placed in byte 4 of the FCB, the open function dispatched ([6F8FH](#6f8fh)) and the Interpreter's output reset to the screen ([4AFFH](#4affh)).

<a name="6b24h"></a>

    Address... 6B24H

This routine is used by the file I/O handlers to close the I/O buffer whose number is supplied in register A. The FCB is located ([6A6DH](#6a6dh)) and, provided the buffer is in use, the close function dispatched ([6F8FH](#6f8fh)) and the buffer filled with zeroes ([6CEAH](#6ceah)). [PTRFIL](#ptrfil) and the FCB mode byte are then zeroed to reset the Interpreter's output to the screen.

<a name="6b5bh"></a>

    Address... 6B5BH

This is the "`LOAD`", "`MERGE`" and "`RUN filespec`" statement handler. The filespec is analyzed ([6A0EH](#6a0eh)) and then, for "`LOAD`" and "`RUN`" only, the program text examined to determine whether the auto-run "`R`" option is specified. I/O buffer 0 is opened for input (6AFAH) and the first byte of [FILNAM](#filnam) set to FFH if auto-run is required. For "`LOAD`" and "`RUN`" only any program text is then cleared via the "`NEW`" statement handler (6287H). As this will reset the Interpreter's output to the screen the buffer FCB is again located and placed in [PTRFIL](#ptrfil) (6AAAH). Control then transfers directly to the Interpreter Mainloop ([4134H](#4134h)) for the program text to be loaded as if typed from the keyboard. Note that no error checking of any sort is carried out on the data read.

<a name="6ba3h"></a>

    Address... 6BA3H

This is the "`SAVE`" statement handler. The filespec is analyzed ([6A0EH](#6a0eh)) and the program text examined to determine whether the ASCII "`A`" suffix is present. This is only relevant under Disk BASIC, it makes no difference on a standard MSX machine. I/O buffer 0 is opened for output (6AFAH) and control transfers to the "`LIST`" statement handler ([522EH](#522eh)) to output the program text. Note that no error checking information of any sort accompanies the text.

<a name="6bdah"></a>

    Address... 6BDAH

This routine is used by the file I/O handlers to return the device code for the currently active I/O buffer. The FCB address is taken from [PTRFIL](#ptrfil) then the device code taken from byte 4 of the FCB and placed in register A.

<a name="6be7h"></a>

    Address... 6BE7H

This routine is used by the file I/O handlers to perform an operation on a number of I/O buffers. The address of the relevant routine is supplied in register pair BC and the buffer count in register A. For example if register pair BC contained 6B24H and register A contained 03H buffers 3, 2, 1 and 0 would be closed. The routine has a slightly different function if it is entered with FLAG NZ. In this case the I/O buffer numbers are taken sequentially from the program text and evaluated (521CH) before the operation is performed, a typical case might be "#1,#2".

<a name="6c14h"></a>

    Address... 6C14H

This is the "`CLOSE`" statement handler. Register pair BC is set to 6B24H, register A is loaded with the contents of [MAXFIL](#maxfil) and the required number of buffers closed ([6BE7H](#6be7h)).

<a name="6c1ch"></a>

    Address... 6C1CH

This routine is used by the file I/O handlers to close every I/O buffer. Register pair BC is set to 6B24H, register A is loaded with the contents of [MAXFIL](#maxfil) and all buffers closed ([6BE7H](#6be7h)).

<a name="6c2ah"></a>

    Address... 6C2AH

This is the "`LFILES`" statement handler. [PRTFLG](#prtflg) is made non- zero, to direct output to the printer, and control drops into the "`FILES`" statement handler.

<a name="6c2fh"></a>

    Address... 6C2FH

This is the "`FILES`" statement handler, an "`Illegal function call`" error is generated (475AH) on a standard MSX machine.

<a name="6c35h"></a>

    Address... 6C35H

Control transfers here from the general "`PUT`" and "`GET`" handlers ([7758H](#7758h)) when the program text contains anything other than a "`SPRITE`" token. A "`Sequential I/O only`" error is generated ([6E86H](#6e86h)) on a standard MSX machine.

<a name="6c48h"></a>

    Address... 6C48H

This routine is used by the file I/O handlers to sequentially output the character supplied in register A. The character is placed in register C and the sequential output function dispatched ([6F8FH](#6f8fh)).

<a name="6c71h"></a>

    Address... 6C71H

This routine is used by the file I/O handlers to sequentially input a single character. The sequential input function is dispatched ([6F8FH](#6f8fh)) and the character returned in register A, FLAG C indicates an EOF (End Of File) condition.

<a name="6c87h"></a>

    Address... 6C87H

This routine is used by the Factor Evaluator to apply the "`INPUT$`" function. The program text is checked for the "$" and "(" characters and the length operand evaluated (521CH). If an I/O buffer number is present it is evaluated, the FCB located ([6A9EH](#6a9eh)) and the mode byte examined. An "`Input past end`" error is generated ([6E83H](#6e83h)) if the buffer is not in input or random mode. After checking that sufficient space is available ([6627H](#6627h)) the required number of characters are sequentially input ([6C71H](#6c71h)), or collected via the [CHGET](#chget) standard routine, and copied to the String Storage Area. Finally the result descriptor is created ([6654H](#6654h)).

<a name="6ceah"></a>

    Address... 6CEAH

This routine is used by the file I/O handlers to fill the buffer whose FCB address is contained in [PTRFIL](#ptrfil) with two hundred and fifty-six zeroes.

<a name="6cfbh"></a>

    Address... 6CFBH

This routine is used by the file I/O handlers to return, in register pair HL, the starting address of the buffer whose FCB address is contained in [PTRFIL](#ptrfil). This just involves adding nine to the FCB address.

<a name="6d03h"></a>

    Address... 6D03H

This routine is used by the Factor Evaluator to apply the "`LOC`" function to the I/O buffer whose number is contained in [DAC](#dac). The FCB is located (6A6AH) and the LOC function dispatched ([6F8FH](#6f8fh)). An "`Illegal function call`" error is generated (475AH) on a standard MSX machine.

<a name="6d14h"></a>

    Address... 6D14H

This routine is used by the Factor Evaluator to apply the "`LOF`" function to the I/O buffer whose number is contained in [DAC](#dac). The FCB is located (6A6AH) and the LOF function dispatched ([6F8FH](#6f8fh)). An "`Illegal function call`" error is generated (475AH) on a standard MSX machine.

<a name="6d25h"></a>

    Address... 6D25H

This routine is used by the Factor Evaluator to apply the "`EOF`" function to the I/O buffer whose number is contained in [DAC](#dac). The FCB is located (6A6AH) and the EOF function dispatched ([6F8FH](#6f8fh)).

<a name="6d39h"></a>

    Address... 6D39H

This routine is used by the Factor Evaluator to apply the "`FPOS`" function to the I/O buffer whose number is contained in [DAC](#dac). The FCB is located (6A6AH) and the `FPOS` function dispatched ([6F8FH](#6f8fh)). An "`Illegal function call`" error is generated (475AH) on a standard MSX machine.

<a name="6d48h"></a>

    Address... 6D48H

Control transfers to this routine when the Interpreter Mainloop encounters a direct statement, that is one with no line number. The [ISFLIO](#isflio) standard routine is first used to determine whether a "`LOAD`" statement is active. If input is coming from the keyboard control transfers to the Runloop execution point ([4640H](#4640h)) to execute the statement. If input is coming from the cassette buffer 0 is closed ([6B24H](#6b24h)) and a "`Direct statement in file`" error generated ([6E71H](#6e71h)). This could happen on a standard MSX machine either through a cassette error or by attempting to load a text file with no line numbers.

<a name="6d57h"></a>

    Address... 6D57H

This routine is used by the "`INPUT`", "`LINE INPUT`" and "`PRINT`" statement handlers to check for the presence of a "#" character in the program text. If one is found the I/O buffer number is evaluated ([521BH](#521bh)), the FCB located and its address placed in [PTRFIL](#ptrfil) (6AAAH). The mode byte of the FCB is then compared with the mode number supplied by the statement handler in register C, if they do not match a "`Bad file number`" error is generated ([6E7DH](#6e7dh)). With "`PRINT`" the allowable modes are output, random and append. With "`INPUT`" and "`LINE INPUT`" the allowable modes are input and random. Note that on a standard MSX machine not all these modes are supported at lower levels. Some sort of error will consequently be generated at a later stage for illegal modes.

<a name="6d83h"></a>

    Address... 6D83H

This routine is used by the "`INPUT`" statement handler to input a string from an I/O buffer. A return is first set up to the "`READ/INPUT`" statement handler (4BF1H). The characters which delimit the input string, comma and space for a numeric Variable and comma only for a string Variable, are placed in registers D and E and control transfers to the "`LINE INPUT`" routine (6DA3H).

<a name="6d8fh"></a>

    Address... 6D8FH

This is the "`LINE INPUT`" statement handler when input is from an I/O buffer. The buffer number is evaluated, the FCB located and the mode checked (6D55H). The Variable to assign to is then located ([5EA4H](#5ea4h)) and its type checked to ensure it is a string type ([3058H](#3058h)). A return is set up to the "`LET`" statement handler (487BH) to perform the assignment and the input string collected.

Characters are sequentially input ([6C71H](#6c71h)) and placed in [BUF](#buf) until the correct delimiter is found, EOF is reached or [BUF](#buf) fills up (6E41H). When the terminating condition is reached and assignment is to a numeric Variable the string is converted to numeric form in [DAC](#dac) ([3299H](#3299h)). When assignment is to a string Variable the string is analyzed and the result descriptor created (6638H).

For "`LINE INPUT`" all characters are accepted until a CR code is reached. Note that if this CR code is preceded by a LF code then it will not function as a delimiter but will merely be accepted as part of the string. For "`INPUT`" to a numeric Variable leading spaces are stripped then characters accepted until a CR code, a space or a comma is reached. Note that as for "`LINE INPUT`" a CR code will not function as a delimiter when preceded by a LF code. In this case however the CR code will not be placed in [BUF](#buf) but ignored. For "`INPUT`" to a string Variable leading spaces are stripped then characters accepted until a CR or comma is reached. Note that as for "`LINE INPUT`" a CR code will not function as a delimiter when preceded by a LF code. In this case however neither code will be placed in [BUF](#buf) both are ignored. An alternative mode is entered when the first character read, after any spaces, is a double quote character. In this case all characters will be accepted, and stored in [BUF](#buf), until another double quote delimiter is read.

Once the input string has been accepted the terminating delimiter is examined to see if any special action is required with respect to trailing characters. If the input string was delimited by a double quote character or a space then any succeeding spaces will be read in and ignored until a non-space character is found. If this character is a comma or CR code then it is accepted and ignored. Otherwise a putback function is dispatched ([6F8FH](#6f8fh)) to return the character to the I/O buffer. If the input string was delimited by a CR code then the next character is read in and checked. If this is a LF code it will be accepted but ignored. If it is not a LF code then a putback function is dispatched ([6F8FH](#6f8fh)) to return the character to the I/O buffer.

<a name="6e6bh"></a>
<a name="6e6eh"></a>
<a name="6e71h"></a>
<a name="6e74h"></a>
<a name="6e77h"></a>
<a name="6e7ah"></a>
<a name="6e7dh"></a>
<a name="6e80h"></a>
<a name="6e83h"></a>
<a name="6e86h"></a>

    Address... 6E6BH

This is a group of ten file I/O related error generators. Register E is loaded with the relevant error code and control transfers to the error handler ([406FH](#406fh)):

|ADDRESS|ERROR
|-------|------------------------
|6E6BH  |Bad file name
|6E6EH  |File already open
|6E71H  |Direct statement in file
|6E74H  |File not found
|6E77H  |File not open
|6E7AH  |Field overflow
|6E7DH  |Bad file number
|6E80H  |Internal error
|6E83H  |Input past end
|6E86H  |Sequential I/O only

</a>

<a name="6e92h"></a>

    Address... 6E92H

This is the "`BSAVE`" statement handler. The filespec is analyzed ([6A0EH](#6a0eh)) and the start address evaluated ([6F0BH](#6f0bh)). The stop address is then evaluated ([6F0BH](#6f0bh)) and placed in [SAVEND](#savend) followed by the optional entry address ([6F0BH](#6f0bh)) which is placed in [SAVENT](#savent). If no entry address exists the start address is taken instead. The device code is checked to ensure that it is CAS, if not a "`Bad file name`" error is generated ([6E6BH](#6e6bh)), and the data written to cassette ([6FD7H](#6fd7h)). Note that no buffering is involved, data is written directly to the cassette, and no error checking information accompanies the data.

<a name="6ec6h"></a>

    Address... 6EC6H

This is the "`BLOAD`" statement handler. The filespec is analyzed ([6A0EH](#6a0eh)) and [RUNBNF](#runbnf) made non-zero if the auto-run "`R`" option is present in the program text. The optional load offset, with a default value of zero, is then evaluated ([6F0BH](#6f0bh)) and the device code checked to ensure that it is CAS, if not a "`Bad file name`" error is generated ([6E6BH](#6e6bh)). Data is then read directly from cassette ([7014H](#7014h)), as with "`BSAVE`" no buffering or error checking is involved.

<a name="6ef4h"></a>

    Address... 6EF4H

Control transfers to this routine when the "`BLOAD`" statement handler has completed loading data into memory. If [RUNBNF](#runbnf) is zero buffer 0 is closed ([6B24H](#6b24h)) and control returns to the Runloop. Otherwise buffer 0 is closed ([6B24H](#6b24h)), a return address of 6CF3H is set up (this routine just pops the program text pointer back into register pair HL and returns to the Runloop) and control transfers to the address contained in [SAVENT](#savent).

<a name="6f0bh"></a>

    Address... 6F0BH

This routine is used by the "`BLOAD`" and "`BSAVE`" handlers to evaluate an address operand, the result is returned in register pair DE. The operand is evaluated (4C64H) then converted to an integer ([5439H](#5439h)).

<a name="6f15h"></a>

    Address... 6F15H

This routine is used by the filespec analyzer to parse a device name such as "`CAS:`". On entry register pair HL points to the start of the filespec string and register E contains its length. If no device name is present the default device code (CAS=FFH) is returned in register A with FLAG Z. If a legal device name is present its code is returned in register A with FLAG NZ.

The filespec is examined until a ":" character is found then the name compared with each of the legal device names in the device table at 6F76H. If a match is found the device code is taken from the table and returned in register A. If no match is found control transfers to the external ROM search routine ([55F8H](#55f8h)). Note that any lower case characters are turned to upper case for comparison purposes. Thus crt and CRT, for example, are the same device.

<a name="6f76h"></a>

    Address... 6F76H

This table is used by the device name parser, it contains the four device names and codes available on a standard MSX machine:

    CAS ... FFH  LPT ... FEH  CRT ... FDH  GRP ... FCH

</a>

<a name="6f87h"></a>

    Address... 6F87H

This table is used by the function dispatcher ([6F8FH](#6f8fh)), it contains the address of the function decoding table for each of the four standard MSX devices:

    CAS ... 71C7H  LPT ... 72A6H  CRT ... 71A2H  GRP ... 7182H

</a>

<a name="6f8fh"></a>

    Address... 6F8FH

This is the file I/O function dispatcher. In conjunction with the Interpreter's buffer structure it provides a consistent, device independent method of inputting or outputting data. The required function code is supplied in register A and the address of the buffer FCB in register pair HL.

The device code is taken from byte 4 of the FCB and examined to determine whether it is one of the four standard devices, if not control transfers to the external ROM function dispatcher ([564AH](#564ah)). Otherwise the address of the device's function decoding table is taken from the table at 6F87H, the required function's address taken from it and control transferred to the relevant function handler.

<a name="6fb7h"></a>

    Address... 6FB7H

This is the "`CSAVE`" statement handler. The filename is evaluated (7098H) followed by the optional baud rate operand ([7A2DH](#7a2dh)). The identification block is then written to cassette ([7125H](#7125h)) with a filetype byte of D3H. The contents of the Program Text Area are written directly to cassette as a single data block ([713EH](#713eh)). Note that no error checking information accompanies the data.

<a name="6fd7h"></a>

    Address... 6FD7H

Control transfers to this routine from the "`BSAVE`" statement handler to write a block of memory to cassette. The identification block is first written to cassette ([7125H](#7125h)) with a filetype byte of D0H. The motor is then turned on and a short header written to cassette ([72F8H](#72f8h)) The starting address is popped from the Z80 stack and written to cassette LSB first, MSB second ([7003H](#7003h)). The stop address is taken from [SAVEND](#savend) and written to cassette LSB first, MSB second ([7003H](#7003h)). The entry address is taken from [SAVENT](#savent) and written to cassette LSB first, MSB second ([7003H](#7003h)). The required area of memory is then written to cassette one byte at a time ([72DEH](#72deh)) and the cassette motor turned off via the [TAPOOF](#tapoof) standard routine. Note that no error checking information accompanies the data.

<a name="7003h"></a>

    Address... 7003H

This routine writes the contents of register pair HL to cassette with register L first ([72DEH](#72deh)) and register H second ([72DEH](#72deh)).

<a name="700bh"></a>

    Address... 700BH

This routine reads two bytes from cassette and places the first in register L ([72D4H](#72d4h)), the second in register H ([72D4H](#72d4h)).

<a name="7014h"></a>

    Address... 7014H

Control transfers to this routine from the "`BLOAD`" statement handler to load data from the cassette into memory. The cassette is read until an identification block with a file type of D0H and the correct filename is found ([70B8H](#70b8h)). The data block header is then located on the cassette ([72E9H](#72e9h)). The offset value is popped from the Z80 stack and added to the start address from the cassette ([700BH](#700bh)). The stop address is read from cassette ([700BH](#700bh)) and the offset added to this as well. The entry address is read from cassette ([700BH](#700bh)) and placed in [SAVENT](#savent) in case auto-run is required. Successive data bytes are then read from cassette ([72D4H](#72d4h)) and placed in memory, at the start address initially, until the stop address is reached. Finally the motor is turned off via the [TAPIOF](#tapiof) standard routine and control transfers to the "`BLOAD`" termination point ([6EF4H](#6ef4h)).

<a name="703fh"></a>

    Address... 703FH

This is the "`CLOAD`" and "`CLOAD?`" statement handler. The program text is first checked for a trailing "`PRINT`" token (91H) which is how the "`?`" character is tokenized. The filename is then evaluated ([708CH](#708ch)) and the cassette read until an identification block with a filetype of D3H and the correct filename is found ([70B8H](#70b8h)). For "`CLOAD`" a "`NEW`" operation is then performed (6287H) to erase the current program text. For "`CLOAD?`" all pointers in the Program Text Area are converted to line numbers (54EAH) to match the cassette data.

The data block header is located on the cassette and successive data bytes read from cassette and placed in memory or compared with the current memory contents ([715DH](#715dh)). When the data block has been completely read the message "`OK`" is displayed ([6678H](#6678h)) and control transfers directly to the end of the Interpreter Mainloop (4237H) to reset the Variable storage pointers. For "`CLOAD?`" reading of the data block will terminate if the cassette byte is not the same as the program text byte in memory. If the address where this occurred is above the end of the Program Text Area then the handler terminates with an "`OK`" message as before. Otherwise a "`Verify error`" is generated.

<a name="708ch"></a>

    Address... 708CH

This routine is used by the "`CLOAD`" and "`CSAVE`" statement handlers to evaluate a filename in the program text. The two handlers use different entry points so that a null filename is allowed for "`CLOAD`" but not for "`CSAVE`". The filename string is evaluated ([4C64H](#4c64h)), its storage freed (680FH) and the first six characters copied to [FILNAM](#filnam). If the filename is longer than six characters the excess is ignored. If the filename is shorter than six characters then [FILNAM](#filnam) is padded with spaces.

<a name="70b8h"></a>

    Address... 70B8H

This routine is used by the "`CLOAD`" and "`BLOAD`" statement handlers and for the dispatcher open function (when the device is CAS and the mode is input) to locate an identification block on the cassette. On entry the filename is in [FILNAM](#filnam) and the file type in register C, D3H for a tokenized BASIC (`CLOAD`) file, D0H for a binary (`BLOAD`) file and EAH for an ASCII (`LOAD` or data) file.

The cassette motor is turned on and the cassette read until a header is found ([72E9H](#72e9h)). Each identification block is prefixed by ten file type characters so successive characters are read from cassette ([72D4H](#72d4h)) and compared to the required file type. If the file type characters do not match control transfers back to the start of the routine to find the next header. Otherwise the next six characters are read in ([72D4H](#72d4h)) and placed in [FILNAM](#filnam). If [FILNAM](#filnam) is full of spaces no filename match is attempted and the identification block has been found. Otherwise the contents of [FILNAM](#filnam) and [FILNM2](#filnm2) are compared to determine whether this is the required file. If the match is unsuccessful, and the Interpreter is in direct mode, the message "`Skip:`" is displayed ([710DH](#710dh)) followed by the filename. Control then transfers back to the start of the routine to try the next header. If the match is successful, and the Interpreter is in direct mode, the message "`Found:`" is displayed ([710DH](#710dh)) followed by the filename and the routine terminates.

<a name="70ffh"></a>

    Address... 70FFH

This is the plain text message "`Found:`" terminated by a zero byte.

<a name="7106h"></a>

    Address... 7106H

This is the plain text message "`Skip :`" terminated by a zero byte.

<a name="710dh"></a>

    Address... 710DH

Unless [CURLIN](#curlin) shows the Interpreter to be in program mode this routine first displays ([6678H](#6678h)) the message whose address is supplied in register pair HL, followed by the six characters contained in [FILNM2](#filnm2).

<a name="7125h"></a>

    Address... 7125H

This routine is used by the "`CSAVE`" and "`BSAVE`" statement handlers and for the dispatcher open function (when the device is CAS and the mode is output) to write an identification block to cassette. On entry the filename is in [FILNAM](#filnam) and the filetype in register A, D3H for a tokenized BASIC (`CSAVE`) file, D0H for a binary (`BSAVE`) file and EAH for an ASCII (`SAVE` or data) file. The cassette motor is turned on and a long header written to cassette ([72F8H](#72f8h)) The filetype byte is then written to cassette ([72DEH](#72deh)) ten times followed by the first six characters from [FILNAM](#filnam) ([72DEH](#72deh)). The cassette motor is turned off via the [TAPOOF](#tapoof) standard routine and the routine terminates.

<a name="713eh"></a>

    Address... 713EH

This routine is used by the "`CSAVE`" statement handler to write the Program Text Area to cassette as a single data block. All pointers in the program text are converted back to line numbers (54EAH) to make the text address independent. The cassette motor is turned on and a short header written to cassette ([72F8H](#72f8h)) The entire Program Text Area is then written to cassette a byte at a time ([72DEH](#72deh)) and followed with seven zero bytes ([72DEH](#72deh)) as a terminator. The cassette motor is then turned off via the [TAPOOF](#tapoof) standard routine and the routine terminates.

<a name="715dh"></a>

    Address... 715DH

This routine is used by the "`CLOAD`" and "`CLOAD?`" statement handlers to read a single data block into the Program Text Area or to compare it with the current contents. On entry register A contains a flag to distinguish between the two statements, 00H for "`CLOAD`" and FFH for "`CLOAD?`". The cassette motor is turned on and the first header located ([72E9H](#72e9h)). Successive characters are read from cassette ([72D4H](#72d4h)) and placed in the Program Text Area or compared with the current contents. If the current statement is "`CLOAD?`" the routine will terminate with FLAG NZ if the cassette character is not the same as the memory character. Otherwise data will be read until ten successive zeroes are found. This sequence of zeroes is composed of the last program line end of line character, the end link and the seven terminator zeroes added by "`CSAVE`". Note that the routine will probably terminate during this sequence, when used by "`CLOAD?`", as memory comparison is still in progress. This accounts for the rather peculiar coding of the "`CLOAD?`" handler terminating conditions.

<a name="7182h"></a>

    Address... 7182H

This table is used by the dispatcher when decoding function codes for the GRP device. It contains the address of the handler for each of the function codes, most are in fact error generators:

|TO     |FUNCTION
|-------|---------------------
|71B6H  | 0, open
|71C2H  | 2, close
|6E86H  | 4, random
|7196H  | 6, sequential output
|475AH  | 8, sequential input
|475AH  |10, loc
|475AH  |12, lof
|475AH  |14, eof
|475AH  |16, fpos
|475AH  |18, putback

</a>

<a name="7196h"></a>

    Address... 7196H

This is the dispatcher sequential output routine for the GRP device. [SCRMOD](#scrmod) is first checked and an "`Illegal function call`" error generated (475AH) if the screen is in either text mode. The character to output is taken from register C and control transfers to the [GRPPRT](#grpprt) standard routine.

<a name="71a2h"></a>

    Address... 71A2H

This table is used by the device dispatcher when decoding function codes for the CRT device. It contains the address of the handler for each of the function codes, most are in fact error generators:

|TO     |FUNCTION
|-------|---------------------
|71B6H  | 0, open
|71C2H  | 2, close
|6E86H  | 4, random
|71C3H  | 6, sequential output
|475AH  | 8, sequential input
|475AH  |10, loc
|475AH  |12, lof
|475AH  |14, eof
|475AH  |16, fpos
|475AH  |18, putback

</a>

<a name="71b6h"></a>

    Address... 71B6H

This is the dispatcher open routine for the CRT, LPT and GRP devices. The required mode, in register E, is checked and a "`Bad file name`" error generated ([6E6BH](#6e6bh)) for input or append. The FCB address is then placed in [PTRFIL](#ptrfil), the mode in byte 0 of the FCB and the routine terminates. Note that the Z80 RET instruction at the end of this routine (71C2H) is the dispatcher close routine for the CRT, LPT and GRP devices.

<a name="71c3h"></a>

    Address... 71C3H

This is the dispatcher sequential output routine for the CRT device. The character to output is taken from register C and control transfers to the [CHPUT](#chput) standard routine.

<a name="71c7h"></a>

    Address... 71C7H

This table is used by the dispatcher when decoding function codes for the CAS device. It contains the address of the handler for each of the function codes, several are error generators:

|TO     |FUNCTION
|-------|---------------------
|71DBH  | 0, open
|7205H  | 2, close
|6E86H  | 4, random
|722AH  | 6, sequential output
|723FH  | 8, sequential input
|475AH  |10, loc
|475AH  |12, lof
|726DH  |14, eof
|475AH  |16, fpos
|727CH  |18, putback

</a>

<a name="71dbh"></a>

    Address... 71DBH

This is the dispatcher open routine for the CAS device. The current I/O buffer position, held in byte 6 of the FCB, and [CASPRV](#casprv), which holds any putback character are both zeroed. The required mode, supplied in register E, is examined and a "`Bad file name`" error generated ([6E6BH](#6e6bh)) for append or random modes. For output mode the identification block is then written to cassette ([7125H](#7125h)) while for input mode the correct identification block is located on the cassette ([70B8H](#70b8h)). The FCB address is then placed in [PTRFIL](#ptrfil), the mode in byte 0 of the FCB and the routine terminates.

<a name="7205h"></a>

    Address... 7205H

This is the dispatcher close routine for the CAS device. Byte 0 of the FCB is examined and, if the mode is input, [CASPRV](#casprv) is zeroed and the routine terminates. Otherwise the remainder of the I/O buffer is filled with end of file characters (1AH) and the I/O buffer contents written to cassette (722FH). [CASPRV](#casprv) is then zeroed and the routine terminates.

<a name="722ah"></a>

    Address... 722AH

This is the dispatcher sequential output routine for the CAS device. The character to output is taken from register C and placed in the next free position in the I/O buffer ([728BH](#728bh)). Byte 6 of the FCB, the I/O buffer position, is then incremented. If the I/O buffer position has wrapped round to zero this means that there are two hundred and fifty-six characters in the I/O buffer and it has to be written to cassette. The cassette motor is turned on, a short header is written to cassette ([72F8H](#72f8h)) followed by the I/O buffer contents ([72DEH](#72deh)), and the motor is turned off via the [TAPOOF](#tapoof) standard routine.

<a name="723fh"></a>

    Address... 723FH

This is the dispatcher sequential input routine for the CAS device. [CASPRV](#casprv) is first checked ([72BEH](#72beh)) to determine whether it contains a character which has been putback, in which case its contents will be non-zero. If so the routine terminates with the character in register A. Otherwise the I/O buffer position is checked ([729BH](#729bh)) to determine whether it contains any characters. If the I/O buffer is empty the cassette motor is turned on and the header located ([72E9H](#72e9h)). Two hundred and fifty-six characters are then read in ([72D4H](#72d4h)), the cassette motor turned off via the [TAPION](#tapion) standard routine and the I/O buffer position reset to zero. The character is then taken from the current I/O buffer position and the position incremented. Finally the character is checked to see if it is the end of file character (1AH). If it is not the routine terminates with the character in register A and FLAG NC. Otherwise the end of file character is placed in [CASPRV](#casprv), so that succeeding sequential input requests will always return the end of file condition, and the routine terminates with FLAG C.

<a name="726dh"></a>

    Address... 726DH

This is the dispatcher eof routine for the CAS device. The next character is input ([723FH](#723fh)) and placed in [CASPRV](#casprv). It is then tested for the end of file code (1AH) and the result placed in [DAC](#dac) as an integer, zero for false, FFFFH for true.

<a name="727ch"></a>

    Address... 727CH

This is the dispatcher putback routine for the CAS device. The character is simply placed in [CASPRV](#casprv) to be picked up at the next sequential input request.

<a name="7281h"></a>

    Address... 7281H

This routine is used by the dispatcher close function to check if there are any characters in the I/O buffer and then zero the I/O buffer position byte in the FCB.

<a name="728bh"></a>

    Address... 728BH

This routine is used by the dispatcher sequential output function to place the character in register A in the I/O buffer at the current I/O buffer position, which is then incremented.

<a name="729bh"></a>

    Address... 729BH

This routine is used by the dispatcher sequential input function to collect the character at the current I/O buffer position, which is then incremented.

<a name="72a6h"></a>

    Address... 72A6H

This table is used by the dispatcher when decoding function codes for the LPT device. It contains the address of the handler for each of the function codes, most are in fact error generators:

|TO     |FUNCTION
|-------|---------------------
|71B6H  | 0, open
|71C2H  | 2, close
|6E86H  | 4, random
|72BAH  | 6, sequential output
|475AH  | 8, sequential input
|475AH  |10, loc
|475AH  |12, lof
|475AH  |14, eof
|475AH  |16, fpos
|475AH  |18, putback

</a>

<a name="72bah"></a>

    Address... 72BAH

This is the dispatcher sequential output routine for the LPT device. The character to output is taken from register C and control transfers to the [OUTDLP](#outdlp) standard routine.

<a name="72beh"></a>

    Address... 72BEH

This routine is used by the dispatcher sequential input function to check if a putback character exists in [CASPRV](#casprv), and if not to return Flag Z. Otherwise [CASPRV](#casprv) is zeroed and the character tested to see if it is the end of file character (1AH). If not it returns with the character in register A and FLAG NZ,NC. Otherwise the end of file character is placed back in [CASPRV](#casprv) and the routine returns with FLAG Z,C.

<a name="72cdh"></a>

    Address... 72CDH

This routine is used by various dispatcher functions to check if the mode in register E is append, if so a "`Bad file name`" error is generated ([6E6BH](#6e6bh)).

<a name="72d4h"></a>

    Address... 72D4H

This routine is used by various dispatcher functions to read a character from the cassette. The character is read via the [TAPIN](#tapin) standard routine and a "`Device I/O error`" generated ([73B2H](#73b2h)) if FLAG C is returned.

<a name="72deh"></a>

    Address... 72DEH

This routine is used by various dispatcher functions to write a character to cassette. The character is written via the [TAPOUT](#tapout) standard routine and a "`Device I/O error`" generated ([73B2H](#73b2h)) if FLAG C is returned.

<a name="72e9h"></a>

    Address... 72E9H

This routine is used by various dispatcher functions to turn the cassette motor on for input. The motor is turned on via the [TAPION](#tapion) standard routine and a "`Device I/O error`" generated ([73B2H](#73b2h)) if FLAG C is returned.

<a name="72f8h"></a>

    Address... 72F8H

This routine is used by various dispatcher functions to turn the cassette motor on for output, control simply transfers to the [TAPOON](#tapoon) standard routine.

<a name="7304h"></a>

    Address... 7304H

This routine is used by the Interpreter Mainloop "`OK`" point, the "`END`" statement handler and the run-clear routine to shut down the printer. [PRTFLG](#prtflg) is first zeroed and then [LPTPOS](#lptpos) tested to see if any characters have been output but left hanging in the printer's line buffer. If so a CR,LF sequence is issued to flush the printer and [LPTPOS](#lptpos) zeroed.

<a name="7323h"></a>

    Address... 7323H

This routine issues a CR,LF sequence to the current output device via the [OUTDO](#outdo) standard routine. [LPTPOS](#lptpos) or [TTYPOS](#ttypos) is then zeroed depending upon whether the printer or the screen is active.

<a name="7347h"></a>

    Address... 7347H

This routine is used by the Factor Evaluator to apply the "`INKEY$`" function. The state of the keyboard buffer is examined via the [CHSNS](#chsns) standard routine. If the buffer is empty the address of a dummy null string descriptor is returned in [DAC](#dac). Otherwise the next character is read from the keyboard buffer via the [CHGET](#chget) standard routine. After checking that sufficient space is available (6625H) the character is copied to the String Storage Area and the result descriptor created (6821H).

<a name="7367h"></a>

    Address... 7367H

This routine is used by the "`LIST`" statement handler to output a character to the current output device via the [OUTDO](#outdo) standard routine. If the character is a LF code then a CR code is also issued.

<a name="7374h"></a>

    Address... 7374H

This routine is used by the Interpreter Mainloop to collect a line of text when input is from an I/O buffer rather than the keyboard, that is when a "`LOAD`" statement is active. Characters are sequentially input ([6C71H](#6c71h)) and placed in [BUF](#buf) until [BUF](#buf) fills up, a CR is detected or the end of file is reached. All characters are accepted apart from LF codes which are filtered out. If [BUF](#buf) fills up or a CR is detected the routine simply returns the line to the Mainloop. If the end of file is reached while some characters are in [BUF](#buf) the line is returned to the Mainloop. When end of file is reached with no characters in [BUF](#buf) then I/O buffer 0 is closed (6D7BH) and [FILNAM](#filnam) checked to determine whether auto-run is required. If not control returns to the Interpreter "`OK`" point (411EH). Otherwise the system is cleared ([629AH](#629ah)) and control transfers to the Runloop ([4601H](#4601h)) to execute the program.

<a name="73b2h"></a>

    Address... 73B2H

This is the "`Device I/O error`" generator.

<a name="73b7h"></a><a name="motor"></a>

    Address... 73B7H

This is the "`MOTOR`" statement handler. If no operand is present control transfers to the [STMOTR](#stmotr) standard routine with FFH in register A. If the "`OFF`" token (EBH) follows control transfers with 00H in register A. If the "`ON`" token (95H) follows control transfers with 01H in register A.

<a name="73cah"></a><a name="sound"></a>

    Address... 73CAH

This is the "`SOUND`" statement handler. The register number operand, which must be less than fourteen, is evaluated (521CH) and placed in register A. The data operand is evaluated (521CH) and bit 7 set, bit 6 reset to avoid altering the PSG auxiliary I/O port modes' The data operand is placed in register E and control transfers to the [WRTPSG](#wrtpsg) standard routine.

<a name="73e4h"></a>

    Address... 73E4H

This is a single ASCII space used by the "`PLAY`" statement handler to replace a null string operand with a one character blank string.

<a name="73e5h"></a><a name="play"></a>

    Address... 73E5H

This is the "`PLAY`" statement handler. The address of the "`PLAY`" command table at 752EH is placed in [MCLTAB](#mcltab) for the macro language parser and [PRSCNT](#prscnt) zeroed. The first string operand, which is obligatory, is evaluated ([4C64H](#4c64h)), its storage freed ([67D0H](#67d0h)) and its length and address placed in [VCBA](#vcba) at bytes 2, 3 and 4. The channel's stack pointer is initialized to [VCBA](#vcba)+33 and placed in [VCBA](#vcba) at bytes 5 and 6' If further text is present in the statement this process is repeated for voices B and C until a maximum of three operands have been evaluated, after this a "`Syntax error`" is generated ([4055H](#4055h)). If there are less than three string operands present an end of queue mark (FFH) is placed in the queue ([7507H](#7507h)) of each unused voice. Register A is then zeroed, to select voice A, and control drops into the play mainloop.

<a name="744dh"></a>

    Address... 744DH

This is the play mainloop. The number of free bytes in the current queue is checked ([7521H](#7521h)) and, if less than eight bytes remain, the next voice is selected (74D6H) to avoid waiting for the queue to empty. The remaining length of the operand string is then taken from the current voice buffer and, if zero bytes remain to be parsed, the loop again skips to the next voice (74D6H). Otherwise the current string length and address are taken from the voice buffer and placed in [MCLLEN](#mcllen) and [MCLPTR](#mclptr) for the macro language parser. The old stack contents are copied from the voice buffer to the Z80 stack (6253H), [MCLFLG](#mclflg) is made non-zero and control transfers to the macro language parser ([56A2H](#56a2h)).

The macro language parser will normally scan along the string, using the "`PLAY`" statement command handlers, until the string is exhausted. However, if a music queue fills up during note generation an abnormal termination is forced back to the play mainloop (748EH) so that the next voice can be processed without waiting for the queue to empty. When control returns normally an end of queue mark is placed in the current queue ([7507H](#7507h)) and [PRSCNT](#prscnt) is incremented to show the number of strings completed. If control returns abnormally then anything left on the Z80 stack is copied into the current voice buffer (6253H). Because of the recursive nature of the macro language parser where the "`X`" command is involved there may be a number of four byte string descriptors, marking the point where the original string was suspended, left on the Z80 stack at termination. Saving the stack contents in the voice buffer means they can be restored when the loop gets around to that voice again. Note that as there are only sixteen bytes available in each voice buffer an "`Illegal function call`" error is generated (475AH) if too much data remains on the stack. This will occur when a queue fills up and multiple, nested "X" commands exist, for example:

```
10 A$="XB$;"
20 B$="XC$;"
30 C$="XD$;"
40 D$=STRING$(150,"A")
50 PLAY A$
```

There seems to be a slight bug in this section as only fifteen bytes of stack data are allowed, instead of sixteen, before an error is generated.

When control returns from the macro language parser register A is incremented to select the next voice for processing. When all three voices have been processed [INTFLG](#intflg) is checked and, if CTRL-STOP has been detected by the interrupt handler, control transfers to the [GICINI](#gicini) standard routine to halt all music and terminate. Assuming bit 7 of [PRSCNT](#prscnt) shows this to be the first pass through the mainloop, that is no voice has been temporarily suspended because of a full queue, [PLYCNT](#plycnt) is incremented and interrupt dequeueing started via the [STRTMS](#strtms) standard routine. [PRSCNT](#prscnt) is then checked to determine the number of strings completed by the macro language parser. If all three operand strings have been completed the handler terminates, otherwise control transfers back to the start of the play mainloop to try each voice again.

<a name="7507h"></a>

    Address... 7507H

This routine is used by the "`PLAY`" statement handler to place an end of queue mark (FFH) in the current queue via the [PUTQ](#putq) standard routine. If the queue is full it waits until space becomes available.

<a name="7521h"></a>

    Address... 7521H

This routine is used by the "`PLAY`" statement handler to check how much space remains in the current queue via the [LFTQ](#lftq) standard routine. If less than eight bytes remain (the largest possible music data packet is seven bytes long) FLAG C is returned.

<a name="752eh"></a>

    Address... 752EH

This table contains the valid command letters and associated addresses for the "`PLAY`" statement commands. Those commands which take a parameter, and consequently have bit 7 set in the table, are shown with an asterisk:

|CMD    |TO
|-------|-----
|A      |[763EH](#763eh)
|B      |[763EH](#763eh)
|C      |[763EH](#763eh)
|D      |[763EH](#763eh)
|E      |[763EH](#763eh)
|F      |[763EH](#763eh)
|G      |[763EH](#763eh)
|M\*    |[759EH](#759eh)
|V\*    |[7586H](#7586h)
|S\*    |[75BEH](#75beh)
|N\*    |[7621H](#7621h)
|O\*    |[75EFH](#75efh)
|R\*    |[75FCH](#75fch)
|T\*    |[75E2H](#75e2h)
|L\*    |[75C8H](#75c8h)
|X      |[5782H](#5782h)

</a>

<a name="755fh"></a>

    Address... 755FH

This table is used by the "`PLAY`" statement "`A`" to "`G`" command handler to translate a note number from zero to fourteen to an offset into the tone divider table at 756EH. The note itself, rather than the note number, is shown below with each offset value:

```
16 ... A-
18 ... A
20 ... A+ or B-
22 ... B or C-
00 ... B+
00 ... C
02 ... C+ or D-
04 ... D
06 ... D+ or E-
08 ... E or F-
10 ... E+
10 ... F
12 ... F+ or G-
14 ... G
16 ... G+
```

</a>

<a name="756eh"></a>

    Address... 756EH

This table contains the twelve PSG divider constants required to produce the tones of octave 1. For each constant the corresponding note and frequency are shown:

```
3421 ... C  32.698 Hz
3228 ... C+ 34.653 Hz
3047 ... D  36.712 Hz
2876 ... D+ 38.895 HZ
2715 ... E  41.201 Hz
2562 ... F  43.662 Hz
2419 ... F+ 46.243 Hz
2283 ... G  48.997 Hz
2155 ... G+ 51.908 Hz
2034 ... A  54.995 Hz
1920 ... A+ 58.261 Hz
1812 ... B  61.773 Hz
```

</a>

<a name="7586h"></a>

    Address... 7586H

This is the "`PLAY`" statement "`V`" command handler. The parameter, with a default value of eight, is placed in byte 18 of the current voice buffer without altering bit 6 of the existing contents. No music data is generated.

<a name="759eh"></a>

    Address... 759EH

This is the "`PLAY`" statement "`M`" command handler. The parameter, with a default value of two hundred and fifty-five, is compared with the existing modulation period contained in bytes 19 and 20 of the current voice buffer. If they are the same the routine terminates with no action. Otherwise the new modulation period is placed in the voice buffer and bit 6 set in byte 18 of the voice buffer to indicate that the new value must be incorporated into the next music data packet produced. No music data is generated.

<a name="75beh"></a>

    Address... 75BEH

This is the "`PLAY`" statement "`S`" command handler. The parameter is placed in byte 18 of the current voice buffer and bit 4 of the same byte set to indicate that the new value must be incorporated into the next music data packet produced. No music data is generated. Because of the PSG characteristics the shape and volume parameters are mutually exclusive so the same byte of the voice buffers is used for both.

<a name="75c8h"></a>

    Address... 75C8H

This is the "`PLAY`" statement "`L`" command handler. The parameter, with a default value of four, is placed in byte 16 of the current voice buffer where it is used in the computation of succeeding note durations. No music data is generated.

<a name="75e2h"></a>

    Address... 75E2H

This is the "`PLAY`" statement "`T`" command handler. The parameter, with a default value of one hundred and twenty, is placed in byte 17 of the current voice buffer where it will be used in the computation of succeeding note durations. ho music data is generated.

<a name="75efh"></a>

    Address... 75EFH

This is the "`PLAY`" statement "`O`" command handler. The parameter, with a default value of four, is placed in byte 15 of the current voice buffer where it is used in the computation of succeeding note frequencies. No music data is generated.

<a name="75fch"></a>

    Address... 75FCH

This is the "`PLAY`" statement "`R`" command handler. The length parameter, with a default value of four, is left in register pair DE and a zero tone divider value placed in register pair HL. The existing volume value is taken from byte 18 of the current voice buffer, temporarily replaced with a zero value and control transferred to the note generator (769CH).

<a name="7621h"></a>

    Address... 7621H

This is the "`PLAY`" statement "`N`" command handler. The obligatory parameter is first examined, if it is zero a rest is generated (760BH). If it is greater than ninety-six an "`Illegal function call`" error is generated (475AH). Otherwise twelve is repeatedly subtracted from the note number until underflow to obtain an octave number from one to nine in register E and a note number from zero to eleven in register C. Control then transfers to the note generator (7673H).

<a name="763eh"></a>

    Address... 763EH

This is the "`PLAY`" statement "`A`" to "`G`" command handler. The note letter is first converted into a note number from zero to fourteen, this extended range being necessary because of the redundancy implicit in the notation. The table at 755FH is then used to obtain the offset into the tone divider table and the divider constant for the note placed in register pair DE. The octave value is taken from byte 15 of the current voice buffer and the divider constant halved until the correct octave is reached. The string operand is then examined directly ([56EEH](#56eeh)) to determine whether a trailing note length parameter exists. If so it is converted (572FH) and placed in register C. If no parameter exists the default length is taken from byte 16 of the current voice buffer. The duration of the note is then computed from:

    Duration (Interrupt ticks) = 12,000/(LENGTH*TEMPO)

With the normal length value (4) and tempo value (120) this gives a note duration of twenty-five interrupt ticks of 20 ms each or 0.5 seconds. The string operand is then examined ([56EEH](#56eeh)) for trailing "`.`" characters and, for each one, the duration multiplied by one and a half. Finally the resulting duration is checked and, if it is less than five interrupt ticks, it is replaced with a value of five. Thus the shortest note that can be generated on a UK machine is 0.10 seconds whatever the tempo or note length.

The music data packet, which will be three, five or seven bytes long, is then assembled in bytes 8 to 14 of the current voice buffer prior to placing it in the queue. The duration is placed in bytes 8 and 9 of the voice buffer. The volume and flag byte is taken from byte 18 and placed in byte 10 of the voice buffer with bit 7 set to indicate a volume change to the interrupt dequeuing routine. If bit 6 of the volume byte is set then the modulation period is taken from bytes 19 and 20 and added to the data packet at bytes 11 and 12. If the tone divider value is non-zero then it is added to the data packet at bytes 11 and 12 (without a modulation period) or bytes 13 and 14 (with a modulation period). Finally the byte count is mixed into the three highest bits of byte 8 of the voice buffer to complete the preparation of the music data packet.

If the tone divider value is zero, indicating a rest, the contents of [SAVVOL](#savvol) are restored to byte 18 of the static buffer. The music data packet is then placed in the current queue via the [PUTQ](#putq) standard routine and the number of free bytes remaining checked ([7521H](#7521h)). If less than eight bytes remain control transfers directly to the "`PLAY`" statement handler (748EH), otherwise control returns normally to the macro language parser.

<a name="7754h"></a>

    Address... 7754H

This is the single precision constant 12,000 used in the computation of note duration.

<a name="7758h"></a><a name="put"></a>

    Address... 7758H

This is the "`PUT`" statement handler. Register B is set to 80H and control drops into the "`GET`" statement handler.

<a name="775bh"></a><a name="get"></a>

    Address... 775BH

This is the "`GET`" statement handler. Register B is zeroed, to distinguish "`GET`" from "`PUT`" and the next program token examined. Control then transfers to the "`PUT SPRITE`" statement handler ([7AAFH](#7aafh)) or the Disk BASIC "`GET/PUT`" statement handler ([6C35H](#6c35h)).

<a name="7766h"></a><a name="locate"></a>

    Address... 7766H

This is the "`LOCATE`" statement handler. If a column coordinate is present it is evaluated (521CH) and placed in register D, otherwise the current column is taken from [CSRX](#csrx). If a row coordinate is present it is evaluated (521CH) and placed in register E, otherwise the current row is taken from [CSRY](#csry). If a cursor switch operand exists it is evaluated (521CH) and register A loaded with 78H for a zero operand (OFF) and 79H for any non-zero operand (ON). The cursor is then switched by outputting ESC, 78H/79H, "`5`" via the [OUTDO](#outdo) standard routine. The row and column coordinates are placed in register pair HL and the cursor position set via the [POSIT](#posit) standard routine.

<a name="77a5h"></a>

    Address... 77A5H

This is the "`STOP ON/OFF/STOP`" statement handler. The address of the device's [TRPTBL](#trptbl) status byte is placed in register pair HL and control transfers to the "`ON/OFF/STOP`" routine (77CFH).

<a name="77abh"></a>

    Address... 77ABH

This is the "`SPRITE ON/OFF/STOP`" statement handler. The address of the device's [TRPTBL](#trptbl) status byte is placed in register pair HL and control transfers to the "`ON/OFF/STOP`" routine (77CFH).

<a name="77b1h"></a>

    Address... 77B1H

This is the "`INTERVAL ON/OFF/STOP`" statement handler. As there is no specific "`INTERVAL`" token (control transfers here when an "`INT`" token is found) a check is first made on the program text for the characters "`E`" and "`R`" then the "`VAL`" token (94H). The address of the device's [TRPTBL](#trptbl) status byte is placed in register pair HL and control transfers to the "`ON/OFF/STOP`" routine (77CFH).

<a name="77bfh"></a>

    Address... 77BFH

This is the "`STRIG ON/OFF/STOP`" statement handler. The trigger number, from zero to four, is evaluated ([7C08H](#7c08h)) and the address of the device's [TRPTBL](#trptbl) status byte placed in register pair HL. The "`ON/OFF/STOP`" token is examined and the [TRPTBL](#trptbl) status byte modified accordingly (77FEH). Control then transfers directly to the Runloop (4612H) to avoid testing for pending interrupts until the end of the next statement.

<a name="77d4h"></a>

    Address... 77D4H

This is the "`KEY(n) ON/OFF/STOP`" statement handler. The key number, from one to ten, is evaluated (521CH) and the address of the devices' [TRPTBL](#trptbl) status byte placed in register pair HL. The "`ON/OFF/STOP`" token is examined and the [TRPTBL](#trptbl) status byte modified accordingly (77FEH). Bit 0 of the [TRPTBL](#trptbl) status byte, the ON bit, is then copied into the corresponding entry in [FNKFLG](#fnkflg) for use during the interrupt keyscan and control transfers directly to the Runloop (4612H).

<a name="77feh"></a>

    Address... 77FEH

This routine checks for the presence of one of the interrupt switching tokens and transfers control to the appropriate routine: "`ON`" ([631BH](#631bh)), "`OFF`" (632BH) or "`STOP`" ([6331H](#6331h)). If no token is present a "`Syntax error`" is generated (4055H).

<a name="7810h"></a>

    Address... 7810H

This routine is used by the "`ON DEVICE GOSUB`" statement handler ([490DH](#490dh)) to check the program text for a device token. Unless none of the device tokens is present, in which case Flag C is returned, the device's [TRPTBL](#trptbl) entry number is returned in register B and the maximum allowable line number operand count in register C:

|DEVICE     |TRPTBL#    |LINE NUMBERS
|-----------|-----------|------------
|KEY        |00         |10
|STOP       |10         |01
|SPRITE     |11         |01
|STRIG      |12         |05
|INTERVAL   |17         |01

Additionally, for "`INTERVAL`" only, the interval operand is evaluated ([542FH](#542fh)) and placed in [INTVAL](#intval) and [INTCNT](#intcnt).

<a name="785ch"></a>

    Address... 785CH

This routine is used by the "`ON DEVICE GOSUB`" statement handler ([490DH](#490dh)) to place the address of a program line in [TRPTBL](#trptbl). The [TRPTBL](#trptbl) entry number, supplied in register B, is multiplied by three and added to the table base to point to the relevant entry. The address, supplied in register pair DE, is then placed there LSB first, MSB second.

<a name="786ch"></a><a name="key"></a>

    Address... 786CH

This is the "`KEY`" statement handler. If the following character is anything other than the "`LIST`" token (93H) control transfers to the "`KEY n`" statement handler ([78AEH](#78aeh)). Each of the ten function key strings is then taken from [FNKSTR](#fnkstr) and displayed via the [OUTDO](#outdo) standard routine with a CR,LF (7328H) after each one. The DEL character (7FH) or any control character smaller than 20H is replaced with a space.

<a name="78aeh"></a>

    Address... 78AEH

This is the "`KEY n`", "`KEY(n) ON/OFF/STOP`", "`KEY ON`" and "`KEY OFF`" statement handler. If the next program text character is "(" control transfers to the "`KEY(n) ON/OFF/STOP`" statement handler ([77D4H](#77d4h)). If it is an "`ON`" token (95H) control transfers to the [DSPFNK](#dspfnk) standard routine and if it is an "`OFF`" token (EBH) to the [ERAFNK](#erafnk) standard routine. Otherwise the function key number is evaluated (521CH) and the key's [FNKSTR](#fnkstr) address placed in register pair DE' The string operand is evaluated ([4C64H](#4c64h)) and its storage freed ([67D0H](#67d0h))' Up to fifteen characters are copied from the string to [FNKSTR](#fnkstr) and unused positions padded with zero bytes. If a zero byte is found in the operand string an "`Illegal function call`" error is generated (475AH). Control then transfers to the [FNKSB](#fnksb) standard routine to update the function key display if it is enabled.

<a name="7900h"></a>

    Address... 7900H

This routine is used by the Factor Evaluator to apply the "`TIME`" function. The contents of [JIFFY](#jiffy) are placed in [DAC](#dac) as a single precision number (3236H).

<a name="790ah"></a>

    Address... 790AH

This routine is used by the Factor Evaluator to apply the "`CSRLIN`" function. The contents of [CSRY](#csry) are decremented and placed in [DAC](#dac) as an integer (2E9AH).

<a name="7911h"></a><a name="time"></a>

    Address... 7911H

This is the "`TIME`" statement handler. The operand is evaluated (542FH) and placed in [JIFFY](#jiffy).

<a name="791bh"></a>

    Address... 791BH

This routine is used by the Factor Evaluator to apply the "`PLAY`" function. The numeric channel selection operand is evaluated ([7C08H](#7c08h)). If this is zero the contents of [MUSICF](#musicf) are placed in [DAC](#dac) as an integer of value zero or FFFFH. Otherwise the channel number is used to select the appropriate bit of [MUSICF](#musicf) and this is then converted to an integer as before.

<a name="7940h"></a>

    Address... 7940H

This routine is used by the Factor Evaluator to apply the "`STICK`" function to an operand contained in [DAC](#dac). The stick number is checked (521FH) and passed to the [GTSTCK](#gtstck) standard routine in register A. The result is placed in [DAC](#dac) as an integer (4FCFH ) .

<a name="794ch"></a>

    Address... 794CH

This routine is used by the Factor Evaluator to apply the "`STRIG`" function to an operand contained in [DAC](#dac). The trigger number is checked (521FH) and passed to the [GTTRIG](#gttrig) standard routine in register A. The result is placed in [DAC](#dac) as an integer of value zero or FFFFH.

<a name="795ah"></a>

    Address... 795AH

This routine is used by the Factor Evaluator to apply the "`PDL`" function to an operand contained in [DAC](#dac). The paddle number is checked (521FH) and passed to the [GTPDL](#gtpdl) standard routine in register A. The result is placed in [DAC](#dac) as an integer (4FCFH).

<a name="7969h"></a>

    Address... 7969H

This routine is used by the Factor Evaluator to apply the "`PAD`" function to an operand contained in [DAC](#dac). The pad number is checked (521F) and passed to the [GTPAD](#gtpad) standard routine in register A. The result is placed in [DAC](#dac) as an integer for pads 1, 2, 5 or 6. For pads 0, 3, 4 or 7 the result is placed in [DAC](#dac) as an integer of value zero or FFFFH.

<a name="7980h"></a><a name="color"></a>

    Address... 7980H

This is the "`COLOR`" statement handler. If a foreground colour operand exists it is evaluated (521CH) and placed in register E, otherwise the current foreground colour is taken from [FORCLR](#forclr). If a background colour operand exists it is evaluated (521CH) and placed in register D, otherwise the current background colour is taken from [BAKCLR](#bakclr). If a border colour operand exists it is evaluated (521CH) and placed in [BDRCLR](#bdrclr). The foreground colour is placed in [FORCLR](#forclr) and [ATRBYT](#atrbyt), the background colour in [BAKCLR](#bakclr) and control transfers to the [CHGCLR](#chgclr) standard routine to modify the VDP.

<a name="79cch"></a><a name="screen"></a>

    Address... 79CCH

This is the "`SCREEN`" statement handler. If a mode operand exists it is evaluated (521CH) and passed to the [CHGMOD](#chgmod) standard routine in register A. If a sprite size operand exists it is evaluated (521CH) and placed in bits 0 and 1 of [RG1SAV](#rg1sav), the Workspace Area copy of VDP [Mode Register 1](#mode_register_1). The VDP sprite parameters are then cleared via the [CLRSPR](#clrspr) standard routine. If a key click operand exists it is evaluated (521CH) and placed in [CLIKSW](#cliksw), zero to disable the click and non-zero to enable it. If a baud rate operand exists it is evaluated and the baud rate set ([7A2DH](#7a2dh)). If a printer mode operand exists it is evaluated (521CH) and placed in [NTMSXP](#ntmsxp), zero for an MSX printer and non- zero for a general purpose printer.

<a name="7a2dh"></a>

    Address... 7A2DH

This routine is used to set the cassette baud rate. The operand is evaluated (521CH) and five bytes copied from [CS1200](#cs1200) or [CS2400](#cs2400) to [LOW](#low) as appropriate.

<a name="7a48h"></a><a name="sprite"></a>

    Address... 7A48H

This is the "`SPRITE`" statement handler. If the next character is anything other than a "$" control transfers to the "`SPRITE ON/OFF/STOP`" statement handler ([77ABH](#77abh)). [SCRMOD](#scrmod) is then checked and an "`Illegal function call`" error generated (475AH) if the screen is in [40x24 Text Mode](#40x24_text_mode). The sprite pattern number is evaluated and its location in the VRAM Sprite Pattern Table obtained (7AA0H). The string operand is then evaluated ([4C5FH](#4c5fh)) and its storage freed ([67D0H](#67d0h)). The sprite size, obtained via the [GSPSIZ](#gspsiz) standard routine, is compared with the string length and, if the string is shorter than the sprite, the Sprite Pattern Table entry is first filled with zeroes via the [FILVRM](#filvrm) standard routine. Characters are then copied from the string body to the Sprite Pattern Table via the [LDIRVM](#ldirvm) standard routine until the string is exhausted or the sprite is full. If the string is longer than the sprite size any excess characters are ignored.

    Address... 7A84H

This routine is used by the Factor Evaluator to apply the "`SPRITE$`" function. The sprite pattern number is evaluated and its location in the VRAM Sprite Pattern Table obtained ([7A9FH](#7a9fh)). The sprite size, obtained via the [GSPSIZ](#gspsiz) standard routine, is then placed in register pair BC to control the number of bytes copied. After checking that sufficient space is available in the String Storage Area ([6627H](#6627h)) the sprite pattern is copied from VRAM via the [LDIRMV](#ldirmv) standard routine and the result descriptor created ([6654H](#6654h)). Note that as no check is made on the screen mode during this function some interesting side effects can be found, see below.

<a name="7a9fh"></a>

    Address... 7A9FH

This routine is used by the "`SPRITE$`" statement and function to locate a sprite pattern in the VRAM Sprite Pattern Table. The pattern number operand is evaluated ([7C08H](#7c08h)) and passed to the [CALPAT](#calpat) standard routine in register A. The pattern address is placed in register pair DE and the routine terminates.

Note that no check is made on the pattern number magnitude for differing sprite sizes. Pattern numbers up to two hundred and fifty-five are accepted even in 16x16 sprite mode when the maximum pattern number should be sixty-three. As a result VRAM addresses greater than 3FFFH will be produced which will wrap around into low VRAM. With the "`SPRITE$`" statement this will corrupt the Character Generator Table, for example:

```
10 SCREEN 3,2
20 SPRITE$(0)=STRING$(32,255)
30 PUT SPRITE 0,(0,0), ,0
40 SPRITE$(65)=STRING$(32,255)
50 GOTO 50
```

The above puts a real sprite in the top left of the screen and then uses an illegal statement in line 40 to corrupt the VRAM just to the right of it. The "`SPRITE$`" function can also be manipulated in this way and, as there is no screen mode check, up to thirty-two bytes of the Name Table can be read in [40x24 Text Mode](#40x24_text_mode), for example:

```
10 SCREEN 0,2
20 PRINT"something"
30 A$=SPRITE$(64)
40 PRINT A$
```

</a>

<a name="7aafh"></a><a name="put_sprite"></a>

    Address... 7AAFH

This is the "`GET/PUT SPRITE`" statement handler, control is transferred here from the general "`GET/PUT`" statement handler ([775BH](#775bh)). Register B is first checked to make sure that the statement is "`PUT`" and an "`Illegal function call`" error generated (475AH) if otherwise. [SCRMOD](#scrmod) is then checked and an "`Illegal function call`" error generated (475AH) if the screen is in [40x24 Text Mode](#40x24_text_mode). The sprite number operand, from zero to thirty-one, is evaluated (521CH) and passed to the [CALATR](#calatr) standard routine to locate the four byte attribute block in the Sprite Attribute Table. If a coordinate operand exists it is evaluated and the X coordinate placed in register pair BC, the Y coordinate in register pair DE ([579CH](#579ch)).

The Y coordinate LSB is written to byte 0 of the attribute block in VRAM via the [WRTVRM](#wrtvrm) standard routine. Bit 7 of the X coordinate is then examined to determine whether it is negative, that is off the left hand side of the screen. If so thirty two is added to the X coordinate and register B is set to 80H to set the early clock bit in the attribute block. For example an X coordinate of -1 (FFFFH) would be changed to +31 with an early clock. The X coordinate LSB is then written to byte 1 of the attribute block via the [WRTVRM](#wrtvrm) standard routine. Byte 3 of the attribute block is read in via the [RDVRM](#rdvrm) standard routine, the new early clock bit is mixed in and it is then written back to VRAM via the [WRTVRM](#wrtvrm) standard routine.

If a colour operand is present it is evaluated (521CH), byte 3 of the attribute block is read in via the [RDVRM](#rdvrm) standard routine the new colour code is mixed into the lowest four bits and it is written back to VRAM via the [WRTVRM](#wrtvrm) standard routine. If a pattern number operand exists it is evaluated (521CH) and checked for magnitude against the current sprite size provided by the [GSPSIZ](#gspsiz) standard routine. The maximum allowable pattern number is two hundred and fifty-five for 8x8 sprites and sixty- three for 16x16 sprites. The pattern number is written to byte 2 of the attribute block via the [WRTVRM](#wrtvrm) standard routine and the handler terminates.

<a name="7b37h"></a>

    Address... 7B37H

This is the "`VDP`" statement handler. The register number operand, from zero to seven, is evaluated ([7C08H](#7c08h)) followed by the data operand (521CH). The register number is placed in register C, the data value in register B and control transferred to the [WRTVDP](#wrtvdp) standard routine.

<a name="7b47h"></a>

    Address... 7B47H

This routine is used by the Factor Evaluator to apply the "`VDP`" function. The register number operand, from zero to eight, is evaluated ([7C08H](#7c08h)) and added to [RG0SAV](#rg0sav) to locate the corresponding register image in the Workspace Area. The VDP register image is then read and placed in [DAC](#dac) as an integer (4FCFH).

<a name="7b5ah"></a><a name="base"></a>

    Address... 7B5AH

This is the "`BASE`" statement handler. The VDP table number operand, from zero to nineteen, is evaluated ([7C08H](#7c08h)) followed by the base address operand ([4C64H](#4c64h)). After checking that the base address is less than 4000H ([7BFEH](#7bfeh)) the VDP table number is used to locate the associated entry in the masking table at 7BA3H. The base address is ANDed with the mask and an "`Illegal function call`" error generated (475AH) if any illegal bits are set. The VDP table number is then added to [TXTNAM](#txtnam) to locate the current base address in the Workspace Area and the new base address placed there. The VDP table number is divided by five to determine which of the four screen modes the table belongs to. If this is the same as the current screen mode the new base address is also written to the VDP ([7B99H](#7b99h)).

<a name="7b99h"></a>

    Address... 7B99H

This routine is used by the "`BASE`" statement handler to update the VDP base addresses. The current screen mode, in register A, is examined and control transfers to the [SETTXT](#settxt), [SETT32](#sett32), [SETGRP](#setgrp) or [SETMLT](#setmlt) standard routine as appropriate. Note that this is not a full VDP initialization and that the four current table addresses ([NAMBAS](#nambas), [CGPBAS](#cgpbas), [PATBAS](#patbas) and [ATRBAS](#atrbas)) which are the ones actually used by the screen routines, are not updated. This can be demonstrated with the following, where the Interpreter carries on outputting to the old VRAM Name Table:

```
10 SCREEN 0
20 BASE(0)=&H400
30 PRINT"something"
40 FOR N=1 TO 2000:NEXT
50 BASE(0)=0
```

Note also that this routine contains a bug. While [SETTXT](#settxt) is correctly used for [40x24 Text Mode](#40x24_text_mode), [SETGRP](#setgrp) is used for [32x24 Text Mode](#32x24_text_mode) and [SETMLT](#setmlt) for [Graphics Mode](#graphics_mode) and [Multicolour Mode](#multicolour_mode). Any "`BASE`" statement should therefore be immediately followed by a "`SCREEN`" statement to perform a full initialization.

<a name="7ba3h"></a>

    Address... 7BA3H

This masking table is used by the "`BASE`" statement handler to ensure that only legal VDP base addresses are accepted. The table number and corresponding Workspace Area variable are shown with each mask:

|MASK   |TABLE
|-------|----------
|03FFH  |00, [TXTNAM](#txtnam)
|003FH  |01, [TXTCOL](#txtcol)
|07FFH  |02, [TXTCGP](#txtcgp)
|007FH  |03, [TXTATR](#txtatr)
|07FFH  |04, [TXTPAT](#txtpat)
|03FFH  |05, [T32NAM](#t32nam)
|003FH  |06, [T32COL](#t32col)
|07FFH  |07, [T32CGP](#t32cgp)
|007FH  |08, [T32ATR](#t32atr)
|07FFH  |09, [T32PAT](#t32pat)
|03FFH  |10, [GRPNAM](#grpnam)
|1FFFH  |11, [GRPCOL](#grpcol)
|1FFFH  |12, [GRPCGP](#grpcgp)
|007FH  |13, [GRPATR](#grpatr)
|07FFH  |14, [GRPPAT](#grppat)
|03FFH  |15, [MLTNAM](#mltnam)
|003FH  |16, [MLTCOL](#mltcol)
|07FFH  |17, [MLTCGP](#mltcgp)
|007FH  |18, [MLTATR](#mltatr)
|07FFH  |19, [MLTPAT](#mltpat)

</a>

<a name="7bcbh"></a>

    Address... 7BCBH

This routine is used by the Factor Evaluator to apply the "`BASE`" function. The VDP table number operand, from zero to nineteen, is evaluated ([7C08H](#7c08h)) and added to [TXTNAM](#txtnam) to locate the required Workspace Area base address. This is then placed in [DAC](#dac) as a single precision number (3236H).

<a name="7be2h"></a><a name="vpoke"></a>

    Address... 7BE2H

This is the "`VPOKE`" statement handler. The VRAM address operand is evaluated ([4C64H](#4c64h)) and checked to ensure that it is less than 4000H ([7BFEH](#7bfeh)). The data operand is then evaluated (521CH) and passed to the [WRTVRM](#wrtvrm) standard routine in register A to write to the required address.

<a name="7bf5h"></a>

    Address... 7BF5H

This routine is used by the Factor Evaluator to apply the "`VPEEK`" function to an operand contained in [DAC](#dac). The VRAM address operand is checked to ensure it is less than 4000H ([7BFEH](#7bfeh)). VRAM is then read via the [RDVRM](#rdvrm) standard routine and the result placed in [DAC](#dac) as an integer (4FCFH).

<a name="7bfeh"></a>

    Address... 7BFEH

This routine converts a numeric operand in [DAC](#dac) to an integer ([2F8AH](#2f8ah)) and places it in register pair HL. If the operand is equal to or greater than 4000H, and thus outside the allowable VRAM range, an "`Illegal function call`" error is generated (475AH).

<a name="7c08h"></a>

    Address... 7C08H

This routine evaluates (521CH) a parenthesized numeric operand and returns it as an integer in register A. If the operand is greater than the maximum allowable value initially supplied in register A an "`Illegal function call`" error is generated (475AH).

<a name="7c16h"></a><a name="dsko$"></a>

    Address... 7C16H

This is the "`DSKO$`" statement handler. An "`Illegal function call`" error is generated (475AH) on a standard MSX machine.

<a name="7c1bh"></a><a name="set"></a>

    Address... 7C1BH

This is the "`SET`" statement handler. An "`Illegal function call`" error is generated (475AH) on a standard MSX machine.

<a name="7c20h"></a><a name="name"></a>

    Address... 7C20H

This is the "`NAME`" statement handler. An "`Illegal function call`" error is generated (475AH) on a standard MSX machine.

<a name="7c25h"></a><a name="kill"></a>

    Address... 7C25H

This is the "`KILL`" statement handler. An "`Illegal function call`" error is generated (475AH) on a standard MSX machine.

<a name="7c2ah"></a><a name="ipl"></a>

    Address... 7C2AH

This is the "`IPL`" statement handler. An "`Illegal function call`" error is generated (475AH) on a standard MSX machine.

<a name="7c2fh"></a><a name="copy"></a>

    Address... 7C2FH

This is the "`COPY`" statement handler. An "`Illegal function call`" error is generated (475AH) on a standard MSX machine.

<a name="7c34h"></a><a name="cmd"></a>

    Address... 7C34H

This is the "`CMD`" statement handler. An "`Illegal function call`" error is generated (475AH) on a standard MSX machine.

<a name="7c39h"></a>

    Address... 7C39H

This routine is used by the Factor Evaluator to apply the "`DSKF`" function to an operand contained in [DAC](#dac). An "`Illegal function call`" error is generated (475AH) on a standard MSX machine.

<a name="7c3eh"></a>

    Address... 7C3EH

This routine is used by the Factor Evaluator to apply the "`DSKI$`" function. An "`Illegal function call`" error is generated (475AH) on a standard MSX machine.

<a name="7c43h"></a>

    Address... 7C43H

This routine is used by the Factor Evaluator to apply the "`ATTR$`" function. An "`Illegal function call`" error is generated (475AH) on a standard MSX machine.

<a name="7c48h"></a><a name="lset"></a>

    Address... 7C48H

This is the "`LSET`" statement handler. An "`Illegal function call`" error is generated (475AH) on a standard MSX machine.

<a name="7c4dh"></a><a name="rset"></a>

    Address... 7C4DH

This is the "`RSET`" statement handler. An "`Illegal function call`" error is generated (475AH) on a standard MSX machine.

<a name="7c52h"></a><a name="field"></a>

    Address... 7C52H

This is the "`FIELD`" statement handler. An "`Illegal function call`" error is generated (475AH) on a standard MSX machine.

<a name="7c57h"></a>

    Address... 7C57H

This routine is used by the Factor Evaluator to apply the "`MKI$`" function to an operand contained in [DAC](#dac). An "`Illegal function call`" error is generated (475AH) on a standard MSX machine.

<a name="7c5ch"></a>

    Address... 7C5CH

This routine is used by the Factor Evaluator to apply the "`MKS$`" function to an operand contained in [DAC](#dac). An "`Illegal function call`" error is generated (475AH) on a standard MSX machine.

<a name="7c61h"></a>

    Address... 7C61H

This routine is used by the Factor Evaluator to apply the "`MKD$`" function to an operand contained in [DAC](#dac). An "`Illegal function call`" error is generated (475AH) on a standard MSX machine.

<a name="7c66h"></a>

    Address... 7C66H

This routine is used by the Factor Evaluator to apply the "`CVI`" function to an operand contained in [DAC](#dac). An "`Illegal function call`" error is generated (475AH) on a standard MSX machine.

<a name="7c6bh"></a>

    Address... 7C6BH

This routine is used by the Factor Evaluator to apply the "`CVS`" function to an operand contained in [DAC](#dac). An "`Illegal function call`" error is generated (475AH) on a standard MSX machine.

<a name="7c70h"></a>

    Address... 7C70H

This routine is used by the Factor Evaluator to apply the "`CVD`" function to an operand contained in [DAC](#dac). An "`Illegal function call`" error is generated (475AH) on a standard MSX machine.

<a name="7c76h"></a>

    Address... 7C76H

This routine completes the power-up initialization. At this point the entire Workspace Area is zeroed and only [EXPTBL](#exptbl) and [SLTTBL](#slttbl) have been initialized. A temporary stack is set at F376H and all one hundred and twelve hooks (560 bytes) filled with Z80 RET opcodes (C9H). [HIMEM](#himem) is set to F380H and the lowest RAM location found ([7D5DH](#7d5dh)) and placed in [BOTTOM](#bottom). The one hundred and forty-four bytes of data commencing at 7F27H are copied to the Workspace Area from F380H to F40FH The function key strings are initialized via the [INIFNK](#inifnk) standard routine, [ENDBUF](#endbuf) and [NLONLY](#nlonly) are zeroed and a comma is placed in [BUFMIN](#bufmin) and a colon in [KBFMIN](#kbfmin). The address of the MSX ROM character set is taken from locations 0004H and 0005H and placed in [CGPNT](#cgpnt)+1 and [PRMPRV](#prmprv) is set to point to [PRMSTK](#prmstk). Dummy values are placed in [STKTOP](#stktop), [MEMSIZ](#memsiz) and [VARTAB](#vartab) (their correct values are not known yet), one I/O buffer is allocated ([7E6BH](#7e6bh)) and the Z80 SP set (62E5H). A zero byte is placed at the base of RAM, [TXTTAB](#txttab) is set to the following location and a "`NEW`" executed (6287H).

The VDP is then initialized via the [INITIO](#initio), [INIT32](#init32) and [CLRSPR](#clrspr) standard routines, the cursor coordinates are set to row 11, column 10 and the sign on message "`MSX system etc.`" is displayed ([6678H](#6678h)). After a three second delay a search is carried out for any extension ROMs ([7D75H](#7d75h)) and a further "`NEW`" executed (6287H) in case a BASIC program has been run from ROM.

Finally the identification message "`MSX BASIC etc.`" is displayed ([7D29H](#7d29h)) and control transfers to the Interpreter Mainloop "`OK`" point 411FH.

<a name="7d29h"></a>

    Address... 7D29H

This routine is used during power-up to enable the function key display, place the screen in [40x24 Text Mode](#40x24_text_mode) via the [INITXT](#initxt) standard routine, and display ([6678H](#6678h)) the identification message "`MSX BASIC etc.`". The amount of free memory is then computed by subtracting the contents of [VARTAB](#vartab) from the contents of [STKTOP](#stktop) and displayed ([3412H](#3412h)) followed by the "`Bytes free`" message.

<a name="7d5dh"></a>

    Address... 7D5DH

This routine is used during power-up to find the lowest RAM location. Starting at EF00H each byte is tested until one is found that cannot be written to or an address of 8000H is reached. The base address, rounded upwards to the nearest 256 byte boundary, is returned in register pair HL.

<a name="7d75h"></a>

    Address... 7D75H

This routine is used during power-up to perform an extension ROM search. Pages 1 and 2 (4000H to BFFFH) of each slot are examined and the results placed in [SLTATR](#sltatr). An extension ROM has the two identification characters "`AB`" in the first two bytes to distinguish it from RAM. Information about its properties is also present in the first sixteen bytes as follows:

<a name="figure48"></a>![][CH05F48]

**Figure 48:** ROM Header

Each page in a given slot is examined by reading the first two bytes ([7E1AH](#7e1ah)) and checking for the "`AB`" characters. If a ROM is present the initialization address is read ([7E1AH](#7e1ah)) and control passed to it via the [CALSLT](#calslt) standard routine. With a games ROM there may be no return to BASIC from this point. The "`CALL`" extended statement handler address is then read ([7E1AH](#7e1ah)) and bit 5 of register B set if it is valid, that is non-zero. The extended device handler address is read ([7E1AH](#7e1ah)) and bit 6 of register B set if it is valid. Finally the BASIC program text address is read ([7E1AH](#7e1ah)) and bit 7 of register B set if it is valid. Register B is then copied to the relevant position in [SLTATR](#sltatr) and the search continued until no more slots remain.

[SLTATR](#sltatr) is then examined for any extension ROM flagged as containing BASIC program text. If one is found its position in [SLTATR](#sltatr) is converted to a Slot ID ([7E2AH](#7e2ah)) and the ROM permanently switched in via the [ENASLT](#enaslt) standard routine. [VARTAB](#vartab) is set to C000H, as it is not known how large the Program Text Area is, [TXTTAB](#txttab) is set to 8008H and [BASROM](#basrom) made non-zero to disable the CTRL-STOP key. The system is cleared ([629AH](#629ah)) and control transfers to the Runloop ([4601H](#4601h)) to execute the BASIC program.

<a name="7e1ah"></a>

    Address... 7E1AH

This routine is used to read two bytes from successive locations in an extension ROM. The initial address is supplied in register pair HL and the Slot ID in register C. The bytes are read via the [RDSLT](#rdslt) standard routine and returned in register pair DE. If both are zero FLAG Z is returned.

<a name="7e2ah"></a>

    Address... 7E2AH

This routine converts the [SLTATR](#sltatr) position supplied in register B into the corresponding Slot ID in register C and ROM base address in register H. The position is first modified so that it runs from 0 to 63 rather than from 64 to 1, so that the required information is present in the form:

<a name="figure49"></a>![][CH05F49]

**Figure 49**

Bits 0 and 1 are shifted into the highest two bits of register H to form the address. Bits 4 and 5 are shifted to bits 0 and 1 of register C to form the Primary Slot number. Bits 2 and 3 are shifted to bits 2 and 3 of register C to form the Secondary Slot number and bit 7 of the corresponding [EXPTBL](#exptbl) entry copied to bit 7 of register C.

<a name="7e4bh"></a><a name="maxfiles"></a>

    Address... 7E4BH

This is the "`MAXFILES`" statement handler. As control transfers here when a "`MAX`" token (CDH) is detected the program text is first checked for a trailing "`FILES`" token (B7H). The buffer count operand, from zero to fifteen, is then evaluated (521CH) and any existing buffers closed ([6C1CH](#6c1ch)). The required number of I/O buffers are allocated ([7E6BH](#7e6bh)), the system is cleared (62A7H) and control transfers directly to the Runloop ([4601H](#4601h)).

<a name="7e6bh"></a>

    Address... 7E6BH

This is the I/O buffer allocation routine. It is used during power-up and by the "`MAXFILES`" and "`CLEAR`" statement handlers to allocate storage for the number of I/O buffers supplied in register A. Two hundred and sixty-seven bytes are subtracted from the contents of [HIMEM](#himem) for every buffer to produce a new [MEMSIZ](#memsiz) value. The size of the existing String Storage Area (initially two hundred bytes) is computed by subtracting the old contents of [STKTOP](#stktop) from the old contents of [MEMSIZ](#memsiz), this is then subtracted from the new [MEMSIZ](#memsiz) value to produce the new [STKTOP](#stktop) value. A further one hundred and forty bytes are subtracted for the Z80 stack and an "`Out of memory`" error generated (6275H) if this address is lower than the start of the Variable Storage Area. Otherwise the buffer count is placed in [MAXFIL](#maxfil) and [MEMSIZ](#memsiz) and [STKTOP](#stktop) set to their new values. The caller's return address is popped, the Z80 SP set to the new position and the return address pushed back onto the stack. [FILTAB](#filtab) is then set to the start of the I/O buffer pointer block and each pointer set to point to the associated FCB. Finally the address of I/O buffer 0, the Interpreter's "`LOAD`" and "`SAVE`" buffer, is placed in [NULBUF](#nulbuf) and the routine terminates.

<a name="7ed8h"></a>

    Address... 7ED8H

This is the plain text message "`MSX system`" terminated by a zero byte

<a name="7ee4h"></a>

    Address... 7EE4H

This is the plain text message "`version 1.0`" CR,LF terminated by a zero byte.

<a name="7ef2h"></a>

    Address... 7EF2H

This is the plain text message "`MSX BASIC`" terminated by a zero byte.

<a name="7efdh"></a>

    Address... 7EFDH

This is the plain text message "`Copyright 1983 by Microsoft`" CR,LF terminated by a zero byte.

<a name="7f1bh"></a>

    Address... 7F1BH

This is the plain text message "`Bytes free`" terminated by a zero byte.

<a name="7f27h"></a>

    Address... 7F27H

This block of one hundred and forty-four data bytes is used to initialize the Workspace Area from F380H to F40FH.

<a name="7fb7h"></a>

    Address... 7FB7H

This seven byte patch fixes a bug in the external device parsing routine ([55F8H](#55f8h)). It checks for a zero length device name in register A and changes it to one if necessary.

<a name="7fbeh"></a>

    Address... 7FBEH

This section of the ROM is unused and filled with zero bytes.

<br><br><br>

<a name="chapter_6"></a>
# 6. Memory Map

A maximum of 32 KB of RAM is available to the BASIC Interpreter to hold the program text, the BASIC Variables, the Z80 stack, the I/O buffers and the internal workspace. A memory map of these areas in the power-up state is shown below:

<a name="figure50"></a>![][CH05F50]

**Figure 50:** Memory Map 8000H to FFFFH

The Program Text Area is composed of tokenized program lines stored in line number order and terminated by a zero end link, when in the "`NEW`" state only the end link is present. The zero byte at 8000H is a dummy end of line character needed to synchronize the Runloop at the start of a program.

The Variable and Array Storage Areas are composed of string or numeric Variables and Arrays stored in the order in which they are found in the program text. Execution speed improves marginally if Variables are declared before Arrays in a program as this reduces the amount of memory to be moved upwards.

The Z80 stack is positioned immediately below the String Storage Area, the structure of the stack top is shown below:

<a name="figure51"></a>![][CH05F51]

**Figure 51:** Z80 Stack Top

Whenever the position of the stack is altered, as a result of a "`CLEAR`" or "`MAXFILES`" statement, two zero bytes are first pushed to function as a terminator during "`FOR`" or "`GOSUB`" parameter block searches. Assuming no parameter blocks are present the Z80 SP will therefore be at [STKTOP](#stktop)-2 within the Interpreter Mainloop and at [STKTOP](#stktop)-4 when control transfers from the Runloop to a statement handler.

The String Storage Area is composed of the string bodies assigned to Variables or Arrays. During expression evaluation a number of intermediate string results may also be temporarily present under the permanent string heap. The zero byte following the String Storage Area is a temporary delimiter for the "`VAL`" function.

The region between the String Storage Area and [HIMEM](#himem) is used for I/O buffer storage. I/O buffer 0, the "`SAVE`" and "`LOAD`" buffer, is always present but the number of user buffers is determined by the "`MAXFILES`" statement. Each I/O buffer consists of a 9 byte FCB, whose address is contained in the table under FCB 0, followed by a 256 byte data buffer. The FCB contains the status of the I/O buffer as below:

<a name="figure52"></a>![][CH05F52]

**Figure 52:** File Control Block

The MOD byte holds the buffer mode, the DEV byte the device code, the POS byte the current position in the buffer (0 to 255) and the PPS byte the "`PRINT`" position. The remainder of the FCB is unused on a standard MSX machine.

<a name="workspace_area"></a>
## Workspace Area

The section of the Workspace Area from F380H to FD99H holds the BIOS/Interpreter variables. These are listed on the following pages in standard assembly language form:

<a name="f380h"></a><a name="rdprim"></a>
<a name="f382h"></a>
<a name="f383h"></a>

```
F380H RDPRIM: OUT (0A8H),A ; Set new Primary Slot
F382H         LD E,(HL)    ; Read memory
F383H         JR WRPRM1    ; Restore old Primary Slot
```

This routine is used by the [RDSLT](#rdslt) standard routine to switch Primary Slots and read a byte from memory. The new Primary Slot Register setting is supplied in register A, the old setting in register D and the byte read returned in register E.

<a name="f385h"></a><a name="wrprim"></a>
<a name="f387h"></a>
<a name="f388h"></a><a name="wrprm1"></a>
<a name="f389h"></a>
<a name="f38bh"></a>

```
F385H WRPRIM: OUT (0A8H),A ; Set new Primary Slot
F387H         LD (HL),E    ; Write to memory
F388H WRPRM1: LD A,D       ; Get old setting
F389H         OUT (0A8H),A ; Restore old Primary Slot
F38BH         RET
```

This routine is used by the [WRSLT](#wrslt) standard routine to switch Primary Slots and write a byte to memory. The new Primary Slot Register setting is supplied in register A, the old setting in register D and the byte to write in register E.

<a name="f38ch"></a><a name="clprim"></a>
<a name="f38eh"></a>
<a name="f38fh"></a>
<a name="f392h"></a>
<a name="f393h"></a>
<a name="f394h"></a>
<a name="f396h"></a>
<a name="f397h"></a>
<a name="f398h"></a><a name="clprm1"></a>

```
F38CH CLPRIM: OUT (0A8H),A ; Set new Primary Slot
F38EH         EX AF,AF'    ; Swap to AF for call
F38FH         CALL CLPRM1  ; Do it
F392H         EX AF,AF'    ; Swap to AF
F393H         POP AF       ; Get old setting
F394H         OUT (0A8H),A ; Restore old Primary Slot
F396H         EX AF,AF'    ; Swap to AF
F397H         RET
F398H CLPRM1: JP (IX)
```

This routine is used by the [CALSLT](#calslt) standard routine to switch Primary Slots and call an address. The new Primary Slot Register setting is supplied in register A, the old setting on the Z80 stack and the address to call in register pair IX.

<a name="f39ah"></a><a name="usrtab"></a>
<a name="f39ch"></a>
<a name="f39eh"></a>
<a name="f3a0h"></a>
<a name="f3a2h"></a>
<a name="f3a4h"></a>
<a name="f3a6h"></a>
<a name="f3a8h"></a>
<a name="f3aah"></a>
<a name="f3ach"></a>

```
F39AH USRTAB: DEFW 475AH   ; USR 0
F39CH         DEFW 475AH   ; USR 1
F39EH         DEFW 475AH   ; USR 2
F3A0H         DEFW 475AH   ; USR 3
F3A2H         DEFW 475AH   ; USR 4
F3A4H         DEFW 475AH   ; USR 5
F3A6H         DEFW 475AH   ; USR 6
F3A8H         DEFW 475AH   ; USR 7
F3AAH         DEFW 475AH   ; USR 8
F3ACH         DEFW 475AH   ; USR 9
```

These ten variables contain the "`USR`" function addresses. Their values are set to the Interpreter "`Illegal function call`" error generator at power-up and thereafter only altered by the "`DEFUSR`" statement.

<a name="f3aeh"></a><a name="linl40"></a>

    F3AEH LINL40: DEFB 37

This variable contains the [40x24 Text Mode](#40x24_text_mode) screen width. Its value is set at power-up and thereafter only altered by the "`WIDTH`" statement.

<a name="f3afh"></a><a name="linl32"></a>

    F3AFH LINL32: DEFB 29

This variable contains the [32x24 Text Mode](#32x24_text_mode) screen width. Its value is set at power-up and thereafter only altered by the "`WIDTH`" statement.

<a name="f3b0h"></a><a name="linlen"></a>

    F3B0H LINLEN: DEFB 37

This variable contains the current text mode screen width. Its value is set from [LINL40](#linl40) or [LINL32](#linl32) whenever the VDP is initialized to a text mode via the [INITXT](#initxt) or [INIT32](#init32) standard routines.

<a name="f3b1h"></a><a name="crtcnt"></a>

    F3B1H CRTCNT: DEFB 24

This variable contains the number of rows on the screen. Its value is set at power-up and thereafter unaltered.

<a name="f3b2h"></a><a name="clmlst"></a>

    F3B2H CLMLST: DEFB 14

This variable contains the minimum number of columns that must still be available on a line for a data item to be "`PRINT`"ed, if less space is available a CR,LF is issued first. Its value is set at power-up and thereafter only altered by the "`WIDTH`" and "`SCREEN`" statements.

<a name="f3b3h"></a><a name="txtnam"></a>
<a name="f3b5h"></a><a name="txtcol"></a>
<a name="f3b7h"></a><a name="txtcgp"></a>
<a name="f3b9h"></a><a name="txtatr"></a>
<a name="f3bbh"></a><a name="txtpat"></a>

```
F3B3H TXTNAM: DEFW 0000H   ; Name Table Base
F3B5H TXTCOL: DEFW 0000H   ; Colour Table Base
F3B7H TXTCGP: DEFW 0800H   ; Character Pattern Base
F3B9H TXTATR: DEFW 0000H   ; Sprite Attribute Base
F3BBH TXTPAT: DEFW 0000H   ; Sprite Pattern Base
```

These five variables contain the [40x24 Text Mode](#40x24_text_mode) VDP base addresses. Their values are set at power-up and thereafter only altered by the "`BASE`" statement.

<a name="f3bdh"></a><a name="t32nam"></a>
<a name="f3bfh"></a><a name="t32col"></a>
<a name="f3c1h"></a><a name="t32cgp"></a>
<a name="f3c3h"></a><a name="t32atr"></a>
<a name="f3c5h"></a><a name="t32pat"></a>

```
F3BDH T32NAM: DEFW 1800H   ; Name Table Base
F3BFH T32COL: DEFW 2000H   ; Colour Table Base
F3C1H T32CGP: DEFW 0000H   ; Character Pattern Base
F3C3H T32ATR: DEFW 1B00H   ; Sprite Attribute Base
F3C5H T32PAT: DEFW 3800H   ; Sprite Pattern Base
```

These five variables contain the [32x24 Text Mode](#32x24_text_mode) VDP base addresses. Their values are set at power-up and thereafter only altered by the "`BASE`" statement.

<a name="f3c7h"></a><a name="grpnam"></a>
<a name="f3c9h"></a><a name="grpcol"></a>
<a name="f3cbh"></a><a name="grpcgp"></a>
<a name="f3cdh"></a><a name="grpatr"></a>
<a name="f3cfh"></a><a name="grppat"></a>

```
F3C7H GRPNAM: DEFW 1800H   ; Name Table Base
F3C9H GRPCOL: DEFW 2000H   ; Colour Table Base
F3CBH GRPCGP: DEFW 0000H   ; Character Pattern Base
F3CDH GRPATR: DEFW 1B00H   ; Sprite Attribute Base
F3CFH GRPPAT: DEFW 3800H   ; Sprite Pattern Base
```

These five variables contain the [Graphics Mode](#graphics_mode) VDP base addresses. Their values are set at power-up and thereafter only altered by the "`BASE`" statement.

<a name="f3d1h"></a><a name="mltnam"></a>
<a name="f3d3h"></a><a name="mltcol"></a>
<a name="f3d5h"></a><a name="mltcgp"></a>
<a name="f3d7h"></a><a name="mltatr"></a>
<a name="f3d9h"></a><a name="mltpat"></a>

```
F3D1H MLTNAM: DEFW 0800H   ; Name Table Base
F3D3H MLTCOL: DEFW 0000H   ; Colour Table Base
F3D5H MLTCGP: DEFW 0000H   ; Character Pattern Base
F3D7H MLTATR: DEFW 1B00H   ; Sprite Attribute Base
F3D9H MLTPAT: DEFW 3800H   ; Sprite Pattern Base
```

These five variables contain the [Multicolour Mode](#multicolour_mode) VDP base addresses. Their values are set at power-up and thereafter only altered by the "`BASE`" statement.

<a name="f3dbh"></a><a name="cliksw"></a>

    F3DBH CLIKSW: DEFB 01H

This variable controls the interrupt handler key click: 00H=Off, NZ=On. Its value is set at power-up and thereafter only altered by the "`SCREEN`" statement.

<a name="f3dch"></a><a name="csry"></a>

    F3DCH CSRY:   DEFB 01H

This variable contains the row coordinate (from 1 to [CTRCNT](#ctrcnt)) of the text mode cursor.

<a name="f3ddh"></a><a name="csrx"></a>

    F3DDH CSRX:   DEFB 01H

This variable contains the column coordinate (from 1 to [LINLEN](#linlen)) of the text mode cursor. Note that the BIOS cursor coordinates for the home position are 1,1 whatever the screen width.

<a name="f3deh"></a><a name="cnsdfg"></a>

    F3DEH CNSDFG: DEFB FFH

This variable contains the current state of the function key display: 00H=Off, NZ=On.

<a name="f3dfh"></a><a name="rg0sav"></a>
<a name="f3e0h"></a><a name="rg1sav"></a>
<a name="f3e1h"></a><a name="rg2sav"></a>
<a name="f3e2h"></a><a name="rg3sav"></a>
<a name="f3e3h"></a><a name="rg4sav"></a>
<a name="f3e4h"></a><a name="rg5sav"></a>
<a name="f3e5h"></a><a name="rg6sav"></a>
<a name="f3e6h"></a><a name="rg7sav"></a>

```
F3DFH RG0SAV: DEFB 00H
F3E0H RG1SAV: DEFB F0H
F3E1H RG2SAV: DEFB 00H
F3E2H RG3SAV: DEFB 00H
F3E3H RG4SAV: DEFB 01H
F3E4H RG5SAV: DEFB 00H
F3E5H RG6SAV: DEFB 00H
F3E6H RG7SAV: DEFB F4H
```

These eight variables mimic the state of the eight write-only [VDP Mode Registers](#vdp_mode_registers). The values shown are for [40x24 Text Mode](#40x24_text_mode).

<a name="f3e7h"></a><a name="statfl"></a>

    F3E7H STATFL: DEFB CAH

This variable is continuously updated by the interrupt handler with the contents of the [VDP Status Register](#vdp_status_register).

<a name="f3e8h"></a><a name="trgflg"></a>

    F3E8H TRGFLG: DEFB F1H

This variable is continuously updated by the interrupt handler with the state of the four joystick trigger inputs and the space key.

<a name="f3e9h"></a><a name="forclr"></a>

    F3E9H FORCLR: DEFB 0FH     ; White

This variable contains the current foreground colour. Its value is set at power-up and thereafter only altered by the "`COLOR`" statement. The foreground colour is used by the [CLRSPR](#clrspr) standard routine to set the sprite colour and by the [CHGCLR](#chgclr) standard routine to set the 1 pixel colour in the text modes. It also functions as the graphics ink colour as it is copied to [ATRBYT](#atrbyt) by the [GRPPRT](#grpprt) standard routine and used throughout the Interpreter as the default value for any optional colour operand.

<a name="f3eah"></a><a name="bakclr"></a>

    F3EAH BAKCLR: DEFB 04H     ; Dark blue

This variable contains the current background colour. Its value is set at power-up and thereafter only altered by the "`COLOR`" statement. The background colour is used by the [CLS](#cls) standard routine to clear the screen in the graphics modes and by the [CHGCLR](#chgclr) standard routine to set the 0 pixel colour in the text modes.

<a name="f3ebh"></a><a name="bdrclr"></a>

    F3EBH BDRCLR: DEFB 04H     ; Dark blue

This variable contains the current border colour. Its value is set at power-up and thereafter only altered by the "`COLOR`" statement. The border colour is used by the [CHGCLR](#chgclr) standard routine in [32x24 Text Mode](#32x24_text_mode), [Graphics Mode](#graphics_mode) and [Multicolour Mode](#multicolour_mode) to set the border colour.

<a name="f3ech"></a><a name="maxupd"></a>
<a name="f3edh"></a>

```
F3ECH MAXUPD: DEFB C3H
F3EDH         DEFW 0000H
```

These two bytes are filled in by the "`LINE`" statement handler to form a Z80 JP to the [RIGHTC](#rightc), [LEFTC](#leftc), [UPC](#upc) or [DOWNC](#downc) standard routines.

<a name="f3efh"></a><a name="minupd"></a>
<a name="f3f0h"></a>

```
F3EFH MINUPD: DEFB C3H
F3F0H         DEFW 0000H
```

These two bytes are filled in by the "`LINE`" statement handler to form a Z80 JP to the [RIGHTC](#rightc), [LEFTC](#leftc), [UPC](#upc) or [DOWNC](#downc) standard routines.

<a name="f3f2h"></a><a name="atrbyt"></a>

    F3F2H ATRBYT: DEFB 0FH

This variable contains the graphics ink colour used by the [SETC](#setc) and [NSETCX](#nsetcx) standard routines.

<a name="f3f3h"></a><a name="queues"></a>

    F3F3H QUEUES: DEFW F959H

This variable contains the address of the control blocks for the three music queues. Its value is set at power-up and thereafter unaltered.

<a name="f3f5h"></a><a name="frcnew"></a>

    F3F5H FRCNEW: DEFB FFH

This variable contains a flag to distinguish the two statements in the "`CLOAD/CLOAD?`" statement handler: 00H=CLOAD, FFH=CLOAD?.

<a name="f3f6h"></a><a name="scncnt"></a>

    F3F6H SCNCNT: DEFB 01H

This variable is used as a counter by the interrupt handler to control the rate at which keyboard scans are performed.

<a name="f3f7h"></a><a name="repcnt"></a>

    F3F7H REPCNT: DEFB 01H

This variable is used as a counter by the interrupt handler to control the key repeat rate.

<a name="f3f8h"></a><a name="putpnt"></a>

    F3F8H PUTPNT: DEFW FBF0H

This variable contains the address of the put position in [KEYBUF](#keybuf).

<a name="f3fah"></a><a name="getpnt"></a>

    F3FAH GETPNT: DEFW FBF0H

This variable contains the address of the get position in [KEYBUF](#keybuf).

<a name="f3fch"></a><a name="cs1200"></a>
<a name="f3fdh"></a>
<a name="f3feh"></a>
<a name="f3ffh"></a>
<a name="f400h"></a>

```
F3FCH CS1200: DEFB 53H     ; LO cycle 1st half
F3FDH         DEFB 5CH     ; LO cycle 2nd half
F3FEH         DEFB 26H     ; HI cycle 1st half
F3FFH         DEFB 2DH     ; HI cycle 2nd half
F400H         DEFB 0FH     ; Header cycle count
```

These five variables contain the 1200 baud cassette parameters. Their values are set at power-up and thereafter unaltered.

<a name="f401h"></a><a name="cs2400"></a>
<a name="f402h"></a>
<a name="f403h"></a>
<a name="f404h"></a>
<a name="f405h"></a>

```
F401H CS2400: DEFB 25H     ; LO cycle 1st half
F402H         DEFB 2DH     ; LO cycle 2nd half
F403H         DEFB 0EH     ; HI cycle 1st half
F404H         DEFB 16H     ; HI cycle 2nd half
F405H         DEFB 1FH     ; Header cycle count
```

These five variables contain the 2400 baud cassette parameters. Their values are set at power-up and thereafter unaltered.

<a name="f406h"></a><a name="low"></a>
<a name="f407h"></a>
<a name="f408h"></a><a name="high"></a>
<a name="f409h"></a>
<a name="f40ah"></a><a name="header"></a>

```
F406H LOW:    DEFB 53H     ; LO cycle 1st half
F407H         DEFB 5CH     ; LO cycle 2nd half
F408H HIGH:   DEFB 26H     ; HI cycle 1st half
F409H         DEFB 2DH     ; HI cycle 2nd half
F40AH HEADER: DEFB 0FH     ; Header cycle count
```

These five variables contain the current cassette parameters. Their values are set to 1200 baud at power-up and thereafter only altered by the "`CSAVE`" and "`SCREEN`" statements.

<a name="f40bh"></a><a name="aspct1"></a>

    F40BH ASPCT1: DEFW 0100H

This variable contains the reciprocal of the default "`CIRCLE`" aspect ratio multiplied by 256. Its value is set at power-up and thereafter unaltered.

<a name="f40dh"></a><a name="aspct2"></a>

    F40DH ASPCT2: DEFW 01C0H

This variable contains the default "`CIRCLE`" aspect ratio multiplied by 256. Its value is set at power-up and thereafter unaltered. The aspect ratio is present in two forms so that the "`CIRCLE`" statement handler can select the appropriate one immediately rather than needing to examine and possibly reciprocate it as is the case with an operand in the program text.

<a name="f40fh"></a><a name="endprg"></a>
<a name="f410h"></a>
<a name="f411h"></a>
<a name="f412h"></a>
<a name="f413h"></a>

```
F40FH ENDPRG: DEFB ":"
F410H         DEFB 00H
F411H         DEFB 00H
FE12H         DEFB 00H
F413H         DEFB 00H
```

These five bytes form a dummy program line. Their values are set at power-up and thereafter unaltered. The line exists in case an error occurs in the Interpreter Mainloop before any tokenized text is available in [KBUF](#kbuf). If an "`ON ERROR GOTO`" is active at this time then it provides some text for the "`RESUME`" statement to terminate on.

<a name="f414h"></a><a name="errflg"></a>

    F414H ERRFLG: DEFB 00H

This variable is used by the Interpreter error handler to save the error number.

<a name="f415h"></a><a name="lptpos"></a>

    F415H LPTPOS: DEFB 00H

This variable is used by the "`LPRINT`" statement handler to hold the current position of the printer head.

<a name="f416h"></a><a name="prtflg"></a>

    F416H PRTFLG: DEFB 00H

This variable determines whether the [OUTDO](#outdo) standard routine directs its output to the screen or to the printer: 00H=Screen, 01H=Printer.

<a name="f417h"></a><a name="ntmsxp"></a>

    F417H NTMSXP: DEFB 00H

This variable determines whether the [OUTDO](#outdo) standard routine will replace headered graphics characters directed to the printer with spaces: 00H=Graphics, NZ=Spaces. Its value is set at power-up and thereafter only altered by the "`SCREEN`" statement.

<a name="f418h"></a><a name="rawprt"></a>

    F418H RAWPRT: DEFB 00H

This variable determines whether the [OUTDO](#outdo) standard routine will modify control and headered graphics characters directed to the printer: 00H=Modify, NZ=Raw. Its value is set at power-up and thereafter unaltered.

<a name="f419h"></a><a name="vlzadr"></a>
<a name="f41bh"></a><a name="vlzdat"></a>

```
F419H VLZADR: DEFW 0000H
F41BH VLZDAT: DEFB 00H
```

These variables contain the address and value of any character temporarily removed by the "`VAL`" function.

<a name="f41ch"></a><a name="curlin"></a>

    F41CH CURLIN: DEFW FFFFH

This variable contains the current Interpreter line number. A value of FFFFH denotes direct mode.

<a name="f41eh"></a><a name="kbfmin"></a>

    F41EH KBFMIN: DEFB ":"

This byte provides a dummy prefix to the tokenized text contained in [KBUF](#kbuf). Its function is similar to that of [ENDPRG](#endprg) but is used for the situation where an error occurs within a direct statement.

<a name="f41fh"></a><a name="kbuf"></a>

    F41FH KBUF:   DEFS 318

This buffer contains the tokenized form of the input line collected by the Interpreter Mainloop. When a direct statement is executed the contents of this buffer form the program text.

<a name="f55dh"></a><a name="bufmin"></a>

    F55DH BUFMIN: DEFB ","

This byte provides a dummy prefix to the text contained in [BUF](#buf). It is used to synchronize the "`INPUT`" statement handler as it starts to analyze the input text.

<a name="f55eh"></a><a name="buf"></a>

    F55EH BUF:    DEFS 259

This buffer contains the text collected from the console by the [INLIN](#inlin) standard routine.

<a name="f661h"></a><a name="ttypos"></a>

    F661H TTYPOS: DEFB 00H

This variable is used by the "`PRINT`" statement handler to hold the current screen position (Teletype!).

<a name="f662h"></a><a name="dimflg"></a>

    F662H DIMFLG: DEFB 00H

This variable is normally zero but is set by the "`DIM`" statement handler to control the operation of the variable search routine.

<a name="f663h"></a><a name="valtyp"></a>

    F663H VALTYP: DEFB 02H

This variable contains the type code of the operand currently contained in [DAC](#dac): integer, 3=String, 4=Single Precision, 8=Double Precision.

<a name="f664h"></a><a name="dores"></a>

    F664H DORES:  DEFB 00H

This variable is normally zero but is set to prevent the tokenization of unquoted keywords following a "`DATA`" token.

<a name="f665h"></a><a name="donum"></a>

    F665H DONUM:  DEFB 00H

This variable is normally zero but is set when a numeric constant follows one of the keywords `GOTO`, `GOSUB`, `THEN`, etc., and must be tokenized to the special line number operand form.

<a name="f666h"></a><a name="contxt"></a>

    F666H CONTXT: DEFW 0000H

This variable is used by the [CHRGTR](#chrgtr) standard routine to save the address of the character following a numeric constant in the program text.

<a name="f668h"></a><a name="consav"></a>

    F668H CONSAV: DEFB 00H

This variable is used by the [CHRGTR](#chrgtr) standard routine to save the token of a numeric constant found in the program text.

<a name="f669h"></a><a name="contyp"></a>

    F669H CONTYP: DEFB 00H

This variable is used by the [CHRGTR](#chrgtr) standard routine to save the type of a numeric constant found in the program text.

<a name="f66ah"></a><a name="conlo"></a>

    F66AH CONLO:  DEFS 8

This buffer is used by the [CHRGTR](#chrgtr) standard routine to save the value of a numeric constant found in the program text.

<a name="f672h"></a><a name="memsiz"></a>

    F672H MEMSIZ: DEFW F168H

This variable contains the address of the top of the String Storage Area. Its value is set at power-up and thereafter only altered by the "`CLEAR`" and "`MAXFILES`" statements.

<a name="f674h"></a><a name="stktop"></a>

    F674H STKTOP: DEFW F0A0H

This variable contains the address of the top of the Z80 stack. Its value is set at power-up to [MEMSIZ](#memsiz)-200 and thereafter only altered by the "`CLEAR`" and "`MAXFILES`" statements.

<a name="f676h"></a><a name="txttab"></a>

    F676H TXTTAB: DEFW 8001H

This variable contains the address of the first byte of the Program Text Area. Its value is set at power-up and thereafter unaltered.

<a name="f678h"></a><a name="temppt"></a>

    F678H TEMPPT: DEFW F67AH

This variable contains the address of the next free location in [TEMPST](#tempst).

<a name="f67ah"></a><a name="tempst"></a>

    F67AH TEMPST: DEFS 30

This buffer is used to store string descriptors. It functions as a stack with string producers pushing their results and string consumers popping them.

<a name="f698h"></a><a name="dsctmp"></a>

    F698H DSCTMP: DEFS 3

This buffer is used by the string functions to hold a result descriptor while it is being constructed.

<a name="f69bh"></a><a name="fretop"></a>

    F69BH FRETOP: DEFW F168H

This variable contains the address of the next free location in the String Storage Area. When the area is empty [FRETOP](#fretop) is equal to [MEMSIZ](#memsiz).

<a name="f69dh"></a><a name="temp3"></a>

    F69DH TEMP3: DEFW 0000H

This variable is used for temporary storage by various parts of the Interpreter.

<a name="f69fh"></a><a name="temp8"></a>

    F69FH TEMP8:  DEFW 0000H

This variable is used for temporary storage by various parts of the Interpreter.

<a name="f6a1h"></a><a name="endfor"></a>

    F6A1H ENDFOR: DEFW 0000H

This variable is used by the "`FOR`" statement handler to hold the end of statement address during construction of a parameter block.

<a name="f6a3h"></a><a name="datlin"></a>

    F6A3H DATLIN: DEFW 0000H

This variable contains the line number of the current "`DATA`" item in the program text.

<a name="f6a5h"></a><a name="subflg"></a>

    F6A5H SUBFLG: DEFB 00H

This variable is normally zero but is set by the "`ERASE`", "`FOR`", "`FN`" and "`DEF FN`" handlers to control the processing of subscripts by the variable search routine.

<a name="f6a6h"></a><a name="flginp"></a>

    F6A6H FLGINP: DEFB 00H

This variable contains a flag to distinguish the two statements in the "`READ/INPUT`" statement handler: 00H=INPUT, NZ=READ.

<a name="f6a7h"></a><a name="temp"></a>

    F6A7H TEMP:   DEFW 0000H

This variable is used for temporary storage by various parts of the Interpreter.

<a name="f6a9h"></a><a name="ptrflg"></a>

    F6A9H PTRFLG: DEFB 00H

This variable is normally zero but is set if any line number operands in the Program Text Area have been converted to pointers.

<a name="f6aah"></a><a name="autflg"></a>

    F6AAH AUTFLG: DEFB 00H

This variable is normally zero but is set when "`AUTO`" mode is turned on.

<a name="f6abh"></a><a name="autlin"></a>

    F6ABH AUTLIN: DEFW 0000H

This variable contains the current "`AUTO`" line number.

<a name="f6adh"></a><a name="autinc"></a>

    F6ADH AUTINC: DEFW 0000H

This variable contains the current "`AUTO`" line number increment.

<a name="f6afh"></a><a name="savtxt"></a>

    F6AFH SAVTXT: DEFW 0000H

This variable is updated by the Runloop at the start of every statement with the current location in the program text. It is used during error recovery to set [ERRTXT](#errtxt) for the "`RESUME`" statement handler and [OLDTXT](#oldtxt) for the "`CONT`" statement handler.

<a name="f6b1h"></a><a name="savstk"></a>

    F6B1H SAVSTK: DEFW F09EH

This variable is updated by the Runloop at the start of every statement with the current Z80 SP for error recovery purposes.

<a name="f6b3h"></a><a name="errlin"></a>

    F6B3H ERRLIN: DEFW 0000H

This variable is used by the error handler to hold the line number of the program line generating an error.

<a name="f6b5h"></a><a name="dot"></a>

    F6B5H DOT:    DEFW 0000H

This variable is updated by the Mainloop and the error handler with the current line number for use with the "." parameter.

<a name="f6b7h"></a><a name="errtxt"></a>

    F6B7H ERRTXT: DEFW 0000H

This variable is updated from [SAVTXT](#savtxt) by the error handler for use by the "`RESUME`" statement handler.

<a name="f6b9h"></a><a name="onelin"></a>

    F6B9H ONELIN: DEFW 0000H

This variable is set by the "`ON ERROR GOTO`" statement handler with the address of the program line to execute when an error occurs.

<a name="f6bbh"></a><a name="oneflg"></a>

    F6BBH ONEFLG: DEFB 00H

This variable is normally zero but is set by the error handler when control transfers to an "`ON ERROR GOTO`" statement. This is to prevent a loop developing if an error occurs inside the error recovery statements.

<a name="f6bch"></a><a name="temp2"></a>

    F6BCH TEMP2:  DEFW 0000H

This variable is used for temporary storage by various parts of the Interpreter.

<a name="f6beh"></a><a name="oldlin"></a>

    F6BEH OLDLIN: DEFW 0000H

This variable contains the line number of the terminating program line. It is set by the "`END`" and "`STOP`" statement handlers for use with the "`CONT`" statement.

<a name="f6c0h"></a><a name="oldtxt"></a>

    F6C0H OLDTXT: DEFW 0000H

This variable contains the address of the terminating program statement.

<a name="f6c2h"></a><a name="vartab"></a>

    F6C2H VARTAB: DEFW 8003H

This variable contains the address of the first byte of the Variable Storage Area.

<a name="f6c4h"></a><a name="arytab"></a>

    F6C4H ARYTAB: DEFW 8003H

This variable contains the address of the first byte of the Array Storage Area.

<a name="f6c6h"></a><a name="strend"></a>

    F6C6H STREND: DEFW 8003H

This variable contains the address of the byte following the Array Storage Area.

<a name="f6c8h"></a><a name="datptr"></a>

    F6C8H DATPTR: DEFW 8000H

This variable contains the address of the current "`DATA`" item in the program text.

<a name="f6cah"></a><a name="deftbl"></a>
<a name="f6cbh"></a>
<a name="f6cch"></a>
<a name="f6cdh"></a>
<a name="f6ceh"></a>
<a name="f6cfh"></a>
<a name="f6d0h"></a>
<a name="f6d1h"></a>
<a name="f6d2h"></a>
<a name="f6d3h"></a>
<a name="f6d4h"></a>
<a name="f6d5h"></a>
<a name="f6d6h"></a>
<a name="f6d7h"></a>
<a name="f6d8h"></a>
<a name="f6d9h"></a>
<a name="f6dah"></a>
<a name="f6dbh"></a>
<a name="f6dch"></a>
<a name="f6ddh"></a>
<a name="f6deh"></a>
<a name="f6dfh"></a>
<a name="f6e0h"></a>
<a name="f6e1h"></a>
<a name="f6e2h"></a>
<a name="f6e3h"></a>

```
F6CAH DEFTBL: DEFB 08H     ; A
F6CBH         DEFB 08H     ; B
F6CCH         DEFB 08H     ; C
F6CDH         DEFB 08H     ; D
F6CEH         DEFB 08H     ; E
F6CFH         DEFB 08H     ; F
F6D0H         DEFB 08H     ; G
F6D1H         DEFB 08H     ; H
F6D2H         DEFB 08H     ; I
F6D3H         DEFB 08H     ; J
F6D4H         DEFB 08H     ; K
F6D5H         DEFB 08H     ; L
F6D6H         DEFB 08H     ; M
F6D7H         DEFB 08H     ; N
F6D8H         DEFB 08H     ; O
F6D9H         DEFB 08H     ; P
F6DAH         DEFB 08H     ; Q
F6DBH         DEFB 08H     ; R
F6DCH         DEFB 08H     ; S
F6DDH         DEFB 08H     ; T
F6DEH         DEFB 08H     ; U
F6DFH         DEFB 08H     ; V
F6E0H         DEFB 08H     ; W
F6E1H         DEFB 08H     ; X
F6E2H         DEFB 08H     ; Y
F6E3H         DEFB 08H     ; Z
```

These twenty-six variables contain the default type for each group of BASIC Variables. Their values are set to double precision at power-up, "`NEW`" and "`CLEAR`" and thereafter altered only by the "`DEF`" group of statements.

<a name="f6e4h"></a><a name="prmstk"></a>

    F6E4H PRMSTK: DEFW 0000H

This variable contains the base address of the previous "`FN`" parameter block on the Z80 stack. It is used during string garbage collection to travel from block to block on the stack.

<a name="f6e6h"></a><a name="prmlen"></a>

    F6E6H PRMLEN: DEFW 0000H

This variable contains the length of the current "`FN`" parameter block in [PARM1](#parm1).

<a name="f6e8h"></a><a name="parm1"></a>

    F6E8H PARM1 : DEFS 100

This buffer contains the local Variables belonging to the "`FN`" function currently being evaluated.

<a name="f74ch"></a><a name="prmprv"></a>

    F74CH PRMPRV: DEFW F6E4H

This variable contains the address of the previous "`FN`" parameter block. It is actually a constant used to ensure that string garbage collection commences with the current parameter block before proceeding to those on the stack.

<a name="f74eh"></a><a name="prmln2"></a>

    F74EH PRMLN2: DEFW 0000H

This variable contains the length of the "`FN`" parameter block being constructed in [PARM2](#parm2)

<a name="f750h"></a><a name="parm2"></a>

    F750H PARM2:  DEFS 100

This buffer is used to construct the local Variables owned by the current "`FN`" function.

<a name="f7b4h"></a><a name="prmflg"></a>

    F7B4H PRMFLG: DEFB 00H

This variable is used during a Variable search to indicate whether local or global Variables are being examined.

<a name="f7b5h"></a><a name="aryta2"></a>

    F7B5H ARYTA2: DEFW 0000H

This variable is used during a Variable search to hold the termination address of the storage area being examined.

<a name="f7b7h"></a><a name="nofuns"></a>

    F7B7H NOFUNS: DEFB 00H

This variable is normally zero but is set by the "`FN`" function handler to indicate to the variable search routine that local Variables are present.

<a name="f7b8h"></a><a name="temp9"></a>

    F7B8H TEMP9:  DEFW 0000H

This variable is used for temporary storage by various parts of the Interpreter.

<a name="f7bah"></a><a name="funact"></a>

    F7BAH FUNACT: DEFW 0000H

This variable contains the number of currently active "`FN`" functions.

<a name="f7bch"></a><a name="swptmp"></a>

    F7BCH SWPTMP: DEFS 8

This buffer is used to hold the first operand in a "`SWAP`" statement.

<a name="f7c4h"></a><a name="trcflg"></a>

    F7C4H TRCFLG: DEFB 00H

This variable is normally zero but is set by the "`TRON`" statement handler to turn on the trace facility.

<a name="f7c5h"></a><a name="fbuffr"></a>

    F7C5H FBUFFR: DEFS 43

This buffer is used to hold the text produced during numeric output conversion.

<a name="f7f0h"></a><a name="dectmp"></a>

    F7F0H DECTMP: DEFW 0000H

This variable is used for temporary storage by the double precision division routine.

<a name="f7f2h"></a><a name="dectm2"></a>

    F7F2H DECTM2: DEFW 0000H

This variable is used for temporary storage by the double precision division routine.

<a name="f7f4h"></a><a name="deccnt"></a>

    F7F4H DECCNT: DEFB 00H

This variable is used by the double precision division routine to hold the number of non-zero bytes in the mantissa of the second operand.

<a name="f7f6h"></a><a name="dac"></a>

    F7F6H DAC:    DEFS 16

This buffer functions as the Interpreter's primary accumulator during expression evaluation.

<a name="f806h"></a><a name="hold8"></a>

    F806H HOLD8:  DEFS 65

This buffer is used by the double precision multiplication routine to hold the multiples of the first operand.

<a name="f847h"></a><a name="arg"></a>

    F847H ARG:    DEFS 16

This buffer functions as the Interpreter's secondary accumulator during expression evaluation.

<a name="f857h"></a><a name="rndx"></a>

    F857H RNDX:   DEFS 8

This buffer contains the current double precision random number.

<a name="f85fh"></a><a name="maxfil"></a>

    F85FH MAXFIL: DEFB 01H

This variable contains the number of currently allocated user I/O buffers. Its value is set to 1 at power-up and thereafter only altered by the "`MAXFILES`" statement.

<a name="f860h"></a><a name="filtab"></a>

    F860H FILTAB: DEFW F16AH

This variable contains the address of the pointer table for the I/O buffer FCBs.

<a name="f862h"></a><a name="nulbuf"></a>

    F862H NULBUF: DEFW F177H

This variable contains the address of the first byte of the data buffer belonging to I/O buffer 0.

<a name="f864h"></a><a name="ptrfil"></a>

    F864H PTRFIL: DEFW 0000H

This variable contains the address of the currently active I/O buffer FCB.

<a name="f866h"></a><a name="filnam"></a>

    F866H FILNAM: DEFS 11

This buffer holds a user-specified filename. It is eleven characters long to allow for disc file specs such as "`FILENAME.BAS`".

<a name="f871h"></a><a name="filnm2"></a>

    F871H FILNM2: DEFS 11

This buffer holds a filename read from an I/O device for comparison with the contents of [FILNAM](#filnam).

<a name="f87ch"></a><a name="nlonly"></a>

    F87CH NLONLY: DEFB 00H

This variable is normally zero but is set during a program "`LOAD`". Bit 0 is used to prevent I/O buffer 0 being closed during loading and bit 7 to prevent the user I/O buffers being closed if auto-run is required.

<a name="f87dh"></a><a name="savend"></a>

    F87DH SAVEND: DEFW 0000H

This variable is used by the "`BSAVE`" statement handler to hold the end address of the memory block to be saved.

<a name="f87fh"></a><a name="fnkstr"></a>

    F87FH FNKSTR: DEFS 160

This buffer contains the ten sixteen-character function key strings. Their values are set at power-up and thereafter only altered by the "`KEY`" statement.

<a name="f91fh"></a><a name="cgpnt"></a>
<a name="f920h"></a>

```
F91FH CGPNT:  DEFB 00H     ; Slot ID
F920H         DEFW 1BBFH   ; Address
```

These variables contain the location of the character set copied to the VDP by the [INITXT](#initxt) and [INIT32](#init32) standard routines. Their values are set to the MSX ROM character set at power-up and thereafter unaltered.

<a name="f922h"></a><a name="nambas"></a>

    F922H NAMBAS: DEFW 0000H

This variable contains the current text mode VDP Name Table base address. Its value is set from [TXTNAM](#txtnam) or [T32NAM](#t32nam) whenever the VDP is initialized to a text mode via the [INITXT](#initxt) or [INIT32](#init32) standard routines.

<a name="f924h"></a><a name="cgpbas"></a>

    F924H CGPBAS: DEFW 0800H

This variable contains the current text mode VDP Character Pattern Table base address. Its value is set from [TXTCGP](#txtcgp) or [T32CGP](#t32cgp) whenever the VDP is initialized to a text mode via the [INITXT](#initxt) or [INIT32](#init32) standard routines.

<a name="f926h"></a><a name="patbas"></a>

    F926H PATBAS: DEFW 3800H

This variable contains the current VDP Sprite Pattern Table base address. Its value is set from [T32PAT](#t32pat), [GRPPAT](#grppat) or [MLTPAT](#mltpat) whenever the VDP is initialized via the [INIT32](#init32), [INIGRP](#inigrp) or [INIMLT](#inimlt) standard routines.

<a name="f928h"></a><a name="atrbas"></a>

    F928H ATRBAS: DEFW 1B00H

This variable contains the current VDP Sprite Attribute Table base address. Its value is set from [T32ATR](#t32atr), [GRPATR](#grpatr) or [MLTATR](#mltatr) whenever the VDP is initialized via the [INIT32](#init32), [INIGRP](#inigrp) or [INIMLT](#inimlt) standard routines.

<a name="f92ah"></a><a name="cloc"></a>
<a name="f92ch"></a><a name="cmask"></a>

```
F92AH CLOC:   DEFW 0000H   ; Pixel location
F92CH CMASK:  DEFB 80H     ; Pixel Mask
```

These variables contain the current pixel physical address used by the [RIGHTC](#rightc), [LEFTC](#leftc), [UPC](#upc), [TUPC](#tupc), [DOWNC](#downc), [TDOWNC](#tdownc), [FETCHC](#fetchc), [STOREC](#storec), [READC](#readc), [SETC](#setc), [NSETCX](#nsetcx), [SCANR](#scanr) and [SCANL](#scanl) standard routines. [CLOC](#cloc) holds the address of the byte containing the current pixel and [CMASK](#cmask) defines the pixel within that byte.

<a name="f92dh"></a><a name="mindel"></a>

    F92DH MINDEL: DEFW 0000H

This variable is used by the "`LINE`" statement handler to hold the minimum difference between the end points of the line.

<a name="f92fh"></a><a name="maxdel"></a>

    F92FH MAXDEL: DEFW 0000H

This variable is used by the "`LINE`" statement handler to hold the maximum difference between the end points of the line.

<a name="f931h"></a><a name="aspect"></a>

    F931H ASPECT: DEFW 0000H

This variable is used by the "`CIRCLE`" statement handler to hold the current aspect ratio. This is stored as a single byte binary fraction so an aspect ratio of 0.75 would become 00C0H. The MSB is only required if the aspect ratio is exactly 1.00, that is 0100H.

<a name="f933h"></a><a name="cencnt"></a>

    F933H CENCNT: DEFW 0000H

This variable is used by the "`CIRCLE`" statement handler to hold the point count of the end angle.

<a name="f935h"></a><a name="clinef"></a>

    F935H CLINEF: DEFB 00H

This variable is used by the "`CIRCLE`" statement handler to hold the two line flags. Bit 0 is set if a line is required from the start angle to the centre and bit 7 set if one is required from the end angle.

<a name="f936h"></a><a name="cnpnts"></a>

    F936H CNPNTS: DEFW 0000H

This variable is used by the "`CIRCLE`" statement handler to hold the number of points within a forty-five degree segment.

<a name="f938h"></a><a name="cplotf"></a>

    F938H CPLOTF: DEFB 00H

This variable is normally zero but is set by the "`CIRCLE`" statement handler if the end angle is smaller than the start angle. It is used to determine whether the pixels should be set "inside" the angles or "outside" them.

<a name="f939h"></a><a name="cpcnt"></a>

    F939H CPCNT:  DEFW 0000H

This variable is used by the "`CIRCLE`" statement handler to hold the point count within the current forty-five degree segment, this is in fact the Y coordinate.

<a name="f93bh"></a><a name="cpcnt8"></a>

    F93BH CPCNT8: DEFW 0000H

This variable is used by the "`CIRCLE`" statement handler to hold the total point count of the present position.

<a name="f93dh"></a><a name="crcsum"></a>

    F93DH CRCSUM: DEFW 0000H

This variable is used by the "`CIRCLE`" statement handler as the point computation counter.

<a name="f93fh"></a><a name="cstcnt"></a>

    F93FH CSTCNT: DEFW 0000H

This variable is used by the "`CIRCLE`" statement handler to hold the point count of the start angle.

<a name="f941h"></a><a name="csclxy"></a>

    F941H CSCLXY: DEFB 00H

This variable is used by the "`CIRCLE`" statement handler as a flag to determine in which direction the elliptic squash is to be applied: 00H=Y, 01H=X.

<a name="f942h"></a><a name="csavea"></a>

    F942H CSAVEA: DEFW 0000H

This variable is used for temporary storage by the [SCANR](#scanr) standard routine.

<a name="f944h"></a><a name="csavem"></a>

    F944H CSAVEM: DEFB 00h

This variable is used for temporary storage by the [SCANR](#scanr) standard routine.

<a name="f945h"></a><a name="cxoff"></a>

    F945H CXOFF:  DEFW 0000H

This variable is used for temporary storage by the "`CIRCLE`" statement handler.

<a name="f947h"></a><a name="cyoff"></a>

    F947H CYOFF:  DEFW 0000H

This variable is used for temporary storage by the "`CIRCLE`" statement handler.

<a name="f949h"></a><a name="lohmsk"></a>

    F949H LOHMSK: DEFB 00H

This variable is used by the "`PAINT`" statement handler to hold the leftmost position of a LH excursion.

<a name="f94ah"></a><a name="lohdir"></a>

    F94AH LOHDIR: DEFB 00H

This variable is used by the "`PAINT`" statement handler to hold the new paint direction required by a LH excursion.

<a name="f94bh"></a><a name="lohadr"></a>

    F94BH LOHADR: DEFW 0000H

This variable is used by the "`PAINT`" statement handler to hold the leftmost position of a LH excursion.

<a name="f94dh"></a><a name="lohcnt"></a>

    F94DH LOHCNT: DEFW 0000H

This variable is used by the "`PAINT`" statement handler to hold the size of a LH excursion.

<a name="f94fh"></a><a name="skpcnt"></a>

    F94FH SKPCNT: DEFW 0000H

This variable is used by the "`PAINT`" statement handler to hold the skip count returned by the [SCANR](#scanr) standard routine.

<a name="f951h"></a><a name="movcnt"></a>

    F951H MOVCNT: DEFW 0000H

This variable is used by the "`PAINT`" statement handler to hold the movement count returned by the [SCANR](#scanr) standard routine.

<a name="f953h"></a><a name="pdirec"></a>

    F953H PDIREC: DEFB 00H

This variable is used by the "`PAINT`" statement handler to hold the current paint direction: 40H=Down, C0H=Up, 00H=Terminate.

<a name="f954h"></a><a name="lfprog"></a>

    F954H LFPROG: DEFB 00H

This variable is normally zero but is set by the "`PAINT`" statement handler if there has been any leftwards progress.

<a name="f955h"></a><a name="rtprog"></a>

    F955H RTPROG: DEFB 00H

This variable is normally zero but is set by the "`PAINT`" statement handler if there has been any rightwards progress.

<a name="f956h"></a><a name="mcltab"></a>

    F956H MCLTAB: DEFW 0000H

This variable contains the address of the command table to be used by the macro language parser. The "`DRAW`" table is at 5D83H and the "`PLAY`" table at 752EH.

<a name="f958h"></a><a name="mclflg"></a>

    F958H MCLFLG: DEFB 00H

This variable is zero if the macro language parser is being used by the "`DRAW`", statement handler and non-zero if it is being used by "`PLAY`".

<a name="f959h"></a><a name="quetab"></a>
<a name="f95ah"></a>
<a name="f95bh"></a>
<a name="f95ch"></a>
<a name="f95dh"></a>
<a name="f95fh"></a>
<a name="f960h"></a>
<a name="f961h"></a>
<a name="f962h"></a>
<a name="f963h"></a>
<a name="f965h"></a>
<a name="f966h"></a>
<a name="f967h"></a>
<a name="f968h"></a>
<a name="f969h"></a>
<a name="f96bh"></a>
<a name="f96ch"></a>
<a name="f96dh"></a>
<a name="f96eh"></a>
<a name="f96fh"></a>

```
F959H QUETAB: DEFB 00H     ; AQ Put position
F95AH         DEFB 00H     ; AQ Get position
F95BH         DEFB 00H     ; AQ Putback flag
F95CH         DEFB 7FH     ; AQ Size
F95DH         DEFW F975H   ; AQ Address

F95FH         DEFB 00H     ; BQ Put position
F960H         DEFB 00H     ; BQ Get position
F961H         DEFB 00H     ; BQ Putback flag
F962H         DEFB 7FH     ; BQ Size
F963H         DEFW F9F5H   ; BQ Address

F965H         DEFB 00H     ; CQ Put position
F966H         DEFB 00H     ; CQ Get position
F967H         DEFB 00H     ; CQ Putback flag
F968H         DEFB 7FH     ; CQ Size
F969H         DEFW FA75H   ; CQ Address

F96BH         DEFB 00H     ; RQ Put position
F96CH         DEFB 00H     ; RQ Get position
F96DH         DEFB 00H     ; RQ Putback flag
F96EH         DEFB 00H     ; RQ Size
F96FH         DEFW 0000H   ; RQ Address
```

These twenty-four variables form the control blocks for the three music queues ([VOICAQ](#voicaq), [VOICBQ](#voicbq) and [VOICCQ](#voiccq)) and the RS232 queue. The three music control blocks are initialized by the [GICINI](#gicini) standard routine and thereafter maintained by the interrupt handler and the [PUTQ](#putq) standard routine. The RS232 control block is unused in the current MSX ROM.

<a name="f971h"></a><a name="quebak"></a>
<a name="f972h"></a>
<a name="f973h"></a>
<a name="f974h"></a>

```
F971H QUEBAK: DEFB 00H     ; AQ Putback character
F972H         DEFB 00H     ; BQ Putback character
F973H         DEFB 00H     ; CQ Putback character
F974H         DEFB 00H     ; RQ Putback character
```

These four variables are used to hold any unwanted character returned to the associated queue. Although the putback facility is implemented in the MSX ROM it is currently unused.

<a name="f975h"></a><a name="voicaq"></a>
<a name="f9f5h"></a><a name="voicbq"></a>
<a name="fa75h"></a><a name="voiccq"></a>
<a name="faf5h"></a><a name="rs2iq"></a>

```
F975H VOICAQ: DEFS 128     ; Voice A queue
F9F5H VOICBQ: DEFS 128     ; Voice B queue
FA75H VOICCQ: DEFS 128     ; Voice C queue
FAF5H RS2IQ:  DEFS 64      ; RS232 queue
```

These four buffers contain the three music queues and the RS232 queue, the latter is unused.

<a name="fb35h"></a><a name="prscnt"></a>

    FB35H PRSCNT: DEFB 00H

This variable is used by the "`PLAY`" statement handler to count the number of completed operand strings. Bit 7 is also set after each of the three operands has been parsed to prevent repeated activation of the [STRTMS](#strtms) standard routine.

<a name="fb36h"></a><a name="savsp"></a>

    FB36H SAVSP: DEFW 0000H

This variable is used by the "`PLAY`" statement handler to save the Z80 SP before control transfers to the macro language parser. Its value is compared with the SP on return to determine whether any data has been left on the stack because of a queue-full termination by the parser.

<a name="fb38h"></a><a name="voicen"></a>

    FB38H VOICEN: DEFB 00H

This variable contains the current voice number being processed by the "`PLAY`" statement handler. The values 0, 1 and 2 correspond to PSG channels A, B and C.

<a name="fb39h"></a><a name="savvol"></a>

    FB39H SAVVOL: DEFW 0000H

This variable is used by the "`PLAY`" statement "`R`" command handler to save the current volume setting while a zero-amplitude rest is generated.

<a name="fb3bh"></a><a name="mcllen"></a>

    FB3BH MCLLEN: DEFB 00H

This variable is used by the macro language parser to hold the length of the string operand being parsed.

<a name="fb3ch"></a><a name="mclptr"></a>

    FB3CH MCLPTR: DEFW 0000H

This variable is used by the macro language parser to hold the address of the string operand being parsed.

<a name="fb3eh"></a><a name="queuen"></a>

    FB3EH QUEUEN: DEFB 00H

This variable is used by the interrupt handler to hold the number of the music queue currently being processed. The values 0, 1 and 2 correspond to PSG channels A, B and C.

<a name="fb3fh"></a><a name="musicf"></a>

    FB3FH MUSICF: DEFB 00H

This variable contains three bit flags set by the [STRTMS](#strtms) standard routine to initiate processing of a music queue by the interrupt handler. Bits 0, 1 and 2 correspond to [VOICAQ](#voicaq), [VOICBQ](#voicbq) and [VOICCQ](#voiccq).

<a name="fb40h"></a><a name="plycnt"></a>

    FB40H PLYCNT: DEFB 00H

This variable is used by the [STRTMS](#strtms) standard routine to hold the number of "`PLAY`" statement sequences currently held in the music queues. It is examined when all three end of queue marks have been found for one sequence to determine whether dequeueing should be restarted.

<a name="fb41h"></a><a name="vcba"></a>
<a name="fb43h"></a>
<a name="fb44h"></a>
<a name="fb46h"></a>
<a name="fb48h"></a>
<a name="fb49h"></a>
<a name="fb50h"></a>
<a name="fb51h"></a>
<a name="fb52h"></a>
<a name="fb53h"></a>
<a name="fb54h"></a>
<a name="fb56h"></a>

```
FB41H VCBA:   DEFW 0000H   ; Duration counter
FB43H         DEFB 00H     ; String length
FB44H         DEFW 0000H   ; String address
FB46H         DEFW 0000H   ; Stack data address
FB48H         DEFB 00H     ; Music packet length
FB49H         DEFS 7       ; Music packet
FB50H         DEFB 04H     ; Octave
FB51H         DEFB 04H     ; Length
FB52H         DEFB 78H     ; Tempo
FB53H         DEFB 88H     ; Volume
FB54H         DEFW 00FFH   ; Envelope period
FB56H         DEFS 16      ; Space for stack data
```

This thirty-seven byte buffer is used by the "`PLAY`" statement handler to hold the current parameters for voice A.

<a name="fb66h"></a><a name="vcbb"></a>

    FB66H VCBB:   DEFS 37

This buffer is used by the "`PLAY`" statement handler to hold the current parameters for voice B, its structure is the same as [VCBA](#vcba).

<a name="fb8bh"></a><a name="vcbc"></a>

    FB8BH VCBC:   DEFS 37

This buffer is used by the "`PLAY`" statement handler to hold the current parameters for voice C, its structure is the same as [VCBA](#vcba).

<a name="fbb0h"></a><a name="enstop"></a>

    FBB0H ENSTOP: DEFB 00H

This variable determines whether the interrupt handler will execute a warm start to the Interpreter upon detecting the keys CODE, GRAPH, CTRL and SHIFT depressed together: 00H=Disable, NZ=Enable.

<a name="fbb1h"></a><a name="basrom"></a>

    FBB1H BASROM: DEFB 00H

This variable determines whether the [ISCNTC](#iscntc) and [INLIN](#inlin) standard routines will respond to the CTRL-STOP key: 00H=Enable, NZ=Disable. It is used to prevent termination of a BASIC ROM located during the power-up ROM search.

<a name="fbb2h"></a><a name="linttb"></a>

    FBB2H LINTTB: DEFS 24

Each of these twenty-four variables is normally non-zero but is zeroed if the contents of the corresponding screen row have overflowed onto the next row. They are maintained by the BIOS but only actually used by the [INLIN](#inlin) standard routine (the screen editor) to discriminate between logical and physical lines.

<a name="fbcah"></a><a name="fstpos"></a>

    FBCAH FSTPOS: DEFW 0000H

This variable is used to hold the cursor coordinates upon entry to the [INLIN](#inlin) standard routine. Its function is to restrict the extent of backtracking performed when the text is collected from the screen at termination.

<a name="fbcch"></a><a name="cursav"></a>

    FBCCH CURSAV: DEFB 00H

This variable is used to hold the screen character replaced by the text cursor.

<a name="fbcdh"></a><a name="fnkswi"></a>

    FBCDH FNKSWI: DEFB 00H

This variable is used by the [CHSNS](#chsns) standard routine to determine whether the shifted or unshifted function keys are currently displayed: 00H=Shifted, 01H=Unshifted.

<a name="fbceh"></a><a name="fnkflg"></a>

    FBCEH FNKFLG: DEFS 10

Each of these ten variables is normally zero but is set to 01H if the associated function key has been turned on by a "`KEY(n) ON`" statement. They are used by the interrupt handler to determine whether, in program mode only, it should return a character string or update the associated entry in [TRPTBL](#trptbl).

<a name="fbd8h"></a><a name="ongsbf"></a>

    FBD8H ONGSBF: DEFB 00H

This variable is normally zero but is incremented by the interrupt handler whenever a device has achieved the conditions necessary to generate a program interrupt. It is used by the Runloop to determine whether any program interrupts are pending without having to search [TRPTBL](#trptbl).

<a name="fbd9h"></a><a name="clikfl"></a>

    FBD9H CLIKFL: DEFB 00H

This variable is used internally by the interrupt handler to prevent spurious key clicks when returning multiple characters from a single key depression such as a function key.

<a name="fbdah"></a><a name="oldkey"></a>

    FBDAH OLDKEY: DEFS 11

This buffer is used by the interrupt handler to hold the previous state of the keyboard matrix, each byte contains one row of keys starting with row 0.

<a name="fbe5h"></a><a name="newkey"></a>

    FBE5H NEWKEY: DEFS 11

This buffer is used by the interrupt handler to hold the current state of the keyboard matrix. Key transitions are detected by comparison with the contents of [OLDKEY](#oldkey) after which [OLDKEY](#oldkey) is updated with the current state.

<a name="fbf0h"></a><a name="keybuf"></a>

    FBF0H KEYBUF: DEFS 40

This buffer contains the decoded keyboard characters produced by the interrupt handler. Note that the buffer is organized as a circular queue driven by [GETPNT](#getpnt) and [PUTPNT](#putpnt) and consequently has no fixed starting point.

<a name="fc18h"></a><a name="linwrk"></a>

    FC18H LINWRK: DEFS 40

This buffer is used by the BIOS to hold a complete line of screen characters.

<a name="fc40h"></a><a name="patwrk"></a>

    FC40H PATWRK: DEFS 8

This buffer is used by the BIOS to hold an 8x8 pixel pattern.

<a name="fc48h"></a><a name="bottom"></a>

    FC48H BOTTOM: DEFW 8000H

This variable contains the address of the lowest RAM location used by the Interpreter. Its value is set at power-up and thereafter unaltered.

<a name="fc4ah"></a><a name="himem"></a>

    FC4AH HIMEM:  DEFW F380H

This variable contains the address of the byte following the highest RAM location used by the Interpreter. Its value is set at power-up and thereafter only altered by the "`CLEAR`" statement.

<a name="fc4ch"></a><a name="trptbl"></a>
<a name="fc4fh"></a>
<a name="fc52h"></a>
<a name="fc55h"></a>
<a name="fc58h"></a>
<a name="fc5bh"></a>
<a name="fc5eh"></a>
<a name="fc61h"></a>
<a name="fc64h"></a>
<a name="fc67h"></a>
<a name="fc6ah"></a>
<a name="fc6dh"></a>
<a name="fc70h"></a>
<a name="fc73h"></a>
<a name="fc76h"></a>
<a name="fc79h"></a>
<a name="fc7ch"></a>
<a name="fc7fh"></a>
<a name="fc82h"></a>
<a name="fc85h"></a>
<a name="fc88h"></a>
<a name="fc8bh"></a>
<a name="fc8eh"></a>
<a name="fc91h"></a>
<a name="fc94h"></a>
<a name="fc97h"></a>

```
FC4CH TRPTBL: DEFS 3       ; KEY 1
FC4FH         DEFS 3       ; KEY 2
FC52H         DEFS 3       ; KEY 3
FC55H         DEFS 3       ; KEY 4
FC58H         DEFS 3       ; KEY 5
FC5BH         DEFS 3       ; KEY 6
FC5EH         DEFS 3       ; KEY 7
FC61H         DEFS 3       ; KEY 8
FC64H         DEFS 3       ; KEY 9
FC67H         DEFS 3       ; KEY 10
FC6AH         DEFS 3       ; STOP
FC6DH         DEFS 3       ; SPRITE
FC70H         DEFS 3       ; STRIG 0
FC73H         DEFS 3       ; STRIG 1
FC76H         DEFS 3       ; STRIG 2
FC79H         DEFS 3       ; STRIG 3
FC7CH         DEFS 3       ; STRIG 4
FC7FH         DEFS 3       ; INTERVAL
FC82H         DEFS 3       ; Unused
FC85H         DEFS 3       ; Unused
FC88H         DEFS 3       ; Unused
FC8BH         DEFS 3       ; Unused
FC8EH         DEFS 3       ; Unused
FC91H         DEFS 3       ; Unused
FC94H         DEFS 3       ; Unused
FC97H         DEFS 3       ; Unused
```

These twenty-six three byte variables hold the current state of the interrupt generating devices. The first byte of each entry contains the device status (bit 0=On, bit 1=Stop, bit 2=Event active) and is updated by the interrupt handler, the Runloop interrupt processor and the "`DEVICE 0=ON/OFF/STOP`" and "`RETURN`" statement handlers. The remaining two bytes of each entry are set by the "`ON DEVICE GOSUB`" statement handler and contain the address of the program line to execute upon a program interrupt.

<a name="fc9ah"></a><a name="rtycnt"></a>

    FC9AH RTYCNT: DEFB 00H

This variable is unused by the current MSX ROM.

<a name="fc9bh"></a><a name="intflg"></a>

    FC9BH INTFLG: DEFB 00H

This variable is normally zero but is set to 03H or 04H if the CTRL-STOP or STOP keys are detected by the interrupt handler.

<a name="fc9ch"></a><a name="pady"></a>

    FC9CH PADY:   DEFB 00H

This variable contains the Y coordinate of the last point detected by a touchpad.

<a name="fc9dh"></a><a name="padx"></a>

    FC9DH PADX:   DEFB 00H

This variable contains the X coordinate of the last point detected by a touchpad.

<a name="fc9eh"></a><a name="jiffy"></a>

    FC9EH JIFFY:  DEFW 0000H

This variable is continually incremented by the interrupt handler. Its value may be set or read by the "`TIME`" statement or function.

<a name="fca0h"></a><a name="intval"></a>

    FCA0H INTVAL: DEFW 0000H

This variable holds the interval duration set by the "`ON INTERVAL`" statement handler.

<a name="fca2h"></a><a name="intcnt"></a>

    FCA2H INTCNT: DEFW 0000H

This variable is continually decremented by the interrupt handler. When zero is reached its value is reset from [INTVAL](#intval) and, if applicable, a program interrupt generated. Note that this variable always counts irrespective of whether an "`INTERVAL ON`" statement is active.

<a name="fca4h"></a><a name="lowlim"></a>

    FCA4H LOWLIM: DEFB 31H

This variable is used to hold the minimum allowable start bit duration as determined by the [TAPION](#tapion) standard routine.

<a name="fca5h"></a><a name="winwid"></a>

    FCA5H WINWID: DEFB 22H

This variable is used to hold the LO/HI cycle discrimination duration as determined by the [TAPION](#tapion) standard routine.

<a name="fca6h"></a><a name="grphed"></a>

    FCA6H GRPHED: DEFB 00H

This variable is normally zero but is set to 01H by the [CNVCHR](#cnvchr) standard routine upon detection of a graphic header code.

<a name="fca7h"></a><a name="esccnt"></a>

    FCA7H ESCCNT: DEFB 00H

This variable is used by the [CHPUT](#chput) standard routine ESC sequence processor to count escape parameters.

<a name="fca8h"></a><a name="insflg"></a>

    FCA8H INSFLG: DEFB 00H

This variable is normally zero but is set to FFH by the [INLIN](#inlin) standard routine when insert mode is on.

<a name="fca9h"></a><a name="csrsw"></a>

    FCA9H CSRSW:  DEFB 00H

If this variable is zero the cursor is only displayed while the [CHGET](#chget) standard routine is waiting for a keyboard character. If it is non-zero the cursor is permanently displayed via the [CHPUT](#chput) standard routine.

<a name="fcaah"></a><a name="cstyle"></a>

    FCAAH CSTYLE: DEFB 00H

This variable determines the cursor style: 00H=Block, NZ=Underline.

<a name="fcabh"></a><a name="capst"></a>

    FCABH CAPST:  DEFB 00H

This variable is used by the interrupt handler to hold the current caps lock status: 00H=Off, NZ=On.

<a name="fcach"></a><a name="kanast"></a>

    FCACH KANAST: DEFB 00H

This variable is used to hold the keyboard Kana lock status on Japanese machines and the DEAD key status on European machines.

<a name="fcadh"></a><a name="kanamd"></a>

    FCADH KANAMD: DEFB 00H

This variable holds a keyboard mode on Japanese machines only.

<a name="fcaeh"></a><a name="flbmem"></a>

    FCAEH FLBMEM: DEFB 00H

This variable is set by the file I/O error generators but is otherwise unused.

<a name="fcafh"></a><a name="scrmod"></a>

    FCAFH SCRMOD: DEFB 00H

This variable contains the current screen mode: 0=[40x24 Text Mode](#40x24_text_mode), 1=[32x24 Text Mode](#32x24_text_mode), 2=[Graphics Mode](#graphics_mode), 3=[Multicolour Mode](#multicolour_mode).

<a name="fcb0h"></a><a name="oldscr"></a>

    FCB0H OLDSCR: DEFB 00H

This variable holds the screen mode of the last text mode set.

<a name="fcb1h"></a><a name="casprv"></a>

    FCB1H CASPRV: DEFB 00H

This variable is used to hold any character returned to an I/O buffer by the cassette putback function.

<a name="fcb2h"></a><a name="bdratr"></a>

    FCB2H BDRATR: DEFB 00H

This variable contains the boundary colour for the "`PAINT`" statement handler. Its value is set by the [PNTINI](#pntini) standard routine and used by the [SCANR](#scanr) and [SCANL](#scanl) standard routines.

<a name="fcb3h"></a><a name="gxpos"></a>

    FCB3H GXPOS:  DEFW 0000H

This variable is used for temporary storage of a graphics X coordinate.

<a name="fcb5h"></a><a name="gypos"></a>

    FCB5H GYPOS:  DEFW 0000H

This variable is used for temporary storage of a graphics Y coordinate.

<a name="fcb7h"></a><a name="grpacx"></a>

    FCB7H GRPACX: DEFW 0000H

This variable contains the current graphics X coordinate for the [GRPPRT](#grpprt) standard routine.

<a name="fcb9h"></a><a name="grpacy"></a>

    FCB9H GRPACY: DEFW 0000H

This variable contains the current graphics Y coordinate for the [GRPPRT](#grpprt) standard routine.

<a name="fcbbh"></a><a name="drwflg"></a>

    FCBBH DRWFLG: DEFB 00H

Bits 6 and 7 of this variable are set by the "`DRAW`" statement "`N`" and "`B`" command handlers to turn the associated mode on.

<a name="fcbch"></a><a name="drwscl"></a>

    FCBCH DRWSCL: DEFB 00H

This variable is used by the "`DRAW`" statement "`S`" command handler to hold the current scale factor.

<a name="fcbdh"></a><a name="drwang"></a>

    FCBDH DRWANG: DEFB 00H

This variable is used by the "`DRAW`" statement "`A`" command handler to hold the current angle.

<a name="fcbeh"></a><a name="runbnf"></a>

    FCBEH RUNBNF: DEFB 00H

This variable is normally zero but is set by the "`BLOAD`" statement handler when an auto-run "`R`" parameter is specified.

<a name="fcbfh"></a><a name="savent"></a>

    FCBFH SAVENT: DEFW 0000H

This variable contains the "`BSAVE`" and "`BLOAD`" entry address.

<a name="fcc1h"></a><a name="exptbl"></a>
<a name="fcc2h"></a>
<a name="fcc3h"></a>
<a name="fcc4h"></a>

```
FCC1H EXPTBL: DEFB 00H     ; Primary Slot 0
FCC2H         DEFB 00H     ; Primary Slot 1
FCC3H         DEFB 00H     ; Primary Slot 2
FCC4H         DEFB 00H     ; Primary Slot 3
```

Each of these four variables is normally zero but is set to 80H during the power-up RAM search if the associated Primary Slot is found to be expanded.

<a name="fcc5h"></a><a name="slttbl"></a>
<a name="fcc6h"></a>
<a name="fcc7h"></a>
<a name="fcc8h"></a>

```
FCC5H SLTTBL: DEFB 00H     ; Primary Slot 0
FCC6H         DEFB 00H     ; Primary Slot 1
FCC7H         DEFB 00H     ; Primary Slot 2
FCC8H         DEFB 00H     ; Primary Slot 3
```

These four variables duplicate the contents of the four possible Secondary Slot Registers. The contents of each variable should only be regarded as valid if [EXPTBL](#exptbl) shows the associated Primary Slot to be expanded.

<a name="fcc9h"></a><a name="sltatr"></a>
<a name="fccdh"></a>
<a name="fcd1h"></a>
<a name="fcd5h"></a>
<a name="fcd9h"></a>
<a name="fcddh"></a>
<a name="fce1h"></a>
<a name="fce5h"></a>
<a name="fce9h"></a>
<a name="fcedh"></a>
<a name="fcf1h"></a>
<a name="fcf5h"></a>
<a name="fcf9h"></a>
<a name="fcfdh"></a>
<a name="fd01h"></a>
<a name="fd05h"></a>

```
FCC9H SLTATR: DEFS 4       ; PS0, SS0
FCCDH         DEFS 4       ; PS0, SS1
FCD1H         DEFS 4       ; PS0, SS2
FCD5H         DEFS 4       ; PS0, SS3

FCD9H         DEFS 4       ; PS1, SS0
FCDDH         DEFS 4       ; PS1, SS1
FCE1H         DEFS 4       ; PS1, SS2
FCE5H         DEFS 4       ; PS1, SS3

FCE9H         DEFS 4       ; PS2, SS0
FCEDH         DEFS 4       ; PS2, SS1
FCF1H         DEFS 4       ; PS2, SS2
FCF5H         DEFS 4       ; PS2, SS3

FCF9H         DEFS 4       ; PS3, SS0
FCFDH         DEFS 4       ; PS3, SS1
FD01H         DEFS 4       ; PS3, SS2
FD05H         DEFS 4       ; PS3, SS3
```

These sixty-four variables contain the attributes of any extension ROMs found during the power-up ROM search. The characteristics of each 16 KB ROM are encoded into a single byte so four bytes are required for each possible slot. The encoding is:

```
Bit 7 set=BASIC program
Bit 6 set=Device handler
Bit 5 set=Statement handler
```

Note that the entries for page 0 (0000H to 3FFFH) and page 3 (C000H to FFFFH) will always be zero as only page 1 (4000H to 7FFFH) and page 2 (8000H to BFFFH) are actually examined. The MSX convention is that machine code extension ROMs are placed in page 1 and BASIC program ROMs in page 2.

<a name="fd09h"></a><a name="sltwrk"></a>

    FD09H SLTWRK: DEFS 128

This buffer provides two bytes of local workspace for each of the sixty-four possible extension ROMs.

<a name="fd89h"></a><a name="procnm"></a>

    FD89H PROCNM: DEFS 16

This buffer is used to hold a device or statement name for examination by an extension ROM.

<a name="fd99h"></a><a name="device"></a>

    FD99H DEVICE: DEFB 00H

This variable is used to pass a device code, from 0 to 3, to an extension ROM.

<a name="the_hooks"></a>
## The Hooks

The section of the Workspace Area from FD9AH to FFC9H contains one hundred and twelve hooks, each of which is filled with five Z80 RET opcodes at power-up. These are called from strategic locations within the BIOS/Interpreter so that the ROM can be extended, particularly so that it can be upgraded to Disk BASIC. Each hook has sufficient room to hold a far call to any slot:

```
RST 30H
DEFB Slot ID
DEFW Address
RET
```

The hooks are listed on the following pages together with the address they are called from and a brief note as to their function.

|ADDRESS                    |NAME   |SIZE   |FROM           |FUNCTION|
|---------------------------|-------|-------|---------------|---------------------------------|
|<a name="fd9ah"></a>FD9AH  |HKEYI: |DEFS 5 |0C4AH          |Interrupt handler|
|<a name="fd9fh"></a>FD9FH  |HTIMI: |DEFS 5 |0C53H          |Interrupt handler|
|<a name="fda4h"></a>FDA4H  |HCHPU: |DEFS 5 |08C0H          |[CHPUT](#chput) standard routine|
|<a name="fda9h"></a>FDA9H  |HDSPC: |DEFS 5 |09E6H          |Display cursor|
|<a name="fdaeh"></a>FDAEH  |HERAC: |DEFS 5 |0A33H          |Erase cursor|
|<a name="fdb3h"></a>FDB3H  |HDSPF: |DEFS 5 |0B2BH          |[DSPFNK](#dspfnk) standard routine|
|<a name="fdb8h"></a>FDB8H  |HERAF: |DEFS 5 |0B15H          |[ERAFNK](#erafnk) standard routine|
|<a name="fdbdh"></a>FDBDH  |HTOTE: |DEFS 5 |0842H          |[TOTEXT](#totext) standard routine|
|<a name="fdc2h"></a>FDC2H  |HCHGE: |DEFS 5 |10CEH          |[CHGET](#chget) standard routine|
|<a name="fdc7h"></a>FDC7H  |HINIP: |DEFS 5 |071EH          |Copy character set to VDP|
|<a name="fdcch"></a>FDCCH  |HKEYC: |DEFS 5 |1025H          |Keyboard decoder|
|<a name="fdd1h"></a>FDD1H  |HKYEA: |DEFS 5 |0F10H          |Keyboard decoder|
|<a name="fdd6h"></a>FDD6H  |HNMI:  |DEFS 5 |1398H          |[NMI](#nmi) standard routine|
|<a name="fddbh"></a>FDDBH  |HPINL: |DEFS 5 |23BFH          |[PINLIN](#pinlin) standard routine|
|<a name="fde0h"></a>FDE0H  |HQINL: |DEFS 5 |23CCH          |[QINLIN](#qinlin) standard routine|
|<a name="fde5h"></a>FDE5H  |HINLI: |DEFS 5 |23D5H          |[INLIN](#inlin) standard routine|
|<a name="fdeah"></a>FDEAH  |HONGO: |DEFS 5 |7810H          |"`ON DEVICE GOSUB`"|
|<a name="fdefh"></a>FDEFH  |HDSKO: |DEFS 5 |7C16H          |"`DSKO$`"|
|<a name="fdf4h"></a>FDF4H  |HSETS: |DEFS 5 |7C1BH          |"`SET`"|
|<a name="fdf9h"></a>FDF9H  |HNAME: |DEFS 5 |7C20H          |"`NAME`"|
|<a name="fdfeh"></a>FDFEH  |HKILL: |DEFS 5 |7C25H          |"`KILL`"|
|<a name="fe03h"></a>FE03H  |HIPL:  |DEFS 5 |7C2AH          |"`IPL`"|
|<a name="fe08h"></a>FE08H  |HCOPY: |DEFS 5 |7C2FH          |"`COPY`"|
|<a name="fe0dh"></a>FE0DH  |HCMD:  |DEFS 5 |7C34H          |"`CMD`"|
|<a name="fe12h"></a>FE12H  |HDSKF: |DEFS 5 |7C39H          |"`DSKF`"|
|<a name="fe17h"></a>FE17H  |HDSKI: |DEFS 5 |7C3EH          |"`DSKI$`"|
|<a name="fe1ch"></a>FE1CH  |HATTR: |DEFS 5 |7C43H          |"`ATTR$`"|
|<a name="fe21h"></a>FE21H  |HLSET: |DEFS 5 |7C48H          |"`LSET`"|
|<a name="fe26h"></a>FE26H  |HRSET: |DEFS 5 |7C4DH          |"`RSET`"|
|<a name="fe2bh"></a>FE2BH  |HFIEL: |DEFS 5 |7C52H          |"`FIELD`"|
|<a name="fe30h"></a>FE30H  |HMKI$: |DEFS 5 |7C57H          |"`MKI$`"|
|<a name="fe35h"></a>FE35H  |HMKS$: |DEFS 5 |7C5CH          |"`MKS$`"|
|<a name="fe3ah"></a>FE3AH  |HMKD$: |DEFS 5 |7C61H          |"`MKD$`"|
|<a name="fe3fh"></a>FE3FH  |HCVI:  |DEFS 5 |7C66H          |"`CVI`"|
|<a name="fe44h"></a>FE44H  |HCVS:  |DEFS 5 |7C6BH          |"`CVS`"|
|<a name="fe49h"></a>FE49H  |HCVD:  |DEFS 5 |7C70H          |"`CVD`"|
|<a name="fe4eh"></a>FE4EH  |HGETP: |DEFS 5 |6A93H          |Locate FCB|
|<a name="fe53h"></a>FE53H  |HSETF: |DEFS 5 |6AB3H          |Locate FCB|
|<a name="fe58h"></a>FE58H  |HNOFO: |DEFS 5 |6AF6H          |"`OPEN`"|
|<a name="fe5dh"></a>FE5DH  |HNULO: |DEFS 5 |6B0FH          |"`OPEN`"|
|<a name="fe62h"></a>FE62H  |HNTFL: |DEFS 5 |6B3BH          |Close I/O buffer 0|
|<a name="fe67h"></a>FE67H  |HMERG: |DEFS 5 |6B63H          |"`MERGE/LOAD`"|
|<a name="fe6ch"></a>FE6CH  |HSAVE: |DEFS 5 |6BA6H          |"`SAVE`"|
|<a name="fe71h"></a>FE71H  |HBINS: |DEFS 5 |6BCEH          |"`SAVE`"|
|<a name="fe76h"></a>FE76H  |HBINL: |DEFS 5 |6BD4H          |"`MERGE/LOAD`"|
|<a name="fe7bh"></a>FE7BH  |HFILE: |DEFS 5 |6C2FH          |"`FILES`"|
|<a name="fe80h"></a>FE80H  |HDGET: |DEFS 5 |6C3BH          |"`GET/PUT`"|
|<a name="fe85h"></a>FE85H  |HFILO: |DEFS 5 |6C51H          |Sequential output|
|<a name="fe8ah"></a>FE8AH  |HINDS: |DEFS 5 |6C79H          |Sequential input|
|<a name="fe8fh"></a>FE8FH  |HRSLF: |DEFS 5 |6CD8H          |"`INPUT$`"|
|<a name="fe94h"></a>FE94H  |HSAVD: |DEFS 5 |6D03H, 6D14H   |"`LOC`", "`LOF`",|
|                           |       |       |6D25H, 6D39H   |"`EOF`", "`FPOS`"|
|<a name="fe99h"></a>FE99H  |HLOC:  |DEFS 5 |6D0FH          |"`LOC`"|
|<a name="fe9eh"></a>FE9EH  |HLOF:  |DEFS 5 |6D20H          |"`LOF`"|
|<a name="fea3h"></a>FEA3H  |HEOF:  |DEFS 5 |6D33H          |"`EOF`"|
|<a name="fea8h"></a>FEA8H  |HFPOS: |DEFS 5 |6D43H          |"`FPOS`"|
|<a name="feadh"></a>FEADH  |HBAKU: |DEFS 5 |6E36H          |"`LINE INPUT#`"|
|<a name="feb2h"></a>FEB2H  |HPARD: |DEFS 5 |6F15H          |Parse device name|
|<a name="feb7h"></a>FEB7H  |HNODE: |DEFS 5 |6F33H          |Parse device name|
|<a name="febch"></a>FEBCH  |HPOSD: |DEFS 5 |6F37H          |Parse device name|
|<a name="fec1h"></a>FEC1H  |HDEVN: |DEFS 5 |               |This hook is not used.|
|<a name="fec6h"></a>FEC6H  |HGEND: |DEFS 5 |6F8FH          |I/O function dispatcher|
|<a name="fecbh"></a>FECBH  |HRUNC: |DEFS 5 |629AH          |Run-clear|
|<a name="fed0h"></a>FED0H  |HCLEA: |DEFS 5 |62A1H          |Run-clear|
|<a name="fed5h"></a>FED5H  |HLOPD: |DEFS 5 |62AFH          |Run-clear|
|<a name="fedah"></a>FEDAH  |HSTKE: |DEFS 5 |62F0H          |Reset stack|
|<a name="fedfh"></a>FEDFH  |HISFL: |DEFS 5 |145FH          |[ISFLIO](#isflio) standard routine |
|<a name="fee4h"></a>FEE4H  |HOUTD: |DEFS 5 |1B46H          |[OUTDO](#outdo) standard routine|
|<a name="fee9h"></a>FEE9H  |HCRDO: |DEFS 5 |7328H          |CR,LF to [OUTDO](#outdo)|
|<a name="feeeh"></a>FEEEH  |HDSKC: |DEFS 5 |7374H          |Mainloop line input|
|<a name="fef3h"></a>FEF3H  |HDOGR: |DEFS 5 |593CH          |Line draw|
|<a name="fef8h"></a>FEF8H  |HPRGE: |DEFS 5 |4039H          |Program end|
|<a name="fefdh"></a>FEFDH  |HERRP: |DEFS 5 |40DCH          |Error handler|
|<a name="ff02h"></a>FF02H  |HERRF: |DEFS 5 |40FDH          |Error handler|
|<a name="ff07h"></a>FF07H  |HREAD: |DEFS 5 |4128H          |Mainloop "`OK`"|
|<a name="ff0ch"></a>FF0CH  |HMAIN: |DEFS 5 |4134H          |Mainloop|
|<a name="ff11h"></a>FF11H  |HDIRD: |DEFS 5 |41A8H          |Mainloop direct statement|
|<a name="ff16h"></a>FF16H  |HFINI: |DEFS 5 |4237H          |Mainloop finished|
|<a name="ff1bh"></a>FF1BH  |HFINE: |DEFS 5 |4247H          |Mainloop finished|
|<a name="ff20h"></a>FF20H  |HCRUN: |DEFS 5 |42B9H          |Tokenize|
|<a name="ff25h"></a>FF25H  |HCRUS: |DEFS 5 |4353H          |Tokenize|
|<a name="ff2ah"></a>FF2AH  |HISRE: |DEFS 5 |437CH          |Tokenize|
|<a name="ff2fh"></a>FF2FH  |HNTFN: |DEFS 5 |43A4H          |Tokenize|
|<a name="ff34h"></a>FF34H  |HNOTR: |DEFS 5 |44EBH          |Tokenize|
|<a name="ff39h"></a>FF39H  |HSNGF: |DEFS 5 |45D1H          |"`FOR`"|
|<a name="ff3eh"></a>FF3EH  |HNEWS: |DEFS 5 |4601H          |Runloop new statement|
|<a name="ff43h"></a>FF43H  |HGONE: |DEFS 5 |4646H          |Runloop execute|
|<a name="ff48h"></a>FF48H  |HCHRG: |DEFS 5 |4666H          |[CHRGTR](#chrgtr) standard routine|
|<a name="ff4dh"></a>FF4DH  |HRETU: |DEFS 5 |4821H          |"`RETURN`"|
|<a name="ff52h"></a>FF52H  |HPRTF: |DEFS 5 |4A5EH          |"`PRINT`"|
|<a name="ff57h"></a>FF57H  |HCOMP: |DEFS 5 |4A54H          |"`PRINT`"|
|<a name="ff5ch"></a>FF5CH  |HFINP: |DEFS 5 |4AFFH          |"`PRINT`"|
|<a name="ff61h"></a>FF61H  |HTRMN: |DEFS 5 |4B4DH          |"`READ/INPUT`" error|
|<a name="ff66h"></a>FF66H  |HFRME: |DEFS 5 |4C6DH          |Expression Evaluator|
|<a name="ff6bh"></a>FF6BH  |HNTPL: |DEFS 5 |4CA6H          |Expression Evaluator|
|<a name="ff70h"></a>FF70H  |HEVAL: |DEFS 5 |4DD9H          |Factor Evaluator|
|<a name="ff75h"></a>FF75H  |HOKNO: |DEFS 5 |4F2CH          |Factor Evaluator|
|<a name="ff7ah"></a>FF7AH  |HFING: |DEFS 5 |4F3EH          |Factor Evaluator|
|<a name="ff7fh"></a>FF7FH  |HISMI: |DEFS 5 |51C3H          |Runloop execute|
|<a name="ff84h"></a>FF84H  |HWIDT: |DEFS 5 |51CCH          |"`WIDTH`"|
|<a name="ff89h"></a>FF89H  |HLIST: |DEFS 5 |522EH          |"`LIST`"|
|<a name="ff8eh"></a>FF8EH  |HBUFL: |DEFS 5 |532DH          |Detokenize|
|<a name="ff93h"></a>FF93H  |HFRQI: |DEFS 5 |543FH          |Convert to integer|
|<a name="ff98h"></a>FF98H  |HSCNE: |DEFS 5 |5514H          |Line number to pointer|
|<a name="ff9dh"></a>FF9DH  |HFRET: |DEFS 5 |67EEH          |Free descriptor|
|<a name="ffa2h"></a>FFA2H  |HPTRG: |DEFS 5 |5EA9H          |Variable search|
|<a name="ffa7h"></a>FFA7H  |HPHYD: |DEFS 5 |148AH          |[PHYDIO](#phydio) standard routine|
|<a name="ffach"></a>FFACH  |HFORM: |DEFS 5 |148EH          |[FORMAT](#format) standard routine|
|<a name="ffb1h"></a>FFB1H  |HERRO: |DEFS 5 |406FH          |Error handler|
|<a name="ffb6h"></a>FFB6H  |HLPTO: |DEFS 5 |085DH          |[LPTOUT](#lptout) standard routine|
|<a name="ffbbh"></a>FFBBH  |HLPTS: |DEFS 5 |0884H          |[LPTSTT](#lptstt) standard routine|
|<a name="ffc0h"></a>FFC0H  |HSCRE: |DEFS 5 |79CCH          |"`SCREEN`"|
|<a name="ffc5h"></a>FFC5H  |HPLAY: |DEFS 5 |73E5H          |"`PLAY`" statement|

</a>

The Workspace Area from FFCAH to FFFFH is unused. (on MSX 1)

<br><br><br>

<a name="chapter_7"></a>
# 7. Machine Code Programs

This chapter contains a number of machine code programs to illustrate the use of MSX system resources. Although prepared with the ZEN Assembler they are designed t o run from BASIC and if necessary, may be entered in hex form using the loader shown below. The code should then be saved on cassette before any attempt is made to run it.

```
10 CLEAR 200,&HE000
20 ADDR=&HE000
30 PRINT RIGHT$ ("000"+HEX$(ADDR),4);
40 INPUT D$
50 POKE ADDR,VAL("&H"+D$)
60 ADDR=ADDR+l
70 GOTO 30
```

All the programs start at address E000H and are entered at the same point. Unless stated otherwise no parameter need be passed to a program, execution may therefore be initiated with a simple `DEFUSR=&HE000:?USR(0)` statement.

<a name="keyboard_matrix"></a>
## Keyboard Matrix

This program displays the keyboard matrix on the screen so that key depressions may be directly observed. The program may be terminated by pressing the CTRL and STOP keys. Note that spurious key depressions can be produced under certain circumstances if more than three or four keys are pressed at one time. This is a characteristic of all matrix type keyboards.

```
                            ORG     0E000H
                            LOAD    0E000H

                    ; ******************************
                    ; *   BIOS STANDARD ROUTINES   *
                    ; ******************************

                    INITXT: EQU     006CH
                    CHPUT:  EQU     00A2H
                    SNSMAT: EQU     0141H
                    BREAKX: EQU     00B7H

                    ; ******************************
                    ; *     WORKSPACE VARIABLES    *
                    ; ******************************

                    INTFLG: EQU     0FC9BH

                    ; ******************************
                    ; *      CONTROL CHARACTERS    *
                    ; ******************************

                    LF:     EQU     10
                    HOME:   EQU     11
                    CR:     EQU     13

E000    CD6C00      MATRIX: CALL    INITXT              ; SCREEN 0
E003    3E0B        MX1:    LD      A,HOME              ;
E005    CDA200              CALL    CHPUT               ; Home Cursor
E008    AF                  XOR     A                   ; A=KBD row
E009    F5          MX2:    PUSH    AF                  ;
E00A    CD4101              CALL    SNSMAT              ; Read a row
E00D    0608                LD      B,6                 ; Eight cols
E00F    07          MX3:    RLCA                        ; Select col
E010    F5                  PUSH    AF                  ;
E011    E601                AND     1                   ;
E013    C630                ADD     A,"0"               ; Result
E015    CDA200              CALL    CHPUT               ; Display col
E018    F1                  POP     AF                  ;
E019    10F4                DJNZ    MX3                 ;
E01B    3E0D                LD      A,CR                ; Newline
E01D    CDA200              CALL    CHPUT               ;
E020    3E0A                LD      A,LF                ;
E022    CDA200              CALL    CHPUT               ;
E025    F1                  POP     AF                  ; A=KBD row
E026    3C                  INC     A                   ; Next row
E027    FE0B                CP      11                  ; Finished?
E029    20DE                JR      NZ,MX2              ;
E02B    CDB700              CALL    BREAKX              ; CTRL-STOP
E02E    30D3                JR      NC,MX1              ; Continue
E030    AF                  XOR     A                   ;
E031    329BFC              LD      (INTFLG),A          ; Clear possible STOP
E034    C9                  RET                         ; Back to BASIC

                            END
```

<a name="40_column_graphics_text"></a>
## 40 Column Graphics Text

This program prints text on the [Graphics Mode](#graphics_mode) screen at forty characters per line. The string to be displayed is passed as the `USR` call parameter, for example `A$=USR("something")`. There us no need to open a GRP file beforehand, the only requirement of the program is that the screen be in the correct mode. The heart of the program is functionally equivalent to the [GRPPRT](#grpprt) standard routine but only the first six dot columns of a given character pattern are placed on the screen instead of eight. As the [GRPPRT](#grpprt) the pattern is placed at the current graphics position and the only control character recognised is ASCII CR (13) which functions as a combined CR, LF. Unlike the [GRPPRT](#grpprt) standard routine characters printed at negative coordinates, but which overlap the screen, will be correctly displayed. The program is currently set up to perform an auto linefeed after dot column 239, thus giving exactly forty characters per line. If required this may be changed, via the constant in the RMDCOL subroutine, so that the full width of the screen is usable.

```
                            ORG     0E000H
                            LOAD    0E000H

                    ; ******************************
                    ; *   BIOS STANDARD ROUTINES   *
                    ; ******************************

                    RDSLT:  EQU     000CH
                    CNVCHR: EQU     00ABH
                    MAPXYC: EQU     0111H
                    SETC:   EQU     0120H

                    ; ******************************
                    ; *     WORKSPACE VARIABLES    *
                    ; ******************************

                    FORCLR: EQU     0F3E9H
                    ATRBYT: EQU     0F3F2H
                    CGPNT:  EQU     0F91FH
                    PATWRK: EQU     0FC40H
                    SCRMOD: EQU     0FCAFH
                    GRPACX: EQU     0FCB7H
                    GRPACY: EQU     0FCB9H

                    ; ******************************
                    ; *      CONTROL CHARACTERS    *
                    ; ******************************

                    CR:     EQU     13

E000    FE03        GFORTY: CP      3                   ; String type?
E002    C0                  RET     NZ                  ;
E003    3AAFFC              LD      A,(SCRMOD)          ; Mode
E006    FE02                CP      2                   ; Graphics?
E008    C0                  RET     NZ                  ;
E009    EB                  EX      DE,HL               ; HL->Descriptor
E00A    46                  LD      B,(HL)              ; B=String len
E00B    23                  INC     HL                  ;
E00C    5E                  LD      E,(HL)              ; Address LSB
E00D    23                  INC     HL                  ;
E00E    56                  LD      D,(HL)              ; DE->String
E00F    04                  INC     B                   ;
E010    05          GF2:    DEC     B                   ; Finished?
E011    C8                  RET     Z                   ;
E012    1A                  LD      A,(DE)              ; A=Chr from string
E013    CD19E0              CALL    GPRINT              ; Print it
E016    13                  INC     DE                  ;
E017    18F7                JR      GF2                 ; Next chr
E019    F5          GPRINT: PUSH    AF                  ;
E01A    C5                  PUSH    BC                  ;
E01B    D5                  PUSH    DE                  ;
E01C    E5                  PUSH    HL                  ;
E01D    FDE5                PUSH    IY                  ;
E01F    ED4BB7FC            LD      BC,(GRPACX)         ; BC=X coord
E023    ED5BB9FC            LD      DE,(GRPACY)         ; DE=Y coord
E027    CD39E0              CALL    GDC                 ; Decode chr
E02A    ED43B7FC            LD      (GRPACX),BC         ; New X coord
E02E    ED53B9FC            LD      (GRPACY),DE         ; New Y coord
E032    FDE1                POP     IY                  ;
E034    E1                  POP     HL                  ;
E035    D1                  POP     DE                  ;
E036    C1                  POP     BC                  ;
E037    F1                  POP     AF                  ;
E038    C9                  RET                         ;

E039    CDAB00      GDC:    CALL    CNVCHR              ; Check graphic
E03C    D0                  RET     NC                  ; NC=Header
E03D    2007                JR      NZ,GD2              ; NZ=Converted
E03F    FE0D                CP      CR                  ; Carriage Return?
E041    2873                JR      Z,GCRLF             ;
E043    FE20                CP      20H                 ; Other control?
E045    D8                  RET     C                   ; Ignore
E046    6F          GD2:    LD      L,A                 ;
E047    2600                LD      H,0                 ; HL=Chr code
E049    29                  ADD     HL,HL               ;
E04A    29                  ADD     HL,HL               ;
E04B    29                  ADD     HL,HL               ; HL=Chr*8
E04C    C5                  PUSH    BC                  ; X coord
E04D    D5                  PUSH    DE                  ; Y coord
E04E    ED5B20F9            LD      DE,(CGPNT+1)        ; Character set
E052    19                  ADD     HL,DE               ; HL->Pattern
E053    1140FC              LD      DE,PATWRK           ; DE->Buffer
E056    0608                LD      B,8                 ; Eight byte pattern
E058    C5          GD3:    PUSH    BC                  ;
E059    D5                  PUSH    DE                  ;
E05A    3A1FF9              LD      A,(CGPNT)           ; Slot ID
E05D    CD0C00              CALL    RDSLT               ; Get pattern
E060    FB                  EI                          ;
E061    D1                  POP     DE                  ;
E062    C1                  POP     BC                  ;
E063    12                  LD      (DE),A              ; Put in buffer
E064    13                  INC     DE                  ;
E065    23                  INC     HL                  ;
E066    10F0                DJNZ    GD3                 ; Next
E068    D1                  POP     DE                  ;
E069    C1                  POP     BC                  ;
E06A    3AE9F3              LD      A,(FORCLR)          ; Current colour
E06D    32F2F3              LS      (ATRBYT),A          ; Set ink
E070    FD2140FC            LD      IY,PATWRK           ; IY->Patterns
E074    D5                  PUSH    DE                  ;
E075    2608                LD      H,8                 ; Max dot rows
E077    CB7A        GD4:    BIT     7,D                 ; Pos Y coord?
E079    202A                JR      NZ,GD8              ;
E07B    CDBFE0              CALL    BMDROW              ; Bottom most row?
E07E    382B                JR      C,GD9               ; C=Y too large
E080    C5                  PUSH    BC                  ;
E081    2E06                LD      L,6                 ; Max dot cols
E083    FD7E00              LD      A,(IY+0)            ; A=Pattern row
E086    CB78        GD5:    BIT     7,B                 ; Pos X coord
E088    2015                JR      NZ,GD6              ;
E08A    CDC8E0              CALL    RMDCOL              ; Rightmost col?
E08D    3815                JR      C,GD7               ; C=X too large
E08F    CB7F                BIT     7,A                 ; Pattern bit
E091    280C                JR      Z,GD6               ; Z=0 Pixel
E093    F5                  PUSH    AF                  ;
E094    D5                  PUSH    DE                  ;
E095    E5                  PUSH    HL                  ;
E096    CD1101              CALL    MAPXYC              ; Map coords
E099    CD2001              CALL    SETC                ; Set pixel
E09C    E1                  POP     HL                  ;
E09D    D1                  POP     DE                  ;
E09E    F1                  POP     AF                  ;
E09F    07          GD6:    RLCA                        ; Shift pattern
E0A0    03                  INC     BC                  ; X=X+1
E0A1    2D                  DEC     L                   ; Finished dot cols?
E0A2    20E2                JR      NZ,GD5              ;
E0A4    C1          GD7:    POP     BC                  ; Initial X coord
E0A5    FD23        GD8:    INC     IY                  ; Next pattern byte
E0A7    13                  INC     DE                  ; Y=Y+1
E0A8    25                  DEC     H                   ; Finished dot rows?
E0A9    20CC                JR      NZ,GD4              ;
E0AB    D1          GD9:    POP     DE                  ; Initial Y coord
E0AC    210600              LD      HL,6                ; Step
E0AF    09                  ADD     HL,BC               ; X=X+6
E0B0    44                  LD      B,H                 ;
E0B1    4D                  LD      C,L                 ; BC=New X coord
E0B2    CDC8E0              CALL    RMDCOL              ; Rightmost col?
E0B5    D0                  RET     NC                  ;

E0B6    010000      GCRLF:  LD      BC,0                ; X=0
E0B9    210800              LD      HL,8                ;
E0BC    19                  ADD     HL,DE               ;
E0BD    EB                  EX      DE,HL               ; Y=Y+8
E0BE    C9                  RET                         ;

E0BF    E5          BMDROW: PUSH    HL                  ;
E0C0    21BF00              LD      HL,191              ; Bottom dot row
E0C3    B7                  OR      A                   ;
E0C4    ED52                SBC     HL,DE               ; Check Y coord
E0C6    E1                  POP     HL                  ;
E0C7    C9                  RET                         ; C=Below screen

E0C8    E5          RMDCOL: PUSH    HL                  ;
E0C9    21EF00              LD      HL,239              ; Rightmost dot col
E0CC    B7                  OR      A                   ;
E0CD    ED42                SBC     HL,BC               ; Check X coord
E0CF    E1                  POP     HL                  ;
E0D0    C9                  RET                         ; C=Beyond right

                            END
```

<a name="string_bubble_sort"></a>
## String Bubble Sort

This program will sort the contents os a string Array into ascending alphabetic order. The location of the Array is passed as the `USR` call parameter, for example `V=USR(VARPRT(A$(0)))`. There are no restrictions on the size of the Array or on its contents but it must only have one dimension. The program is based on the classic bubble sort algorithm where string pairs are compared and their positions swapped if the second is smaller than the first. a 250 element Array of randomly generated stringswill be sorted in approximately 2.5 seconds. The equivalent BASIC program takes over six minutes.

```
                            ORG     0E000H
                            LOAD    0E000H

E000    FE02        SORT:   CP      2                   ; Integer type?
E002    C0                  RET     NZ                  ;
E003    23                  INC     HL                  ; HL->DAC+1
E004    23                  INC     HL                  ; HL->DAC+2
E005    5E                  LD      E,(HL)              ; Address LSB
E006    23                  INC     HL                  ; HL->DAC+3
E007    56                  LD      D,(HL)              ; Address MSB
E008    EB                  EX      DE,HL               ; HL->A$(0)
E009    E5                  PUSH    HL                  ;
E00A    DDE1                POP     IX                  ; IX->A$(0)
E00C    DD7EF8              LD      A,(IX-8)            ; Array type
E00F    FE03                CP      3                   ; String Array?
E011    C0                  RET     NZ                  ;
E012    DD7EFD              LD      A,(IX-3)            ; Dimension
E015    3D                  DEC     A                   ; Single dimension?
E016    C0                  RET     NZ                  ;
E017    DD4EFE              LD      C,(IX-2)            ;
E01A    DD46FF              LD      B,(IX-1)            ; BC=Element count
E01D    C5          SR2:    PUSH    BC                  ;
E01E    E5                  PUSH    HL                  ; HL->Dsc(N)
E01F    46          SR3:    LD      B,(HL)              ; B=Len(N)
E020    23                  INC     HL                  ;
E021    5E                  LD      E,(HL)              ;
E022    23                  INC     HL                  ;
E023    E5                  PUSH    HL                  ;
E024    56                  LD      D,(HL)              ; DE->String(N)
E025    23                  INC     HL                  ; HL->Dsc(N+1)
E026    4E                  LD      C,(HL)              ; C=Len(N+1)
E027    23                  INC     HL                  ;
E028    7E                  LD      A,(HL)              ;
E029    23                  INC     HL                  ;
E02A    E5                  PUSH    HL                  ;
E02B    66                  LD      H,(HL)              ;
E02C    6F                  LD      L,A                 ; HL->String(N+1)
E02D    EB                  EX      DE,HL               ; HL->(N),DE->(N+1)
E02E    04                  INC     B                   ;
E02F    0C                  INC     C                   ;
E030    05          SR4:    DEC     B                   ; Remaining len(N)
E031    2B25                JR      Z,NEXT              ; Z=(N)<=(N+1)
E033    0D                  DEC     C                   ; Remaining len(N+1)
E034    2808                JR      Z,SWAP              ; Z=(N+1)<(N)
E036    1A                  LD      A,(DE)              ; Chr from (N+1)
E037    BE                  CP      (HL)                ; Chr from (N)
E038    13                  INC     DE                  ;
E039    23                  INC     HL                  ;
E03A    28F4                JR      Z,SR4               ; Same, continue
E03C    301A                JR      NC,NEXT             ; NC=(N)<(N+1)
E03E    E1          SWAP:   POP     HL                  ; HL->Dsc(N+1)
E03F    D1                  POP     DE                  ; DE->Dsc(N)
E040    0603                LD      B,3                 ; Descriptor size
E042    1A          SW2:    LD      A,(DE)              ; Swap descriptors
E043    4E                  LD      C,(HL)              ;
E044    77                  LD      (HL),A              ;
E045    79                  LD      A,C                 ;
E046    12                  LD      (DE),A              ;
E047    1B                  DEC     DE                  ;
E048    2B                  DEC     HL                  ;
E049    10F7                DJNZ    SW2                 ;
E04B    DDE5                PUSH    IX                  ;
E04D    E1                  POP     HL                  ; HL->A$(0)
E04E    B7                  OR      A                   ;
E04F    ED52                SBC     HL,DE               ; At Array start?
E051    3007                JR      NC,NX2              ; NC=At start
E053    1B                  DEC     DE                  ; Back up
E054    1B                  DEC     DE                  ;
E055    EB                  EX      DE,HL               ; HL->Dsc(N-1_
E056    18C7                JR      SR3                 ; Go check again
E058    E1          NEXT:   POP     HL                  ; Lose junk
E059    E1                  POP     HL                  ;
E05A    E1          NX2:    POP     HL                  ; HL->Dsc(N)
E05B    C1                  POP     BC                  ; BC=Element count
E05C    23                  INC     HL                  ; Next descriptor
E05D    23                  INC     HL                  ;
E05E    23                  INC     HL                  ;
E05F    0B                  DEC     BC                  ;
E060    78                  LD      A,B                 ;
E061    B1                  OR      C                   ; Finished?
E062    20B9                JR      NZ,SR2              ;
E064    C9                  RET                         ;

                            END
```

<a name="graphics_screen_dump"></a>
## Graphics Screen Dump

This program will dump the screen contents, in any mode, to the printer. When first activated via a `USR` call the program merely patches itself into the interrupt handler keyscan hook.

Once the program has installed itself it effectively becomes an extension of the interrupt handler and a screen dump may then be initiated from any part of the system simply by pressing the ESC key. If necessary the dump can be terminated by pressing the CTRL and STOP keys. An example of a [Graphics Mode](#graphics_mode) screen, in which all thirty-two sprites are active, is shown below:

The simplest method of generating a screen dump is to copy all the character codes from the Name Table to the printer. However this would only work in the two text modes, the sprites could not be displayed and the result would reflect the printer's internal character set rather than the VDP character set. The program therefore reproduces the screen as a 240/256x192 bit image on the printer in all modes, each point in the image being derived from the colour code of the corresponding point on the screen. No dot for colours 0 to 7 and a dot for colours 8 to 15.

The colour code for a given point is obtained by first examining the thirty-two sprites in sequence to determine whether any one overlaps it. If every sprite is transparent at the point then the character plane is examined. This is done by using the point coordinates to locate the corresponding entry in the Name Table then, via the character code, to isolate the relevant bit in the associated pattern. If the bit's colour code is found to be transparent the background plane colour is returned.

Note that the control code sequences used in the program are the Epson FX80 printer. These are marked in the listings in case another printer is to be used. One sequence is used to enter bit image mode at the start of a 240/256 byte line (each byte defines eight vertical dots) and one sequence is used to initiate a paper feed at the end of the line. The program is generally optimised for speed, rather than for minimal code, and takes about five seconds plus printer time to produce the 46,080/49,152 dots in the image.

```
                            ORG     0E000H
                            LOAD    0E000H

                    ; ******************************
                    ; *   BIOS STANDARD ROUTINES   *
                    ; ******************************

                    RDVRM:  EQU     004AH
                    CALATR: EQU     0087H
                    LPTOUT: EQU     00A5H

                    ; ******************************
                    ; *     WORKSPACE VARIABLES    *
                    ; ******************************

                    T32COL: EQU     0F3BFH
                    GRPNAM: EQU     0F3C7H
                    GRPCOL: EQU     0F3C9H
                    GRPCGP: EQU     0F3CBH
                    MLTNAM: EQU     0F3D1H
                    MLTCGP: EQU     0F3D5H
                    RG1SAV: EQU     0F3E0H
                    RG7SAV: EQU     0F3E6H
                    NAMBAS: EQU     0F922H
                    CGPBAS: EQU     0F924H
                    PATBAS: EQU     0F926H
                    ATRBAS: EQU     0F928H
                    SCRMOD: EQU     0FCAFH
                    HKEYC:  EQU     0FDCCH

                    ; ******************************
                    ; *      CONTROL CHARACTERS    *
                    ; ******************************

                    CR:     EQU     13
                    ESC:    EQU     27

E000    3ACCFD      ENTRY:  LD      A,(HKEYC)           ; Hook
E003    FEC9                CP      0C9H                ; Free to use?
E005    C0                  RET     NZ                  ;
E006    2112E0              LD      HL,DUMP             ; Where to go
E009    22CDFD              LD      (HKEYC+1),HL        ; Redirect hook
E00C    3ECD                LD      A,0CDH              ; CALL
E00E    32CCFD              LD      (HKEYC),A           ;
E011    C9                  RET                         ;

E012    FE3A        DUMP:   CP      3AH                 ; ESC key number?
E014    C0                  RET     NZ                  ;
E015    F5                  PUSH    AF                  ;
E016    C5                  PUSH    BC                  ;
E017    D5                  PUSH    DE                  ;
E018    E5                  PUSH    HL                  ;
E019    ED734FE2            LD      (BRKSTK),SP         ; For CTRL-STOP
E01D    0E00                LD      C,0                 ; C=Row
E01F    3AAFFC      DU1:    LD      A,(SCRMOD)          ; Mode
E022    B7                  OR      A                   ;
E023    21F000              LD      HL,240              ; T40 Dots per row
E026    112B06              LD      DE,6*256+40         ;
E029    2806                JR      Z,DU2               ;
E02B    210001              LD      HL,256              ; T32,GRP,MLT Dots
E02E    112008              LD      DE,8*256+32         ;
E031    3E1B        DU2:    LD      A,ESC               ; ***** FX80 *****
E033    CD8DE0              CALL    PRINT               ; *              *
E036    3E4B                LD      A,"K"               ; *   Bit mode   *
E038    CD8DE0              CALL    PRINT               ; *              *
E03B    7D                  LD      A,L                 ; *  Bytes  LSB  *
E03C    CD8DE0              CALL    PRINT               ; *              *
E03F    7C                  LD      A,H                 ; *  Bytes  MSB  *
E040    CD8DE0              CALL    PRINT               ; ****************
E043    0600                LD      B,0                 ; B=Column
E045    CD97E0      DU3:    CALL    CELL                ; Do an 8x8 cell
E048    D5                  PUSH    DE                  ;
E049    C5                  PUSH    BC                  ;
E04A    2151E2              LD      HL,CBUFF            ; HL->Colours
E04D    42                  LD      B,D                 ; B=Dot cols (6 or 8)
E04E    110800              LD      DE,8                ; CBUFF offset
E051    C5          DU4:    PUSH    BC                  ;
E052    E5                  PUSH    HL                  ;
E053    0608                LD      B,8                 ; B=Dot rows
E055    7E          DU5:    LD      A,(HL)              ; A=Colour code
E056    FE08                CP      8                   ; Dark or light?
E058    3F                  CCF                         ; Light=Print dot
E059    CB11                RL      C                   ; Build result
E05B    19                  ADD     HL,DE               ; Next dot row
E05C    10F7                DJNZ    DU5                 ;
E05E    79                  LD      A,C                 ; 8 Vertical dots
E05F    CD8DE0              CALL    PRINT               ;
E062    E1                  POP     HL                  ;
E063    C1                  POP     BC                  ;
E064    23                  INC     HL                  ; Next dot col
E065    10EA                DJNZ    DU4                 ;
E067    C1                  POP     BC                  ;
E068    D1                  POP     DE                  ;
E069    04                  INC     B                   ; Next column
E06A    78                  LD      A,B                 ;
E06B    BB                  CP      E                   ; End of row?
E06C    20D7                JR      NZ,DU3              ;
E06E    3E0D                LD      A,CR                ; Head left
E070    CD8DE0              CALL    PRINT               ;
E073    3E1B                LD      A,ESC               ; ***** FX80 *****
E075    CD8DE0              CALL    PRINT               ; *              *
E078    3E4A                LD      A,"J"               ; *  Paper feed  *
E07A    CD8DE0              CALL    PRINT               ; *              *
E07D    3E18                LD      A,24                ; * 24/216= 1/9" *
E07F    CD8DE0              CALL    PRINT               ; ****************
E082    0C                  INC     C                   ; Next row
E083    79                  LD      A,C                 ;
E084    FE18                CP      24                  ; Finished screen?
E086    2097                JR      NZ,DU1              ;
E088    E1          DU6:    POP     HL                  ;
E089    D1                  POP     DE                  ;
E08A    C1                  POP     BC                  ;
E08B    F1                  POP     AF                  ;
E08C    C9                  RET                         ;

E08D    CDA500      PRINT:  CALL    LPTOUT              ; To printer
E090    D0                  RET     NC                  ; CTRL-STOP?
E091    ED7B4FE2            LD      SP,(BRKSTK)         ; Restore stack
E095    18F1                JR      DU6                 ; Terminate program

E097    C5          CELL:   PUSH    BC                  ;
E098    D5                  PUSH    DE                  ;
E099    E5                  PUSH    HL                  ;
E09A    FDE5                PUSH    IY                  ;
E09C    2151E2              LD      HL,CBUFF            ; For results
E09F    3E40                LD      A,64                ;
E0A1    3600        CL1:    LD      (HL),0              ; Transparent
E0A3    23                  INC     HL                  ;
E0A4    3D                  DEC     A                   ; Fill
E0A5    20FA                JR      NZ,CL1              ;
E0A7    3AAFFC              LD      A,(SCRMOD)          ; Mode
E0AA    B7                  OR      A                   ; T40?
E0AB    F5                  PUSH    AF                  ;
E0AC    C5                  PUSH    BC                  ;
E0AD    C469E1              CALL    NZ,SPRTES           ; Sprites first
E0B0    C1                  POP     BC                  ;
E0B1    69                  LD      L,C                 ;
E0B2    2600                LD      H,0                 ; HL=Row
E0B4    29                  ADD     HL,HL               ;
E0B5    29                  ADD     HL,HL               ;
E0B6    29                  ADD     HL,HL               ; HL=Row*8
E0B7    5D                  LD      E,L                 ;
E0B8    54                  LD      D,H                 ; DE=Row*8
E0B9    29                  ADD     HL,HL               ;
E0BA    29                  ADD     HL,HL               ; HL=Row*32
E0BB    F1                  POP     AF                  ; Mode
E0BC    F5                  PUSH    AF                  ;
E0BD    2001                JR      NZ,CL2              ; T40?
E0BF    19                  ADD     HL,DE               ; HL=Row*40
E0C0    58          CL2:    LD      E,B                 ; DE=Column
E0C1    19                  ADD     HL,DE               ;
E0C2    EB                  EX      DE,HL               ; DE=NAMTAB offset
E0C3    D602                SUB     2                   ; Mode
E0C5    79                  LD      A,C                 ; A=Row
E0C6    010000              LD      BC,0                ; BC=CGPTAB offset
E0C9    2A24F9              LD      HL,(CGPBAS)         ;
E0CC    E5                  PUSH    HL                  ;
E0CD    2A22F9              LD      HL,(NAMBAS)         ;
E0D0    3819                JR      C,CL4               ; C=T40 or T32
E0D2    200C                JR      NZ,CL3              ; NZ=MLT
E0D4    2ACBF3              LD      HL,(GRPCGP)         ; Else GRP
E0D7    E3                  EX      (SP),HL             ;
E0D8    2AC7F3              LD      HL,(GRPNAM)         ;
E0DB    E618                AND     18H                 ; Row MSBs
E0DD    47                  LD      B,A                 ; 1/3=2kB CGP offset
E0DE    180B                JR      CL4                 ;
E0E0    2AD5F3      CL3:    LD      HL,(MLTCGP)         ;
E0E3    E3                  EX      (SP),HL             ;
E0E4    2AD1F3              LD      HL,(MLTNAM)         ;
E0E7    07                  RLCA                        ; Row*2
E0E8    E606                AND     6                   ;
E0EA    4F                  LD      C,A                 ; 1/6=2B CGP offset
E0EB    19          CL4:    ADD     HL,DE               ; HL->NAMTAB
E0EC    CD4A00              CALL    RDVRM               ; Get chr code
E0EF    6F                  LD      L,A                 ;
E0F0    2600                LD      H,0                 ; HL=Chr code
E0F2    29                  ADD     HL,HL               ;
E0F3    29                  ADD     HL,HL               ;
E0F4    29                  ADD     HL,HL               ; HL=Chr*8
E0F5    09                  ADD     HL,BC               ; GRP,MLT offsets
E0F6    EB                  EX      DE,HL               ; DE=CGPTAB offset
E0F7    FDE1                POP     IY                  ; IY=CGPTAB base
E0F9    FD19                ADD     IY,DE               ; IY->Pattern
E0FB    2AC9F3              LD      HL,(GRPCOL)         ;
E0FE    19                  ADD     HL,DE               ; HL->GRP colours
E0FF    0F                  RRCA                        ;
E100    0F                  RRCA                        ;
E101    0F                  RRCA                        ; Chr code/8
E102    E61F                AND     1FH                 ;
E104    4F                  LD      C,A                 ;
E105    0600                LD      B,0                 ;
E107    3AE6F3              LD      A,(RG7SAV)          ; T40 Colours
E10A    57                  LD      D,A                 ; D=T40 Colours
E10B    E60F                AND     0FH                 ;
E10D    5F                  LD      E,A                 ; E=Background colour
E10E    F1                  POP     AF                  ; Mode
E10F    E5                  PUSH    HL                  ; STK->GRP Colours
E110    3D                  DEC     A                   ;
E111    2008                JR      NZ,CL5              ; Z=T32
E113    2ABFF3              LD      HL,(T32COL)         ;
E116    09                  ADD     HL,BC               ; HL->T32 Colours
E117    CD4A00              CALL    RDVRM               ; Get T32 Colours
E11A    57                  LD      D,A                 ; D=T32 Colours
E11B    2151E2      CL5:    LD      HL,CBUFF            ; Results
E11E    0608                LD      B,8                 ; Dot rows
E120    FDE5        CL6:    PUSH    IY                  ;
E122    E3                  EX      (SP),HL             ; HL->Pattern
E123    CD4A00              CALL    RDVRM               ; Get pattern
E126    4F                  LD      C,A                 ; C=Pattern
E127    E1                  POP     HL                  ;
E128    FD23                INC     IY                  ; Next dot row
E12A    3AAFFC              LD      A,(SCRMOD)          ; Mode
E12D    D602                SUB     2                   ;
E12F    3815                JR      C,CL8               ; C=T40 or T32
E131    280C                JR      Z,CL7               ; Z=GRP
E133    51                  LD      D,C                 ; MLT Colours=Pattern
E134    0EF0                LD      C,0F0H              ; Dummy MLT pattern
E136    78                  LD      A,B                 ; Dot row
E137    FE05                CP      5                   ; Cell halfway mark?
E139    280B                JR      Z,CL8               ;
E13B    FD2B                DEC     IY                  ; Back up pattern
E13D    1807                JR      CL8                 ;
E13F    E3          CL7:    EX      (SP),HL             ; HL->GRP Colours
E140    CD4A00              CALL    RDVRM               ; Get colours
E143    57                  LD      D,A                 ; D=GRP Colours
E144    23                  INC     HL                  ; Next dot row
E145    E3                  EX      (SP),HL             ; STK->GRP Colours
E146    C5          CL8:    PUSH    BC                  ;
E147    0608                LD      B,8                 ; Dot cols
E149    CB11        CL9:    RL      C                   ; Dot from pattern
E14B    34                  INC     (HL)                ;
E14C    35                  DEC     (HL)                ; Check CBUFF clear
E14D    200D                JR      NZ,CL12             ; NZ=Sprite above
E14F    7A                  LD      A,D                 ; A=Colours
E150    3004                JR      NC,CL10             ; NC=0 Pixel
E152    0F                  RRCA                        ;
E153    0F                  RRCA                        ;
E154    0F                  RRCA                        ;
E155    0F                  RRCA                        ; Select 1 colour
E156    E60F        CL10:   AND     0FH                 ;
E158    2001                JR      NZ,CL11             ; Z=Transparent
E15A    7B                  LD      A,E                 ; Use background
E15B    77          CL11:   LD      (HL),A              ; Colour in CBUFF
E15C    23          CL12:   INC     HL                  ;
E15D    10EA                DJNZ    CL9                 ; Next dot col
E15F    C1                  POP     BC                  ;
E160    10BE                DJNZ    CL6                 ; Next dot row
E162    E1                  POP     HL                  ;
E163    FDE1                POP     IY                  ;
E165    E1                  POP     HL                  ;
E166    D1                  POP     DE                  ;
E167    C1                  POP     BC                  ;
E168    C9                  RET                         ;

E169    78          SPRTES: LD      A,B                 ; A=Column
E16A    07                  RLCA                        ;
E16B    07                  RLCA                        ;
E16C    07                  RLCA                        ; A=X coord
E16D    C607                ADD     A,7                 ; RH edge of cell
E16F    47                  LD      B,A                 ; B=X coord
E170    79                  LD      A,C                 ; A=Row
E171    07                  RLCA                        ;
E172    07                  RLCA                        ;
E173    07                  RLCA                        ; A=Y coord
E174    C607                ADD     A,7                 ; Bottom of cell
E176    4F                  LD      C,A                 ; C=Y coord
E177    AF                  XOR     A                   ; Sprite number
E178    CD8700      SS1:    CALL    CALATR              ; HL->Attributes
E17B    57                  LD      D,A                 ; D=Sprite number
E17C    CD4A00              CALL    RDVRM               ; Get Sprite Y
E17F    FED0                CP      208                 ; Terminator?
E181    C8                  RET     Z                   ;
E182    D5                  PUSH    DE                  ;
E183    C5                  PUSH    BC                  ;
E184    CD8FE1              CALL    SPRITE              ; Do a sprite
E187    C1                  POP     BC                  ;
E188    F1                  POP     AF                  ;
E189    3C                  INC     A                   ; Next sprite number
E18A    FE20                CP      32                  ; Done all?
E18C    20EA                JR      NZ,SS1              ;
E18E    C9                  RET                         ;

E18F    91          SPRITE: SUB     C                   ; (SY-Y)
E190    2F                  CPL                         ; Make (Y-SY)
E191    FE27                CP      39                  ; Possible overlap?
E193    D0                  RET     NC                  ;
E194    4F                  LD      C,A                 ; C=(Y-SY)
E195    23                  INC     HL                  ;
E196    CD4A00              CALL    RDVRM               ; Get Sprite X
E199    5F                  LD      E,A                 ;
E19A    78                  LD      A,B                 ; A=X coord
E19B    93                  SUB     E                   ;
E19C    5F                  LD      E,A                 ; E=(X-SX)
E19D    9F                  SBC     A,A                 ; Make 16 bit
E19E    57                  LD      D,A                 ; DE=(X-SX)
E19F    23                  INC     HL                  ;
E1A0    CD4A00              CALL    RDVRM               ; Get pattern#
E1A3    47                  LD      B,A                 ;
E1A4    23                  INC     HL                  ;
E1A5    CD4A00              CALL    RDVRM               ; Get EC & Colour
E1A8    CB7F                BIT     7,A                 ; Early clock?
E1AA    2805                JR      Z,SP1               ;
E1AC    212000              LD      HL,32               ;
E1AF    19                  ADD     HL,DE               ; Increase (X-SX)
E1B0    EB                  EX      DE,HL               ;
E1B1    14          SP1:    INC     D                   ;
E1B2    15                  DEC     D                   ; (X-SX)>255 or neg?
E1B3    C0                  RET     NZ                  ; NZ-Outside cell
E1B4    E60F                AND     0FH                 ; Colour
E1B6    C8                  RET     Z                   ; Z=Transparent
E1B7    57                  LD      D,A                 ; D=Colour
E1B8    3AE0F3              LD      A,(RG1SAV)          ; Flags
E1BB    DB4F                BIT     1,A                 ; SIZE
E1BD    0F                  RRCA                        ; MAG
E1BE    3E08                LD      A,8                 ; Minimum size
E1C0    3001                JR      NC,SP2              ;
E1C2    87                  ADD     A,A                 ; Double for MAG
E1C3    2800        SP2:    JR      Z,SP3               ;
E1C5    CB80                RES     0,B                 ; Change pattern#
E1C7    CB88                RES     1,B                 ;
E1C9    87                  ADD     A,A                 ; Double for SIZE
E1CA    6F          SP3:    LD      L,A                 ; L=Sprite size
E1CB    C606                ADD     A,6                 ; Allow cell size
E1CD    B9                  CP      C                   ;
E1CE    D8                  RET     C                   ; Sprite above
E1CF    BB                  CP      E                   ;
E1D0    D8                  RET     C                   ; Sprite to left
E1D1    79                  LD      A,C                 ;
E1D2    D607                SUB     7                   ; (Y-SY) from top
E1D4    4F                  LD      C,A                 ;
E1D5    7D                  LD      A,L                 ; A=Sprite size
E1D6    2608                LD      H,8                 ; Max dot rows
E1D8    3800                JR      C,SP5               ; C=Below cell top
E1DA    91                  SUB     C                   ; A=Dot row overlap
E1DB    FE09                CP      9                   ;
E1DD    3802                JR      C,SP4               ;
E1DF    3E08                LD      A,8                 ;
E1E1    67          SP4:    LD      H,A                 ; H=Row overlap
E1E2    7B          SP5:    LD      A,E                 ;
E1E3    D607                SUB     7                   ; (X-SX) from cell LH
E1E5    5F                  LD      E,A                 ;
E1E6    7D                  LD      A,L                 ; A=Sprite size
E1E7    2E08                LD      L,8                 ; Max dot cols
E1E9    3808                JR      C,SP7               ; C=Past cell LH
E1EB    93                  SUB     E                   ; A=Dot col overlap
E1EC    FE09                CP      9                   ;
E1EE    3802                JR      C,SP6               ;
E1F0    3E08                LD      A,8                 ;
E1F2    6F          SP6:    LD      L,A                 ; L=Col overlap
E1F3    FD2151E2    SP7:    LD      IY,CBUFF            ; Results
E1F7    D5          SP8:    PUSH    DE                  ;
E1F8    CB79                BIT     7,C                 ; Reached sprite?
E1FA    2048                JR      NZ,SP15             ;
E1FC    E5                  PUSH    HL                  ;
E1FD    FDE5                PUSH    IY                  ;
E1FF    CB7B        SP9:    BIT     7,E                 ; Reached sprite?
E201    2038                JR      NZ,SP14             ;
E203    FD7E00              LD      A,(IY+0)            ; CBUFF
E206    B7                  OR      A                   ; Transparent?
E207    2032                JR      NZ,SP14             ;
E209    C5                  PUSH    BC                  ;
E20A    D5                  PUSH    DE                  ;
E20B    E5                  PUSH    HL                  ;
E20C    3AE0F3              LD      A,(RG1SAV)          ; Flags
E10F    0F                  RRCA                        ; MAG
E210    3004                JR      NC,SP10             ;
E212    CB39                SRL     C                   ; (Y-SY)/2
E214    CB3B                SRL     E                   ; (X-SX)/2
E216    CB5B        SP10:   BIT     3,E                 ; (X-SX)>7?
E218    2804                JR      Z,SP11              ;
E21A    CB9B                RES     3,E                 ; (X-SX)-8
E21C    CBE1                SET     4,C                 ; (Y-SY)+16
E21E    68          SP11:   LD      L,B                 ;
E21F    2600                LD      H,0                 ; HL=Pattern#
E221    44                  LD      B,H                 ; BC=Y offset
E222    29                  ADD     HL,HL               ;
E223    29                  ADD     HL,HL               ;
E224    29                  ADD     HL,HL               ; HL=Pattern*8
E225    09                  ADD     HL,BC               ; Select dot row
E226    ED4B26F9            LD      BC,(PATBAS)         ;
E22A    09                  ADD     HL,BC               ; HL->Pattern
E22B    CD4A00              CALL    RDVRM               ; Get dot row
E22E    1C                  INC     E                   ;
E22F    07          SP12:   RLCA                        ; Select dot col
E230    1D                  DEC     E                   ;
E231    20FC                JR      NZ,SP12             ;
E233    3003                JR      NC,SP13             ; NC=0 Pixel
E235    FD7200              LD      (IY+0),D            ; Colour in CBUFF
E238    E1          SP13:   POP     HL                  ;
E239    D1                  POP     DE                  ;
E23A    C1                  POP     BC                  ;
E23B    FD23        SP14:   INC     IY                  ;
E23D    1C                  INC     E                   ; Right a dot col
E23E    2D                  DEC     L                   ; Finished cols?
E23F    20BE                JR      NZ,SP9              ;
E241    FDE1                POP     IY                  ;
E243    E1                  POP     HL                  ;
E244    110800      SP15:   LD      DE,8                ;
E247    FD19                ADD     IY,DE               ;
E249    D1                  POP     DE                  ;
E24A    0C                  INC     C                   ; Down a dot row
E24B    25                  DEC     H                   ; Finished?
E24C    20A9                JR      NZ,SP8              ;
E24E    C9                  RET                         ;

E24F    0000        BRKSTK: DEFW    0                   ; Break stack

                    ; ****************************
                    ; * This buffer holds the 64 *
                    ; * colour codes produced by *
                    ; *       a cell scan:       *
                    ; *                          *
                    ; *   CCCCCCCC Bytes 00-07   *
                    ; *   CCCCCCCC Bytes 08-15   *
                    ; *   CCCCCCCC Bytes 16-23   *
                    ; *   CCCCCCCC Bytes 24-31   *
                    ; *   CCCCCCCC Bytes 32-39   *
                    ; *   CCCCCCCC Bytes 40-47   *
                    ; *   CCCCCCCC Bytes 48-55   *
                    ; *   CCCCCCCC Bytes 56-64   *
                    ; *                          *
                    ; ****************************

E251                CBUFF:  DEFS    64                  ; Cell buffer

                            END
```

<a name="character_editor"></a>
## Character Editor

This program allows the MSX character patterns to be modified. When the program is first entered it copies the 2KB character set from its present location (usually the MSX ROM) to the CHRTAB buffer (E2A3H to EAA2H) and sets up the screen as shown below:

The program has two levels of operation, command and edit, with the RETURN key being used to toggle between them. In command mode the four arrow keys are used to select the character for editing. This is marked by a large cursor an is also displayed in magnified form on the right hand side of the screen. The "Q" key will quit the program and return to BASIC. The "A" key is used to adopt the character set, that is, to make it the system character set. When the character set is adopted it is copied to the highest part of memory (EB80H to F37FH) and its Slot ID and address placed in [CGPNT](#cgpnt).

In edit mode the four arrow keys are used to select the dot for editing, this is marked by a small cursor. The SPACE key will erase the current dot and the "." key set it. As the patter is modified the character menu on the left hand side of the screen is updated.

The character set in the CHRTAB may be saved on the cassette using a "BSAVE" statement and later re-loaded with a "BLOAD" statement. The ADOPT subroutine should be saved with the patterns and executed upon re-loading so that the system adopts the new character set. Alternatively the character set alone can be saved and its Slot ID and address placed in [CGPNT](#cgpnt) upon re-loading using BASIC statements. Note that altering the character patterns does not affect the operation of the MSX system un the slightest.

```
                            ORG     0E000H
                            LOAD    0E000H

                    ; ******************************
                    ; *   BIOS STANDARD ROUTINES   *
                    ; ******************************

                    RDSLT:  EQU     000CH
                    RDVRM:  EQU     004AH
                    WRTVRM: EQU     004AH
                    FILVRM: EQU     0056H
                    INIGRP: EQU     0072H
                    CHSNS:  EQU     009CH
                    CHGET:  EQU     009FH
                    MAPXYC: EQU     0111H
                    FETCHC: EQU     0114H
                    RSLREG: EQU     0138H

                    ; ******************************
                    ; *     WORKSPACE VARIABLES    *
                    ; ******************************

                    GRPCOL: EQU     0F3D9H
                    FORCLR: EQU     0F3E9H
                    BAKCLR: EQU     0F3EAH
                    CGPNT:  EQU     0F91FH
                    EXPTBL: EQU     0FCC1H
                    SLTTBL: EQU     0FCC5H

                    ; ******************************
                    ; *      CONTROL CHARACTERS    *
                    ; ******************************

                    CR:     EQU     13
                    RIGHT:  EQU     28
                    LEFT:   EQU     29
                    UP:     EQU     30
                    DOWN:   EQU     31

E000    CDF6E0      CHEDIT: CALL    INIT                ; Cold start
E003    CDBDE0      CH1:    CALL    CHRMAG              ; Magnify chr
E006    CDFEE1              CALL    CHRXY               ; Chr coords
E009    1608                LD      D,8                 ; Cursor size
E00B    CD2FE2              CALL    GETKEY              ; Get command
E00E    FE51                CP      "Q"                 ; Quit
E010    C8                  RET     Z                   ;
E011    2103E0              LD      HL,CH1              ; Set up return
E014    E5                  PUSH    HL                  ;
E015    FE41                CP      "A"                 ; Adopt
E017    CA6EE2              JP      Z,ADOPT             ;
E01A    FE0D                CP      CR                  ; Edit
E01C    281F                JR      Z,EDIT              ;
E01E    0E01                LD      C,1                 ; C=Offset
E020    FE1C                CP      RIGHT               ; Right
E022    2811                JR      Z,CH2               ;
E024    0EFF                LD      C,0FFH              ;
E026    FE1D                CP      LEFT                ; Left
E028    280B                JR      Z,CH2               ;
E02A    0EF0                LD      C,0F0H              ;
E02C    FE1E                CP      UP                  ; Up
E02E    2805                JR      Z,CH2               ;
E030    0E10                LD      C,16                ;
E032    FE1F                CP      DOWN                ; Down
E034    C0                  RET     NZ                  ;
E035    3AA1E2      CH2:    LD      A,(CHRNUM)          ; Current chr
E038    81                  ADD     A,C                 ; Add offset
E039    32A1E2              LD      (CHRNUM),A          ; New chr
E03C    C9                  RET                         ;

E03D    CDE6E1      EDIT:   CALL    DOTXY               ; Dot coords
E040    1602                LD      D,2                 ; Cursor size
E042    CD2FE2              CALL    GETKEY              ; Get command
E045    FE0D                CP      CR                  ; Quit
E047    C8                  RET     Z                   ;
E048    213DE0              LD      HL,EDIT             ; Set up return
E04B    E5                  PUSH    HL                  ;
E04C    0100FE              LD      BC,0FE00H           ; AND/OR masks
E04F    FE20                CP      " "                 ; Space
E051    2824                JR      Z,ED3               ;
E053    0C                  INC     C                   ; New OR mask
E054    FE2E                CP      "."                 ; Dot
E056    281F                JR      Z,ED3               ;
E058    FE1C                CP      RIGHT               ; Right
E05A    2811                JR      Z,ED2               ;
E05C    0EFF                LD      C,0FFH              ; C=Offset
E05E    FE1D                CP      LEFT                ; Left
E060    280B                JR      Z,ED2               ;
E062    0EF8                LD      C,0F8H              ;
E064    FE1E                CP      UP                  ; Up
E066    2805                JR      Z,ED2               ;
E068    0E08                LD      C,8                 ;
E06A    FE1F                CP      DOWN                ; Down
E06C    C0                  RET     NZ                  ;
E06D    3AA2E2      ED2:    LD      A,(DOTNUM)          ; Current dot
E070    81                  ADD     A,C                 ; Add offset
E071    E63F                AND     63                  ; Wrap round
E073    32A2E2              LD      (DOTNUM),A          ; New dot
E076    C9                  RET                         ;
E077    CD1EE2      ED3:    CALL    PATPOS              ; IY->Pattern
E07A    3AA2E2              LD      A,(DOTNUM)          ; Current dot
E07D    F5                  PUSH    AF                  ;
E07E    0F                  RRCA                        ;
E07F    0F                  RRCA                        ;
E080    0F                  RRCA                        ;
E081    E607                AND     7                   ; A=Row
E083    5F                  LD      E,A                 ;
E084    1600                LD      D,0                 ; DE=Row
E086    FD19                ADD     IY,DE               ; IY->Row
E088    F1                  POP     AF                  ;
E089    E607                AND     7                   ; A=Column
E08B    3C                  INC     A                   ;
E08C    CB08        ED4:    RRC     B                   ; AND mask
E08E    CB09                RRC     C                   ; OR mask
E090    3D                  DEC     A                   ; Count columns
E091    20F9                JR      NZ,ED4              ;
E093    FD7E00              LD      A,(IY+0)            ; A=Pattern
E096    A0                  AND     B                   ; Strip old bit
E097    B1                  OR      C                   ; New bit
E098    FD7700              LD      (IY+0),A            ; New pattern
E09B    CDBDE0              CALL    CHRMAG              ; Update magnified

E09E    CD1EE2      CHROUT: CALL    PATPOS              ; IY->Pattern
E0A1    CDFEE1              CALL    CHRXY               ; Get coords
E0A4    CDA3E1              CALL    MAP                 ; Map
E0A7    0608                LD      B,8                 ; Dot rows
E0A9    D5          CO1:    PUSH    DE                  ;
E0AA    E5                  PUSH    HL                  ;
E0AB    3E08                LD      A,8                 ; Dot cols
E0AD    FD5E00              LD      E,(IY+0)            ; E=Pattern
E0B0    CDC4E1              CALL    SETROW              ; Set row
E0B3    E1                  POP     HL                  ; HL=CLOC
E0B4    D1                  POP     DE                  ; D=CMASK
E0B5    CDB8E1              CALL    DOWNP               ; Down a pixel
E0B8    FD23                INC     IY                  ;
E0BA    10ED                DJNZ    CO1                 ;
E0BC    C9                  RET                         ;

E0BD    CD1EE2      CHRMAG: CALL    PATPOS              ; IY->Pattern
E0C0    0EBF                LD      C,191               ; Start X
E0C2    1E07                LD      E,7                 ; Start Y
E0C4    CDA3E1              CALL    MAP                 ; Map
E0C7    0608                LD      B,8                 ; Dot rows
E0C9    0E05        CM1:    LD      C,5                 ; Row mag
E0CB    C5          CM2:    PUSH    BC                  ;
E0CC    D5                  PUSH    DE                  ;
E0CD    E5                  PUSH    HL                  ;
E0CE    0608                LD      B,8                 ; Dot columns
E0D0    FD7E00              LD      A,(IY+0)            ; A=Pattern
E0D3    07          CM3:    RLCA                        ; Test bit
E0D4    F5                  PUSH    AF                  ;
E0D5    9F                  SBC     A,A                 ; 0=00H, 1=FFH
E0D6    5F                  LD      E,A                 ; E=Mag pattern
E0D7    3E05                LD      A,5                 ; Column mag
E0D9    CDC4E1              CALL    SETROW              ; Set row
E0DC    CDAEE1              CALL    RIGHTP              ; Right a pixel
E0DF    CDAEE1              CALL    RIGHTP              ; Skip grid
E0E2    F1                  POP     AF                  ;
E0E3    10EE                DJNZ    CM3                 ;
E0E5    E1                  POP     HL                  ; HL=CLOC
E0E6    D1                  POP     DE                  ; D=CMASK
E0E7    C1                  POP     BC                  ;
E0E8    CDB8E1              CALL    DOWNP               ; Down a pixel
E0EB    0D                  DEC     C                   ;
E0EC    20DD                JR      NZ,CM2              ;
E0EE    CDB8E1              CALL    DOWNP               ; Skip grid
E0F1    FD23                INC     IY                  ;
E0F3    10D4                DJNZ    CM1                 ;
E0F5    C9                  RET                         ;

E0F6    100008      INIT:   LD      BC,2048             ; Size
E0F9    11A3E2              LD      DE,CHRTAB           ; Destination
E0FC    2A20F9              LD      HL,(CGPNT+1)        ; Source
E0FF    C5          IN1:    PUSH    BC                  ;
E100    D5                  PUSH    DE                  ;
E101    3A1FF9              LD      A,(CGPNT)           ; Slot ID
E104    CD0C00              CALL    RDSLT               ; Read chr  pattern
E107    FB                  EI                          ;
E108    D1                  POP     DE                  ;
E109    C1                  POP     BC                  ;
E10A    12                  LD      (DE),A              ; Put in buffer
E10B    13                  INC     DE                  ;
E10C    23                  INC     HL                  ;
E10D    0B                  DEC     BC                  ;
E10E    78                  LD      A,B                 ;
E10F    B1                  OR      C                   ;
E110    20ED                JR      NZ,IN1              ;
E112    CD7200              CALL    INIGRP              ; SCREEN 2
E115    3AE9F3              LD      A,(FORCLR)          ; Colour 1
E118    07                  RLCA                        ;
E119    07                  RLCA                        ;
E11A    07                  RLCA                        ;
E11B    07                  RLCA                        ;
E11C    4F                  LD      C,A                 ; C=Colour 1
E11D    3AEAF3              LD      A,(BAKCLR)          ; Colour 0
E120    B1                  OR      C                   ; Mix
E121    010018              LD      BC,6144             ; Colour table size
E124    2AC9F3              LD      HL,(GRPCOL)         ; Colour table
E127    CD5600              CALL    FILVRM              ; Fill colours
E12A    210BB1              LD      HL,177*256+11       ;
E12D    010AFF              LD      BC,0FFH*256+10      ;
E130    1E06                LD      E,6                 ;
E132    3E11                LD      A,17                ;
E134    CD62E1              CALL    GRID                ; Draw chr grid
E137    210631              LD      HL,49*256+6         ;
E13A    01BEAA              LD      BC,0AAH*256+190     ;
E13D    1E06                LD      E,6                 ;
E13F    3E09                LD      A,9                 ;
E141    CD62E1              CALL    GRID                ; Draw mag grid
E144    213031              LD      HL,49*256+48        ;
E147    01BEFF              LD      BC,0FFH*256+190     ;
E14A    1E06                LD      E,6                 ;
E14C    3E02                LD      A,2                 ;
E14E    CD62E1              CALL    GRID                ; Draw mag box
E151    AF                  XOR     A                   ;
E152    32A2E2              LD      (DOTNUM),A          ; Current dot
E155    21A1E2              LD      HL,CHRNUM           ;
E158    77                  LD      (HL),A              ; Current chr
E159    E5          IN2:    PUSH    HL                  ;
E15A    CD9EE0              CALL    CHROUT              ; Display chr
E15D    E1                  POP     HL                  ;
E15E    34                  INC     (HL)                ; Next chr
E15F    20F8                JR      NZ,IN2              ; Do 256
E161    C9                  RET                         ;

E162    F5          GRID:   PUSH    AF                  ;
E163    C5                  PUSH    BC                  ;
E164    E5                  PUSH    HL                  ;
E165    CDA3E1              CALL    MAP                 ; Map
E168    C1                  POP     BC                  ; B=Len,C=Step
E169    F1                  POP     AF                  ;
E16A    5F                  LD      E,A                 ; E=Pattern
E16B    F1                  POP     AF                  ; A=Count
E16C    F5                  PUSH    AF                  ;
E16D    D5                  PUSH    DE                  ;
E16E    E5                  PUSH    HL                  ;
E16F    F5          GR1:    PUSH    AF                  ;
E170    C5                  PUSH    BC                  ;
E171    D5                  PUSH    DE                  ;
E172    E5                  PUSH    HL                  ;
E173    78                  LD      A,B                 ; A=Len
E174    CDC4E1              CALL    SETROW              ; Horizontal line
E177    E1                  POP     HL                  ; HL=CLOC
E178    D1                  POP     DE                  ; D=CMASK
E179    CDB8E1      GR3:    CALL    DOWNP               ; Down a pixel
E17C    0D                  DEC     C                   ; Done step?
E17D    20FA                JR      NZ,GR3              ;
E17F    C1                  POP     BC                  ;
E180    F1                  POP     AF                  ; A=Count
E181    3D                  DEC     A                   ; Done lines?
E182    20EB                JR      NZ,GR1              ;
E184    E1                  POP     HL                  ; HL=Initial CLOC
E185    D1                  POP     DE                  ; D=Initial CMASK
E186    F1                  POP     AF                  ; A=Count
E187    F5          GR4:    PUSH    AF                  ;
E188    C5                  PUSH    BC                  ;
E189    D5                  PUSH    DE                  ;
E18A    E5                  PUSH    HL                  ;
E18B    3E01        GR5:    LD      A,1                 ; Line width
E18D    CDC4E1              CALL    SETROW              ; Thin line
E190    CDB8E1              CALL    DOWNP               ; Down a pixel
E193    10F6                DJNZ    GR5                 ; Vertical len
E195    E1                  POP     HL                  ; HL=CLOC
E196    D1                  POP     DE                  ; D=CMASK
E197    CDAEE1      GR6:    CALL    RIGHTP              ; Right a pixel
E19A    0D                  DEC     C                   ; Done step?
E19B    20FA                JR      NZ,GR6              ;
E19D    C1                  POP     BC                  ;
E19E    F1                  POP     AF                  ; A=Count
E19F    3D                  DEC     A                   ; Done lines?
E1A0    20E5                JR      NZ,GR4              ;
E1A2    C9                  RET                         ;

E1A3    0600        MAP:    LD      B,0                 ; X MSB
E1A5    50                  LD      D,B                 ; Y MSB
E1A6    CD1101              CALL    MAPXYC              ; Map coords
E1A9    CD1401              CALL    FETCHC              ; HL=CLOC
E1AC    57                  LD      D,A                 ; D=CMASK
E1AD    C9                  RET                         ;

E1AE    CB0A        RIGHTP: RRC     D                   ; Shift CMASK
E1B0    D0                  RET     NC                  ; NC=Same cell
E1B1    C5          RP1:    PUSH    BC                  ;
E1B2    010800              LD      BC,8                ; Offset
E1B5    09                  ADD     HL,BC               ; HL=Next cell
E1B6    C1                  POP     BC                  ;
E1B7    C9                  RET                         ;

E1B8    23          DOWNP:  INC     HL                  ; CLOC down
E1B9    7D                  LD      A,L                 ;
E1BA    E607                AND     7                   ; Select pixel row
E1BC    C0                  RET     NZ                  ; NZ=Same cell
E1BD    C5                  PUSH    BC                  ;
E1BE    01F800              LD      BC,00F8H            ; Offset
E1C1    09                  ADD     HL,BC               ; HL=Next cell
E1C2    C1                  POP     BC                  ;
E1C3    C9                  RET                         ;

E1C4    C5          SETROW: PUSH    BC                  ;
E1C5    47                  LD      B,A                 ; B=Count
E1C6    CD4A00      SE1:    CALL    RDVRM               ; Get old pattern
E1C9    4F          SE2:    LD      C,A                 ; C=Old
E1CA    7A                  LD      A,D                 ; A=CMASK
E1CB    2F                  CPL                         ; AND mask
E1CC    A1                  AND     C                   ; Strip old bit
E1CD    CB03                RLC     E                   ; Shift pattern
E1CF    3001                JR      NC,SE3              ; NC=0 Pixel
E1D1    B2                  OR      D                   ; Set 1 Pixel
E1D2    05          SE3:    DEC     B                   ; Finished?
E1D3    280C                JR      Z,SE4               ;
E1D5    CB0A                RRC     D                   ; CMASK right
E1D7    30F0                JR      NC,SE2              ; NC=Same cell
E1D9    CD4D00              CALL    WRTVRM              ; Update cell
E1DC    CDB1E1              CALL    RP1                 ; Next cell
E1DF    18E5                JR      SE1                 ; Start again
E1E1    CD4D00      SE4:    CALL    WRTVRM              ; Update cell
E1E4    C1                  POP     BC                  ;
E1E5    C9                  RET                         ;

E1E6    3AA2E2      DOTXY:  LD      A,(DOTNUM)          ; Current dot
E1E9    F5                  PUSH    AF                  ;
E1EA    E607                AND     7                   ; Column
E1EC    07                  RLCA                        ;
E1ED    4F                  LD      C,A                 ; C=Col*2
E1EE    07                  RLCA                        ; A=Col*4
E1EF    81                  ADD     A,C                 ; A=Col*6
E1F0    C6BF                ADD     A,191               ; Grid atart
E1F2    4F                  LD      C,A                 ; C=X coord
E1F3    F1                  POP     AF                  ;
E1F4    E638                AND     38H                 ; Row*8
E1F6    0F                  RRCA                        ;
E1F7    5F                  LD      E,A                 ; E=Row*4
E1F8    0F                  RRCA                        ; A=Row*2
E1F9    83                  ADD     A,E                 ; A=Row*6
E1FA    C607                ADD     A,7                 ; Grid start
E1FC    5F                  LD      E,A                 ; E=Y coord
E1FD    C9                  RET                         ;

E1FE    3AA1E2      CHRXY:  LD      A,(CHRNUM)          ; Current chr
E201    F5                  PUSH    AF                  ;
E202    CD14E2              CALL    MULT11              ; Column*11
E205    C60C                ADD     A,12                ; Grid start
E207    4F                  LD      C,A                 ; C=X coord
E208    F1                  POP     AF                  ;
E209    0F                  RRCA                        ;
E20A    0F                  RRCA                        ;
E20B    0F                  RRCA                        ;
E20C    0F                  RRCA                        ;
E20D    CD14E2              CALL    MULT11              ; Row*11
E210    C608                ADD     A,8                 ; Grid start
E212    5F                  LD      E,A                 ; E=Y coord
E213    C9                  RET                         ;

E214    E60F        MULT11: AND     0FH                 ;
EF16    57                  LD      D,A                 ; D=N
E217    07                  RLCA                        ;
E218    47                  LD      B,A                 ; B=N*2
E219    07                  RLCA                        ;
E21A    07                  RLCA                        ; A=N*8
E21B    80                  ADD     A,B                 ;
E21C    82                  ADD     A,D                 ; A=N*11
E21D    C9                  RET                         ;

E21E    3AA1E2      PATPOS: LD      A,(CHRNUM)          ; Current chr
E221    6F                  LD      L,A                 ;
E222    2600                LD      H,0                 ; HL=Chr
E224    29                  ADD     HL,HL               ;
E225    29                  ADD     HL,HL               ;
E226    29                  ADD     HL,HL               ; HL=Chr*8
E227    EB                  EX      DE,HL               ; DE=Chr*8
E228    FD21A3E2            LD      IY,CHRTAB           ; Patterns
E22C    FD19                ADD     IY,DE               ; IY->Pattern
E22E    C9                  RET                         ;

E22F    0600        GETKEY: LD      B,0                 ; Cursor flag
E231    C5          GE1:    PUSH    BC                  ; C=X coord
E232    D5                  PUSH    DE                  ; E=Y coord
E233    CD50E2              CALL    INVERT              ; Flip cursor
E236    D1                  POP     DE                  ;
E237    C1                  POP     BC                  ;
E238    04                  INC     B                   ; Flip flag
E239    21401F              LD      HL,8000             ; Blink rate
E23C    CD9C00      GE2:    CALL    CHSNS               ; Check KEYBUF
E23F    2007                JR      NZ,GE3              ; NZ=Got key
E241    2B                  DEC     HL                  ;
E242    7C                  LD      A,H                 ;
E243    B5                  OR      L                   ;
E244    20F6                JR      NZ,GE2              ;
E246    18E9                JR      GE1                 ; Time for cursor
E248    CB40        GE3:    BIT     0,B                 ; Cursor state
E24A    C450E2              CALL    NZ,INVERT           ; Remove cursor
E24D    C39F00              JP      CHGET               ; Collect character

E250    D5          INVERT: PUSH    DE                  ;
E251    CDA3E1              CALL    MAP                 ; Map coords
E254    F1                  POP     AF                  ; A=Cursor size
E255    47                  LD      B,A                 ; B=Rows
E256    5F                  LD      E,A                 ; E=Cols
E257    D5          IV1:    PUSH    DE                  ;
E258    E5                  PUSH    HL                  ;
E259    CD4A00      IV2:    CALL    RDVRM               ; Old pattern
E25C    AA                  XOR     D                   ; Flip a bit
E25D    CD4D00              CALL    WRTVGM              ; Put it back
E260    CDAEE1              CALL    RIGHTP              ; Right a pixel
E263    1D                  DEC     E                   ;
E264    20F3                JR      NZ,IV2              ;
E266    E1                  POP     HL                  ; HL=CLOC
E267    D1                  POP     DE                  ; D=CMASK
E268    CDB8E1              CALL    DOWNP               ; Down a pixel
E26B    10EA                DJNZ    IV1                 ;
E26D    C9                  RET                         ;

E26E    010008      ADOPT:  LD      BC,2048             ; Size
E271    1180EB              LD      DE,0EB80H           ; Destination
E274    ED5320F9            LD      (CGPNT+1),DE        ;
E278    21A3E2              LD      HL,CHRTAB           ; Source
E27B    EDB0                LDIR                        ; Copy up high
E27D    CD3801              CALL    RSLREG              ; Read PSLOT reg
E280    07                  RLCA                        ;
E281    07                  RLCA                        ;
E282    E603                AND     3                   ; Select Page 3
E284    4F                  LD      C,A                 ;
E285    0600                LD      B,0                 ; BC=Page 3 PSLOT#
E287    21C1FC              LD      HL,EXPTBL           ; Expanders
E28A    09                  ADD     HL,BC               ;
E28B    CB7E                BIT     7,(HL)              ; PSLOT expanded?
E28D    280E                JR      Z,AD1               ; A=Normal
E28F    21C5FC              LD      HL,SLTTBL           ; Secondary regs
E292    09                  ADD     HL,BC               ;
E293    7E                  LD      A,(HL)              ; A=Secondary reg
E294    07                  RLCA                        ;
E295    07                  RLCA                        ;
E296    07                  RLCA                        ;
E297    07                  RLCA                        ;
E298    E60C                AND     0CH                 ; A=Page 3 SSLOT#
E29A    B1                  OR      C                   ; Mix Page 3 PSLOT#
E29B    CBFF                SET     7,A                 ; A=Slot ID
E29D    321FF9      AD1:    LD      (CGPNT),A           ;
E2A0    C9                  RET                         ;

E2A1    00          CHRNUM: DEFB    0                   ; Current chr
E2A2    00          DOTNUM: DEFB    0                   ; Current dot
E2A3                CHRTAB: DEFS    2048                ; Patterns to EAA2H

                            END
```

[CH01F01]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH01F01.svg
[CH01F02]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH01F02.svg
[CH01F03]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH01F03.svg
[CH01F04]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH01F04.svg
[CH01F05]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH01F05.svg
[CH01F06]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH01F06.svg
[CH02F07]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH02F07.svg
[CH02F08]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH02F08.svg
[CH02F09]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH02F09.svg
[CH02F10]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH02F10.svg
[CH02F11]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH02F11.svg
[CH02F12]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH02F12.svg
[CH02F13]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH02F13.svg
[CH02F14]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH02F14.svg
[CH02F15]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH02F15.svg
[CH02F16]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH02F16.svg
[CH02F17]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH02F17.svg
[CH02F18]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH02F18.svg
[CH02F19]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH02F19.svg
[CH02F20]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH02F20.svg
[CH02F21]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH02F21.svg
[CH02F22]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH02F22.svg
[CH02F23]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH02F23.svg
[CH02F24]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH02F24.svg
[CH03F25]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH03F25.svg
[CH03F26]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH03F26.svg
[CH03F27]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH03F27.svg
[CH03F28]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH03F28.svg
[CH03F29]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH03F29.svg
[CH03F30]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH03F30.svg
[CH03F31]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH03F31.svg
[CH03F32]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH03F32.svg
[CH03F33]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH03F33.svg
[CH04F34]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH04F34.svg
[CH04F35]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH04F35.svg
[CH04F36]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH04F36.svg
[CH04F37]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH04F37.svg
[CH04F38]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH04F38.svg
[CH04F39a]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH04F39a.svg
[CH04F39b]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH04F39b.svg
[CH04F40]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH04F40.svg
[CH05F41]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH05F41.svg
[CH05F42]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH05F42.svg
[CH05F43]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH05F43.svg
[CH05F44]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH05F44.svg
[CH05F45]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH05F45.svg
[CH05F46]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH05F46.svg
[CH05F47]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH05F47.svg
[CH05F48]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH05F48.svg
[CH05F49]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH05F49.svg
[CH05F50]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH05F50.svg
[CH05F51]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH05F51.svg
[CH05F52]: https://rawgit.com/oraculo666/the-msx-red-book/master/images/CH05F52.svg
