# ⚡ AlphaX Linux — Gaming & Wayland Distro (`Codex WM`)

![Arch Base](https://img.shields.io/badge/Base-Arch%20Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![WM](https://img.shields.io/badge/WM-Codex%20WM%20(Hyprland)-7aa2f7?style=for-the-badge&logo=wayland&logoColor=white)
![Installer](https://img.shields.io/badge/Installer-Calamares-bb9af7?style=for-the-badge)

**AlphaX Linux** es una distribución personalizada basada en **Arch Linux (`archiso`)** enfocada en **Gaming, bajo consumo de recursos y un entorno Wayland moderno**. Incorpora **Codex WM**, un entorno *tiling/mosaico* construido sobre Hyprland con estética **Tokyo Night**, barra superior en Waybar, lanzador Rofi e instalador gráfico **Calamares** con soporte tanto offline como online.

---

## ✨ Características Principales y Diferenciadores

- **⚡ Modo Competitivo Zero-Lag (`SUPER + G`):** Desactiva en tiempo real el *blur*, las sombras, los bordes redondeados y las animaciones del compositor Hyprland, fuerza `allow_tearing = 1`, silencia notificaciones emergentes y prioriza la CPU en modo `performance` para obtener **0 input lag y máximos FPS**.
- **🧠 Kernel `linux-zen` + Tuning de Baja Latencia de Fábrica:**
  - Kernel **`linux-zen`** con parches de escritorio/gaming y arranque con `nowatchdog tsc=reliable split_lock_detect=off`.
  - **SteamOS Memory Tuning (`vm.max_map_count = 2147483642`)** y `kernel.split_lock_mitigate = 0`.
  - **Red Competitiva TCP BBR + Fair Queueing (`fq` + `bbr`)** para minimizar el *bufferbloat* y estabilizar el ping en partidas online.
  - **ZRAM con compresión `zstd`** automático en RAM + reglas `udev` de baja latencia (`none` para NVMe, `mq-deadline` para SSD SATA) y límites `rtprio 98` / `nofile 1048576` para Esync/Fsync.
- **🛠️ AlphaX Control Center (`/usr/local/bin/alphax` / `SUPER + A`):**
  - Centro de mando propio en CLI y Rofi para alternar el modo Zero-Lag, cambiar gobernadores de CPU (`performance`/`schedutil`), **descargar e instalar la última versión de Proton-GE en 1 clic**, autodetectar e instalar drivers GPU Vulkan (AMD/Intel/NVIDIA) y ver el panel de estado `alphax status`.
- **🖥️ Codex WM (Wayland):** Basado en Hyprland + Waybar + Hyprpaper + Rofi + SwayNC + Kitty, preconfigurado con paleta *Tokyo Night* y fuentes `JetBrainsMono Nerd Font`.
- **💿 Instalador Gráfico Calamares:** Instalación base **100% funcional sin conexión a Internet** con limpieza automática post-instalación e identidad persistente en `/etc/os-release` mediante hook de Pacman.

---

## ⌨️ Atajos de Teclado (`Codex WM`)

| Atajo | Acción |
| :--- | :--- |
| `SUPER + Enter` | Abrir terminal **Kitty** (con Fastfetch) |
| `SUPER + A` | Abrir **AlphaX Control Center** (Zero-Lag, CPU, Proton-GE, Drivers GPU) |
| `SUPER + G` | Alternar **Modo Competitivo Zero-Lag** (0 Blur/Animaciones + Tearing ON) |
| `SUPER + D` | Abrir lanzador de aplicaciones **Rofi** |
| `SUPER + E` | Abrir explorador de archivos **Dolphin** |
| `SUPER + Q` | Cerrar ventana activa |
| `SUPER + T` | Alternar layout entre **Tiling (`dwindle`)** y **Mosaico (`master`)** |
| `SUPER + F` | Pantalla completa (*Fullscreen*) |
| `SUPER + Shift + F` | Alternar ventana flotante (*Floating*) |
| `SUPER + 1..5` | Cambiar al espacio de trabajo `1..5` (`main`, `code`, `game`, `media`, `misc`) |
| `SUPER + Shift + 1..5` | Mover ventana activa al espacio de trabajo `1..5` |
| `Print` | Captura de pantalla de área seleccionada (`grim` + `slurp` en `~/Pictures`) |

---

## 📂 Estructura del Repositorio

```text
Base-AlphaX/
├── build.sh                     # Script reproducible para compilar la ISO (Arch nativo o Docker/Podman)
├── scripts/
│   └── check.sh                 # Validador de sintaxis Bash, JSONC, paquetes y Calamares
├── codex-wm/                    # Fuente maestra de Codex WM (sincronizada a /etc/skel/.config/codex)
│   ├── bar/                     # Configuración (config.jsonc) y tema Tokyo Night (style.css) de Waybar
│   ├── config/                  # Configuración de Hyprland (hyprland.conf) y Hyprpaper (hyprpaper.conf)
│   ├── scripts/                 # Scripts de Wi-Fi, selector de Wallpapers y cambio de Layout
│   └── wallpapers/              # Fondos de pantalla predeterminados
├── installer/
│   └── modules/post-install.sh  # Script opcional post-instalación para activar Chaotic-AUR y helpers AUR
└── iso/alphax-profile/          # Perfil completo de Archiso (BIOS Syslinux + UEFI systemd-boot/GRUB)
    ├── airootfs/                # Sistema de archivos raíz de la ISO Live y configuración de Calamares
    ├── local-repo/              # Repositorio local preempaquetado (Calamares)
    ├── packages.x86_64          # Lista depurada de 169 paquetes para la ISO
    ├── pacman.conf              # Configuración de Pacman para la construcción
    └── profiledef.sh            # Definición de imagen y permisos de Archiso
```

---

## 🛠️ Cómo Validar y Compilar la ISO

### 1. Validar configuraciones y scripts (en cualquier distro Linux)
```bash
./scripts/check.sh
```

### 2. Compilar la ISO localmente
El script `./build.sh` detecta automáticamente tu sistema:
- **En Arch Linux:** Ejecuta `mkarchiso` directamente.
- **En Void Linux / Ubuntu / Fedora:** Si tienes `docker` o `podman`, levanta automáticamente un contenedor `archlinux:latest` privilegiado y compila la ISO adentro sin ensuciar tu sistema anfitrión.

```bash
./build.sh
```
La imagen resultante y su hash `.sha256` se guardarán en la carpeta `out/`.

### 3. Compilar en la nube con GitHub Actions
Cada `git push` a la rama `main` (o ejecución manual desde la pestaña **Actions**) dispara el flujo `.github/workflows/build-iso.yml`, el cual valida el código, construye la ISO en los servidores de GitHub y publica el archivo `.iso` listo para descargar en la sección **Artifacts**.

---

## 🖥️ Cómo Probar la ISO en QEMU

```bash
qemu-system-x86_64 \
  -enable-kvm \
  -m 4096 \
  -smp 4 \
  -vga virtio \
  -display sdl,gl=on \
  -cdrom out/alphax-*.iso
```

### Credenciales de la Sesión Live
- **Usuario:** `liveuser` (Autologin automático en `tty1` directo a Codex WM)
- **Contraseña:** `liveuser`
- **Root:** Login directo bloqueado por seguridad (`sudo` habilitado para el grupo `wheel`). During la instalación con Calamares, `liveuser` se elimina y se configura únicamente el usuario creado por ti con contraseña obligatoria para `sudo`.
