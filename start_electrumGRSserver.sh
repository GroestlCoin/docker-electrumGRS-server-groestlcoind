#!/bin/bash -x
TXINDEX=1
IMAGE="test/grs-e-server"
EGRS_HOSTNAME=localhost
GROUP="electrum-grs"
APP="electrum-grsserver"
HOST_DATA_PREFIX="/tmp/electrum-grs-server"
COINDIR="/home/coin/.groestlcoin"
DATA_VOLDIR="/var/electrum-grs-server"
HOSTNAME=${HOSTNAME:-localhost}
NAME="${GROUP}_${APP}"

run () {
docker run -d \
  -h "${HOSTNAME}" \
  --name=${NAME} \
  --restart=always \
  -p 50002:50002 \
  -p 8000:8000 \
  -p 12835:12835 \
  -v ${HOST_DATA_PREFIX}/app/certs:/app/certs \
  -v ${HOST_DATA_PREFIX}/groestlcoind:${COINDIR} \
  -v ${HOST_DATA_PREFIX}/electrum-grs-data:${DATA_VOLDIR} \
  ${IMAGE}

}

start () {
docker start ${NAME}
}
stop () {
docker stop ${NAME}
}

remove () {
docker rm ${NAME}
}


case ${1} in
 remove) remove
	;;
  start) start
	;;
   stop) stop
	;;
    run) run
	;;
      *) echo "Usage: ${0} [run|start|stop|remove]"
	;;
esac
