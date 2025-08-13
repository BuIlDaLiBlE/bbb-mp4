# Docker base
FROM ubuntu:bionic

# Create working directory
WORKDIR /usr/src/app

# Install curl and gnupg2 for source file modification
RUN apt-get -y update && apt-get -y install curl gnupg2

# Install chromium
RUN apt-get -y install chromium-browser

#Installing all other dependencies
RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:savoury1/ffmpeg4
RUN apt-get -y update && apt-get -y install libgbm-dev ffmpeg gconf-service libasound2 libatk1.0-0 libc6 libcairo2 \
    libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 \
    libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 \
    libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 \
    libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 \
    libxtst6 ca-certificates fonts-liberation libappindicator1  libnss3 \
    lsb-release xdg-utils wget xvfb fonts-noto \
    dbus-x11 libasound2 fluxbox libasound2-plugins alsa-utils alsa-oss pulseaudio pulseaudio-utils

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash
RUN apt-get install --yes nodejs

#Install npm scripts
RUN npm install npm@v7 -g
COPY *.json ./
RUN npm install

#copy all files from bbb-mp4 project
COPY *.sh ./
COPY *.js ./
COPY .env ./

RUN mkdir processing processed

#Initialize ENV
ENV REC_URL=" "

# Command that will execute when container starts
ENTRYPOINT ["sh","docker-entrypoint.sh"]
CMD node /usr/src/app/bbb-mp4.js $REC_URL
