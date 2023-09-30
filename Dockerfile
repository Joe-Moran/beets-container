FROM alpine:latest
ARG BEETS_DIRECTORY
# set beet-specific variable pointing to config directory. ENV is read as an environment variable to linux
ENV BEETSDIR=${BEETS_DIRECTORY}
ENV CRON_INTERVAL="0 0 * * */1"

# install all the things
RUN apk update
RUN apk add --no-cache rust cargo
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools
RUN pip3 install beets

# Add the cron job
RUN crontab -l | { cat; echo -e ${CRON_INTERVAL} "beet import -q" ${BEETS_DIRECTORY}; } | crontab -

# Run the command on container startup
CMD crond -l 2 -f

# create/use the volume /beets
VOLUME /beets
