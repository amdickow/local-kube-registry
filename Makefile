

create-pod:
	kubectl create -f kube-registry.yaml
	sleep 5

start-service: create-pod
	$(eval PODNAME=$(shell sh -c "kubectl get po -n kube-system | grep kube-registry-v0" | awk '{print a$$1;}'))
	kubectl port-forward --namespace kube-system ${PODNAME} 5000:5000

stop-service:
	kubectl delete -f kube-registry.yaml
