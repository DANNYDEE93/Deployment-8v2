FROM python:3.9

RUN git clone https://github.com/DANNYDEE93/Deployment-8v2.git

WORKDIR Deployment-8v2/backend/

RUN pip install -r requirements.txt

EXPOSE 8000

RUN python manage.py migrate

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
