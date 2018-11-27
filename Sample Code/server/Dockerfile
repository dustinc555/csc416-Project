FROM perl:5.20
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp

RUN cpanm install LWP::Simple
RUN cpanm install Net::Server
RUN cpanm install HTML::TreeBuilder

CMD [ "perl", "./server.pl" ]
