FROM php:7.1
LABEL maintainer "Vincent Falies <vincent@vfac.fr>"

# Install base dependencies
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libsqlite3-dev \
        libssl-dev \
        libcurl3-dev \
        libxml2-dev \
        libzzip-dev \
        wget \
        curl \
    && docker-php-ext-install mcrypt mysqli pdo_mysql xmlrpc zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

# Atom dependencies
RUN apt-get install -y \
    git \
    gconf2 \
    gconf-service \
    libgtk2.0-0 \
    libnotify4 \
    libxtst6 \
    libnss3 \
    gvfs-bin \
    xdg-utils

# X11 dependencies
RUN apt-get install -y \
    libxss1 \
    libxkbfile1

# Install Composer
RUN wget https://raw.githubusercontent.com/composer/getcomposer.org/1b137f8bf6db3e79a38a5bc45324414a6b1f9df2/web/installer -O - | php -- --install-dir=/usr/local/bin --filename=composer
RUN chmod a+x /usr/local/bin/composer
RUN composer selfupdate

# Install NodeJS and Npm
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get update && apt-get install -y \
      nodejs \
	    && rm -rf /var/lib/apt/lists/*

# Install Npm global dependencies
RUN npm install -g gulp-cli
RUN npm install -g bower

# Install php-cs-fixer
RUN wget http://cs.sensiolabs.org/download/php-cs-fixer-v2.phar -O php-cs-fixer
RUN chmod a+x php-cs-fixer
RUN mv php-cs-fixer /usr/local/bin/php-cs-fixer

#Create user developer
ENV HOME /home/developer
RUN useradd --create-home --home-dir $HOME developer \
      && chown -R developer:developer $HOME \
      && chmod -R 775 $HOME

USER root

# download the source
RUN set -x \
	&& curl -sSL https://atom.io/download/deb -o /tmp/atom-amd64.deb \
	&& dpkg -i /tmp/atom-amd64.deb \
	&& rm -rf /tmp/*.deb

USER developer

#Install atom packages
RUN apm install aligner \
                aligner-javascript \
                aligner-php \
                busy-signal \
                docblockr \
                file-icons \
                git-plus \
                hyperclick \
                intentions \
                language-docker \
                linter \
                linter-ui-default \
                php-integrator-base \
                php-integrator-autocomplete-plus \
                php-integrator-navigation \
                php-integrator-linter \
                php-integrator-refactoring \
                project-manager \
                php-twig \
                symbols-list \
                platformio-ide-terminal

# Autorun atom
ENTRYPOINT [ "atom", "--foreground" ]
