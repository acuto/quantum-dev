#! /bin/bash 

NAMESPACE=$1
NAME=$2
TOKEN=`kubectl logs $NAME-0 -n quantum-dev | grep token | cut -d = -f 2 | head -n 1`
PORT=`kubectl get svc -n $NAMESPACE | grep $NAME | awk '{print$5}' | cut -d / -f 1`
echo "http://127.0.0.1:$PORT/?token=$TOKEN"
kubectl -n $NAMESPACE port-forward services/$NAME $PORT:$PORT &
