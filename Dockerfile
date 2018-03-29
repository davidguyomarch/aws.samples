FROM ulsmith/debian-apache-php
MAINTAINER David Guyomarch <david.guyomarch@orange.fr>

# Copy your files to working directory /var/www/html
ADD ./docker /var/www/html
RUN chmod -R 0755 /var/www/html

EXPOSE 80
CMD ["/run.sh"]
