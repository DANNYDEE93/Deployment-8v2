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

&emsp;&emsp;&emsp;&emsp;	The deployment involves creating a secure Python script for GitHub integration, managing Jenkins CI/CD pipelines, and configuring AWS resources via Terraform for a resilient and scalable multi-container application. This setup not only showcases the use of modern DevOps tools and practices but also stresses the importance of team collaboration and role-based responsibilities in a real-world software deployment scenario.


&emsp;&emsp;&emsp;&emsp;	This deployment aims to launch an e-commerce application on AWS using ECS. Jenkins and Terraform automate infrastructure provisioning, with GitHub and Dockerhub storing source code and application images. Additionally, a Python script prevents unintentional exposure of sensitive information. To enhance team collaboration, GitHub collaboration features and AWS user accounts have been created.

___________________________________________________
## <ins>Description</ins>
____________________________________________________

&emsp;&emsp;&emsp;&emsp;

 What is the application stack of this application?
Java - node.js environment for the front end
Python environment - 
React-web layer
Django - app layer
Sql - data layer


The application adopts a structured approach with distinct layers, utilizing React.js for the front end and Gunicorn-Django-SQLite for the back end, separated into public and private subnets in a two-tier architecture. This microservices design enhances scalability and resilience by breaking down the application into independently deployable services, enabling quicker development cycles and improved fault isolation. Moreover, for security measures, the back-end resides in a private subnet, while the front end is deployed in the public subnet.

&emsp;&emsp;&emsp;&emsp;	In this project, providing team members with console and ECS access has been crucial in troubleshooting. This strategy allows for concurrent exploration of AWS services, creating a collaborative troubleshooting environment. Team members have the flexibility to investigate issues through the console and effectively troubleshoot containerized applications with ECS access. This shared access also encourages knowledge sharing across different roles, enhancing our problem-solving process.

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

- [*Python script:*](d8script.py) Created to automate the *AWS CLI installation*, *AWS configurations*, search through files for any info involving my AWS access and secret keys, and automate pushes to GitHub excluding the files with sensitive info from local repo.

- Configured Jenkinsfile explained later in our steps.

________________________________________________________________________________________

**<ins>Chief architect managed Terraform files:</ins>** 

- Configured [Jenkins infrastructure](Setup files/Jenkinsinfra.tf)
The management of Terraform files is central to configuring our Jenkins infrastructure, Docker agent server, and Terraform agent server. Jenkins is employed for streamlining CI/CD automation, Docker ensures consistent and isolated environments for application deployment, and Terraform aids in the efficient management of our infrastructure across multiple cloud environments. Our Terraform configuration is modularized into distinct files (Jenkinsinfra.tf, ecs.tf, vpc.tf, alb.tf), enhancing clarity and simplifying error handling in our scalable and agile infrastructure setup.

- Configured [Load Balancer](intTerraform/alb.tf)
A Load Balancer was included in the deployment to distribute incoming traffic across two subnets in this case, enhancing application responsiveness and availability. It ensures scalability and reliability, effectively managing traffic spikes and server performance, thereby maintaining high application availability.

- Configured [cluster environment](intTerraform/ecs.tf)
An ESC cluster environment was configured to enhance the application's performance and reliability. It allows for workload distribution across multiple servers, ensuring high availability and fault tolerance, and facilitates easy scalability as your application's demands grow.

________________________________________________________________________________________

 **<ins>System administrator configured Docker files for the frontend and backend:</ins>**
 
- Created AWS user accounts (user IAM roles) for team members: 

- Creating Docker images through Dockerfiles ensures a standardized method for packaging and distributing applications. This approach guarantees consistent execution across diverse environments, reducing the risk of configuration drift. The application comprises two tiers, each with its Docker image.

- The [Dockerfile](frontend/dockerfile) is employed to construct an image for the application's front end, while the back end follows its dedicated [Dockerfile](dockerfile). After the build process, these images are uploaded to Docker Hub, a cloud-based service designed for hosting Docker images. The seamless integration of this workflow is facilitated by Jenkins credentials
  
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

![system diagram](https://github.com/DANNYDEE93/Deployment-8v2/blob/main/Deploy8.drawio.png)

_________________________________________________________________
## <ins>Optimization</ins>
____________________________________________________________________-

*Fault tolerance:* We used one availability zone for our backend and one of our front end containers. To strengthen the availability of our application, we could have duplicated our infrastructure in another region.

*Security:* We used a private subnet for our backend container




