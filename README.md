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
- [Laravel Valet] (https://laravel.com/docs/5.2/valet) (requires Homebrew, PHP, MySQL/MariaDB, Composer)
- [WP-CLI] (https://wp-cli.org/)
- Sass
- node.js, npm, gulp
- [Genesis framework] (http://www.studiopress.com/)
- git
- a .gitignore file (sample provided)
- [Bitbucket] (https://bitbucket.org/) account
- Chrome
- [Atom] (https://atom.io/)

Tips:

- Make it executable! (chmod +x locationofscript)
- You may have to modify the [shebang] (https://en.wikipedia.org/wiki/Shebang_(Unix))
- "$ valet park" on the parent directory
