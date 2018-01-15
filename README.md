Trading API YoBit for PHP 7.0

Translation into English "Google Translate".

Dependencies:

git
php7.0
php7.0-curl

Example:

Debian\Ubuntu

apt-get install git php7.0 php7.0-curl

download\clone git, examle:
git clone https://github.com/Lexwer/tradingAPIcryptoExchange.git

cd tradingAPIcryptoExchange
chmod +x test.php

look and edit test.php lines: 9,10,11
run test.php:

php test.php -pgen
Run with parameters only once to create files (nonce, api_key, api_secret). Run without parameters will show files (nonce, api_key, api_secret).

look and edit order_bay.sh lines: 7,8,9,10,11

chmod +x order_bay.sh

./order_bay.sh

If the output is error-free then everything is fine

testing Ubuntu 16.04