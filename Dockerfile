ARG version="latest"
FROM nginx:$version
LABEL maintainer="Carlinfg <fongangcarlin@gmail.com>"

RUN rm -rf /var/lib/apt/lists/*   # Remove temporary files
RUN apt-get update && \
    apt-get install --no-install-recommends -y git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /usr/share/nginx/html/*
    
    
RUN git clone https://github.com/diranetafen/static-website-example.git \
    && mv static-website-example/* /usr/share/nginx/html/


EXPOSE 80

ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]