#!/usr/bin/env bash
# Soluciones de referencia de los laboratorios. Inténtalo antes de mirarlas.
# Las aplica sobre el escenario ya preparado:  ./laboratorio.sh 03 && ./soluciones.sh 03 && ./comprobar.sh 03
set -euo pipefail
source "$(dirname "$0")/comun.sh"
N="$(numero "${1:-}")"
cd "$PRACTICA/$N"

# Identidad y editor sólo para este script (en la práctica usarías los tuyos).
export GIT_AUTHOR_NAME="Estudiante" GIT_AUTHOR_EMAIL="estudiante@example.com"
export GIT_COMMITTER_NAME="Estudiante" GIT_COMMITTER_EMAIL="estudiante@example.com"
export GIT_EDITOR=true

case "$N" in
01) # Crear el repositorio con un .gitignore desde el primer commit
    git init -q -b main
    printf 'datos/\n.env\n__pycache__/\n' > .gitignore
    git add .
    git status --short                          # comprueba qué entra ANTES del commit
    git commit -q -m "Primer commit del pipeline"
    ;;
02) # Rama de funcionalidad y merge sin fast-forward
    git switch -c feature/limpieza
    printf 'def limpiar(filas):\n    return [f for f in filas if f]\n' > limpieza.py
    git add limpieza.py
    git commit -q -m "Añade la limpieza de filas vacías"
    git switch main
    git merge --no-ff feature/limpieza -m "Merge de feature/limpieza"
    git branch -d feature/limpieza
    ;;
03) # Resolver un conflicto a mano
    git merge rendimiento || true               # se para con CONFLICT en config.yaml
    printf 'origen: ventas.csv\nlote: 500\nreintentos: 5\n' > config.yaml
    git add config.yaml
    git commit -q --no-edit
    ;;
04) # Deshacer un commit ya publicado: revert, nunca reset
    malo="$(git log --format=%H --grep='^Cambia el umbral$' -n 1)"
    git revert --no-edit "$malo"
    git push -q origin main
    ;;
05) # Poner la rama al día con rebase
    git switch feature/informe
    git rebase main
    ;;
06) # Aparcar el trabajo con stash para atender una urgencia
    git stash push -u -m "modelo a medias"      # -u incluye los ficheros nuevos (notas.txt)
    git switch main
    printf 'ruta: /datos/v2\n' > config.yaml
    git commit -q -am "Corrige la ruta de datos"
    git switch feature/modelo
    git stash pop
    ;;
07) # Etiquetar una versión
    estable="$(git log --format=%H --grep='^Versión estable del pipeline$' -n 1)"
    git tag -a v1.0.0 "$estable" -m "Primera versión estable"
    git show --no-patch v1.0.0
    ;;
08) # Llevar un único commit a otra rama
    git switch main
    git cherry-pick "$(git log develop --format=%H --grep='^Corrige división por cero$' -n 1)"
    ;;
09) # Sacar un secreto del repositorio (y después: ¡cambiar la contraseña!)
    git rm -q --cached .env                     # deja de versionarlo, pero no lo borra del disco
    printf '.env\n' >> .gitignore
    printf 'DB_HOST=\nDB_PASSWORD=\n' > .env.example
    git add .gitignore .env.example
    git commit -q -m "Deja de versionar .env y añade .env.example"
    ;;
10) # Búsqueda binaria del commit que rompió la prueba
    git bisect start main "$(git rev-list --max-parents=0 main)"   # malo: main · bueno: el primero
    git bisect run ./prueba.sh
    git rev-parse refs/bisect/bad > RESULTADO.txt
    git bisect reset
    ;;
esac
