CC=avr-gcc
CFLAGS=-mmcu=atmega328p -Wall -O3 -g
DEPS=lcd.h
SOURCES=main.c lcd.c
OBJS=main.o lcd.o
ELF=main.elf
HEX=main.hex

%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)
main.elf: $(OBJS)
	$(CC) -o $(ELF)  $(OBJS) $(CFLAGS)
	avr-objcopy -j .text -j .data -O ihex $(ELF) $(HEX)
