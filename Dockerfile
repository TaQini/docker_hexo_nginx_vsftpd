FROM node

WORKDIR /opt/hexo

RUN  npm install hexo-cli -g
RUN  hexo init blog

WORKDIR /opt/hexo/blog
RUN  hexo g
RUN  cp -r /opt/hexo/blog /opt/hexo/bak

