What is it?
==========
Kalytical is a big data platform built on Kubernetes. It’s goal is to provide data engineers and scientists a place to play - a platform they can bring up completely automatically, or tear down at will.  

Usually organizations spend tons-o-money building some variation of this platform, making it out of reach for everyday people to play with. I hope you find it useful and at least interesting. If you already have a platform or are looking to build one, consider some strategies taken here upon which to draw inspiration.  

I’m not selling anything - the entire stack is open source. The stack I chose attempts to be as agnostic and functional as possible, but can be augmented very easily to use, say, cloud storage rather than HDFS, Postgres in place of MySQL... It can bootstrap on a local machine with internet access or a VM on cloud (multi node support is upcoming)  

For data engineers and scientists, the sample data pipeline and ML model deployments should give some idea of how I expected the platform to be utilized  

For Devops or SRE or Admin types, the infrastructure automation is simplified greatly by Kubernetes. This also gives a working example of how Kubernetes and containers can be used as a platform.  

If you’re feeling froggy, jump on an issue. Devopsy and data engineery type issues to be worked on. The end goal would be to have a full platform, with log aggregation, self healing, effective dummy data and several pipelines running through the platform.

Quickstart:
==========
This should bootstrap properly on any Centos or Rhel 7 system.

1. I reccomend 8 cores with at least 16GB of RAM. 
2. While you could use a local VM, the bootstrapping of the platform is pretty network heavy as it loads several large docker images and tar files into nexus - cloud VMs have much more network bandwidth  
3. You can get $300 in free credits with Google Cloud - thats what I use and reccomend. You can also provision the box with 100GB of SSD in the free version - I highly reccomend that as well.  
4. Once you've provisioned the box, clone this repo.  
5. cd to the repo folder. Execute  "sudo bootstrap/bootstrapCentos7.sh" - this will take up to 30 minutes  
  5.1 If you're using a cloud VM, ensure that you have internet ingress to ports 30000-32767, or some other way to reach the box (perhaps through a jump host)
6. Navigate to the instance IP at port 30080 to reach jenkins, 30881 to reach Nexus.  
7. Execute the run-all jenkins job to bring up the remaining resources.  
8. Streamsets can be reached at port 30530, and a pipeline started to write to HDFS  
9. Run kubectl get services -n bsavoy to see other services  
10. You can tinker and explore - much more is to come.   
11. Try running "watch kubectl get pods -n bsavoy" in a shell then testing the spark job in jenkins to see k8s spark scheduling :)  

![](https://github.com/yetanotherdudecoding/kalytical/blob/master/resources/kalytical_proposed_arch.PNG)
