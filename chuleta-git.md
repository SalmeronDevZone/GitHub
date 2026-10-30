# Chuleta de Git para el día a día

Los comandos que de verdad se usan en un equipo de datos o de plataforma, agrupados por situación. Para practicarlos con escenarios reales: [laboratorios](ejercicios/README.md).

## Configurar (una vez por equipo)

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu@correo.com"
git config --global init.defaultBranch main
git config --global pull.rebase true          # historial más limpio al traer cambios
```

## Empezar

| Quiero... | Comando |
| --- | --- |
| Crear un repositorio | `git init -b main` |
| Copiar uno existente | `git clone <url>` |
| Ver qué ha cambiado | `git status` · `git diff` · `git diff --staged` |
| Preparar y guardar | `git add <fichero>` · `git commit -m "Mensaje en imperativo"` |
| Ver el historial | `git log --oneline --graph --all` |

## Ramas

| Quiero... | Comando |
| --- | --- |
| Crear una rama y cambiar a ella | `git switch -c feature/nombre` |
| Cambiar de rama | `git switch main` |
| Traer los cambios de otra rama | `git merge feature/nombre` (`--no-ff` para dejar constancia) |
| Poner mi rama al día con main | `git rebase main` (sólo en ramas que no comparte nadie) |
| Llevar un único commit a mi rama | `git cherry-pick <hash>` |
| Borrar una rama ya fusionada | `git branch -d feature/nombre` |

## Remotos

| Quiero... | Comando |
| --- | --- |
| Subir mi rama por primera vez | `git push -u origin feature/nombre` |
| Traer cambios | `git pull` |
| Ver qué hay en el remoto sin tocar mi trabajo | `git fetch` y después `git log origin/main` |

## Deshacer (de menos a más peligroso)

| Situación | Comando |
| --- | --- |
| Descartar cambios de un fichero sin commit | `git restore <fichero>` |
| Sacar un fichero del staging | `git restore --staged <fichero>` |
| Corregir el último commit **si aún no lo has subido** | `git commit --amend` |
| Deshacer un commit **ya publicado** | `git revert <hash>` (crea un commit nuevo; nunca reescribe) |
| Volver atrás en local, conservando los cambios | `git reset --soft HEAD~1` |
| ⚠️ Tirar commits y cambios locales | `git reset --hard <hash>` (sin vuelta atrás fácil) |
| Recuperar algo que creías perdido | `git reflog` |

## Aparcar trabajo

```bash
git stash push -u -m "a medias"   # -u incluye ficheros nuevos
git stash list
git stash pop                     # recupera y borra del stash
```

## Versiones

```bash
git tag -a v1.2.0 -m "Release 1.2.0"
git push origin v1.2.0
```

## Investigar

| Quiero saber... | Comando |
| --- | --- |
| Quién cambió cada línea | `git blame <fichero>` |
| Cuándo apareció un texto | `git log -S "texto" --oneline` |
| Qué commit rompió algo | `git bisect start <malo> <bueno>` y `git bisect run ./prueba.sh` |
| Por qué se ignora un fichero | `git check-ignore -v <fichero>` |

## Ficheros que nunca van al repositorio

`.env` y cualquier secreto · datos (`*.csv`, `*.parquet`, `datos/`) · `node_modules/`, `.venv/`, `__pycache__/` · artefactos de compilación (`dist/`, `bin/`, `obj/`) · `*.tfstate` de Terraform.

> Si un secreto llega al repositorio, sácalo con `git rm --cached` **y cámbialo**: sigue en el historial.
