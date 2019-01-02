FROM alpine

ENV HOME=/root
ENV GOROOT=$HOME/.golang/go
ENV GOPATH=$HOME/.golang/path
ENV PATH=$PATH:$HOME/.golang/go/bin
ENV GOROOT_BOOTSTRAP=$HOME/.golang/go1.4

RUN set -ex && \
    apk add --no-cache --virtual .build-deps \
                                build-base \
                                gcc \
                                git \
                                make \
                                bash \
                                g++ && \
    git clone https://github.com/golang/go.git ~/.golang/go && \
    cd ~/.golang && \
    cp -r go go1.4 && \
    cd ~/.golang/go1.4 && \
    git checkout release-branch.go1.4 && \
    cd src && \
    ./make.bash && \
    cd ~/.golang/go && \
    git checkout release-branch.go1.11 && \
    cd src && \
    ./make.bash && \
    git clone https://github.com/fatedier/frp.git $GOPATH/src/github.com/fatedier/frp && \
    cd $GOPATH/src/github.com/fatedier/frp && \
    make && \
    apk del .build-deps \
            build-base \
            gcc \
            git \
            make \
            bash \
            g++ && \
    mkdir /frp && \
    cp $GOPATH/src/github.com/fatedier/frp/bin/frp* /frp && \
    cp $GOPATH/src/github.com/fatedier/frp/conf/* /frp && \
    rm -rf ~/.golang

ENTRYPOINT [ "/frp/frps" , "-c" , "/frp/frps.ini" ]