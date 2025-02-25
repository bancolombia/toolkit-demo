#!/bin/bash

VAR_NAME_ROOT_REPOSITORY=$(echo $VAR_NAME_REPOSITORY | cut -d'/' -f2)
cd ..
mkdir -p $VAR_NAME_ROOT_REPOSITORY/semantic-release/
cp $OFL "$VAR_LOCAL_PATH/files/semantic-release/create-release-branch.js" "$VAR_NAME_ROOT_REPOSITORY/semantic-release/create-release-branch.js"
cp $OFL "$VAR_LOCAL_PATH/files/semantic-release/release.config.js" "$VAR_NAME_ROOT_REPOSITORY/release.config.js"
cp $OFL "$VAR_LOCAL_PATH/files/semantic-release/release-rules.js" "$VAR_NAME_ROOT_REPOSITORY/semantic-release/release-rules.js"
cp $OFL "$VAR_LOCAL_PATH/files/semantic-release/writerChangelog.js" "$VAR_NAME_ROOT_REPOSITORY/semantic-release/writerChangelog.js"
cp $OFL "$VAR_LOCAL_PATH/files/semantic-release/semantic-release.yml" "$VAR_NAME_ROOT_REPOSITORY/.github/workflows/semantic-release.yml"

echo "Configurando Git..."
git config --global user.email "action@github.com"
git config --global user.name "GitHub Action"

echo "Agregando cambios..."
git add .

echo "Haciendo commit..."
git commit -m "Feat: Agregar archivos de configuración inicial" || echo "No hay cambios para commitear"

# Configurar la URL remota usando el token proporcionado
REMOTE_URL=$(git remote get-url origin)
AUTH_REMOTE_URL=$(echo "$REMOTE_URL" | sed -e "s/https:\/\/github.com/https:\/\/x-access-token:$VAR_TOKEN@github.com/")
git remote set-url origin "$AUTH_REMOTE_URL"

# Determinar la rama de push: si se pasa un input 'branch' se usa ese valor, de lo contrario se extrae de GITHUB_REF
if [ -z "$VAR_BRANCH" ]; then
  branch=${GITHUB_REF#refs/heads/}
else
  branch="$VAR_BRANCH"
fi

echo "Haciendo push a la rama ${branch}..."
git push origin HEAD:"${branch}"
