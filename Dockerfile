FROM debian:buster

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install nginx
RUN apt-get -y install mariadb-server
RUN apt-get -y install php-fpm php-mysql
RUN apt-get -y install php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip

RUN apt-get -y install wget
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xzvf latest.tar.gz
RUN mkdir var/www/site_dir
RUN mv wordpress/ /var/www/site_dir/wordpress
COPY srcs/wp-config.php /var/www/site_dir/wordpress

RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-english.tar.gz
RUN tar -xzvf phpMyAdmin-5.0.2-english.tar.gz
RUN mv phpMyAdmin-5.0.2-english/ /var/www/site_dir/phpmyadmin
COPY /srcs/config.inc.php /var/www/site_dir/phpmyadmin
RUN rm latest.tar.gz && rm phpMyAdmin-5.0.2-english.tar.gz



