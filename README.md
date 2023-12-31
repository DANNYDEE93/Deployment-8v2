## <ins>DREAM TEAM</ins> 
________________________________________________________
#### November 11, 2023
________________________________________________________	

#### *Project Manager:* Danielle Davis
#### *Chief Architect:* Jo White
#### *System Administrator:* Kevin Gonzalez

____________________________________________________________
## <ins>Purpose</ins>
_________________________________________________________

&emsp;&emsp;&emsp;&emsp;	To launch an e-commerce application on AWS using ECS. Jenkins and Terraform automate infrastructure provisioning, with GitHub and Dockerhub storing source code and application images. Additionally, a Python script prevents unintentional exposure of sensitive information. To enhance team collaboration, GitHub collaboration features and AWS user accounts have been created.

___________________________________________________
## <ins>App Description</ins>
____________________________________________________

&emsp;&emsp;&emsp;&emsp; The application adopts a structured approach with distinct layers, utilizing React.js for the front end and Gunicorn-Django-SQLite for the back end, separated into public and private subnets in a two-tier architecture. This microservices design enhances scalability and resilience by breaking down the application into independently deployable services, enabling quicker development cycles and improved fault isolation. Moreover, for security measures, the back-end resides in a private subnet, while the front end is deployed in the public subnet.

&emsp;&emsp;&emsp;&emsp;  Amazon ECS, Elastic Container Service, is a popular AWS offering for managing Docker containers in the cloud. It simplifies container orchestration by allowing users to define task specifications, allocate resources, and manage instances within clusters. It supports both EC2 and Fargate. In this project, AWS Fargate a serverless compute engine for containers was tasked with hosting the application. It allows to run containers without managing the underlying infrastructure.

In application, infrastructure consisted of 

- 1 cluster that hosted all the containers
- 2 containers for the front end on public subnets, one in each AZ
- 1 container for the back end on the private subnet

&emsp;&emsp;&emsp;&emsp; 
____________________________________________________________
## <ins>Issues</ins>
_______________________________________________________________

- Incorrect naming conventions caused issues within the Terraform files.
  
- Configuration & testing: We kept trying to deploy our container manually but the backend task kept failing because we realized every time we make changes to the directory repo files, we needed to make a new image so that it could be reflected in our application. Jenkins looking for GitHub making the automation of our deployment necessary.
  
- Retrieving Backend container IP address: we attempted to retrieve the IP address through the aws command line interface but realized we could find the IP address through the network interface associated with the private subnet that we created within our VPC that we spun up after applying our terraform [vpc.tf](intTerraform/vpc.tf) file.

_______________________________________________________________________
## <ins>Project Organization</ins>
________________________________________________________________________

**<ins>Project manager created team workspace:</ins>** 

- Create a free account and [Jira Board](https://www.atlassian.com/software/jira)

![jiraboard](https://github.com/DANNYDEE93/Deployment-8v2/blob/main/Results/JiraBoard.png)

- Create main GitHub repo → Go to *Settings* → Select *Collaborators* → Select *Add people* to add team members so we can all work on one repo and work on our Jenkins pipeline together and separately if needed.

- [*Python script:*](d8script.py) Created to automate *AWS CLI installation*, *AWS configurations*, *GitHub initialization*, *GitHub configurations*, search through files for any info involving my AWS access and secret keys, and to exclude these files with sensitive information before pushing to GitHub to ensure security and avoid compromisation of your AWS account. 

- Configured Jenkinsfile explained later in our steps.

________________________________________________________________________________________

**<ins>Chief architect managed Terraform files:</ins>** 

- Configured [Jenkins infrastructure](Setup files/Jenkinsinfra.tf):
  
The management of Terraform files is central to configuring our Jenkins infrastructure, Docker agent server, and Terraform agent server. Jenkins is employed for streamlining CI/CD automation, Docker ensures consistent and isolated environments for application deployment, and Terraform aids in the efficient management of our infrastructure across multiple cloud environments. Our Terraform configuration is modularized into distinct files (Jenkinsinfra.tf, ecs.tf, vpc.tf, alb.tf), enhancing clarity and simplifying error handling in our scalable and agile infrastructure setup.

- Configured [Load Balancer](intTerraform/alb.tf):
  
A Load Balancer was included in the deployment to distribute incoming traffic across two subnets in this case, enhancing application responsiveness and availability. It ensures scalability and reliability, effectively managing traffic spikes and server performance, thereby maintaining high application availability.

- Configured [cluster environment](intTerraform/ecs.tf):
  
An ESC cluster environment was configured to enhance the application's performance and reliability. It allows for workload distribution across multiple servers, ensuring high availability and fault tolerance, and facilitates easy scalability as your application's demands grow.

________________________________________________________________________________________

 **<ins>System administrator configured Docker files for the frontend and backend:</ins>**

- Creating Docker images through Dockerfiles ensures a standardized method for packaging and distributing applications. This approach guarantees consistent execution across diverse environments, reducing the risk of configuration drift. The application comprises two tiers, each with its Docker image.

- The [Dockerfile](frontend/dockerfile) is employed to construct an image for the application's front end, while the back end follows its dedicated [Dockerfile](dockerfile). After the build process, these images are uploaded to Docker Hub, a cloud-based service designed for hosting Docker images. The seamless integration of this workflow is facilitated by Jenkins credentials

- In this project, providing team members with AWS user roles was crucial for troubleshooting. Some of the policies given were console, ECS access, and EC2 access. This strategy allows for concurrent exploration of AWS services, creating a collaborative troubleshooting environment. Team members have the flexibility to investigate issues through the console and effectively troubleshoot containerized applications with ECS access. This shared access also encourages knowledge sharing across different roles, enhancing our problem-solving process.
__________________________________________________________________________
**<ins>Create & Edit Application Files:</ins>**
__________________________________________________________________________

**Jenkinsfile:** 

Compared to our previous deployment, we listed out each stage for the Docker and Terraform steps. We needed to combine the deployment stages for both of our backend and frontend containers since the frontend container connects to the backend’s API to connect to the application and data logical layer. If the backend stages were unable to build our Docker images, then the front end would not work.

**Build Backend & Build Frontend:** 

With this [Jenkinsfile](Jenkinsfile), we consolidated my Docker steps for the frontend and the backend to build our image, login into the appropriate Docker Hub, and push our image to Docker Hub. To make sure that the Jenkinsfile could locate both Dockerfiles separately, we placed our *build frontend* stage in the frontend directory to find our frontend dockerfile and left our backend dockerfile in the main directory. These Docker Hub credentials were associated with our Jenkins node *awsDeploy* to connect our Jenkins pipeline to our Docker agent server.
 
**Terraform:** 

We also consolidated our terraform *init, plan & apply* steps to create the infrastructure designed in our .tf files found in the *intTerraform* directory. Using the Jenkins agent node *awsDeploy2*, we connected our pipeline to our Terraform agent server.


**package.json file:**

In this project, the backend container's private IP address, located on a network interface within a private subnet, was identified. This address was then added to the frontend application's package.json file, facilitating direct communication between the frontend and backend containers. This configuration ensures secure and efficient interaction between the two parts of the application within the same private network.

_________________________________________________________________
**<ins>Jenkins Staging Environment:</ins>**
______________________________________________________________________

**<ins>Purpose:</ins>** 

Our Jenkins staging environment is crucial for rigorously testing our CI/CD pipelines, ensuring the reliability and stability of our processes before they are deployed in the production environment. This approach is vital for maintaining high quality and avoiding potential disruptions in live settings.

**<ins>Jenkins Agent Nodes:</ins>** 

To optimize our build and deployment efficiency, we have configured Jenkins agent nodes to enable parallel execution of tasks. This setup significantly enhances the speed and efficiency of our build processes. Specifically, we have strategically placed agent nodes on both the Terraform and Docker servers. This placement is designed to streamline and expedite tasks specific to infrastructure provisioning and container management, respectively, ensuring a smooth and efficient pipeline flow.

**<ins>Credentials for Jenkins:</ins>** 

To ensure Terraform has the necessary access to AWS, it requires both AWS access and secret keys. Since the main.tf files are hosted on GitHub but shouldn't have public access for security reasons, Jenkins credentials are created for AWS. Similarly, credentials are created for Docker Hub with a username and password:

*For AWS:*  Navigate to **Manage Jenkins > Credentials > System > Global credentials (unrestricted)** > Create two credentials for access and secret keys as "Secret text."

*For Docker Hub:* Navigate to **Manage Jenkins > Credentials > System > Global credentials (unrestricted)** > Create credentials for access and secret keys using DockerHub-generated key and username.

_________________________________________________________
## <ins> System Diagram </ins>
____________________________________________________________

<ins>Chief architect created deployment diagram:</ins>

![system diagram](https://github.com/DANNYDEE93/Deployment-8v2/blob/main/Deploy8.drawio%20(1).png)

_____________________________________________________________________
## <ins>Optimization</ins>
____________________________________________________________________

## Multi-Region Deployment for Enhanced Fault Tolerance

Duplicate the application infrastructure in a secondary AWS region to increase fault tolerance.

1. **Replicate Backend Services:**
   Duplicate backend services in the secondary region for load distribution and redundancy.

2. **Load Balancing:**
   Configure load balancing to evenly distribute requests.

3. **Data Synchronization:**
   Implement mechanisms, such as RDS, for consistent data synchronization across regions.

**Benefits:**
- **Fault Tolerance:** Reduces downtime risk, providing failover options.
- **User Experience:** Minimizes latency for users in different geographical locations.

## Domain Names for Improved Connectivity

Switch from using IP addresses to domain names when connecting the front end to the back end. This simplifies the process; if a back-end container goes down, the IP wouldn't have to be reconfigured in the package.json.

**Benefits:**
- **Scalability:** Facilitates updates without changing frontend configurations.
_____________________________________________________________________
## <ins> Conclusion </ins>
____________________________________________________________________
&emsp;&emsp;&emsp;&emsp;  The application was successfully deployed on the AWS Network using ECS, with Docker building images from Dockerfiles and pushing them to DockerHub. Terraform handled infrastructure provisioning, and Jenkins streamlined automation. Collaboration was enhanced through tools like meet calls, Slack, Scrum meetings, AWS user collaboration, GitHub access, and Jira integration. The successful deployment of the project stands as a noteworthy accomplishment, demonstrating a smooth build and deployment process. Post-deployment efforts are focused on identifying opportunities for optimizing processes and refining solutions.
