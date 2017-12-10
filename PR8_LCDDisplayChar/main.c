#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/pgmspace.h>
#define  F_CPU 8000000UL
#include <util/delay.h>
#include "lcd.h"

#define		PORTDIR			DDRD
#define		PORTOUT			PORTD
#define		PORTIN			PIND
#define		LINE_CHARS		16

/* Sprite definitions */
#define	    SPRT_OFF		8
#define     ALIEN   		1
#define     BULLET  		2
#define     SHIP    		3
#define	    BOOM		    4
#define     ROCK    		5
#define     PWRUP   		6
#define     SPRITES 		4
#define     SPRITE_NUM  	SPRITES*8 - 1

/* Implicit function definitions */
void port_init(void);
void prog_custom_chars(void);
void get_events(void);
void refresh(void);
char next_item();
void lcd_send_number(int numero, int lenght);


/* Constant definitions  */
static const PROGMEM unsigned char sprites[] =
{
	0x1f, 0x11, 0x15, 0x11, 0x1f, 0x15, 0x0a, 0x00,     // Alien
	0x00, 0x00, 0x0a, 0x05, 0x0a, 0x00, 0x00, 0x00,	    // Bullet
	0x00, 0x0c, 0x1e, 0x13, 0x13, 0x1e, 0x0c, 0x00,     // Ship
	0x04, 0x11, 0x0e, 0x1b, 0x0e, 0x11, 0x04, 0x00	    // Explosion
};
//char string[33] = {[0 ... LINE_CHARS-1] = 32,'\n',[LINE_CHARS +1 ... LINE_CHARS*2-1] = 32};
//char old_string[33] = {[0 ... LINE_CHARS-1] = 32,'\n',[LINE_CHARS +1 ... LINE_CHARS*2-1] = 32};
char old_string0[LINE_CHARS] = {SHIP,[1 ... LINE_CHARS-1] = 32};
char old_string1[LINE_CHARS] = {[0 ... LINE_CHARS-1] = 32};
char string0[LINE_CHARS] = {SHIP,[1 ... LINE_CHARS-1] = 32};
char string1[LINE_CHARS] = {[0 ... LINE_CHARS-1] = 32};
int score = 0;
char game[32] = 
    {
        ALIEN, ALIEN, ALIEN, ALIEN, ALIEN, ALIEN, ALIEN, 32,
        32, 32, 32, 32, ALIEN, 32, 32, ALIEN,
        ALIEN, 32, ALIEN, 32 ,32 ,32, 32, ALIEN,
        ALIEN, 32, 32, 32, ALIEN, 32, 32, ALIEN
    };

int main (void) {
    int score_int;
    port_init();	/** Init ports **/
    lcd_init(LCD_DISP_ON);
    prog_custom_chars();
    sei();
    while(1){
        score_int = score;
        lcd_command(LCD_HOME);
	lcd_clrscr();
	lcd_puts(&string0);
        lcd_gotoxy(0,1);
        lcd_puts("Puntos: ");
        score_int /= 10;
        lcd_putc(48 + score_int%10);
        score_int = score;
        lcd_putc(48 + score_int%10);
	lcd_puts("       ");
        _delay_ms(20);
        refresh();
    }
    return 0;
}

/* Explicit function definitions */

void port_init(){
	PORTDIR = 0xFF;
	PORTDIR &= ~(_BV(PIND2) | _BV(PIND3));	/** PIND2 & PIND3 button inputs. **/
	PORTOUT	= (_BV(PIND2) | _BV(PIND3));   /** Pullups **/
	EIMSK = 1<<INT0 | 1 << INT1;					// Enable INT0 & INT1
	EICRA = ~(1<<ISC01 | 1<<ISC00);	// Trigger INT0 & INT1 on falling edge
}


char next_item(){
    return game[rand()%31];
}

void refresh(void) {
	int i;
	string0[LINE_CHARS-1] = next_item();
    string1[LINE_CHARS-1] = next_item();
	for(i = 0; i < LINE_CHARS; i++) {
        if(old_string0[i] == BOOM)
            string0[i] = 32;
//        if(old_string1[i] == BOOM)
//            string1[i] = 32;

        if(old_string0[i] == SHIP){
            if(old_string0[i+1] == ALIEN){
                lcd_clrscr();
                lcd_puts("PERDEDOR");
               for(;;);
            }
        }
//        if(old_string1[i] == SHIP){
//            if(old_string1[i+1] == ALIEN){
//                lcd_clrscr();
//                lcd_puts("PERDEDOR");
//                for(;;);
//            }
//        }

		if(old_string0[i] == ALIEN ) {
			if(old_string0[i-2] == BULLET || old_string0[i-1] == BULLET)
			{
                score++;
			 	string0[i-1] = BOOM;
			}
			else{
			string0[i-1] = ALIEN;
			}
			string0[i] = 32;
		}
//		if(old_string1[i] == ALIEN ) {
//			if(old_string1[i-2] == BULLET || old_string1[i-1] == BULLET)
//			{
//			 	string1[i-1] = BOOM;
//			}
//			else{
//			string1[i-1] = ALIEN;
//			}
//			string1[i] = 32;
//		}
		if(old_string0[i] == BULLET){
			string0[i] = 32;
			string0[i+1] = BULLET;
			
		}
//		if(old_string1[i] == BULLET){
//			string1[i] = 32;
//			string1[i+1] = BULLET;			
//		}

	}
//  strcpy(old_string0, string0);
//  strcpy(old_string1, string1);
	memcpy(old_string0, string0, sizeof(string0));
	memcpy(old_string1, string1, sizeof(string1));

}

void prog_custom_chars(void){
    int i = 0;
    lcd_command(_BV(LCD_CGRAM)+SPRT_OFF);   /** Set CG RAM address **/
    for (i = 0; i < SPRITE_NUM; i++) {
        lcd_data(pgm_read_byte_near(&sprites[i]));
    }
    lcd_command(_BV(LCD_DDRAM));
}

ISR(INT0_vect)
{
	if(old_string0[0] == SHIP)
	{
//		string0[0] = 32;
//		string1[0] = SHIP;
	}else{
//		string0[0] = SHIP;
//		string1[0] = 32;
	} 
}

ISR(INT1_vect)
{
	if(old_string0[0] == SHIP)
	{
		string0[1] = BULLET;
	}else{
//		string1[1] = BULLET;
	} 
}	
