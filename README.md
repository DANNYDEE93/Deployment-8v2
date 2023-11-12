## <ins>DREAM TEAM</ins> 

#### November 11, 2023

	

#### *Project Manager:* Danielle Davis
#### *Chief Architect:* Jo White
#### *System Administrator:* Kevin Gonzalez

____________________________________________________________
## <ins>Purpose</ins>
_________________________________________________________

The deployment involves creating a secure Python script for GitHub integration, managing Jenkins CI/CD pipelines, and configuring AWS resources via Terraform for a resilient and scalable multi-container application. This setup not only showcases the use of modern DevOps tools and practices but also stresses the importance of team collaboration and role-based responsibilities in a real-world software deployment scenario.


This deployment aims to launch an e-commerce application on AWS using ECS. Jenkins and Terraform automate infrastructure provisioning, with GitHub and Dockerhub storing source code and application images. Additionally, a Python script prevents unintentional exposure of sensitive information. To enhance team collaboration, GitHub collaboration features and AWS user accounts have been created.

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


Our backend container was configured in a Python 3.9 environment and acted as our API server with our Django application and sqlite database. Django is a python web application framework that we used with our WSGI Gunicorn server. Our frontend container was configured in a Node.js environment
## <ins>Issues</ins>

- Incorrect naming conventions caused issues within the Terraform files.
  
- Configuration & testing: We kept trying to deploy our container manually but the backend task kept failing because we realized every time we make changes to the directory repo files, we needed to make a new image so that it could be reflected in our application. Jenkins looking for github making the automation of our deployment necessary.
  
- Retrieving Backend container IP address: we  attempting to retrieve the ip address through aws command line interface but realized we could find the ip address through the network interface associated with the private subnet that we created within our VPC that we spun up after applying our terraform [vpc.tf](intTerraform/vpc.tf) file.


Collab aws user

In this project, providing team members with console and ECS access has been crucial in troubleshooting. This strategy allows for concurrent exploration of AWS services, creating a collaborative troubleshooting environment. Team members have the flexibility to investigate issues through the console and effectively troubleshoot containerized applications with ECS access. This shared access also encourages knowledge sharing across different roles, enhancing our problem-solving process.

_______________________________________________________________________
## <ins>Steps</ins>
________________________________________________________________________

<ins>Project manager created team workspace:</ins> 
Create free account and [Jira Board](https://www.atlassian.com/software/jira)

Create main GitHub repo → Go to *Settings* → Select *Collaborators* → Select *Add people* to add team members so we could all work on one repo and work on our Jenkins pipeline together and separately if needed.

[*Python script:*](d8script.py) Created to automate the *AWS CLI installation*, *AWS configurations*, search through files for any info involving my AWS access and secret keys, and automate pushes to GitHub excluding the files with sensitive info from local repo.

________________________________________________________________________________________

<ins>Chief architect managed Terraform files:</ins> 
Configured [Jenkins infrastructure](Setup files/Jenkinsinfra.tf)
The management of Terraform files is central to configuring our Jenkins infrastructure, Docker agent server, and Terraform agent server. Jenkins is employed for streamlining CI/CD automation, Docker ensures consistent and isolated environments for application deployment, and Terraform aids in the efficient management of our infrastructure across multiple cloud environments. Our Terraform configuration is modularized into distinct files (Jenkinsinfra.tf, ecs.tf, vpc.tf, alb.tf), enhancing clarity and simplifying error handling in our scalable and agile infrastructure setup.

Configured [Load Balancer](intTerraform/alb.tf)
A Load Balancer was included in the deployment to distribute incoming traffic across two subnets in this case, enhancing application responsiveness and availability. It ensures scalability and reliability, effectively managing traffic spikes and server performance, thereby maintaining high application availability.

Configured [cluster environment](intTerraform/ecs.tf)
An ESC cluster environment was configured to enhance the application's performance and reliability. It allows for workload distribution across multiple servers, ensuring high availability and fault tolerance, and facilitates easy scalability as your application's demands grow.

________________________________________________________________________________________

 <ins>System administrator configured Docker files for the frontend and backend:</ins>
Created AWS user accounts (user IAM roles) for team members: 
Creating Docker images through Dockerfiles ensures a standardized method for packaging and distributing applications. This approach guarantees consistent execution across diverse environments, reducing the risk of configuration drift. The application comprises two tiers, each with its Docker image.

The [Dockerfile](frontend/dockerfile) is employed to construct an image for the application's front end, while the back end follows its dedicated [Dockerfile](dockerfile). After the build process, these images are uploaded to Docker Hub, a cloud-based service designed for hosting Docker images. The seamless integration of this workflow is facilitated by Jenkins credentials


<ins>Create & Edit Application Files:</ins>

*Jenkinsfile* : 

Compared to our previous deployment, we listed out each stage for the Docker and Terraform steps. We needed to combine the deployment stages for both of our backend and frontend containers since the frontend container connects to the backend’s API in order to connect to the application and data logical layer. If the backend stages were unable to build our Docker images, then the front end would not work.

*Build Backend & Build Frontend*: With this [Jenkinsfile](Jenkinsfile), we consolidated my Docker steps for the frontend and the backend to build our image, login into the appropriate Docker Hub, and to push our image to Docker Hub. To make sure that the Jenkinsfile could locate both Dockerfiles separately, we placed our *build frontend* stage in the frontend directory to find our frontend dockerfile and left our backend dockerfile in the main directory. These Docker Hub credentials were associated with our Jenkins node *awsDeploy* to connect our Jenkins pipeline to our Docker agent server.
 
*Terraform*: I also consolidated our terraform *init, plan & apply* steps to create the infrastructure designed in our .tf files found in the *intTerraform* directory. Using the Jenkins agent node *awsDeploy2*, we connected our pipeline to our Terraform agent server.


*package.json* file: 
In this project, the backend container's private IP address, located on a network interface within a private subnet, was identified. This address was then added to the frontend application's package.json file, facilitating direct communication between the frontend and backend containers. This configuration ensures secure and efficient interaction between the two parts of the application within the same private network.


<ins>Jenkins Staging Environment:</ins>

Purpose: Our Jenkins staging environment is crucial for rigorously testing our CI/CD pipelines, ensuring the reliability and stability of our processes before they are deployed in the production environment. This approach is vital for maintaining high quality and avoiding potential disruptions in live settings.

Jenkins Agent Nodes: To optimize our build and deployment efficiency, we have configured Jenkins agent nodes to enable parallel execution of tasks. This setup significantly enhances the speed and efficiency of our build processes. Specifically, we have strategically placed agent nodes on both the Terraform and Docker servers. This placement is designed to streamline and expedite tasks specific to infrastructure provisioning and container management, respectively, ensuring a smooth and efficient pipeline flow.

Credentials for Jenkins: To ensure Terraform has the necessary access to AWS, it requires both AWS access and secret keys. Since the main.tf files are hosted on GitHub but shouldn't have public access for security reasons, Jenkins credentials are created for AWS. Similarly, credentials are created for Docker Hub with a username and password:
For AWS:  Navigate to **Manage Jenkins > Credentials > System > Global credentials (unrestricted)** > Create two credentials for access and secret keys as "Secret text."
For Docker Hub: Navigate to **Manage Jenkins > Credentials > System > Global credentials (unrestricted)** > Create credentials for access and secret keys using DockerHub-generated key and username.


## <ins> System Diagram </ins>

<ins>Chief architect created deployment diagram:</ins>

[system diagram](Deploy8.drawio.png)


## <ins>Optimization</ins>

*Fault tolerance:* We used one availability zone for our backend and one of our front end containers. To strengthen the availability of our application, we could have duplicated our infrastructure into another region.
*Security:* We used a private subnet for our backend container




