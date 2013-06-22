---
title: 自制CA证书
create-at: 2013-06-22 07:50:39 +0800
updated-at: 2013-06-22 07:50:39 +0800
category: Tech
---

生成秘钥和CA证书：

    cd /etc/ssl/
    sudo openssl req -config /etc/ssl/openssl.cnf -new -x509 -days 3650 -keyout private/GitCafeKey.pem -out GitCafeCA.crt

更新CA证书：

    sudo mkdir -p /usr/share/ca-certificates/[YOUR WEBSITE]/
    sudo mv /etc/ssl/GitCafeCA.crt /usr/share/ca-certificates/[YOUR WEBSITE]/
    sudo dpkg-reconfigure ca-certificates

生成用户秘钥：

    openssl genrsa -des3 -out gitcafe.key

生成用户证书：

    openssl req -new -days 3650 -key gitcafe.key -out userreq.crt

使用 CA 签发用户证书：

    sudo openssl ca -days 3650 -in userreq.crt -out gitcafe_com.crt

http://rhythm-zju.blog.163.com/blog/static/310042008015115718637/
