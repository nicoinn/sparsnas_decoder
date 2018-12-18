#!/bin/sh


if [ -z "$SPARSNAS_SENSOR_ID"  ]
then
	echo "Sensor ID not defined - Cannot continue"
	exit 1
fi



if [ -z "$SPARSNAS_FREQ_MIN"  ] || [ -z "$SPARSNAS_FREQ_MAX"  ]
then 
	echo "######################################"
	echo "Recording 30s of data for callibration"
	echo "######################################"
	
	(rtl_sdr -f 868000000 -s 1024000 -g 40 - > /tmp/sparsnas.raw ) &
	(sleep 30 && killall rtl_sdr ) &
	wait 

	echo "#############################################"
	echo "Searching frequencies - This may take a while"
	echo "#############################################"

	export `sparsnas_decode /tmp/sparsnas.raw --find-frequencies`
	rm /tmp/sparsnas.raw

	echo " "
	echo "######################"
	echo "####Found frequencies:" 
	echo " " 
	echo "SPARNAS_FREQ_MIN " $SPARSNAS_FREQ_MIN
	echo "SPARNAS_FREQ_MAX " $SPARSNAS_FREQ_MAX
fi

rtl_sdr -f 868000000 -s 1024000 -g 40 - | sparsnas_decode | python2 /sensor_data_forwarder/sparsnas_forwarder.py 
