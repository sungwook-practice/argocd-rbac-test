# 개요
* kustomize로 argocd 설치

# 전제조건
* 30950, 30951 포트 미사용
  * 이유: argocd server pod가 30950/30950포트를 nodeport로 사용

# 설치방법
```bash
kubectl create ns argocd
kubectl kustomize ./ | kubectl apply -f -
```

# admin default password
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

# argocd 로컬계정 비밀번호 설정
* argcd CLI 다운로드
```bash
ARGOCD_VERSION=v2.6.2
PLATFORM=darwin-amd64
wget https://github.com/argoproj/argo-cd/releases/download/$ARGOCD_VERSION/argocd-$PLATFORM
chmod u+x ./argocd-$PLATFORM
sudo mv ./argocd-$PLATFORM /usr/local/bin/argocd
```

* 계정 변경
```bash
# /pathces/argocd-cm.yaml에 설정된 계정 비밀번호 변경
ADMIN_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
NEW_PASSWORD=password1234
argocd login 127.0.0.1:30951 --insecure --username admin --password $ADMIN_PASSWORD
argocd account update-password --account alice --current-password $ADMIN_PASSWORD --new-password $NEW_PASSWORD
argocd account update-password --account bob --current-password $ADMIN_PASSWORD --new-password $NEW_PASSWORD
argocd account update-password --account tom --current-password $ADMIN_PASSWORD --new-password $NEW_PASSWORD
```

# 삭제 방법
```bash
kubectl kustomize ./ | kubectl delete -f -
kubectl delete ns argocd
```

# 참고자료
* https://github.com/argoproj/argo-cd/issues/11318
* https://argo-cd.readthedocs.io/en/stable/operator-manual/rbac
* https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/
* https://github.com/argoproj/argo-cd/blob/master/assets/builtin-policy.csv