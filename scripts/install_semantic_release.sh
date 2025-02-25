#!/bin/bash
set -e

# Cambiar al directorio del repositorio clonado
cd "$GITHUB_WORKSPACE"

# Define la rama por defecto y la rama destino
DEFAULT_BRANCH="main"
BRANCH_NAME="${VAR_BRANCH:-feature/test-semantic}"

# Obtén el último commit de la rama principal
COMMIT_SHA=$(git rev-parse origin/$DEFAULT_BRANCH)

echo "Creando la rama ${BRANCH_NAME} a partir de ${DEFAULT_BRANCH} (commit ${COMMIT_SHA})..."
git checkout "$COMMIT_SHA"
git switch --create "$BRANCH_NAME"

# Sincroniza la carpeta de workflows con la de la rama principal para evitar problemas de permisos
echo "Sincronizando archivos de workflows desde origin/${DEFAULT_BRANCH}..."
git checkout origin/$DEFAULT_BRANCH -- .github/workflows

# Copia los archivos de configuración de semantic-release que deseas subir.
echo "Copiando archivos de configuración de semantic-release..."
# Crea el directorio de destino para los archivos (ajusta según tu estructura)
mkdir -p "./semantic-release"
cp "$GITHUB_ACTION_PATH/files/semantic-release/create-release-branch.js" "./semantic-release/create-release-branch.js"
cp "$GITHUB_ACTION_PATH/files/semantic-release/release.config.js" "./release.config.js"
cp "$GITHUB_ACTION_PATH/files/semantic-release/release-rules.js" "./semantic-release/release-rules.js"
cp "$GITHUB_ACTION_PATH/files/semantic-release/writerChangelog.js" "./semantic-release/writerChangelog.js"
# Para el workflow, lo copiamos en .github/workflows
cp "$GITHUB_ACTION_PATH/files/semantic-release/semantic-release.yml" "./.github/workflows/semantic-release.yml"

# Agrega y comitea los cambios
echo "Agregando y commiteando cambios..."
git add .
git commit -m "chore: Agregar archivos de semantic-release y sincronizar workflows" || echo "No hay cambios para commitear"

# Push de la rama actualizada
echo "Haciendo push a la rama ${BRANCH_NAME}..."
git push origin "$BRANCH_NAME"
