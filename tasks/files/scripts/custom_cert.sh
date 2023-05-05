set -ux
curl -O https://certs.corp.redhat.com/certs/2022-IT-Root-CA.pem
curl -O https://certs.corp.redhat.com/certs/2015-IT-Root-CA.pem
cp $PWD/2022-IT-Root-CA.pem /etc/pki/ca-trust/source/anchors/
cp $PWD/2022-IT-Root-CA.pem /etc/pki/tls/certs/
cp $PWD/2015-IT-Root-CA.pem /etc/pki/ca-trust/source/anchors/
cp $PWD/2015-IT-Root-CA.pem /etc/pki/tls/certs/
update-ca-trust
