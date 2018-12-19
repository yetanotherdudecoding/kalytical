#sudo mkdir /nexus-data && chown 200 /nexus-dataa
sudo docker run -d --restart=always  -p 80:8081 -p 5000:5000 -p 8080-8085:8080-8085 --name localnexus -v /nexus-data:/nexus-data sonatype/nexus3
