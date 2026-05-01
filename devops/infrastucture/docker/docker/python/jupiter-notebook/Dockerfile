# Use an official Python image as the base
FROM python:3.12.4

# Set the working directory
WORKDIR /opt

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Install Jupyter Notebook
RUN pip install --no-cache-dir notebook

# Expose the default Jupyter Notebook port
EXPOSE 8888

# Copy notebooks to the working directory
COPY notebooks/ /opt/notebooks/

# Set the CMD to launch Jupyter Notebook
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
