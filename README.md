# Init Config Files Action

Esta GitHub Action crea, si no existen, los siguientes archivos de configuración inicial en el repositorio:

- `README.md`
- `LICENSE.md`
- `GETTINGSTARTED.md`
- `CONTRIBUTING.md`
- `COMMIT_RULES.md`
- `CODE_OF_CONDUCT.md`
- `.gitignore`

## Cómo usarla

Agrega la acción a tu workflow de GitHub Actions. Un ejemplo de workflow sería:

```yaml
name: Toolkit
on: workflow_dispatch
jobs:
  init-config:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout del repositorio
        uses: actions/checkout@v4

      - name: Inicializar archivos de configuración
        uses: tu-usuario/init-config-action@v1.0.0
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          branch: 'rama-ejemplo'
```