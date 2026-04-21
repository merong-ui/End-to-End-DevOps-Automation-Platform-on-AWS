# Base image
FROM python:3.9

# Working directory inside container
WORKDIR /app

# Copy app files into container
COPY . .

# Install dependencies
RUN pip install -r requirements.txt

# Run application
CMD ["python", "app.py"]
