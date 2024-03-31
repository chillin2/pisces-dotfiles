# pisces-dotfiles

My Dev workflow for WSL 

---

git clone https://github.com/chillin2/pisces-jwk-dotfiles.git ~/.config

## Requirement

neovim  
fish shell ( User friendly interactive shell )  
fisher ( Plugin manager for Fish )  
shellder ( Shell theme )  
peco ( Interactive filtering tool )  
exa ( A mordern replacement for 'ls' )  
ghq ( Local Git repository oganizer )  
z ( Directory jumping )

sudo apt-add-repository ppa:fish-shell/release-3  
sudo apt update  
sudo apt install fish

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

sudo apt install exa
