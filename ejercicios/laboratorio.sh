#!/usr/bin/env bash
# Prepara el escenario de un laboratorio en ~/laboratorios-git/NN (si ya existía, empieza de cero).
#   ./laboratorio.sh 03
set -euo pipefail
source "$(dirname "$0")/comun.sh"
N="$(numero "${1:-}")"
DIR="$PRACTICA/$N"
rm -rf "$DIR" "$DIR-remoto.git"
mkdir -p "$DIR"
cd "$DIR"

case "$N" in
01)
    mkdir -p datos __pycache__
    cat > pipeline.py <<'EOF'
import csv


def cargar(ruta):
    with open(ruta, newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))
EOF
    printf '# Pipeline de ventas\n' > README.md
    printf 'id,importe\n1,10\n2,20\n' > datos/ventas_2025.csv
    printf 'DB_PASSWORD=no-lo-subas\n' > .env
    printf 'bytecode' > __pycache__/pipeline.cpython-312.pyc
    ;;
02)
    repo_nuevo
    printf 'def cargar():\n    pass\n' > pipeline.py
    guardar "Pipeline inicial"
    printf '# Pipeline\n' > README.md
    guardar "Añade README"
    ;;
03)
    repo_nuevo
    printf 'origen: ventas.csv\nlote: 100\nreintentos: 3\n' > config.yaml
    guardar "Configuración inicial"
    git switch -q -c rendimiento
    printf 'origen: ventas.csv\nlote: 500\nreintentos: 3\n' > config.yaml
    guardar "Sube el tamaño de lote"
    git switch -q main
    printf 'origen: ventas.csv\nlote: 200\nreintentos: 5\n' > config.yaml
    guardar "Ajusta lote y reintentos"
    ;;
04)
    repo_nuevo
    printf 'UMBRAL = 0.05\n' > pipeline.py
    guardar "Pipeline con umbral de calidad"
    printf 'def informe():\n    pass\n' > informe.py
    guardar "Añade informe"
    printf 'UMBRAL = 5\n' > pipeline.py
    guardar "Cambia el umbral"
    printf '# Pipeline\n' > README.md
    guardar "Añade README"
    # Un "servidor" local: lo que ya está en origin/main lo tiene todo el equipo.
    git init -q --bare -b main "$DIR-remoto.git"
    git remote add origin "$DIR-remoto.git"
    git push -q -u origin main
    ;;
05)
    repo_nuevo
    printf 'def cargar():\n    pass\n' > pipeline.py
    guardar "Pipeline inicial"
    git switch -q -c feature/informe
    printf 'def informe():\n    pass\n' > informe.py
    guardar "Añade informe"
    printf 'def informe():\n    return "ok"\n' > informe.py
    guardar "Completa el informe"
    git switch -q main
    printf '# Pipeline\n' > README.md
    guardar "Añade README"
    printf 'lote: 100\n' > config.yaml
    guardar "Añade configuración"
    git switch -q feature/informe
    ;;
06)
    repo_nuevo
    printf 'ruta: /datos/v1\n' > config.yaml
    printf 'def entrenar():\n    pass\n' > modelo.py
    guardar "Versión inicial"
    git switch -q -c feature/modelo
    printf 'def entrenar():\n    return "modelo"\n' > modelo.py
    guardar "Primer modelo"
    printf 'def entrenar():\n    return "modelo mejorado"  # trabajo a medias\n' > modelo.py
    printf 'ideas sin terminar\n' > notas.txt
    ;;
07)
    repo_nuevo
    printf 'v=1\n' > version.txt
    guardar "Pipeline inicial"
    printf 'v=2\n' > version.txt
    guardar "Añade validaciones"
    printf 'v=3\n' > version.txt
    guardar "Versión estable del pipeline"
    printf 'v=4\n' > version.txt
    guardar "Experimento sin terminar"
    ;;
08)
    repo_nuevo
    printf 'def dividir(a, b):\n    return a / b\n' > calculos.py
    guardar "Cálculos iniciales"
    git switch -q -c develop
    printf 'EXPERIMENTO = True\n' > experimental.py
    guardar "Funcionalidad experimental"
    printf 'def dividir(a, b):\n    return a / b if b else 0\n' > calculos.py
    guardar "Corrige división por cero"
    printf 'EXPERIMENTO = "v2"\n' > experimental.py
    guardar "Más experimentos"
    git switch -q main
    ;;
09)
    repo_nuevo
    printf 'import os\n\nPASSWORD = os.environ["DB_PASSWORD"]\n' > app.py
    printf 'DB_HOST=localhost\nDB_PASSWORD=Sup3rS3creta!\n' > .env
    guardar "Primera versión"
    ;;
10)
    repo_nuevo
    cat > prueba.sh <<'EOF'
#!/usr/bin/env bash
# Prueba del pipeline: los importes deben redondearse a 2 decimales.
grep -q '^redondeo=2$' config.ini
EOF
    chmod +x prueba.sh
    printf 'redondeo=2\nlote=100\n' > config.ini
    guardar "Configuración inicial"
    redondeo=2
    for i in $(seq 1 11); do
        # En uno de estos ajustes "inocentes" se cuela el fallo.
        if [ "$i" -eq 7 ]; then redondeo=0; fi
        printf 'redondeo=%s\nlote=%s\n' "$redondeo" "$((100 + i * 10))" > config.ini
        guardar "Ajuste de configuración $i"
    done
    ;;
esac

echo "Laboratorio $N preparado. Entra con:  cd \"$DIR\""
echo "Enunciado: ejercicios/README.md · Cuando acabes, desde ejercicios/:  ./comprobar.sh $N"
