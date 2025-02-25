#!/bin/bash
set -e

# Cambiar al directorio del repositorio
if [ -z "$GITHUB_WORKSPACE" ]; then
  echo "La variable GITHUB_WORKSPACE no está definida. Asegúrate de ejecutar actions/checkout."
  exit 1
fi

cd "$GITHUB_WORKSPACE"

# Determinar la rama a usar. Si VAR_BRANCH no está definida, se extrae de GITHUB_REF.
BRANCH="${VAR_BRANCH:-${GITHUB_REF#refs/heads/}}"

# Actualizar la rama local con los cambios remotos
echo "Actualizando la rama ${BRANCH}..."
git pull origin "${BRANCH}" || echo "No se pudo actualizar, continúo..."

# Copiar los archivos de configuración de semantic release a las ubicaciones deseadas.
# Ajusta las rutas según la estructura de tu repositorio.
echo "Copiando archivos de configuración..."
# Ejemplo: Crea el directorio de destino si no existe
mkdir -p "./semantic-release"
cp "$GITHUB_ACTION_PATH/files/semantic-release/create-release-branch.js" "./semantic-release/create-release-branch.js"
cp "$GITHUB_ACTION_PATH/files/semantic-release/release.config.js" "./release.config.js"
cp "$GITHUB_ACTION_PATH/files/semantic-release/release-rules.js" "./semantic-release/release-rules.js"
cp "$GITHUB_ACTION_PATH/files/semantic-release/writerChangelog.js" "./semantic-release/writerChangelog.js"
mkdir -p "./.github/workflows"
cp "$GITHUB_ACTION_PATH/files/semantic-release/semantic-release.yml" "./.github/workflows/semantic-release.yml"

# Configurar Git
echo "Configurando Git..."
git config --global user.email "action@github.com"
git config --global user.name "GitHub Action"

# Agregar y commitear los cambios
echo "Agregando cambios..."
git add .
echo "Realizando commit..."
git commit -m "Feat: Agregar configuración de semantic release" || echo "No hay cambios para commitear"

# Configurar la URL remota usando el token para autenticación
REMOTE_URL=$(git remote get-url origin)
AUTH_REMOTE_URL=$(echo "$REMOTE_URL" | sed -e "s/https:\/\/github.com/https:\/\/x-access-token:${VAR_TOKEN}@github.com/")
git remote set-url origin "$AUTH_REMOTE_URL"

# Hacer push a la rama correspondiente
echo "Haciendo push a la rama ${BRANCH}..."
git push origin HEAD:"${BRANCH}"
