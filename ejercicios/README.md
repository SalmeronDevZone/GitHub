# Laboratorios de Git

Diez situaciones reales de un equipo de datos, del primer commit a encontrar con `git bisect` el cambio que rompió la producción. Cada laboratorio crea un repositorio de práctica con el escenario ya montado y se corrige solo.

```bash
cd ejercicios
./laboratorio.sh 01               # prepara el escenario en ~/laboratorios-git/01
cd ~/laboratorios-git/01          # ... resuelve el reto con Git ...
cd -
./comprobar.sh 01                 # ✅ / ❌ en cada punto
```

Los repositorios de práctica se crean **fuera** de este repositorio (en `~/laboratorios-git/`), así ningún comando de práctica puede tocar el repositorio de verdad.

Funciona en Linux, macOS y Windows (con **Git Bash**). Necesitas Git 2.28 o superior y tener configurada tu identidad (`git config --global user.name` y `user.email`). Si te lías, `./laboratorio.sh 01` vuelve a empezar de cero.

| # | Laboratorio | Nivel | Comandos clave |
| --- | --- | --- | --- |
| 01 | Primer repositorio, sin secretos ni datos | 🟢 | `init`, `.gitignore`, `add`, `commit` |
| 02 | Rama de funcionalidad y merge | 🟢 | `switch -c`, `merge --no-ff`, `branch -d` |
| 03 | Resolver un conflicto | 🟡 | `merge`, edición manual, `add`, `commit` |
| 04 | Deshacer un commit ya publicado | 🟡 | `revert` (y por qué no `reset`) |
| 05 | Poner tu rama al día | 🟡 | `rebase` |
| 06 | Una urgencia con trabajo a medias | 🟡 | `stash -u`, `stash pop` |
| 07 | Etiquetar una versión | 🟢 | `tag -a` |
| 08 | Llevar sólo una corrección a main | 🟡 | `cherry-pick` |
| 09 | Un secreto en el repositorio | 🟡 | `rm --cached`, `.env.example` |
| 10 | ¿Qué commit rompió la prueba? | 🔴 | `bisect run` |

---

### 01 · Primer repositorio, sin secretos ni datos 🟢

La carpeta tiene un pipeline, un README, un CSV de datos, un `.env` con una contraseña y la caché de Python. Convierte la carpeta en un repositorio (rama `main`) y haz un primer commit con el código y el README, pero **sin** `datos/`, `.env` ni `__pycache__/`. Al terminar no debe quedar nada pendiente en `git status`.

<details><summary>Pista</summary>

Crea el `.gitignore` **antes** del primer `git add`. Con `git status` verás qué va a entrar antes de hacer el commit.
</details>

### 02 · Rama de funcionalidad y merge 🟢

Crea la rama `feature/limpieza`, añade un fichero `limpieza.py` con un commit y fusiónala en `main` **creando un commit de merge** aunque se pudiera avanzar sin él. Después borra la rama.

<details><summary>Pista</summary>

`git merge --no-ff` deja constancia en el historial de que esos cambios llegaron juntos desde una rama.
</details>

### 03 · Resolver un conflicto 🟡

`main` cambió el lote a 200 y los reintentos a 5; la rama `rendimiento` subió el lote a 500. Fusiona `rendimiento` en `main` quedándote con **lote 500 y 5 reintentos**.

<details><summary>Pista</summary>

Tras el `merge`, abre `config.yaml`, deja el contenido final sin las marcas `<<<<<<<`, `=======` y `>>>>>>>`, y termina con `git add` y `git commit`.
</details>

### 04 · Deshacer un commit ya publicado 🟡

Alguien subió «Cambia el umbral» y puso el umbral de calidad a 5 en lugar de 0.05. Ese commit ya está en `origin/main`, así que el equipo lo tiene. Deshaz el cambio **sin reescribir la historia publicada** y conservando los commits posteriores.

<details><summary>Pista</summary>

`git reset` reescribe la historia y rompería el repositorio de tus compañeros. `git revert <commit>` crea un commit nuevo que hace lo contrario.
</details>

### 05 · Poner tu rama al día 🟡

Mientras trabajabas en `feature/informe`, `main` avanzó dos commits. Pon tu rama encima de la última versión de `main` **con un historial lineal**, sin commits de merge.

<details><summary>Pista</summary>

Desde tu rama, `git rebase main`. Hazlo sólo con ramas que no comparte nadie más.
</details>

### 06 · Una urgencia con trabajo a medias 🟡

Estás en `feature/modelo` con cambios sin terminar en `modelo.py` y un `notas.txt` nuevo. Hay que corregir ya en `main` la ruta de datos (`ruta: /datos/v2` en `config.yaml`) con un commit que mencione «ruta». Después vuelve a tu rama y recupera tu trabajo **sin haber hecho commit de lo que estaba a medias**.

<details><summary>Pista</summary>

`git stash push -u` guarda también los ficheros nuevos. Después, `git stash pop`.
</details>

### 07 · Etiquetar una versión 🟢

Crea la etiqueta **anotada** `v1.0.0` con el mensaje «Primera versión estable» en el commit «Versión estable del pipeline». Ojo: no es el último commit.

<details><summary>Pista</summary>

`git tag -a v1.0.0 <commit> -m "..."`. Para encontrar el commit: `git log --oneline`.
</details>

### 08 · Llevar sólo una corrección a main 🟡

En `develop` hay tres commits, pero a `main` sólo debe llegar «Corrige división por cero». Lo experimental no.

<details><summary>Pista</summary>

Desde `main`: `git cherry-pick <hash>`. Puedes ver los commits de la otra rama con `git log develop --oneline`.
</details>

### 09 · Un secreto en el repositorio 🟡

Alguien subió `.env` con la contraseña de la base de datos. Deja de versionarlo **sin borrarlo de tu disco**, haz que Git lo ignore y sube un `.env.example` con las mismas claves pero sin valores (`DB_HOST=` y `DB_PASSWORD=`).

<details><summary>Pista</summary>

`git rm --cached .env`. Y en la vida real, además, **cambia la contraseña**: sigue en el historial y cualquiera con acceso al repositorio la puede ver.
</details>

### 10 · ¿Qué commit rompió la prueba? 🔴

`./prueba.sh` pasaba en el primer commit y falla en el último, y entre medias hay once «ajustes de configuración». Encuentra el commit culpable con `git bisect`, escribe su hash en `RESULTADO.txt` y deja el repositorio otra vez en `main`.

<details><summary>Pista</summary>

`git bisect start <malo> <bueno>`, después `git bisect run ./prueba.sh`, y al terminar `git bisect reset`. Git lo encuentra en unos 4 pasos en lugar de 11.
</details>

---

Las soluciones están en [`soluciones.sh`](soluciones.sh). Para ver que todo funciona: `./verificar_todo.sh`, que es lo que ejecuta la CI en cada push.
