echo Building client...
docker build -t abutler93/multi-client:latest -t abutler93/multi-client:$SHA -f ./client/Dockerfile ./client
echo Building server...
docker build -t abutler93/multi-server:latest -t abutler93/multi-server:$SHA -f ./server/Dockerfile ./server
echo Building worker...
docker build -t abutler93/multi-worker:latest -t abutler93/multi-worker:$SHA -f ./worker/Dockerfile ./worker


docker push abutler93/multi-client:latest
docker push abutler93/multi-server:latest
docker push abutler93/multi-worker:latest
docker push abutler93/multi-client:$SHA
docker push abutler93/multi-server:$SHA
docker push abutler93/multi-worker:$SHA

kubectl apply -f k8s

kubectl set image deployments/server-deployment server=abutler93/multi-server:$SHA
kubectl set image deployments/client-deployment server=abutler93/multi-client:$SHA
kubectl set image deployments/worker-deployment server=abutler93/multi-worker:$SHA


docker build -t abutler93/multi-server:latest -f ./server/Dockerfile ./server