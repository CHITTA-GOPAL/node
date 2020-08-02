sudo docker service create --name assign -p 8082:80 --replicas=1 venkatasunil/nodeapp:$BUILD_NUMBER 

