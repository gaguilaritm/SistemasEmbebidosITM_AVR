;**** A P P L I C A T I O N   N O T E   A V R 3 2 5 ************************
;*
;* Title:          High-speed Interface to Host EPP Parallel Port
;* Version:        1.0
;* Last updated:   2001.12.20
;* Target:         All AVR Devices with 12 I/O pins or more
;*
;* Support E-mail: avr@atmel.com
;* 
;* DESCRIPTION
;* This Application Note describes a method for high-speed bidirectional data
;* transfer between an AVR microcontroller and an off-the-shelf Intel x86
;* desktop computer.
;*
;* The code contains the EPP library and ISR, along with a sample application
;* which merely echoes to the host any data sent to it.
;*
;***************************************************************************

.include "8515def.inc"

;   Handy application registers. EPP library registers are below.

.def    tmp     = R17                   ; Ubiquitous temporary
.def    par0    = R16                   ; First function parameter

;   Point of terminology:
;   Tx and Rx are used throughout from the host's point of view
;   (Tx, e.g. goes out from	the host).
;   The AVR program, however,  has the notion of putting
;   and getting data to/from a peer, where put corresponds
;   to a host Rx operation.
;   The terminology conversion (as it were) takes place in
;   epp_getc/epp_putc.

;-----------------------------------------------------------

;   Reset and interrupt vectors

.cseg
.org    0                               ; Reset vector
    rjmp    start

.org    INT0addr                        ; INT0 vector
    rjmp    epp_int0

;-----------------------------------------------------------
;
;   start() - Come here after reset
;
;   This is a sample main program, which just echoes
;   characters sent from the host with a little bit
;   of decoration.

.equ    PROMPT = '>'                    ; prompt character
.equ    CR = 0x0d                       ; Carriage Return
.equ    LF = 0x0a                       ; Line Feed

start:
    ldi	    tmp,low(RAMEND)             ; Set up stack pointer
    out	    SPL,tmp                     ; SP low half
    ldi	    tmp,high(RAMEND)
    out	    SPH,tmp                     ; SP high half

;   Initialize the EPP - epp_init assumes interrupts are disabled.

    rcall   epp_init                    ; Initialization

    sei                                 ; Now we can enable interrupts

;   This is a sample application which echoes (forever)
;   what the host sends it over the EPP.

;   The only modifications it does to the data stream are 
;     (1) a linefeed is inserted following any carriage return and 
;     (2) a prompt at the beginning of each line.

newline:                                ; beginning of new line
    ldi     par0,PROMPT                 ; prompt
    rcall   epp_putc                    ; send it

;   Forever:
;   Get character from host

loop:
    rcall   epp_getc

;   Echo the character back to the host

echo:
    rcall   epp_putc                    ; echo

;   To make it pretty, add a linefeed after any CR

    cpi     par0,CR                     ; after a CR,
    brne    loop
    ldi     par0,LF                     ; add a linefeed for niceness
    rcall   epp_putc

    rjmp    newline                     ; back to the top (prompt)

;   End of sample application

;-----------------------------------------------------------
;   This is the EPP library.
;   Private definitions are here for data-hiding
;   (and easy copying).

;   Registers:
;   The library uses 5 registers. Three provide
;   the buffering mechanism, and the other two are
;   dedicated to the ISR for performance/stack.

;   The following dedicated registers (could be in SRAM)
;   provide a one-element queue in each direction.
;
.def    epprxbuf = R25                  ; one-element queue to host
.def    epptxbuf = R24                  ; one-element queue from host
.def    eppflag  = R23                  ; control bits (see below)

;   Flags (bit numbers) in "eppflag"

.equ    EPPC_OBUFFULL = 0               ; obuf (epprxbuf) is full
.equ    EPPC_IBUFFULL = 1               ; ibuf (epptxbuf) is full
.equ    EPPC_IOVERRUN = 2               ; Tx has overrun

;   These two registers are dedicated to the ISR, and aren't saved.
;   In an 8MHz AVR, these could probably be pushed/popped and still
;   meet the deadline.

.def    SAVE_SREG = R1                  ; used to save SREG
.def    itmp = r22                      ; ISR work register

;	These are the port pins used by the EPP.

;   The four control lines use pins 2 and 4-6 of port D

.equ    eppctlddr = DDRD                ; control lines data direction
.equ    eppctlin  = PIND                ; input
.equ    eppctlout = PORTD               ; output

;   The control line assignments in PORTD are mostly conveniences,
;   in that they sidestep the UART and INT1 lines.
;   The only assignment we depend on is nDATASTR, assigned to INT0

.equ    nDATASTR = PD2                  ; Data Strobe (from host) [pin 14]
.equ    nWRITE   = PD4                  ; Read/Write  (from host) [pin  1]
.equ    nINTR    = PD5                  ; Interrupt   (to host)   [pin 10]
.equ    nWAIT    = PD6                  ; Device ready (to host)  [pin 11]

;   The eight data lines [pins 2-9] use (all of) port C

.equ    eppdataddr = DDRC               ; Data lines Data Direction
.equ    eppdatain  = PINC               ; Data lines Input
.equ    eppdataout = PORTC              ; Data lines Output

;   Use PORTB (LEDs) for debug

.equ    debugddr = DDRB                 ; Data Direction for LEDs
.equ    debugout = PORTB                ; Port for LEDs

;   If you don't want LED debugging, empty these two macros or remove them and
;   the references to them

.macro	LEDDEBUGINIT
    ser     itmp                        ; 0xFF
    out     debugddr,itmp               ; output
    out     debugout,itmp               ; off initially
.endmacro

.macro  LEDDEBUG
    mov     itmp,@0
    com     itmp
    out     debugout,itmp
.endmacro

;------------------------------------------------------------------
;
;   epp_init() - One-time initialization for the EPP unit.
;   Input:  none
;   Output: none

;   Notes:  Assumes interrupts are disabled.

epp_init:
    ldi     eppflag,(0<<EPPC_IBUFFULL)|(0<<EPPC_OBUFFULL)|(0<<EPPC_IOVERRUN)

;   DEBUG: set up the LEDs

    LEDDEBUGINIT

;   Initialize the data lines for input.
;   This isn't strictly necessary, since they'll be set on the fly.

    clr     itmp                        ; 0x00
    out     eppdataddr,itmp             ; input
    out     eppdataout,itmp             ; tri-state

;   Set nINTR to 0 (no interrupt)

    sbi     eppctlddr,nINTR             ; output
    cbi     eppctlout,nINTR             ; initially 0 (no int)

;   Set nWAIT to 0 (not busy)

    sbi     eppctlddr,nWAIT             ; output
    cbi     eppctlout,nWAIT             ; initially 0

;   Set nDATASTR to input, and turn off the internal pullups

    cbi     eppctlddr,nDATASTR          ; input
    cbi     eppctlout,nDATASTR          ; tri-state

;   Set nWRITE to input, and turn off the internal pullups

    cbi     eppctlddr,nWRITE            ; input
    cbi     eppctlout,nWRITE            ; tri-state

;   Set int0 for falling edge (initially)

    in      itmp,MCUCR
    cbr     itmp,(1<<ISC01)|(1<<ISC00)  ; clear 'em both
    sbr     itmp,(1<<ISC01)|(0<<ISC00)  ; set to falling
    out     MCUCR,itmp

;   Enable int0, which will indicate nDATASTR to us.

    in	    itmp,GIMSK
    sbr     itmp,(1<<INT0)
    out     GIMSK,itmp

    ret

;-----------------------------------------------------------
;
;   epp_putc:   Send byte to host

;   Input: 	PAR0 - Byte to send
;   Output:	none

;   Notes:  This function waits until it can stage the byte

epp_putc:

;   Spin until output buffer becomes free

epp_put1:
    sbrc    eppflag,EPPC_OBUFFULL       ; skip if OBUF empty
    rjmp    epp_put1                    ; else wait some more

;   Set the Rx buffer so the ISR can pick it up

    mov     epprxbuf,par0               ; pass to ISR

;   Tell ISR there's something to send to the host

    sbr     eppflag,(1<<EPPC_OBUFFULL)  ; Tell ISR

;   Tell host we've got data (similar to EOI)

    sbi     eppctlout,nINTR             ; tell host directly

    ret

;-----------------------------------------------------------
;
;   epp_getc: get byte from host

;   Input:  none
;   Output:	PAR0 - byte from host

;   Notes:  This function waits until the byte arrives

epp_getc:

;   Spin until input buffer is full

epp_get1:
    sbrs    eppflag,EPPC_IBUFFULL       ; wait until
    rjmp    epp_get1                    ; ibuf is full

;   If there was an overrun, send back a '!'

    sbrc    eppflag,EPPC_IOVERRUN       ; skip if no overrun
    rjmp    epp_get_overrun

;   Fetch the byte from the Tx buffer

    mov     par0,epptxbuf               ; grab the byte

;   Mark the Tx buffer as empty

    cbr     eppflag,(1<<EPPC_IBUFFULL) 	; say we've got it

    ret

;   Overrun is indicated by passing back a '!' byte.
;   In a real application, this might be checked by
;   the caller, ignored, or indicated by an EPP
;   Write Timeout (see notes in the ISR below).

epp_get_overrun:
    ldi     par0,'!'
    cbr     eppflag,(1<<EPPC_IOVERRUN) 	; minor race with ISR
    ret

;-----------------------------------------------------------
;
;   INT0 ISR
;
;   Invoked when nDATASTR changes.
;   Depending on the setting of nWRITE (Read or Write),
;   it puts (Rx) or gets (Tx) a byte to/from the host.

;   The EPP read or write cycle is handled in two phases.
;   The first happens when nDATASTR is asserted (falling);
;   Here the data is transferred and nWAIT is asserted.
;   The second happens when nDATASTR is de-asserted (rising).
;   In this phase nWAIT is de-asserted.

;   To catch both phases, the int0 interrupt sense is flip-
;   flopped between falling-edge and rising-edge.

;   The protocol, which says that the host shouldn't 
;   de-assert nDATASTR until we assert nWAIT, Should prevent 
;   any races.

;   If the host comes back to us (de-asserts nDATASTR) fast
;   enough, we do both phases within a single ISR call.

epp_int0:
    in      SAVE_SREG,SREG

;   Check which phase we're in

    in      itmp,MCUCR                  ; ISC0x bits

;   If we were set to rising-edge, then this is EOI

    sbrc    itmp,ISC00                  ; skip if we're set to falling-edge
    rjmp    epp0eoi                     ;  else it's the rising edge -> EOI

    sbr     itmp,(0<<ISC01)|(1<<ISC00)  ; set for rising edge
    out     MCUCR,itmp                  ; next time

;   Else if nWRITE is asserted (low), it's a write (Tx direction)

    sbis    eppctlin,nWRITE             ; skip if read
    rjmp    epp0write                   ; else write (Tx)

;   EPP read cycle (Rx)

epp0read:

;   We expect that the host will only read after we've 
;   indicated the availability of data via nINTR.
;   If there's no Rx data, then the host is asking out
;   of turn. For this case, we ignore the request and
;   let the host time out.

    sbrs    eppflag,EPPC_OBUFFULL       ; skip if buffer full
    rjmp    epp0done                    ; else let host time out

;   Put the byte on the data port

    ser     itmp                        ; all bits
    out     eppdataout,epprxbuf         ; put the byte
    out     eppdataddr,itmp             ; output

;   Signal the host that the data is ready

    sbi     eppctlout,nWAIT             ; tell host to proceed

;   At this point, we've sent the data and acknowledged the strobe.
;   While the host is doing its thing, we do bookkeeping.

    cbi     eppctlout,nINTR             ; muzzle the host interrupt

;   Show the byte on the LEDs for debugging

    LEDDEBUG epprxbuf                   ; put what we sent on the LEDs

    cbr     eppflag,(1<<EPPC_OBUFFULL)  ; say Rx buffer is empty now
    rjmp    epp0eio                     ; end of phase 1

;   EPP write cycle (Tx)

epp0write:

;   If the Tx buffer is full, we indicate overrun, but go
;   ahead and accept the byte. (The alternative would be
;   to let the host write time out and let it retry.)

    sbrc    eppflag,EPPC_IBUFFULL       ; skip if buffer empty
    sbr     eppflag,(1<<EPPC_IOVERRUN)  ; else indicate overrun

    clr     itmp                        ; all bits
    out     eppdataddr,itmp             ; input
    in      epptxbuf,eppdatain          ; get the byte
    sbi     eppctlout,nWAIT             ; let host proceed

;   We've accepted the byte, and acknowledged the strobe.
;   The next move is up to the host. Do some bookkeeping now.

    sbr     eppflag,(1<<EPPC_IBUFFULL)  ; say it's full now

;   Show the byte on the LEDs for debugging

    LEDDEBUG epptxbuf                   ; put what we got on the LEDs

;   At the end of phase-1, we check (opportunistically)
;   to see if the host is already done (nDATASTR de-asserted);
;   if so, we fall into the EOI sequence to finish the
;   EPP cycle, thus doing the whole operation in 1 ISR call.
;
;   Evidence suggests that this is a high-probability path,
;   since most modern PCs are so much faster than we are.
;   The speed advantage (nearly double) is so high that it 
;   may even be worth inserting a short spin-loop here if 
;   increase the probability of a hit.

epp0eio:
    sbis    eppctlin,nDATASTR           ; Has the host de-asserted already?
    rjmp    epp0done                    ; No, wait for rising edge.

    ldi     itmp,(1<<INTF0)             ; we suppose it's happened
    out     GIFR,itmp                   ; so clear the interrupt

    in      itmp,MCUCR

;   EPP end-of-interrupt (nDATASTR de-asserted)

epp0eoi:
    cbr     itmp,(0<<ISC01)|(1<<ISC00)  ; set for falling edge
    out     MCUCR,itmp                  ; next time

;   We acknowledge the de-assertion of nDATASTR by de-asserting nWAIT.

    cbi     eppctlout,nWAIT             ; end the cycle

;   Set the Data port back to input, though it's not strictly needed.

    clr     itmp
    out     eppdataddr,itmp             ; set data port back to input
    out     eppdataout,itmp             ; and tri-state

;	Done. Get out.

epp0done:
    out     SREG,SAVE_SREG
    reti
