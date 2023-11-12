# Use an official Python 3.9 image as a parent image
FROM python:3.9

# Clone your Git repository into the current directory
RUN git clone https://github.com/DANNYDEE93/Deployment-8v2.git

# Change to the "backend" directory inside your app directory
WORKDIR Deployment-8v2/backend/

# Install the Python dependencies from requirements.txt
RUN pip install -r requirements.txt

# Install Gunicorn for serving the Django application
RUN pip install gunicorn

# Perform Django database migrations
RUN python manage.py migrate

# Expose the port that your application listens on
EXPOSE 8000

# Create a Gunicorn configuration file
RUN echo "[gunicorn]" > gunicorn.conf && \
    echo "bind = 0.0.0.0:8000" >> gunicorn.conf && \
    echo "workers = 3" >> gunicorn.conf

# Run Gunicorn using the virtual environment
CMD ["gunicorn", "-c", "gunicorn.conf", "my_project.wsgi:application"]
