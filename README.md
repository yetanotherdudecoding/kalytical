Kalytical is a pet project aimed at providing an out-of-the-box advanced analytical environment - on premises and on cloud

Kalytical is configured for demo purposes only and is not production ready without several security measures and high availability measures put in place - but it aims to be a representation of the assets and their respective roles in an analytics platform (i.e. it could in theory be scaled up and locked down enough to be production grade)

The platform handles both data ingestion pipelines, data product and machine learning pipelines in a single SDLC process

Each of these pipeline types are capable of some degree of CI/CD process to automate

Of particular interest is the machine learning lifecycle, where models exist as ephemeral containers handling streaming inference workloads from Kafka. These are managed as deployments in Kubernetes and are managed accordingy. 


Reasons to do this:

		Kubernetes is platform agnostic - i.e. cloud provider or on premises agnostic - making it an ideal target platform
	
		Big data platforms are rife with underutilized resources - this can serve as an attempt to consolidate applications and determine if this helps

		Automating this will provide a lower bar of entry to trying advanced analytics and guide individuals into a sustainable SDLC process to deploy and upgrade ML models or data munging jobs

		Developers will be able to experiment with the entire stack on their local machine
          
		All critical assets required for an advaned analytics platform will be brought under a single umbrella for easier visibility/management



![Proposed Architecture](resources/kalitical_proposed_architecture.jpeg)

