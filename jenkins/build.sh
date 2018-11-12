chmod +x ./getJenkins.sh 
./getJenkins.sh
cd docker
docker build . -t bsavoy/jenkins:custom
