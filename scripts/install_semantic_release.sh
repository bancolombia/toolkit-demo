#!/bin/bash
set -e

# Cambiar al directorio del repositorio clonado
cd "$GITHUB_WORKSPACE"

DEFAULT_BRANCH="main"
BRANCH_NAME="${VAR_BRANCH:-feature/test-semantic}"

# Obtener el último commit de la rama principal
COMMIT_SHA=$(git rev-parse origin/$DEFAULT_BRANCH)

# Verificar si la rama ya existe en el remoto
if git ls-remote --exit-code --heads origin "$BRANCH_NAME" > /dev/null; then
  echo "La rama '$BRANCH_NAME' ya existe en remoto. Cambiando a la rama y actualizando..."
  git switch "$BRANCH_NAME"
  git pull --rebase origin "$BRANCH_NAME"
else
  echo "Creando la rama '$BRANCH_NAME' a partir de '$DEFAULT_BRANCH' (commit $COMMIT_SHA)..."
  git checkout "$COMMIT_SHA"
  git switch --create "$BRANCH_NAME"
fi

# Sincronizar los archivos de workflows para evitar el error de permisos
echo "Sincronizando archivos de workflows desde origin/$DEFAULT_BRANCH..."
git checkout origin/$DEFAULT_BRANCH -- .github/workflows

# Copiar los archivos de configuración de semantic-release que necesitas subir
echo "Copiando archivos de semantic-release..."
mkdir -p "./semantic-release"
cp "$GITHUB_ACTION_PATH/files/semantic-release/create-release-branch.js" "./semantic-release/create-release-branch.js"
cp "$GITHUB_ACTION_PATH/files/semantic-release/release.config.js" "./release.config.js"
cp "$GITHUB_ACTION_PATH/files/semantic-release/release-rules.js" "./semantic-release/release-rules.js"
cp "$GITHUB_ACTION_PATH/files/semantic-release/writerChangelog.js" "./semantic-release/writerChangelog.js"
cp "$GITHUB_ACTION_PATH/files/semantic-release/semantic-release.yml" "./.github/workflows/semantic-release.yml"

# Agregar y commitear los cambios
echo "Agregando cambios..."
git add .
echo "Realizando commit..."
git commit -m "chore: Agregar archivos de semantic-release y sincronizar workflows" || echo "No hay cambios para commitear"

# Hacer push de la rama actualizada
echo "Haciendo push a la rama '$BRANCH_NAME'..."
git push origin "$BRANCH_NAME"
