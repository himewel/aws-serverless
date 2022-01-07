#!/usr/bin/env bash

curl 'https://storage.googleapis.com/kaggle-data-sets/19911/2710089/bundle/archive.zip?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=gcp-kaggle-com%40kaggle-161607.iam.gserviceaccount.com%2F20220107%2Fauto%2Fstorage%2Fgoog4_request&X-Goog-Date=20220107T011105Z&X-Goog-Expires=259199&X-Goog-SignedHeaders=host&X-Goog-Signature=28ec644536ac4074bbd4d52424d5f226fba007f5409797840bebc61e1b0069b8eeffbcc31bf7dd6c9a4dc52f78ebfb005b4ba5fcf302fb21667f77558c913cb4d21c9ccc71e275cc050e931241acbd31a8460fcacb4ca7410b489af66e292b0b2d4f33fb5a5c775956b737f6c7e3e12d8c7f62c2a54f17a8d1d9d80fa8d2ddb2403916e220e23075acd88a656c81019907c9bc4ab1925a40c3730b8b9f0d0e3cf03e852d97765c3a292b2d64846aa693ff07b5232705724add745f679b2785126906fbad714af1cec7796f8078777fec1d462afa584b44f8389fe6ad877c3f16cd6e6d4c39982ec0adb74d37eedb28b0bb92021606c41908a7f458112f16a9c9' \
    -H 'authority: storage.googleapis.com' \
    -H 'pragma: no-cache' \
    -H 'cache-control: no-cache' \
    -H 'upgrade-insecure-requests: 1' \
    -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36' \
    -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
    -H 'sec-fetch-site: none' \
    -H 'sec-fetch-mode: navigate' \
    -H 'sec-fetch-user: ?1' \
    -H 'sec-fetch-dest: document' \
    -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="96", "Google Chrome";v="96"' \
    -H 'sec-ch-ua-mobile: ?0' \
    -H 'sec-ch-ua-platform: "Linux"' \
    -H 'accept-language: en-US,en;q=0.9,pt-BR;q=0.8,pt;q=0.7' \
    --compressed \
    -O archive.zip

unzip -o archive.zip -d archive
