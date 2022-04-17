#!/bin/bash
# Provisioner script for bitnami wordpress server

# Ugrade all packages
echo "Appling OS Updates"

{
apt update
apt -y full-upgrade
} >> /var/log/user-data.log 2>&1

# Setup bitnami user
echo "Adding bitnami User"
{
groupadd -g 1000 bitnami
useradd -s /bin/bash -d /home/bitnami -m -u 1000 -g bitnami -G adm,dialout,cdrom,floppy,sudo,audio,dip,video,plugdev bitnami
install -d -m 0700 -o bitnami -g bitnami /home/bitnami/.ssh
install -o bitnami -g bitnami /root/.ssh/authorized_keys /home/bitnami/.ssh/
install -o root -g root -m 0440 /dev/null /etc/sudoers.d/bitnami
echo "bitnami     ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/bitnami
} >> /var/log/user-data.log 2>&1

# Install Base Packages
echo "Installing Base Packages"
{
apt -y install curl httpie git gnupg htop software-properties-common libncurses5
} >> /var/log/user-data.log 2>&1


# Install Bitnami Wordpress Stack
echo "Installing Bitnami Wordpress Stack"
{
chmod u+x /tmp/${bitnami_installer}
/tmp/${bitnami_installer} --optionfile /tmp/bitnami-options.cfg
chmod u-x /tmp/${bitnami_installer}
ln -s /opt/bitnami/apps /home/bitnami/apps
ln -s /opt/bitnami/apache2/htdocs /home/bitnami/htdocs
ln -s /opt/bitnami /home/bitnami/stack
/opt/bitnami/apps/wordpress/updateip --appurl /
/opt/bitnami/apps/wordpress/bnconfig --disable_banner 1
/opt/bitnami/ctlscript.sh restart apache

# Setup bitnami PATH
sed -i '5 i PATH="/opt/bitnami/apps/wordpress/bin:/opt/bitnami/varnish/bin:/opt/bitnami/sqlite/bin:/opt/bitnami/php/bin:/opt/bitnami/mariadb/bin:/opt/bitnami/letsencrypt/:/opt/bitnami/apache2/bin:/opt/bitnami/common/bin:$PATH"\nexport PATH\n' /home/bitnami/.bashrc

# Allow phpmyadmin from network subnet
sed -i 's/^Require local/Require ${phpmyadmin_require}/'  /opt/bitnami/apps/phpmyadmin/conf/httpd-app.conf

# Create bitnami_credentials file for reference
password="$(grep base_password /tmp/bitnami-options.cfg |cut -d= -f2)"
cat << EOF > /home/bitnami/bitnami_credentials
Welcome to the Bitnami WordPress Stack

******************************************************************************
The default username and password is 'bitnami' and '$password'.
Mariadb root password is '$password'.
******************************************************************************

You can also use this password to access the databases and any other component the stack includes.

Please refer to https://docs.bitnami.com/ for more details.
EOF
} >> /var/log/user-data.log 2>&1

# Set basic wordpress file security
echo "Set Basic Wordpress File Security"
{
WPD="/home/bitnami/apps/wordpress/htdocs"
for dir in '.' wp-includes wp-admin wp-admin/js wp-content wp-content/themes wp-content/plugins wp-content/uploads; do
    chmod 0775 $WPD/$dir
done
echo "# htaccess placeholder" > $WPD/.htaccess
chmod 0444 $WPD/wp-config.php $WPD/.htaccess

} >> /var/log/user-data.log 2>&1

# Finally restart apache to apply changes
echo "Restart apache to apply config changes"
{
/opt/bitnami/ctlscript.sh restart apache
} >> /var/log/user-data.log 2>&1
