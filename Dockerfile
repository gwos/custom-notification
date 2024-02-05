ARG BASE_IMG=nginx:perl

FROM ${BASE_IMG}

RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qqy \
        build-essential \
        fcgiwrap \
        liblwp-protocol-https-perl \
        vim \
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
CMD /docker_cmd.sh