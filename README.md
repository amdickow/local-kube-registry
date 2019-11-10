Using local registry for sharing docker images to kubernetes deployments in minikube


TLDR;
Use the Makefile for starting and stopping the service:

START ->
$ make start-service

STOP ->
$ make stop-service


If you have docker-machine:
ssh -i ~/.docker/machine/machines/default/id_rsa -R 5000:localhost:5000 \docker@$(docker-machine ip)



This blog post explains the problem:
https://blog.hasura.io/sharing-a-local-registry-for-minikube-37c7240d0615/

.. and the solution:

- Use localhost:5000 as the registry

1. Create a registry on minikube
Create a registry (a replication-controller and a service) and create a proxy to make sure the minikube VM’s 5000 is proxied to the registry service’s 5000.

kubectl create -f kube-registry.yaml

(Grab kube-registry.yaml from this gist on github.)

At this point, minikube ssh && curl localhost:5000 should work and give you a response from the docker registry.

2. Map the host port 5000 to minikube registry pod
kubectl port-forward --namespace kube-system \ 
$(kubectl get po -n kube-system | grep kube-registry-v0 | \awk '{print $1;}') 5000:5000
After this, from the host curl localhost:5000 should return a valid response from the docker registry running on minikube

3. Non-linux peoples: Map docker-machine’s 5000 to the host’s 5000.
ssh -i ~/.docker/machine/machines/default/id_rsa \
-R 5000:localhost:5000 \docker@$(docker-machine ip)
After this, running docker-machine ssh && curl localhost:5000 should return a valid response from the docker registry running on minikube.




