#!/bin/bash

# =============================================================================
# Instalador de Ferramentas de Pentest
# Execute como root: sudo bash install_pentest_tools.sh
# =============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    log_error "Execute como root: sudo bash $0"
    exit 1
fi

REAL_USER=${SUDO_USER:-$USER}
REAL_HOME=$(eval echo ~$REAL_USER)
TOOLS_DIR="/opt/pentest-tools"

mkdir -p "$TOOLS_DIR"

log_info "Atualizando repositórios..."
apt update && apt upgrade -y

# =============================================================================
# Dependências básicas
# =============================================================================
log_info "Instalando dependências básicas..."
apt install -y \
    git curl wget build-essential libssl-dev libffi-dev \
    python3 python3-pip python3-dev python3-venv \
    libpcap-dev libnl-3-dev libnl-genl-3-dev \
    libnetfilter-queue-dev libkrb5-dev \
    smbclient libsmbclient-dev \
    ruby ruby-dev \
    default-jdk \
    unzip p7zip-full \
    net-tools dnsutils \
    freerdp2-x11 \
    opencl-headers ocl-icd-libopencl1 ocl-icd-opencl-dev pipx

# =============================================================================
# Nmap
# =============================================================================
log_info "Instalando Nmap..."
apt install -y nmap
log_success "Nmap instalado"

# =============================================================================
# Hydra
# =============================================================================
log_info "Instalando Hydra..."
apt install -y hydra
log_success "Hydra instalado"

# =============================================================================
# Gobuster
# =============================================================================
log_info "Instalando Gobuster..."
apt install -y gobuster || {
    log_warn "Gobuster não disponível no apt, será instalado via Go"
}
log_success "Gobuster instalado"

# =============================================================================
# Nikto
# =============================================================================
log_info "Instalando Nikto..."
apt install -y nikto
log_success "Nikto instalado"

# =============================================================================
# WhatWeb
# =============================================================================
log_info "Instalando WhatWeb..."
apt install -y whatweb
log_success "WhatWeb instalado"

# =============================================================================
# nbtscan
# =============================================================================
log_info "Instalando nbtscan..."
apt install -y nbtscan
log_success "nbtscan instalado"

# =============================================================================
# enum4linux
# =============================================================================
log_info "Instalando enum4linux..."
apt install -y enum4linux || {
    log_info "Instalando enum4linux do GitHub..."
    git clone https://github.com/CiscoCXSecurity/enum4linux.git "$TOOLS_DIR/enum4linux"
    chmod +x "$TOOLS_DIR/enum4linux/enum4linux.pl"
    ln -sf "$TOOLS_DIR/enum4linux/enum4linux.pl" /usr/local/bin/enum4linux
}
log_success "enum4linux instalado"

# =============================================================================
# xfreerdp
# =============================================================================
log_info "Instalando xfreerdp..."
apt install -y freerdp2-x11
log_success "xfreerdp instalado"

# =============================================================================
# hashid
# =============================================================================
log_info "Instalando hashid..."
pip3 install hashid --break-system-packages 2>/dev/null || pip3 install hashid
log_success "hashid instalado"

# =============================================================================
# Impacket
# =============================================================================
log_info "Instalando Impacket..."
python3 -m pipx install impacket 2>/dev/null || pip3 install impacket
log_success "Impacket instalado"

# =============================================================================
# Hashcat
# =============================================================================
log_info "Instalando Hashcat..."
apt install -y hashcat
log_success "Hashcat instalado"

# =============================================================================
# John the Ripper (Jumbo)
# =============================================================================
log_info "Instalando John the Ripper (Jumbo)..."
apt install -y john || {
    log_info "Compilando John the Ripper Jumbo do source..."
    cd "$TOOLS_DIR"
    git clone https://github.com/openwall/john.git john-jumbo
    cd john-jumbo/src
    ./configure && make -j$(nproc)
    ln -sf "$TOOLS_DIR/john-jumbo/run/john" /usr/local/bin/john-jumbo
}
log_success "John the Ripper instalado"

# =============================================================================
# Responder
# =============================================================================
log_info "Instalando Responder..."
cd "$TOOLS_DIR"
if [ -d "Responder" ]; then
    cd Responder && git pull
else
    git clone https://github.com/lgandx/Responder.git
fi
chmod +x "$TOOLS_DIR/Responder/Responder.py"
log_success "Responder instalado"
log_success "Responder baixado em $TOOLS_DIR/Responder"

# =============================================================================
# NetExec (nxc) - sucessor do CrackMapExec
# =============================================================================
log_info "Instalando NetExec (nxc)..."
pipx ensurepath
pipx install git+https://github.com/Pennyw0rth/NetExec
log_success "NetExec instalado"

# =============================================================================
# Mimikatz (Windows binary - para uso em máquinas Windows comprometidas)
# =============================================================================
log_info "Baixando Mimikatz..."
mkdir -p "$TOOLS_DIR/mimikatz"
cd "$TOOLS_DIR/mimikatz"
MIMIKATZ_URL=$(curl -s https://api.github.com/repos/gentilkiwi/mimikatz/releases/latest | grep "browser_download_url.*mimikatz_trunk.zip" | cut -d '"' -f 4)
if [ -n "$MIMIKATZ_URL" ]; then
    wget -q "$MIMIKATZ_URL" -O mimikatz.zip
    unzip -o mimikatz.zip
    rm mimikatz.zip
    log_success "Mimikatz baixado em $TOOLS_DIR/mimikatz"
else
    log_warn "Não foi possível baixar Mimikatz automaticamente"
    log_info "Baixe manualmente de: https://github.com/gentilkiwi/mimikatz/releases"
fi

# =============================================================================
# Go (usando seu repositório)
# =============================================================================
log_info "Instalando Go by script lupedsagaces..."
cd "$TOOLS_DIR"
if [ -d "go_install" ]; then
    rm -rf go_install
fi
git clone https://github.com/lupedsagaces/go_install.git
cd go_install
python3 -m venv myenv
source myenv/bin/activate
pip install requests lxml
python3 linux_install.py
deactivate

log_success "Go instalado"

# =============================================================================
# getJS
# =============================================================================
log_info "Instalando getJS..."
go install github.com/003random/getJS/v2@latest
log_success "getJS instalado"

# =============================================================================
# Gobuster via Go (se não instalou via apt)
# =============================================================================
if ! command -v gobuster &> /dev/null; then
    log_info "Instalando Gobuster via Go..."
    sudo -u "$REAL_USER" bash -c "export PATH=\$PATH:/usr/local/go/bin:\$HOME/go/bin && go install github.com/OJ/gobuster/v3@latest"
    ln -sf "$REAL_HOME/go/bin/gobuster" /usr/local/bin/gobuster 2>/dev/null || true
    log_success "Gobuster instalado via Go"
fi

# =============================================================================
# Burp Suite Community
# =============================================================================
log_info "Baixando Burp Suite Community..."
cd "$TOOLS_DIR"
BURP_URL="https://portswigger.net/burp/releases/download?product=community&type=Linux"
wget -q "$BURP_URL" -O burpsuite_installer.sh || {
    log_warn "Download direto falhou, tentando alternativa..."
    curl -sL "https://portswigger.net/burp/releases/download?product=community&type=Linux" -o burpsuite_installer.sh
}
if [ -f burpsuite_installer.sh ] && [ -s burpsuite_installer.sh ]; then
    chmod +x burpsuite_installer.sh
    log_success "Burp Suite baixado em $TOOLS_DIR/burpsuite_installer.sh"
    log_info "Execute manualmente: sudo bash $TOOLS_DIR/burpsuite_installer.sh"
else
    log_warn "Não foi possível baixar Burp Suite automaticamente"
    log_info "Baixe manualmente de: https://portswigger.net/burp/communitydownload"
fi

# =============================================================================
# nbstat (net-tools inclui ferramentas similares)
# =============================================================================
log_info "Verificando nbstat/net-tools..."
apt install -y net-tools
log_success "net-tools instalado (inclui funcionalidades nbstat)"

# =============================================================================
# Limpeza
# =============================================================================
log_info "Limpando cache..."
apt autoremove -y
apt clean

# =============================================================================
# Resumo
# =============================================================================
echo ""
echo "============================================================================="
echo -e "${GREEN}INSTALAÇÃO CONCLUÍDA!${NC}"
echo "============================================================================="
echo ""
echo "Ferramentas instaladas:"
echo "  - Nmap: nmap"
echo "  - Hydra: hydra"
echo "  - Gobuster: gobuster"
echo "  - Nikto: nikto"
echo "  - WhatWeb: whatweb"
echo "  - nbtscan: nbtscan"
echo "  - enum4linux: enum4linux"
echo "  - xfreerdp: xfreerdp"
echo "  - hashid: hashid"
echo "  - Impacket: impacket-* (vários scripts)"
echo "  - Hashcat: hashcat"
echo "  - John the Ripper: john"
echo "  - Responder: responder ou python3 $TOOLS_DIR/Responder/Responder.py"
echo "  - NetExec (nxc): nxc"
echo "  - getJS: getJS"
echo "  - Go: go"
echo ""
echo "Ferramentas em $TOOLS_DIR:"
echo "  - Mimikatz: $TOOLS_DIR/mimikatz/"
echo "  - Burp Suite: Execute sudo bash $TOOLS_DIR/burpsuite_installer.sh"
echo ""
echo -e "${YELLOW}IMPORTANTE:${NC} Recarregue o shell para atualizar o PATH:"
echo "  source ~/.bashrc"
echo ""
echo "============================================================================="