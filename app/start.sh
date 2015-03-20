#!/bin/bash

# Mazacoind is expected to be at hostname 'groestlcoind'
# which is set via --link
# Because we use linked containers we can use the 
# standard ports 
### Tate-server doesn't really support testnet
. /app/electrum-grs-server.env
COIN=GroestlCoin
USER=${USER:-coin}
EGRS_HOSTNAME=${EGRS_HOSTNAME:-${HOSTNAME}}
EGRS_PORT=${EGRS_PORT:-50001}
EGRS_SSLPORT=${EGRS_SSL_PORT:-50002}
COIND=${COIND:-localhost}
COINDIR=${COINDIR:-/home/${USER}/.${COIN}}
RPCPORT=${RPCPORT:-1441}
RPCUSER=${RPCUSER:-$(grep rpcuser "${COINDIR}"/${COIN}.conf |awk -F= '{print $2}')}
RPCPASSWORD=${RPCPASSWORD:-$(grep rpcpassword "${COINDIR}"/${COIN}.conf |awk -F= '{print $2}')}
txidx=$(grep "txindex=" "${COINDIR}"/${COIN}.conf |awk -F= '{print $2}')
TXINDEX=${TXINDEX:-${txidx}}

EGRS_PASSWORD=$(egrep '^password =' /etc/electrum-grs.conf|awk -F= '{print $2}')

EGRS_PASSWORD=$(apg -a 0 -m 32 -x 32 -n 1)
if [ "${TXINDEX}" = "1" ] ; then
   echo "-txindex is set    good to go"
else echo "$(date) txindex not set in groestlcoin.conf - daemon restart required"
     touch /etc/service/groestlcoind/down
     echo "Now you can start groestlcoind manually with -reindex and then add:"
     echo "txindex=1"
     echo "to your ${COINDIR}/groestlcoin.conf"
     echo "then remove /etc/service/groestlcoind/down"
fi     
## this is kinda backwards, but there you have it
echo "$(date) starting electrum-grs-server with RPC from: ${COIND}:${RPCPORT}"
cd /app
IFS="" sed -e 's/bitcoind_host\ \=.*/bitcoind_host\ \=\ '${COIND}'/g' \
	-e 's/bitcoind_port\ \=.*/bitcoind_port\ \=\ '${RPCPORT}'/g' \
	-e 's/bitcoind_user\ \=.*/bitcoind_user\ \=\ '${RPCUSER}'/g' \
	-e 's/bitcoind_password\ \=.*/bitcoind_password\ \=\ '${RPCPASSWORD}'/g' \
	-e 's/^host\ \=.*/host\ \=\ '${EGRS_HOSTNAME}'/g' \
	-e 's/^password\ \=.*/password\ \=\ '${EGRS_PASSWORD}'/g' \
	-e 's/^username\ \=.*/username\ \=\ '${USER}'/g' \
	-e 's/^stratum_tcp_ssl_port\ \=.*/stratum_tcp_ssl_port\ \=\ '${EGRS_SSLPORT}'/g' \
	-e 's/^stratum_tcp_port\ \=.*/stratum_tcp_port\ \=\ '${EGRS_PORT}'/g' \
	electrum-grs.conf > ./new-egrs.conf
cp ./new-egrs.conf /etc/electrum-grs.conf
exec /app/run_electrum_grs_server
