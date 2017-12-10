#include <avr/io.h>
#define	F_CPU 12800000UL
#include <util/delay.h>

int main(){
    DDRD = 0xFF;
    PORTD = 0x03;
	for(;;){
        PORTD ^= 0x03;
		_delay_ms(1000);
	}
}


