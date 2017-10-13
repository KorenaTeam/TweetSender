TweetSender | پروژه ارسال هوشمند پست در کانال تلگرام با تایید  -- @TvShowTweet
#Tweet Sender bot V0.1
* * *

# Installation  
**------------------------------------------------------------------------------------------**
# First | Preparation
```sh
sudo apt-get update

sudo apt-get upgrade

sudo apt-get install libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev libevent-dev make unzip git redis-server g++ libjansson-dev libpython-dev expat libexpat1-dev tmux subversion
```
**------------------------------------------------------------------------------------------**
# Second | Essential prerequisites | luarocks install
```sh
 wget http://luarocks.org/releases/luarocks-2.2.2.tar.gz
 tar zxpf luarocks-2.2.2.tar.gz
 cd luarocks-2.2.2
 ./configure; sudo make bootstrap
 sudo luarocks install luasocket
 sudo luarocks install luasec
 sudo luarocks install redis-lua
 sudo luarocks install lua-term
 sudo luarocks install serpent
 sudo luarocks install dkjson
 sudo luarocks install lanes
 sudo luarocks install Lua-cURL
 sudo luarocks install luaxmlrpc
 cd ..
```
**------------------------------------------------------------------------------------------**
# Third | Other prerequisites
```sh
sudo apt-get install libstdc++6
sudo add-apt-repository ppa:ubuntu-toolchain-r/test 
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
```
**------------------------------------------------------------------------------------------**
# Fourth | git clone | install
```sh
cd $HOME
https://github.com/KorenaTeam/TweetSender.git
cd TweetSender
chmod +x tweet.sh
./tweet.sh install
./tweet.sh 
**------------------------------------------------------------------------------------------**
*Put Your ID & BOT token in : config.lua & bot.lua*
*Put Group Mod ID & Channel ID in : bot.lua*
*Put your channel username in : core.lua , Line 190*
```
**------------------------------------------------------------------------------------------**
# Fifth | For Auto Launch:
```sh
cd tweet
chmod 777 run.sh
screen ./run.sh
```
**------------------------------------------------------------------------------------------**
### Our Telegram channel:
[@KorenaTeam](https://telegram.me/korenateam)
