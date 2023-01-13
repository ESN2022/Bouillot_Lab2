#include <stdio.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "sys/alt_irq.h"

int main(){
	while(1){
		for (unsigned int k=0; k<10;k++){
			IOWR_ALTERA_AVALON_PIO_DATA(PIO_0_BASE,k<<8);
			for (unsigned int j=0; j<10;j++){
				IOWR_ALTERA_AVALON_PIO_DATA(PIO_0_BASE,j<<4);
				for (unsigned int i=0; i<10;i++){
					IOWR_ALTERA_AVALON_PIO_DATA(PIO_0_BASE,(k<<8) | (j<<4) | i);
					usleep(60000);
				}
			}
		}
	}
	return 0;
}