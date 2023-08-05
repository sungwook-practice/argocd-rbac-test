up: install-argocd deploy-argocd-applications
down: delete-argocd-applications uninstall-argocd

install-kindcluster:
	cd kind_cluster && kind create cluster --config ./cluster.yaml

uninstall-kindcluster:
	kind delete cluster --name argocd-practice

install-argocd:
	cd argocd_manifests && \
	kubectl apply -f namespace.yaml && \
	kubectl kustomize ./ | kubectl apply -f -

uninstall-argocd:
	cd argocd_manifests && \
	kubectl kustomize ./ | kubectl delete -f -

deploy-argocd-applications:
	kubectl apply -f ./argocd_applications

delete-argocd-applications:
	kubectl delete -f ./argocd_applications
