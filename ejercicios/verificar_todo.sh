#!/usr/bin/env bash
# Verifica los 10 laboratorios (lo usa la CI): el escenario recién preparado NO debe pasar
# las comprobaciones, y después de aplicar la solución de referencia SÍ.
set -uo pipefail
cd "$(dirname "$0")"
# Una carpeta temporal propia, para no tocar los laboratorios que tengas a medias.
export LABORATORIOS_GIT="$(mktemp -d)"
fallos=0
for n in 01 02 03 04 05 06 07 08 09 10; do
    ./laboratorio.sh "$n" > /dev/null
    if ./comprobar.sh "$n" > /dev/null 2>&1; then
        echo "❌ $n: el escenario sin resolver ya pasa las comprobaciones"
        fallos=$((fallos + 1))
        continue
    fi
    if ! ./soluciones.sh "$n" > /dev/null 2>&1; then
        echo "❌ $n: la solución de referencia falla"
        fallos=$((fallos + 1))
        continue
    fi
    if ./comprobar.sh "$n" > /dev/null; then
        echo "✅ $n"
    else
        echo "❌ $n: la solución no supera las comprobaciones"
        ./comprobar.sh "$n"
        fallos=$((fallos + 1))
    fi
done
rm -rf "$LABORATORIOS_GIT"
exit "$fallos"
