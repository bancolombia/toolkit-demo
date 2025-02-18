#!/bin/bash

echo "Iniciando la creación de archivos de configuración..."

# Lista de archivos y su contenido inicial
declare -A archivos=(
  ["README.md"]="# Proyecto"$'\n'"Este archivo fue creado automáticamente."
  ["LICENSE.md"]="Licencia: MIT"
  ["GETTINGSTARTED.md"]="# Guía de inicio"
  ["CONTRIBUTING.md"]="# Cómo contribuir"
  ["COMMIT_RULES.md"]="# Reglas de commit"
  ["CODE_OF_CONDUCT.md"]="# Código de conducta"
  [".gitignore"]="node_modules/"
)

# Iterar sobre los archivos con un while
while IFS= read -r archivo; do
  if [ ! -f "$archivo" ]; then
    echo -e "${archivos[$archivo]}" > "$archivo"
    echo "Archivo $archivo creado."
  else
    echo "$archivo ya existe."
  fi
done < <(printf "%s\n" "${!archivos[@]}")

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