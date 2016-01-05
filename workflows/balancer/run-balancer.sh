#!/bin/sh

export HADOOP_USER_NAME=$3

BAND_CURRENT=`hdfs getconf -confkey dfs.datanode.balance.bandwidthPerSec`
BAND_REQUIRED=$1
BALANCING_THRESHOLD=$2
RC=0

echo "Current network bandwidth: $BAND_CURRENT B/sec"
echo "Required network bandwidth: $BAND_REQUIRED B/sec"

if [ $BAND_CURRENT -lt $BAND_REQUIRED ]
	then 
		hdfs dfsadmin -setBalancerBandwidth $BAND_REQUIRED	
		RC=$?
fi

if [ $RC -eq 0 ]
    then
        echo "Starting balancer......"
	hdfs balancer -threshold $BALANCING_THRESHOLD
	RC=$?
fi

if [ $RC -ne 0 ]
    then
	echo "ERROR: Error while rebalancing the cluster!"
    else
	echo "SUCCESS: Rebalancing was successfull!"
fi

exit $RC
