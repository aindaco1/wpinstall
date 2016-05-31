#!/bin/sh -e

clear

echo "================================================================="
echo "Hermes WordPress Installer for Laravel Valet"
echo "================================================================="

# accept the name of our website
echo "Site name: "
read -e sitename

# accept user input for the database name
echo "Database name: "
read -e dbname

# accept a comma separated list of pages
echo "Add pages: "
read -e allpages

# accept user input for the wp admin username
echo "WordPress admin username: "
read -e wpuser

# accept user input for the wp admin email
echo "WordPress admin email: "
read -e wpemail

# accept git remote
echo "git remote: "
read -e gitremote

if [ "$gitremote" == "" ] ; then

	# accept default .gitignore location
	echo ".gitignore location: "
	read -e gitignore

fi

# bitbucket username
echo "Bitbucket username: "
read -e bituser

# bitbucket username
echo "Bitbucket password: "
read -s bitpass

# Genesis?
echo "Genesis? (y/n)"
read -e genesis

if [ "$genesis" == y ] ; then

	# Genesis location
	echo "Genesis location: "
	read -e genesisloc

	# Genesis starter theme location
	echo "Genesis starter theme location: "
	read -e genesisstarter

else

	# non-Genesis starter theme location
	echo "Starter theme location: "
	read -e startertheme

fi

# WooCommerce?
echo "WooCommerce? (y/n)"
read -e woocommerce

# Set up gulp.js?
echo "npm, gulp & sass? (y/n)"
read -e npmandgulp

# add a simple yes/no confirmation before we proceed
echo "Run install? (y/n)"
read -e run

# if the user didn't say no, then go ahead and install
if [ "$run" == n ] ; then

	exit

fi

# parse the current directory name
currentdirectory=${PWD##*/}

if [ "$gitremote" != "" ] ; then

	# clone existing repository
	git clone $gitremote temp
	mv temp/.git .git
	mv temp/.gitignore .gitignore
	rm -rf temp

else

	# create bitbucket repo and add remote
	curl --user $bituser:$bitpass https://api.bitbucket.org/1.0/repositories/ \
	--data name=$currentdirectory --data is_private='true'
	git init
	git remote add origin git@bitbucket.org:$bituser/$currentdirectory.git
	# add and commit gitignore
	cp $gitignore .gitignore
	git add .gitignore
	git commit -m "gitignore"
	git push origin master

fi

clear

# download the WordPress core files
wp core download

# create the wp-config file with our standard setup
wp core config --dbprefix=hd_ --dbname=$dbname --dbuser=root --dbpass= --extra-php <<PHP
define( 'WP_DEBUG', true );
define( 'DISALLOW_FILE_EDIT', true );
PHP

# generate random 12 character password
password=$(LC_CTYPE=C tr -dc A-Za-z0-9_\!\@\#\$\%\^\&\*\(\)-+= < /dev/urandom | head -c 12)

# copy password to clipboard
echo $password | pbcopy

# create database, and install WordPress
wp db create
wp core install --url="http://$currentdirectory.dev/" --title="$sitename" --admin_user="$wpuser" --admin_password="$password" --admin_email="$wpemail"

# discourage search engines
wp option update blog_public 0

# show only 10 posts on an archive page
wp option update posts_per_page 10

# delete sample page, and create homepage, blog, about, contact and landing page
wp post delete $(wp post list --post_type=page --posts_per_page=1 --post_status=publish --pagename="sample-page" --field=ID --format=ids)
wp post create --post_type=page --post_title=Home --post_status=publish --post_author=$(wp user get $wpuser --field=ID --format=ids) --post_content="Lorem ipsum dolor sit amet, ea etiam dicant sit, solum percipit est ne. Et ullum minim eum. Cu nam reque mucius accumsan, sea quem iudico theophrastus te, vix ne nullam pericula. Mei ea justo choro definitionem, id nam prima posse consetetur. Atomorum mandamus consequuntur ius ea.

Usu cu purto etiam legere. Id quo iisque consequat persecuti, tractatos consequuntur id mel, erat praesent mei ei. Ex ancillae perfecto quo, tempor audiam mediocrem mei ei. Sale eloquentiam has in. Quo legere fuisset id, elaboraret eloquentiam usu cu."
wp post create --post_type=page --post_title=Blog --post_status=publish --post_author=$(wp user get $wpuser --field=ID --format=ids) --post_content="Lorem ipsum dolor sit amet, ea etiam dicant sit, solum percipit est ne. Et ullum minim eum. Cu nam reque mucius accumsan, sea quem iudico theophrastus te, vix ne nullam pericula. Mei ea justo choro definitionem, id nam prima posse consetetur. Atomorum mandamus consequuntur ius ea.

Usu cu purto etiam legere. Id quo iisque consequat persecuti, tractatos consequuntur id mel, erat praesent mei ei. Ex ancillae perfecto quo, tempor audiam mediocrem mei ei. Sale eloquentiam has in. Quo legere fuisset id, elaboraret eloquentiam usu cu."
wp post create --post_type=page --post_title=Landing --post_status=publish --post_author=$(wp user get $wpuser --field=ID --format=ids) --post_content="Lorem ipsum dolor sit amet, ea etiam dicant sit, solum percipit est ne. Et ullum minim eum. Cu nam reque mucius accumsan, sea quem iudico theophrastus te, vix ne nullam pericula. Mei ea justo choro definitionem, id nam prima posse consetetur. Atomorum mandamus consequuntur ius ea.

Usu cu purto etiam legere. Id quo iisque consequat persecuti, tractatos consequuntur id mel, erat praesent mei ei. Ex ancillae perfecto quo, tempor audiam mediocrem mei ei. Sale eloquentiam has in. Quo legere fuisset id, elaboraret eloquentiam usu cu."

wp post create --post_type=page --post_title=About --post_status=publish --post_author=$(wp user get $wpuser --field=ID --format=ids) --post_content="Lorem ipsum dolor sit amet, ea etiam dicant sit, solum percipit est ne. Et ullum minim eum. Cu nam reque mucius accumsan, sea quem iudico theophrastus te, vix ne nullam pericula. Mei ea justo choro definitionem, id nam prima posse consetetur. Atomorum mandamus consequuntur ius ea.

Usu cu purto etiam legere. Id quo iisque consequat persecuti, tractatos consequuntur id mel, erat praesent mei ei. Ex ancillae perfecto quo, tempor audiam mediocrem mei ei. Sale eloquentiam has in. Quo legere fuisset id, elaboraret eloquentiam usu cu."

wp post create --post_type=page --post_title=Contact --post_status=publish --post_author=$(wp user get $wpuser --field=ID --format=ids) --post_content="Lorem ipsum dolor sit amet, ea etiam dicant sit, solum percipit est ne. Et ullum minim eum. Cu nam reque mucius accumsan, sea quem iudico theophrastus te, vix ne nullam pericula. Mei ea justo choro definitionem, id nam prima posse consetetur. Atomorum mandamus consequuntur ius ea.

Usu cu purto etiam legere. Id quo iisque consequat persecuti, tractatos consequuntur id mel, erat praesent mei ei. Ex ancillae perfecto quo, tempor audiam mediocrem mei ei. Sale eloquentiam has in. Quo legere fuisset id, elaboraret eloquentiam usu cu."

# set homepage as front page
wp option update show_on_front 'page'

# set homepage to be the new page
wp option update page_on_front $(wp post list --post_type=page --post_status=publish --posts_per_page=1 --pagename=home --field=ID --format=ids)

# create all of the pages
export IFS=","
for page in $allpages; do

	wp post create --post_type=page --post_status=publish --post_author=$(wp user get $wpuser --field=ID --format=ids) --post_title="$(echo $page | sed -e 's/^ *//' -e 's/ *$//')"

done

# delete all sidebar widgets except search
wp widget delete recent-posts-2
wp widget delete recent-comments-2
wp widget delete archives-2
wp widget delete categories-2
wp widget delete meta-2

# delete akismet and hello dolly
wp plugin delete akismet
wp plugin delete hello

# install jetpack plugin
wp plugin install jetpack --activate

# install unplug jetpack plugin
wp plugin install unplug-jetpack --activate

# install cmb2 plugin
wp plugin install cmb2 --activate

# install theme check plugin
wp plugin install theme-check --activate

# install user switching plugin
wp plugin install user-switching --activate

# install relative url plugin
wp plugin install relative-url

# install duplicator plugin
wp plugin install duplicator

# install wp-sweep plugin
wp plugin install wp-sweep

# install w3 total cache plugin
wp plugin install w3-total-cache

# install updraftplus plugin
wp plugin install updraftplus

# install woocommerce and create shop page
if [ "$woocommerce" == y ] ; then

	wp plugin install woocommerce --activate
	wp post create --post_type=page --post_title=Shop --post_status=publish --post_author=$(wp user get $wpuser --field=ID --format=ids)

fi

# set appropriate themepaths
if [ "$genesis" == n ] ; then

	themeinstallpath="$startertheme"
	# get theme name
	themefilename=$(echo "$startertheme" | sed 's|.*/||')
	themename=${themefilename%????}

else

	themeinstallpath="$genesisloc"
	# get theme name
	themefilename=$(echo "$genesisstarter" | sed 's|.*/||')
	themename=${themefilename%????}

fi

# install the company starter theme
wp theme install $themeinstallpath --activate
if [ "$genesis" == y ] ; then

	wp theme install $genesisstarter --activate

fi

# delete extraneous themes
wp theme delete twentysixteen
wp theme delete twentyfifteen
wp theme delete twentyfourteen

# if genesis & woocommerce, activate genesis connect woocommerce
if [ "$genesis" == y ] && [ "$woocommerce" == y ] ; then

	wp plugin install genesis-connect-woocommerce

fi

# create a navigation bar
wp menu create "Main Navigation"

# add pages to navigation
export IFS=" "
for pageid in $(wp post list --order="ASC" --orderby="date" --post_type=page --post_status=publish --posts_per_page=-1 --field=ID --format=ids); do

	wp menu item add-post main-navigation $pageid

done

# assign navigation to primary location
wp menu location assign main-navigation primary

# set pretty urls
wp rewrite structure '/%postname%/' --hard
wp rewrite flush --hard

clear

echo "================================================================="
echo "Installation is complete. Your username/password is listed below."
echo ""
echo "Username: $wpuser"
echo "Password: $password"
echo ""
echo "================================================================="

# Open the new website with Google Chrome
/usr/bin/open -a "/Applications/Google Chrome.app" "http://$currentdirectory.dev/"

# Open the project in Atom
/Applications/Atom.app/Contents/Resources/app/atom.sh wp-content/themes/$themename/functions.php

# install gulp.js dependencies and start the gulp server
if [ "$npmandgulp" == y ] ; then

	cd $(wp theme path)/$themename/
	npm install --save-dev --legacy-bundling &
	echo ""
	echo "Finished installing npm dependencies"
	sleep 30

fi

clear

cd ../../../

if [ "$gitremote" == "" ] ; then

	# Clean up dashboard
	echo "\n" >> wp-content/themes/$themename/functions.php
	echo "/** Remove worthless dashboard panels */" >> wp-content/themes/$themename/functions.php
	echo "function remove_dashboard_meta() {
			remove_meta_box('dashboard_right_now', 'dashboard', 'normal');   // Right Now
			remove_meta_box('dashboard_incoming_links', 'dashboard', 'normal');  // Incoming Links
			remove_meta_box('dashboard_quick_press', 'dashboard', 'side');  // Quick Press
			remove_meta_box('dashboard_primary', 'dashboard', 'side');   // WordPress blog
			remove_meta_box('dashboard_secondary', 'dashboard', 'side');   // Other WordPress News
		}
	add_action( 'admin_init', 'remove_dashboard_meta' );" >> wp-content/themes/$themename/functions.php

	echo "\n" >> wp-content/themes/$themename/functions.php
	echo "/** Remove welcome dashboard panel */" >> wp-content/themes/$themename/functions.php
	echo "function remove_welcome_panel()	{
		  remove_action('welcome_panel', 'wp_welcome_panel');
		  \$user_id = get_current_user_id();
		  if (0 !== get_user_meta( \$user_id, 'show_welcome_panel', true ) ) {
		      update_user_meta( \$user_id, 'show_welcome_panel', 0 );
		  }
		}
	add_action( 'load-index.php', 'remove_welcome_panel' );" >> wp-content/themes/$themename/functions.php

	# Initial commit
	git add .
	git commit -m "initial commit"
	git pull origin master --rebase
	git push origin master

else

	git fetch --all
	git reset --hard origin/master

fi
