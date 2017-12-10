#include <avr/io.h>
#include "lcd.h"

int main()
{
	lcd_init();	
	lcd_set_cursor(0,0);
	lcd_send_string("Hola");
		
	
    for(;;)
    return 0;
}
