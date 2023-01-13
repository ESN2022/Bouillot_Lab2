#include <stdio.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "sys/alt_irq.h"
#include "altera_avalon_timer_regs.h"

int cpt = 0,i,j,k,tempo = 0;

static void irqhandler_timer(void* context){
	if (cpt == 1000){cpt=0;}
	tempo = cpt;
	//centaine
	k = tempo / 100;
	tempo -= k*100;
	//dizaine
	j = tempo / 10;
	tempo -= j*10;
	//unité
	i = tempo;
	cpt ++;
	IOWR_ALTERA_AVALON_PIO_DATA(PIO_0_BASE,(k<<8) | (j<<4) | i);
	
	//reset de l'interruption
	IOWR_ALTERA_AVALON_TIMER_STATUS(TIMER_0_BASE, 0);
}

int main(){
	//définition du registre et de la routine d'interruption
	alt_ic_isr_register(TIMER_0_IRQ_INTERRUPT_CONTROLLER_ID,TIMER_0_IRQ, (void*)irqhandler_timer, NULL, 0);
	//démarrage du timer
	IOWR_ALTERA_AVALON_TIMER_CONTROL(TIMER_0_BASE, 0x7);
	
	while(1){}
	return 0;
}