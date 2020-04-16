#! make

include env-retro

all: init up

init:
	mkdir -p backups plugins uploads

	wget https://downloads.wordpress.org/plugin/issuem.2.8.1.zip
	unzip issuem.2.8.1.zip plugins

	wget https://downloads.wordpress.org/plugin/leaky-paywall.4.14.1.zip
	unzip leaky-paywall.4.14.1.zip plugins

	wget https://downloads.wordpress.org/plugin/woo-swish-e-commerce.2.3.2.zip
	unzip woo-swish-e-commerce.2.3.2.zip plugins

	wget https://downloads.wordpress.org/plugin/wp-paypal.zip
	unzip wp-paypal.zip plugins

	wget https://downloads.wordpress.org/plugin/krokedil-paysoncheckout-20-for-woocommerce.zip
	unzip krokedil-paysoncheckout-20-for-woocommerce.zip plugins

	wget https://downloads.wordpress.org/plugin/woocommerce-pay-per-post.2.5.2.zip
	unzip woocommerce-pay-per-post.2.5.2.zip plugins

	wget https://downloads.wordpress.org/plugin/woo-wallet.1.3.14.zip
	unzip woo-wallet.1.3.14.zip plugins

	echo "Now pls run 'make permissions' to ensure writable directories in wp-admin gui"

permissions:
	# https://stackoverflow.com/questions/44251019/wordpress-on-docker-could-not-create-directory-on-mounted-volume
	docker-compose exec wordpress chown -R www-data:www-data /var/www/

up:
	docker-compose up -d

changesiteurl:
	# https://stackoverflow.com/questions/48825586/docker-i-cant-map-ports-other-than-80-to-my-wordpress-container
	docker-compose exec wordpress bash

backup-wp:
	docker-compose run backup \
		tar zcvf /tmp/wp-varwwwhtml.tgz /var/www/html

backup-db:
	@docker-compose exec db \
		bash -c "mysqldump -u${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE}" > backups/wp.sql

backup: backup-wp backup-db
