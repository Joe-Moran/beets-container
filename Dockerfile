FROM alpine:latest

# set beet-specific variable pointing to config directory. ENV is read as an environment variable to linux
ENV BEETSDIR="/beets"

# install all the things
RUN apk update
RUN apk add --no-cache rust cargo
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools
RUN pip3 install beets

# Add the cron job
RUN crontab -l | { cat; echo -e "*/10 * * * * beet import -q /beets"; } | crontab -
# RUN beet import /beets

# Run the command on container startup
CMD crond -l 2 -f

# create/use the volume /beets
VOLUME /beets
