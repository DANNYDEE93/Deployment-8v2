FROM python:3.9

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

# Expose the port that your application listens on
EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
