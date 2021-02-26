# Main OS
FROM debian:buster

# Copy all files
COPY srcs/* ./tmp/

# Install all utilites
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install nginx
RUN apt-get -y install mariadb-server
RUN apt-get -y install php-fpm php-mysql
RUN apt-get -y install php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip
RUN apt-get -y install wget
RUN apt-get -y install vim

# Install and configure wordpress
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xzvf latest.tar.gz
RUN mkdir var/www/site_dir
RUN mv wordpress/ /var/www/site_dir/wordpress
RUN cp /tmp/wp-config.php /var/www/site_dir/wordpress
RUN cp /tmp/index.html /var/www/site_dir

# Install and configure phpMyAdmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-english.tar.gz
RUN tar -xzvf phpMyAdmin-5.0.2-english.tar.gz
RUN mv phpMyAdmin-5.0.2-english/ /var/www/site_dir/phpmyadmin
RUN cp /tmp/config.inc.php /var/www/site_dir/phpmyadmin
RUN rm latest.tar.gz && rm phpMyAdmin-5.0.2-english.tar.gz

# Install SSL certifier
RUN wget -O mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.3.0/mkcert-v1.3.0-linux-amd64
RUN chmod +x mkcert
RUN mv mkcert /usr/local/bin
RUN mkcert -install

# Configure nginx
RUN cp /tmp/nginx.conf /etc/nginx/sites-available/localhost
RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/
RUN rm /etc/nginx/sites-enabled/default

# Get SSL certificate
RUN mkcert localhost
RUN mv localhost.pem /etc/nginx/
RUN mv localhost-key.pem /etc/nginx/

# Expose HTTP and HTTPS ports
EXPOSE 80 443

# Launch script
CMD bash tmp/begin.sh



