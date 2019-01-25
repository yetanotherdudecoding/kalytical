
Quickstart:

This should bootstrap properly on any Centos or Rhel 7 system.

        I reccomend 8 cores with at least 16GB of RAM.

        While you could use a VM, the bootstrapping of the platform is pretty network heavy as it loads several large docker images and tar files into nexus

        You can get $300 in free credits with Google Cloud - thats what I use and reccomend. You can also provision the box with 100GB of SSD in the free version - I highly reccomend that as well.

        Once you've provisioned the box, clone this repo.

        Execute  "sudo bootstrap/bootstrap/bootstrapCentos7.sh" - this will take up to 30 minutes

        Navigate to the instance IP at port 30080 to reach jenkins, 30881 to reach Nexus.

        Execute the run-all jenkins job to bring up the remaining resources.

        Streamsets can be reached at port 30530, and a pipeline started to write to HDFS

        Run kubectl get services -n bsavoy to see other services

        You can tinker and explore - much more is to come. Try running "watch kubectl get pods -n bsavoy" in a shell then testing the spark job in jenkins to see k8s spark scheduling :)


Kalytical is a pet project aimed at providing an out-of-the-box advanced analytical environment - on premises and on cloud

Kalytical is configured for demo purposes only and is not production ready without several security measures and high availability measures put in place - but it aims to be a representation of the assets and their respective roles in an analytics platform (i.e. it could in theory be scaled up and locked down enough to be production grade)

The platform handles both data ingestion pipelines, data product and machine learning pipelines in a single SDLC process

Each of these pipeline types are capable of some degree of CI/CD process to automate

Of particular interest is the machine learning lifecycle, where models exist as ephemeral containers handling streaming inference workloads from Kafka. These are managed as deployments in Kubernetes and are managed accordingy.

![Proposed Architecture](resources/kalitical_proposed_architecture.jpeg)


