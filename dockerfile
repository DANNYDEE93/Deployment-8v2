# Use an official Python 3.9 image as a parent image
FROM python:3.9-slim

# Install git
RUN apt-get update && apt-get install -y git

# Clone your Git repository into the current directory
RUN git clone https://github.com/DANNYDEE93/Deployment-8v2.git

# Change to the "backend" directory inside your app directory
WORKDIR Deployment-8v2/backend/

# Install the Python dependencies from requirements.txt
RUN pip install -r requirements.txt

# Perform Django database migrations
RUN python manage.py migrate

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Expose the port that your application listens on
EXPOSE 8000

# Create a non-root user
RUN adduser --disabled-password myuser
USER myuser

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
