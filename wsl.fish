#!bin/fish
echo "wsl.fish"
echo "---------------------------------------------------------------------------------------------"

sudo add-apt-repository ppa:wslutilities/wslu
sudo apt install ubuntu-wsl wslu -y

echo 'Configuring wsl specific parameters.'
rg --files /mnt/c/Users/ -g code | fish_add_path
sudo touch /etc/wsl.conf || exit
echo -e '[interop]\nappendWindowsPath = false' | sudo tee /etc/wsl.conf