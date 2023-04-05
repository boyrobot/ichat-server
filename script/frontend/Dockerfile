FROM nginx:latest

WORKDIR /usr/share/nginx/html
ADD ichat-weixin  .
COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
