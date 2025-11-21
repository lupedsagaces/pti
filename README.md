# 🛡️ pti - Pentest Tools Installer

Um script automatizado para instalação de ferramentas essenciais de pentest/red team em sistemas Linux baseados em Debian/Ubuntu.

## 📋 Ferramentas Incluídas

| Ferramenta | Descrição | Instalação |
|------------|-----------|------------|
| **Nmap** | Scanner de rede e portas | apt |
| **Hydra** | Brute force de autenticação | apt |
| **Gobuster** | Directory/DNS busting | apt/Go |
| **Nikto** | Scanner de vulnerabilidades web | apt |
| **WhatWeb** | Fingerprinting de websites | apt |
| **nbtscan** | Scanner NetBIOS | apt |
| **enum4linux** | Enumeração SMB/Samba | apt/GitHub |
| **xfreerdp** | Cliente RDP | apt |
| **hashid** | Identificador de hashes | pip |
| **Impacket** | Biblioteca de protocolos de rede | pipx |
| **Hashcat** | Cracking de hashes (GPU) | apt |
| **John the Ripper** | Cracking de hashes (Jumbo) | apt/source |
| **Responder** | LLMNR/NBT-NS/mDNS poisoner | GitHub |
| **NetExec (nxc)** | Pós-exploração de rede | pipx |
| **Mimikatz** | Extração de credenciais Windows | GitHub Release |
| **getJS** | Extrator de arquivos JavaScript | Go |
| **Burp Suite Community** | Proxy e scanner web | Instalador oficial |

## ⚙️ Requisitos

- Sistema operacional: **Debian/Ubuntu** (ou derivados)
- Privilégios de **root**
- Script testado em ambiente com Linux Lite OS e ParrotOS ambos amd64

## 🚀 Instalação

### Método 1: Clone do repositório

```bash
git clone https://github.com/lupedsagaces/pti.git
cd pti
chmod +x pti.sh
sudo pti.sh
```

### Método 2: Download direto

```bash
wget https://raw.githubusercontent.com/lupedsagaces/pti/main/pti.sh
chmod +x pti.sh
sudo pti.sh
```

### Método 3: One-liner

```bash
curl -sL https://raw.githubusercontent.com/lupedsagaces/pti/main/pti.sh | sudo bash
```

## 📁 Estrutura de Diretórios

Após a instalação, as ferramentas ficam organizadas em:

```
/opt/pentest-tools/
├── Responder/          # Responder (LLMNR/NBT-NS poisoner)
├── mimikatz/           # Binários do Mimikatz
├── go_install/         # Scripts de instalação do Go
└── burpsuite_installer.sh  # Instalador do Burp Suite
```

## 📖 Uso Pós-Instalação

### Recarregar o shell

```bash
source ~/.bashrc
```

### Instalar Burp Suite (manual)

```bash
sudo bash /opt/pentest-tools/burpsuite_installer.sh
```

### Verificar instalações

```bash
# Testar algumas ferramentas
nmap --version
hashcat --version
john --version
nxc --version
getJS --help
```

## ⚠️ Aviso Legal

**Este script e as ferramentas instaladas são destinados EXCLUSIVAMENTE para:**

- Testes de penetração autorizados
- Avaliações de segurança com permissão explícita
- Ambientes de laboratório e CTFs
- Fins educacionais

**O uso não autorizado dessas ferramentas contra sistemas que você não possui ou não tem permissão explícita para testar é ILEGAL e pode resultar em processos criminais.**

O autor não se responsabiliza pelo uso indevido deste script.

## 🤝 Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para:

1. Fazer um fork do projeto
2. Criar uma branch para sua feature (`git checkout -b feature/nova-ferramenta`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova ferramenta'`)
4. Push para a branch (`git push origin feature/nova-ferramenta`)
5. Abrir um Pull Request

## 📝 Changelog

### v1.0.0
- Release inicial
- Instalação automatizada de 17+ ferramentas de pentest
- Suporte a Debian/Ubuntu

## 📜 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 🔗 Referências

- [Nmap](https://nmap.org/)
- [Hydra](https://github.com/vanhauser-thc/thc-hydra)
- [Gobuster](https://github.com/OJ/gobuster)
- [Impacket](https://github.com/fortra/impacket)
- [Responder](https://github.com/lgandx/Responder)
- [NetExec](https://github.com/Pennyw0rth/NetExec)
- [Mimikatz](https://github.com/gentilkiwi/mimikatz)
- [John the Ripper](https://github.com/openwall/john)
- [Hashcat](https://hashcat.net/hashcat/)
- [Burp Suite](https://portswigger.net/burp)

---

**Feito com ☕ para a comunidade de segurança**