# 🧩 Git y GitHub: manual, laboratorios y chuleta

Todo lo necesario para trabajar con Git en un equipo de datos o de plataforma: un manual de base, **10 laboratorios prácticos con corrección automática**, una chuleta para el día a día y una guía para que Recursos Humanos sepa leer un perfil de GitHub.

[![laboratorios](https://github.com/SalmeronDevZone/GitHub/actions/workflows/laboratorios.yml/badge.svg)](https://github.com/SalmeronDevZone/GitHub/actions/workflows/laboratorios.yml)
![Git](https://img.shields.io/badge/Git-2.28%2B-F05032?logo=git&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-Linux%20%C2%B7%20macOS%20%C2%B7%20Git%20Bash-4EAA25?logo=gnubash&logoColor=white)

## Contenido

| Recurso | Para quién | Qué es |
| --- | --- | --- |
| [**Laboratorios**](ejercicios/README.md) | Quien quiera practicar | 10 escenarios reales con un repositorio ya montado y un corrector: conflictos, `revert`, `rebase`, `stash`, `cherry-pick`, secretos subidos por error, `bisect`... |
| [**Chuleta**](chuleta-git.md) | Uso diario | Los comandos que se usan de verdad, agrupados por situación, incluido cómo deshacer cada cosa |
| [**Manual básico**](git.pdf) | Quien empieza | Conceptos esenciales: commits, ramas, merge y buenas prácticas |
| [**Guía para RR. HH.**](forHumanResources.md) | Recursos Humanos | Cómo revisar el GitHub de un candidato sin conocimientos técnicos (inglés y español) |

## Los laboratorios en 30 segundos

```bash
git clone https://github.com/SalmeronDevZone/GitHub.git
cd GitHub/ejercicios
./laboratorio.sh 03               # monta el escenario: un conflicto de merge
cd ~/laboratorios-git/03          # resuélvelo con Git
cd -
./comprobar.sh 03                 # ✅ / ❌ en cada punto
```

| | Laboratorios |
| --- | --- |
| 🟢 | Primer repositorio sin secretos ni datos · Rama y merge · Etiquetar una versión |
| 🟡 | Resolver un conflicto · Revert de un commit publicado · Rebase · Stash ante una urgencia · Cherry-pick · Sacar un secreto del repositorio |
| 🔴 | Encontrar con `git bisect` el commit que rompió la prueba |

La CI de GitHub Actions comprueba en cada push que cada laboratorio **falla** sin resolver y **pasa** con su solución de referencia.

## Recursos externos

- [Pro Git](https://git-scm.com/book/es/v2), el libro oficial (en español).
- [Video sobre control de versiones](https://www.youtube.com/watch?v=OZSYz-tvr50).

---

**Jesús Salmerón** · Data Engineer · [GitHub](https://github.com/SalmeronDevZone) · [LinkedIn](https://www.linkedin.com/in/jesussalmeronarmario/)
