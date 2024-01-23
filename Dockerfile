FROM ubuntu:18.04
LABEL maintainer="Carlinfg <fongangcarlin@gmail.com>"

# Définit le répertoire de travail
WORKDIR /var/www/html/

# Installe Nginx et Git
RUN apt-get update && \
    apt-get install -y nginx git && \
    rm -rf /var/www/html/*

# Clone le dépôt Git
RUN git clone https://github.com/CarlinFongang/static-website-example.git /var/www/html
#RUN git clone https://github.com/CarlinFongang/cursus-devops.git .

# Expose le port 80
EXPOSE 80

# Démarre Nginx
ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]
