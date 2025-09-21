#!/bin/bash

##############
# migrate.sh #
##############
#
# Description: 
# Updates URL in database so the site can run on localhost
#

export new_url="https://lektorenverband.de"
export old_url="https://blog-dev.vfll.de"

mysql -uroot -p$MYSQL_ROOT_PASSWORD -D$MYSQL_DATABASE -e "
UPDATE ${WORDPRESS_TABLE_PREFIX}options SET option_value = REPLACE(option_value, '${old_url}', '${new_url}') WHERE option_name = 'home' OR option_name = 'siteurl'; 
UPDATE ${WORDPRESS_TABLE_PREFIX}posts SET guid = REPLACE(guid, '${old_url}', '${new_url}'); 
UPDATE ${WORDPRESS_TABLE_PREFIX}posts SET post_content = REPLACE(post_content, '${old_url}', '${new_url}'); 
UPDATE ${WORDPRESS_TABLE_PREFIX}posts SET post_content = REPLACE(post_content, 'src=\"${old_url}\"', 'src=\"${new_url}\"'); 
UPDATE ${WORDPRESS_TABLE_PREFIX}posts SET guid = REPLACE(guid, '${old_url}', '${new_url}') WHERE post_type = 'attachment'; 
UPDATE ${WORDPRESS_TABLE_PREFIX}postmeta SET meta_value = REPLACE(meta_value, '${old_url}', '${new_url}');"
