###install the necessary dependencies to run script successfully
import os
import subprocess


# Set the AWS credentials in the environment variables
os.environ['AWS_ACCESS_KEY_ID'] = 'YOUR ACCESS KEY'
os.environ['AWS_SECRET_ACCESS_KEY'] = 'YOUR SECRET KEY'


# Command to install Python3 pip and AWS CLI
commands = [
    'sudo apt install -y python3-pip',
    'sudo apt install -y awscli'
]

# Run each command using subprocess
for cmd in commands:
    subprocess.run(cmd, shell=True)

# Set your AWS credentials (export first to define variables first)
access_key = os.environ['AWS_ACCESS_KEY_ID'] #OR INPUT VALUE & REMOVE VARIABLE ABOVE
secret_key = os.environ['AWS_SECRET_ACCESS_KEY'] #OR INPUT VALUE & REMOVE VARIABLE ABOVE
region = "us-east-1"

# Create a shell script to export AWS credentials to configure
with open("exportaws.sh", "w") as script_file:
    script_file.write("#!/bin/bash\n")
    script_file.write(f"export AWS_ACCESS_KEY_ID=AKIAQ66VYTZDRIPQPYVR\n")
    script_file.write(f"export AWS_SECRET_ACCESS_KEY=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\n")
    script_file.write(f"export AWS_DEFAULT_REGION=us-east-1\n")

print("Credentials were exported")

# Commands to configure AWS credentials
commands = [
    f"aws configure set aws_access_key_id {access_key}",
    f"aws configure set aws_secret_access_key {secret_key}",
    f"aws configure set region {region}"
]

print("Credentials are configured")

# Run each command using subprocess
for cmd in commands:
    subprocess.run(cmd, shell=True)




# Define the pattern to search for AWS access key information
#access_key_pattern = re.compile(r"AWS_ACCESS_KEY_ID|AWS_SECRET_ACCESS_KEY")



# Function to search for sensitive information in files within the current directory
#print back the specific file with the sensitive information (terraform.tfvars)
#check all files in the current directory(current directory) for sensitive information 
# Provide the current directory for the search
def search_sensitive_info():
    sensitive_files = []
    current_directory = os.getcwd()
    sensitive_vars = ['access_key', 'secret_key', 'AWS_ACCESS_KEY_ID', 'AWS_SECRET_ACCESS_KEY'] 
    for file in os.listdir(current_directory):
        if os.path.isfile(os.path.join(current_directory, file)):
            #if file.endswith:  
            with open(file, 'r') as f:
                for line in f:
                    for var in sensitive_vars:
                            if 'AWS_ACCESS_KEY_ID' in line or 'AWS_SECRET_ACCESS_KEY' in line or 'access_key' in line or 'secret_key' in line:
                            #if re.search(fr'{var}\s*=\s*".*"', line):
                                print(f"File with sensitive info: {file} - {line.strip()}")
                                #add found files into defined list 
                                sensitive_files.append(file)
                                break
                        
    return sensitive_files                   

# Call the function to search within the current directory
search_sensitive_info()


#prevent script from being pushed to github
#push to github
# Configure Git to use HTTPS URL for authentication
os.system("git config --global init.defaultBranch main")
os.system("git init")
#os.system("git remote rm origin")
os.system("git remote add origin https://github.com/DANNYDEE93/Deployment8v2.git")  
os.system('git config --global user.email "dan.dee5761@gmail.com"')
os.system('git config --global user.name "DANNYDEE93"')


def exclude_files(files):
    sensitive_files = search_sensitive_info()
    for file in sensitive_files:
        os.system(f"git rm --cached {file}")
        exclude_files(sensitive_files)
    


# Use git add with file exclusion 
def push_to_github(exclude_files):
    os.system("git add .")
    for file in exclude_files:
#prevent the sensitive files from entering the staging environment
        os.system("git reset HEAD {file}")
        os.system('git commit -m "Add current directory to repo"')
        os.system("git checkout -b main")
print("Created main branch")

#error handling
try:
    os.system("git push -u origin main")
except Exception as e:
    print(f"Error while pushing: {e}")
os.system("git push origin main")

sensitive_files = search_sensitive_info()


#if sensitive files are found, exclude them before pushing
if sensitive_files:
    print("Excluding sensitive files from the push.")
    push_to_github(sensitive_files)
else:
    print("No sensitive files found. Push to GitHub repo was successful")

print("Push to GitHub repo was successful")

