sudo docker service create --name assign -port 8082:80 --replicas=1 venkatasunil/nodeapp:$BUILD_NUMBER 

