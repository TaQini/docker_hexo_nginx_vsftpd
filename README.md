# easy_hexo

通过docker快速搭建Hexo博客平台

## 运行机制

| docker服务器 | 功能                           |
| ------------ | ------------------------------ |
| `hexo`       | 负责实时检测文章、生成静态页面 |
| `nginx`      | 用于展示`hexo`生成的静态页面   |
| `vsftpd`     | 用于上传、编辑、删除文章       |

## 特点

- 通过docker部署，方便快捷
- 数据与服务隔离，易于升级
- 通过ftp服务器编辑、发布文章，对不熟悉控制台的用户比较友好

## 安装

下载代码

```shell
git clone https://github.com/TaQini/easy_hexo.git
```

进入目录，修改ftp服务默认密码：

```shell
cd easy_hexo
vim docker-compose.yml
```

将`your_passwd`改成你的密码

```yaml
    environment:
    - FTP_USER=blog
    - FTP_PASS=your_passwd
```

一键安装

```shell
sudo docker-compose up -d
```

安装成功后，访问[http://your.site:8080](http://your.site:8080)即可浏览网页

![]()

## 配置

### WEB服务端口配置

> web服务默认运行在`8080`端口

打开`docker-compose.yml`文件，找到如下部分：

```yml
services:
  nginx:
    image: "nginx"
    volumes:
      - ./public:/usr/share/nginx/html
    ports:
    - "8080:80"
```

将默认的`8080`修改即可

### FTP服务器配置

> ftp默认绑定的20/21端口，如无特殊需要，不建议进行修改

ftp服务在`docker-compose.yml`文件中对应的配置如下：

```yaml
  vsftpd:
    image: "fauria/vsftpd"
    volumes:
      - ./source/_posts:/home/vsftpd/blog/blog
    ports:
    - "20:20"
    - "21:21"
    - "21100-21110:21100-21110"
    environment:
    - FTP_USER=blog
    - FTP_PASS=your_passwd
    - PASV_ADDRESS=127.0.0.1
    - PASV_MIN_PORT=21100
    - PASV_MAX_PORT=21110
```

### Hexo配置

安装成功后，查看服务是否正常运行：

```shell
sudo docker-compose ps 
```

> 若三个`State`都是`Up`则说明服务正常运行

输入如下命令，进入控制台：

```shell
sudo docker-compose exec hexo /bin/bash
```

随后可对hexo进行配置，具体配置请参考[官方文档](https://hexo.io/zh-cn/docs/configuration)

## 编辑文章

在本地使用`markdown`语言编写文章，推荐使用Typora [下载地址](https://typora.io/)

```markdown
---
title: Hello Hexo
date: 2020-03-02 12:34:00
updated: 2020-03-02 13:24:00
tags: atag
categories: acat
keywords: hexo
description: hello
---

# Hello Hexo

Hello world

```

文章开头的参数可配置，Hexo预先定义的参数如下：

| 参数         | 描述                                                 | 默认值       |
| ------------ | ---------------------------------------------------- | ------------ |
| `layout`     | 布局                                                 |              |
| `title`      | 标题                                                 | 文章的文件名 |
| `date`       | 建立日期                                             | 文件建立日期 |
| `updated`    | 更新日期                                             | 文件更新日期 |
| `comments`   | 开启文章的评论功能                                   | true         |
| `tags`       | 标签（不适用于分页）                                 |              |
| `categories` | 分类（不适用于分页）                                 |              |
| `permalink`  | 覆盖文章网址                                         |              |
| `keywords`   | 仅用于 meta 标签和 Open Graph 的关键词（不推荐使用） |              |

> 可以保存成一个模板，方便以后使用 :D

编写的文章最好保存在本地的一个文件夹中，这样便于后续的[文章发布](#发布文章)

## 发布文章

使用先前设置的用户名和密码连接FTP服务器

> 建议使用FTP客户端，比如FileZilla [下载地址](https://filezilla-project.org/download.php?type=client)


