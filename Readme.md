# 개요
* argocd rbac 테스트

# 전제조건
* 쿠버네티스가 설치되어 있어야 함
  * (옵션) kind로 kubernetes 설치
  * kind를 사용하려면 docker가 설치되어 있어야 함
```bash
brew install kind
make install-kindcluster
```

* 30950, 30951 포트 미사용
  * 이유: argocd server pod가 30950/30950포트를 nodeport로 사용

# argocd 설치 방법
* make스크립트를 사용하여 argocd와 argocd application과 생성
```bash
make up
```

# argocd web UI접속
* admin 계정 비밀번호 확인
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

* nodeport를 사용하여 argocd server접속
주소: https://127.0.0.1:30951

# argocd 로컬계정 비밀번호 설정
* argcd CLI 다운로드
```bash
ARGOCD_VERSION=v2.6.2
PLATFORM=darwin-amd64
wget https://github.com/argoproj/argo-cd/releases/download/$ARGOCD_VERSION/argocd-$PLATFORM
chmod u+x ./argocd-$PLATFORM
sudo mv ./argocd-$PLATFORM /usr/local/bin/argocd
```

* 계정 비밀번호 변경
  * argocd를 설치하면 tom, alice, bob 계정이 생성되어 있습니다.
```bash
# ./argocd_manifests/pathces/argocd-cm.yaml에 설정된 계정 비밀번호 변경
ADMIN_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
NEW_PASSWORD=password1234

argocd login 127.0.0.1:30951 --insecure --username admin --password $ADMIN_PASSWORD
argocd account update-password --account alice --current-password $ADMIN_PASSWORD --new-password $NEW_PASSWORD
argocd account update-password --account bob --current-password $ADMIN_PASSWORD --new-password $NEW_PASSWORD
argocd account update-password --account tom --current-password $ADMIN_PASSWORD --new-password $NEW_PASSWORD
```

# argocd 삭제 방법
* argocd application과 argocd가 삭제됨
```bash
make down
```

* (옵션) kind cluster 삭제
```bash
make uninstall-kindcluster
```