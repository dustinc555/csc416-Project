FROM perl:5.20
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp

RUN cpanm install LWP::Simple
RUN cpanm install Net::Server

CMD [ "perl", "./server.pl" ]
