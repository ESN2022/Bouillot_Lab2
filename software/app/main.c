#include <stdio.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "sys/alt_irq.h"

//tableau de génération des chiffres
int cpt[10] =  {0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110, 0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01101111};

int main(){
	while(1){
		for (int i=0; i<10;i++){
			IOWR_ALTERA_AVALON_PIO_DATA(PIO_0_BASE,~cpt[i]);
			usleep(125000);
		}
	}
	return 0;
}