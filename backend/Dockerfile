FROM ghdl/vunit:llvm
WORKDIR /home/debian

# Install python tools
RUN pip3 install fastapi[all] ptyprocess

# Copy the source code to the container
ADD . .

# Expose ports
EXPOSE 8000

# Uvicorn start server
CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0"]