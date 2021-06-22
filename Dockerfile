FROM pulumi/pulumi:v3.4.0
WORKDIR /app
ADD . /app
RUN npm install 
