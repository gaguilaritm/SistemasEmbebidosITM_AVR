#include <msp430g2553.h>
#include "LCD_working.h"

void adc_init();
void timerA_init();
void port_init();
void update_screen();

int s_frec_count = 0;
int sec = 0;
int min = 14;
int hora = 4
;

void timerA_init()
{
	TACTL = TASSEL_2 | ID_3 | MC_1 | TAIE | TACLR;
	TACCTL0 = CCIE;
	TACCTL1 = OUTMOD_3;
	TACCR0 = 2083;
	TACCR1 = 1041;
}
void port_init()
{
	P1OUT &= 0x00;               // Shut down everything
	P1DIR &= 0x00;               
	P1DIR |= BIT0 + BIT6;            // P1.0 and P1.6 pins output the rest are input 
	P1REN |= BIT3;                   // Enable internal pull-up/down resistors
	P1OUT |= BIT3;                   //Select pull-up mode for P1.3
	P1IE |= BIT3;                       // P1.3 interrupt enabled
	P1IES |= BIT3;                     // P1.3 Hi/lo edge
	P1IFG &= ~BIT3;                  // P1.3 IFG cleared
}

int main()
{
	WDTCTL = WDTPW + WDTHOLD;
	DCOCTL = CALDCO_1MHZ;
	BCSCTL1 = CALBC1_1MHZ;
	
	port_init();
	
	lcd_init();	
	lcd_set_cursor(0,0);
	lcd_send_number(hora,2);
	lcd_send_string(":");
	lcd_set_cursor(3,0);
	lcd_send_number(min,2);
	lcd_send_string(":");	
	lcd_set_cursor(6,0);
	lcd_send_number(sec,2);
		
	timerA_init();
	
	_BIS_SR(CPUOFF + GIE);
    for(;;)
    return 0;
}
__attribute__((__interrupt__(TIMER0_A0_VECTOR)))
void timerA_isr(void){
	s_frec_count++;
	if(s_frec_count > 59)
	{
		sec++;
		if(sec > 59)
		{
			min++;
			if(min > 59)
			{
				hora++;
				if(hora > 11)
					hora = 0;
				lcd_set_cursor(0,0);
				lcd_send_number(hora,2);
				lcd_send_string(":");
				min = 0;
			}
			lcd_set_cursor(3,0);
			lcd_send_number(min,2);
			lcd_send_string(":");
			sec = 0;
		}
		lcd_set_cursor(6,0);
		lcd_send_number(sec,2);
		s_frec_count = 0;		
	}
} 
