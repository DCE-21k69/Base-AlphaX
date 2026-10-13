#!/usr/bin/env bash
# ═══════════════════════════════════════════════════
# AlphaX Linux — Script Reproducible de Construcción de ISO
# Soporta ejecución nativa en Arch Linux o vía Contenedor desde Void/otras distros
# ═══════════════════════════════════════════════════
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

 PROFILE_DIR="$REPO_ROOT/iso/alphax-profile"
WORK_DIR="$REPO_ROOT/work"
OUT_DIR="$REPO_ROOT/out"

# 1. Ejecutar validaciones previas y sincronizar codex-wm
bash "$REPO_ROOT/scripts/check.sh"

# 2. Enlazar el repositorio local en /tmp/alphax-local-repo (usado por pacman.conf)
ln -sfn "$PROFILE_DIR/local-repo" /tmp/alphax-local-repo

# 3. Si mkarchiso está instalado nativamente (Arch Linux / contenedor Arch)
if command -v mkarchiso >/dev/null 2>&1; then
    echo "==> Construyendo ISO AlphaX Linux con mkarchiso nativo..."
    sudo rm -rf "$WORK_DIR"
    mkdir -p "$OUT_DIR"
    sudo mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" "$PROFILE_DIR"
    sudo chown -R "$(id -u):$(id -g)" "$OUT_DIR" 2>/dev/null || true

    echo "==> Generando sumas SHA256..."
    (
        cd "$OUT_DIR"
        for iso in *.iso; do
            [ -f "$iso" ] || continue
            sha256sum "$iso" > "${iso}.sha256"
            echo "  ✓ ISO generada: $OUT_DIR/$iso"
            echo "  ✓ SHA256:       $(cat "${iso}.sha256")"
        done
    )
    exit 0
fi

# 4. Si estamos en Void Linux u otra distro sin mkarchiso, usar Docker o Podman
CONTAINER_ENGINE=""
if command -v docker >/dev/null 2>&1; then
    CONTAINER_ENGINE="docker"
elif command -v podman >/dev/null 2>&1; then
    CONTAINER_ENGINE="podman"
fi

if [ -n "$CONTAINER_ENGINE" ]; then
    echo "==> No se detectó mkarchiso nativo (estás fuera de Arch Linux)."
    echo "==> Usando contenedor oficial archlinux:latest vía $CONTAINER_ENGINE..."
    mkdir -p "$OUT_DIR"
    sudo "$CONTAINER_ENGINE" run --rm --privileged \
        -v "$REPO_ROOT:/workspace" \
        -w /workspace \
        archlinux:latest \
        bash -c "pacman -Syu --noconfirm archiso git && ./build.sh"
    exit 0
fi

echo "✗ Error: No tienes 'mkarchiso' ni 'docker'/'podman' instalados localmente."
echo "  Opciones:"
echo "  1. Sube tus cambios a GitHub (git push) y descarga la ISO compilada desde GitHub Actions."
echo "  2. En Void Linux, instala docker (sudo xbps-install -S docker) y vuelve a ejecutar ./build.sh."
exit 1
