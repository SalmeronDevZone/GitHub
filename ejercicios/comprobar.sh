#!/usr/bin/env bash
# Comprueba si has resuelto un laboratorio.
#   ./comprobar.sh 03
set -uo pipefail
source "$(dirname "$0")/comun.sh"
N="$(numero "${1:-}")"
DIR="$PRACTICA/$N"
[ -d "$DIR" ] || { echo "Primero prepara el laboratorio: ./laboratorio.sh $N"; exit 2; }
cd "$DIR"

FALLOS=0
comprobar() {
    local descripcion="$1"
    shift
    if "$@" > /dev/null 2>&1; then
        echo "  ✅ $descripcion"
    else
        echo "  ❌ $descripcion"
        FALLOS=$((FALLOS + 1))
    fi
}
rama_actual() { git rev-parse --abbrev-ref HEAD 2> /dev/null; }
en_rama() { [ "$(rama_actual)" = "$1" ]; }
versionado() { git ls-files --error-unmatch -- "$1"; }
no_versionado() { ! git ls-files --error-unmatch -- "$1"; }
contenido() { [ "$(git show "$1" 2> /dev/null)" = "$2" ]; }
asunto() { git log -1 --format=%s "${1:-HEAD}"; }
es_merge() { [ "$(git rev-list --parents -n 1 "${1:-HEAD}" | wc -w)" -eq 3 ]; }
arbol_limpio() { [ -z "$(git status --porcelain)" ]; }
hash_de() { git log --all --format=%H --grep="^$1\$" -n 1; }

echo "Laboratorio $N"
case "$N" in
01)
    comprobar "Es un repositorio de Git" bash -c '[ "$(git rev-parse --git-dir 2> /dev/null)" = ".git" ]'
    comprobar "Está en la rama main" en_rama main
    comprobar "Hay al menos un commit" git rev-parse --verify HEAD
    comprobar "pipeline.py y README.md están versionados" bash -c 'git ls-files --error-unmatch pipeline.py README.md'
    comprobar ".gitignore está versionado" versionado .gitignore
    comprobar ".env NO está versionado (es un secreto)" no_versionado .env
    comprobar "datos/ NO está versionado (los datos no van a Git)" bash -c '[ -z "$(git ls-files datos)" ]'
    comprobar "__pycache__/ NO está versionado" bash -c '[ -z "$(git ls-files __pycache__)" ]'
    comprobar "No queda nada sin guardar ni sin ignorar" arbol_limpio
    ;;
02)
    comprobar "Estás en main" en_rama main
    comprobar "limpieza.py ha llegado a main" versionado limpieza.py
    comprobar "El último commit de main es un merge (--no-ff)" es_merge
    comprobar "La rama feature/limpieza se ha borrado" bash -c '! git rev-parse --verify --quiet refs/heads/feature/limpieza'
    comprobar "No hay cambios sin guardar" arbol_limpio
    ;;
03)
    comprobar "Estás en main" en_rama main
    comprobar "El último commit es el merge de rendimiento" bash -c '[ "$(git rev-list --parents -n1 HEAD | wc -w)" -eq 3 ] && git merge-base --is-ancestor rendimiento HEAD'
    comprobar "No quedan marcas de conflicto (<<<<<<<)" bash -c '! grep -qE "^(<<<<<<<|=======|>>>>>>>)" config.yaml'
    comprobar "config.yaml combina lo mejor de las dos ramas: lote 500 y 5 reintentos" contenido HEAD:config.yaml "$(printf 'origen: ventas.csv\nlote: 500\nreintentos: 5')"
    comprobar "No hay un merge a medias" bash -c '! git rev-parse --verify --quiet MERGE_HEAD'
    ;;
04)
    comprobar "El umbral vuelve a ser 0.05" contenido HEAD:pipeline.py "UMBRAL = 0.05"
    comprobar "Los commits posteriores siguen ahí (informe.py y README.md)" bash -c 'git ls-files --error-unmatch informe.py README.md'
    comprobar "El commit erróneo sigue en el historial (no se reescribe lo publicado)" bash -c 'git log --format=%s | grep -qx "Cambia el umbral"'
    comprobar "Lo publicado en origin/main no se ha reescrito" git merge-base --is-ancestor origin/main HEAD
    comprobar "El último commit es un revert del cambio de umbral" bash -c 'git log -1 --format=%s | grep -q "^Revert \"Cambia el umbral\""'
    ;;
05)
    comprobar "Estás en feature/informe" en_rama feature/informe
    comprobar "feature/informe parte de la última versión de main" git merge-base --is-ancestor main HEAD
    comprobar "El historial es lineal (sin commits de merge)" bash -c '[ -z "$(git rev-list --merges main..HEAD)" ]'
    comprobar "Conserva tus 2 commits encima de main" bash -c '[ "$(git rev-list --count main..HEAD)" -eq 2 ]'
    comprobar "El informe está completo" contenido HEAD:informe.py "$(printf 'def informe():\n    return "ok"')"
    ;;
06)
    comprobar "La corrección está en main: ruta /datos/v2" contenido main:config.yaml "ruta: /datos/v2"
    comprobar "El commit de la corrección habla de la ruta" bash -c 'git log -1 --format=%s main | grep -qi "ruta"'
    comprobar "Has vuelto a feature/modelo" en_rama feature/modelo
    comprobar "Tu trabajo a medias sigue sin commit en modelo.py" bash -c 'grep -q "trabajo a medias" modelo.py && ! git diff --quiet -- modelo.py'
    comprobar "notas.txt sigue ahí, sin versionar" bash -c '[ -f notas.txt ] && ! git ls-files --error-unmatch notas.txt'
    comprobar "No has hecho commit del trabajo a medias" bash -c '[ "$(git log -1 --format=%s)" = "Primer modelo" ]'
    comprobar "El stash ha quedado vacío" bash -c '[ -z "$(git stash list)" ]'
    ;;
07)
    comprobar "Existe la etiqueta v1.0.0" git rev-parse --verify --quiet refs/tags/v1.0.0
    comprobar "Es una etiqueta anotada (no ligera)" bash -c '[ "$(git cat-file -t v1.0.0)" = "tag" ]'
    comprobar "Apunta al commit «Versión estable del pipeline»" bash -c '[ "$(git rev-parse "v1.0.0^{commit}")" = "$(git log --format=%H --grep="^Versión estable del pipeline$" -n1)" ]'
    comprobar "Su mensaje es «Primera versión estable»" bash -c 'git tag -l --format="%(contents)" v1.0.0 | grep -q "Primera versión estable"'
    ;;
08)
    comprobar "Estás en main" en_rama main
    comprobar "main tiene la corrección de la división por cero" bash -c 'git show HEAD:calculos.py | grep -q "if b else 0"'
    comprobar "main NO tiene lo experimental" bash -c '! git ls-files --error-unmatch experimental.py'
    comprobar "main tiene sólo un commit nuevo" bash -c '[ "$(git rev-list --count HEAD)" -eq 2 ]'
    comprobar "Ese commit es la corrección" bash -c '[ "$(git log -1 --format=%s)" = "Corrige división por cero" ]'
    ;;
09)
    comprobar ".env sigue en tu disco" test -f .env
    comprobar ".env ya NO está versionado" no_versionado .env
    comprobar "Git ignora .env" git check-ignore -q .env
    comprobar ".env.example está versionado" versionado .env.example
    comprobar ".env.example tiene las claves sin valores" bash -c 'grep -qx "DB_HOST=" .env.example && grep -qx "DB_PASSWORD=" .env.example'
    comprobar ".env.example no contiene la contraseña" bash -c '! grep -q "Sup3rS3creta" .env.example'
    comprobar "Todo guardado" arbol_limpio
    ;;
10)
    culpable=""
    for c in $(git rev-list --reverse main 2> /dev/null); do
        if ! git show "$c:config.ini" | grep -q '^redondeo=2$'; then culpable="$c"; break; fi
    done
    respuesta="$(tr -d '[:space:]' < RESULTADO.txt 2> /dev/null || true)"
    comprobar "RESULTADO.txt contiene un hash (7 caracteres o más)" bash -c "[[ '$respuesta' =~ ^[0-9a-f]{7,40}\$ ]]"
    comprobar "Es el commit que rompió la prueba" bash -c "[ -n '$respuesta' ] && [[ '$culpable' == '$respuesta'* ]]"
    comprobar "Has terminado la búsqueda (git bisect reset)" bash -c '! git bisect log'
    comprobar "Has vuelto a main" en_rama main
    ;;
esac

if [ "$FALLOS" -eq 0 ]; then
    echo "🎉 Laboratorio $N superado"
else
    echo "Te faltan $FALLOS comprobaciones. Si te atascas, mira la pista en ejercicios/README.md"
    exit 1
fi
