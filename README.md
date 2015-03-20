## electrum-grs-server docker image


Variable settings below are sufficient to forge a new 
server database. You'll want to review the full set 
of  env variables supported in electrum-grs-server/app/start.sh
to run your production server. 

Initial database forging is **slow**
It's recommended to run with the groestlcoin blockdata
and the electrum-grs-server db in RAM, set as below
with the correct variables for the included start script, or
make your own with the bindmounts below in RAM.

For bonus speedup, if you have a lot of ram run a docker daemon with 
the graph set to storage space in ram. Be sure to account for needed images

For faster startup, data images are provided. 
groestlcoin/groestlcoin-idxdata
groestlcoin/electrum-grs-server-data 



Customize your electrum-grs.conf by adding ont to 
$HOST_DATA_PREFIX/app
and provide a docker bindmount
```
  -v ${HOST_DATE_PREFIX}/app/electrum-grs.conf:/app/electrum-grs.conf
```

```
TXINDEX=1
EGRS_HOSTNAME=localhost
COINDIR="/home/coin/.groestlcoin"
DATA_VOLDIR="/var/electrum-grs-server"
```
Adding thos

Customize hostname and mounts to your local config as needed:
```
HOST_DATA_PREFIX="/tmp/electrum-grs-server"
GROUP="electrum-grs"
APP="electrum-grsserver"
IMAGE="groestlcoin/electrum-grs-server-groestlcoind""
NAME="${GROUP}_${APP}"

docker run -d \
  -h "${HOSTNAME}" \
  --name=${NAME} \
  --restart=always \
  -p 50002:50002 \
  -p 8000:8000 \
  -p 12835:12835 \
  -e TXINDEX=1 \
  -e EGRS_HOSTNAME=localhost \
  -e HOSTNAME=${HOSTNAME:-localhost} \
  -v ${HOST_DATA_PREFIX}/app/certs:/app/certs \
  -v ${HOST_DATA_PREFIX}/groestlcoind:${COINDIR} \
  -v ${HOST_DATA_PREFIX}/electrum-grs-data:${DATA_VOLDIR} \
  ${IMAGE}



on docker run line


