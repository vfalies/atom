FROM debian:stretch
LABEL maintainer "Vincent Falies <vincent.falies@gmail.com>"

# Install base dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    build-essential \
    gnupg2 \
    ssh \
    openssl \
    gconf2 \
    gconf-service \
    gvfs-bin \
    libasound2 \
    libcap2 \
    libgconf-2-4 \
    libgnome-keyring-dev \
    libgtk2.0-0 \
    libnotify4 \
    libnss3 \
    libxkbfile1 \
    libxss1 \
    libxtst6 \
    xdg-utils

# Install dependencies
RUN apt-get install -y \
    sqlite3 \
    nodejs \
    nodejs-legacy \
    php \
    php-curl \
    php-sqlite3 \
    php-mbstring \
    php-xml \
    php-pdo-pgsql \
    php-bcmath \
    php-mcrypt \
    php-zip \
    php-bz2 \
    php-gd \
    php-ldap \
    php-apcu \
    php-xdebug \
    curl \
    zip \
    git \
    git-flow \
    wget \
    unzip \
	&& rm -rf /var/lib/apt/lists/*

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
RUN apm install language-docker \
                project-manager \
                minimap \
                atom-beautify \
                atom-ungit \
                linter \
                linter-ui-default \
                intentions \
                busy-signal \
                file-icons \
                highlight-line \
                color-picker \
                auto-indent \
                linter-docker \
                language-gherkin \
                php-twig \
                php-integrator-base \
                php-integrator-linter \
                php-integrator-navigation \
                hyperclick \
                php-integrator-autocomplete-plus

# Autorun atom
ENTRYPOINT [ "atom", "--foreground" ]
