
# ARG BASE_IMG=nginx:perl
# using stable base to prevent apt-get issue
# Note that following to `Docker best practice` and doing `rm -rf /var/lib/apt/lists/*` makes it impossible to use apt on nested images
ARG BASE_IMG=nginx:stable-bullseye-perl

FROM ${BASE_IMG}

RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qqy \
        build-essential \
        fcgiwrap \
        liblwp-protocol-https-perl \
        vim \
    && apt-get clean \
    && cpan \
        CGI \
        Data::Dumper \
        IO::Handle \
        JSON \
        LWP::UserAgent \
        MIME::Base64 \
        REST::Client \
    && rm -f \
        /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh \
        /etc/nginx/conf.d/default.conf \
    && ln -sf /dev/stderr /var/log/custom_notification.log

COPY ./src/ /

# wrap upstream entrypoint into custom
# Note:  https://docs.docker.com/reference/dockerfile/#entrypoint
# If CMD is defined from the base image, setting ENTRYPOINT will reset CMD to an empty value.
# In this scenario, CMD must be defined in the current image to have a value.
ENTRYPOINT ["/docker_cmd.sh", "/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
