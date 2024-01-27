Oh My Zsh

1. 本篇文章會安裝以下套件：
* 1-1. Zsh
* 1-2. Oh My Zsh
* 1-3. Powerlevel10k 主題
* 1-4. zsh-autosuggestions
* 1-5. zsh-syntax-highlighting
* 1-6. Zsh-z

## 2. 安裝 必要的套件
sudo apt install wget git curl vim -y

3. 安裝 Patched 字型(連線端)
wget https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Regular.ttf &&
wget https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Bold.ttf &&
wget https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Italic.ttf &&
wget https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Bold%20Italic.ttf

4. 安裝 Zsh
shell 輸入
sudo apt install zsh -y

5. 安裝 Oh My Zsh
輸入以下指令安裝 Oh My Zsh，安裝完畢後，按下 Enter 同意把預設 Shell 換成 Zsh。
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

6. 設定預設 Shell
若之前並沒有成功設定修改預設 Shell，請執行以下指令:
chsh -s $(which zsh)

7. 安裝插件
安裝以下插件的時候，
請確定已安裝好 Oh My Zsh ，且目前正在使用的 Shell 是 Zsh。

7-1. 主題 PowerLevel10k
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

7-2. 插件 zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

7-3. 插件 zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

7-4. 插件 Zsh-z
類似於 autojump 的插件，比 cd 更快速地直接跳到想去的資料夾，且效能更好沒有一堆依賴包。
git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z

8. 啟動插件
vi ~/.zshrc
點擊 i ，進入編輯模式。

8-1. 修改主題
ZSH_THEME="powerlevel10k/powerlevel10k"
8-2. 新增要啟動的插件 (Plugins)
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-z)

點擊 ESC 跳出編輯模式。
輸入 :wq 儲存。

9.應用修改過的 zshrc
source ~/.zshrc

10. 進入設定精靈

11. p10k configure(可重設)
