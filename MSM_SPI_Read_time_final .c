#include <bcm2835.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include <string.h>
#include <errno.h>
#include <time.h>    
//#include <fcntl.h>
//#include <sys/ioctl.h>
//#include <linux/spi/spidev.h>

//#include <wiringPi.h>
//#include <wiringPiSPI.h>

#define	TRUE	(1==1)
#define	FALSE	(!TRUE)

#define SPI_PACKET_BYTES	17
#define SAMPLE_RATE			50000

uint16_t convertFrom8To16 (uint8_t dataFirst, uint8_t dataSecond) {
    uint16_t dataBoth = 0x0000;

    dataBoth = dataFirst;
    dataBoth = dataBoth << 8;
    dataBoth |= dataSecond;
    return dataBoth;
}



int main (int argc, char** argv){
	
	time_t nowtime;
	struct tm *today;  
	char buffer [30];
	char date[9];
	
	
	uint64_t sample_time = 1000000/SAMPLE_RATE;
	uint32_t sample_rate = SAMPLE_RATE;
	unsigned int sample_cnt = 0, ii, samples = 50000, sample_timer = sample_time;
	uint64_t start_time, end_time, now, time_now;
	uint8_t data[SPI_PACKET_BYTES] = {0};
	int16_t ch0_data = 0;
	int16_t ch1_data = 0;
	int16_t ch2_data = 0;
	int16_t ch3_data = 0;
	int16_t ch4_data = 0;
	int16_t ch5_data = 0;
	int16_t ch6_data = 0;
	int16_t ch7_data = 0;
	int16_t ch8_data = 0;
	int16_t ch9_data = 0;
	int16_t ch10_data = 0;
	int16_t ch11_data = 0;
	uint32_t bytes_to_transfer = 2;
	
    nowtime = time(NULL);
    struct tm *t = localtime(&nowtime);
    
    strftime( buffer, sizeof(buffer), "data_%d%m%y_%H%M%S.txt", t );
	
	

	if (argc < 2) {
        fprintf(stderr, "Usage: %s [-N SAMPLES] [-fs SAMPLE RATE]\n\n", argv[0]);
    }
	
	while (*argv) {
        if (strcmp(*argv, "-N") == 0) {
            argv++;
            if (*argv)
                samples = atoi(*argv);
        }
        if (strcmp(*argv, "-fs") == 0) {
            argv++;
            if (*argv)
                sample_rate = atoi(*argv);
				sample_time = 1000000/sample_rate;
        }
        if (*argv)
            argv++;
    }

	printf("MSM-Aufnahme von %i Samples (fs = %.2f kHz) wird gestartet...\n", samples, (float)sample_rate/1000);

	/* Create Output File */
	FILE *output_file = 0;
	output_file = fopen(buffer, "w");
	
	if(output_file == 0){
		fprintf (stderr, "Can't create output file: %s\n", strerror (errno));
		exit (EXIT_FAILURE); 
	}

	/* SPI Initialization */
	if (!bcm2835_init()){
		printf("bcm2835_init failed. Are you running as root??\n");
		return 1;
	}
	bcm2835_spi_begin();
	bcm2835_spi_setBitOrder(BCM2835_SPI_BIT_ORDER_MSBFIRST);      // The default
	bcm2835_spi_setDataMode(BCM2835_SPI_MODE1);                   // The default
	bcm2835_spi_setClockDivider(BCM2835_SPI_CLOCK_DIVIDER_16);  // 128 = 1.953125MHz ; 64 = 3,9MHz
	bcm2835_spi_chipSelect(BCM2835_SPI_CS0);                      // The default
	bcm2835_spi_setChipSelectPolarity(BCM2835_SPI_CS0 , LOW);      // the default


	start_time = bcm2835_st_read();
	fprintf(output_file, "%i,%i\n",start_time);
	fprintf(output_file, "ch0, ch1, ch2, ch3, ch4, ch5, ch6,ch7, ch8, ch9, ch10, ch11 ,us\n");
	while(sample_cnt < samples){
		now = bcm2835_st_read();

			sample_cnt++;
			/* Request Data from MSM-Module */
			bcm2835_spi_transfern(data, SPI_PACKET_BYTES);
			time_now = bcm2835_st_read();
			now = time_now - start_time;
			// output on console to see errors
			//printf("%02x,%02x,%02x,%02x,%02x,%02x,%02x,%02x,%02x,%02x,%02x,%02x,%02x,%02x,%02x,%02x\n",data[0],data[1],data[2],data[3],data[4],data[5],data[6],data[7],data[8],data[9],data[10],data[11],data[12],data[13],data[14],data[15],data[16]);

			ch0_data = convertFrom8To16(data[1],data[2]);
			ch1_data = convertFrom8To16(data[3],data[4]);	
			ch2_data = convertFrom8To16(data[5],data[6]);	
			ch3_data = convertFrom8To16(data[7],data[8]);	
			ch4_data = convertFrom8To16(data[9],data[10]);	
			ch5_data = convertFrom8To16(data[11],data[12]);	
			ch6_data = convertFrom8To16(data[13],data[14]);
                        
                        //hinzugefügt für die anderen mikros
                        ch7_data = convertFrom8To16(data[15],data[16]);	
			ch8_data = convertFrom8To16(data[17],data[18]);	
			ch9_data = convertFrom8To16(data[19],data[20]);	
			ch10_data = convertFrom8To16(data[21],data[22]);	
			ch11_data = convertFrom8To16(data[23],data[24]);
	
			
			//angepasst auf 12
			fprintf(output_file, "%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i, %i\n", ch0_data, ch1_data, ch2_data, ch3_data, ch4_data, ch5_data, ch6_data, ch7_data, ch8_data, ch9_data, ch10_data, ch11_data, now);  //now,
			
		//}
	}
	
	end_time = bcm2835_st_read();
	float duration = (float)(end_time - start_time)/1000000;
	printf("Dauer: %f s\n", duration);
	float samplerate = ((float)samples/duration)/1000;
	printf("Samplerate: %.2f kHz\n", samplerate);
	
	fclose(output_file);
	bcm2835_spi_end();
	bcm2835_close();
	
	return 0;
}
