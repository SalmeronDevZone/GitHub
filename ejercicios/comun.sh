# Funciones compartidas por los scripts de los laboratorios (se carga con "source").

AQUI="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Fuera de este repositorio: así un comando de práctica nunca toca el repositorio de verdad.
PRACTICA="${LABORATORIOS_GIT:-$HOME/laboratorios-git}"

numero() {
    if [[ ! "${1:-}" =~ ^[0-9]+$ ]] || ((10#$1 < 1 || 10#$1 > 10)); then
        echo "Indica el número de laboratorio, del 01 al 10. Ejemplo: $(basename "$0") 03" >&2
        exit 2
    fi
    printf "%02d" "$((10#$1))"
}

# Repositorio de práctica. Sin conversión de saltos de línea: así se comporta igual en Windows.
repo_nuevo() {
    git init -q -b main
    git config core.autocrlf false
}

# Los commits del escenario los firma "Laboratorio"; los tuyos, tu identidad de Git.
guardar() {
    git add -A
    git -c user.name="Laboratorio" -c user.email="laboratorio@example.com" commit -q -m "$1"
}
