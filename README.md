# pisces-dotfiles  

## Requirement  

sudo apt install peco  

cd ~
curl -OL https://golang.org/dl/go1.20.1.linux-amd64.tar.gz  
sha256sum go1.16.7.linux-amd64.tar.gz  
sudo tar -C /usr/local -xvf go1.20.1.linux-amd64.tar.gz  
sudo nano ~/.profile  
export PATH=$PATH:/usr/local/go/bin  
source ~/.profile  
go version  

git clone https://github.com/x-motemen/ghq  
cd ghq  
make install  


