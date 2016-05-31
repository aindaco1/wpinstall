# wpinstall
WordPress installation bash script for Laravel Valet

- Creates local WordPress installation for Laravel Valet
- Hardens core (a bit)
- Creates Bitbucket repo (or lets you clone existing repo)
- Removes Hello Dolly & Akismet, installs dev plugins
- Removes sample posts, adds pages, posts, widgets with dummy content
- Installs starter theme
- Supports npm, gulp, sass
- Customizes WordPress dashboard
- Opens site on Chrome and functions.php in Atom

Requirements to get it to work as is:

- Mac OS X
- Laravel Valet (requires Homebrew, PHP, MySQL/MariaDB, Composer)
- Sass
- node.js, npm, gulp
- Genesis framework
- git
- a .gitignore file (sample provided)
- Bitbucket account
- Chrome
- Atom

Tips:

- Make it executable! (chmod +x locationofscript)
