const fs = require('fs');
const path = require('path');
const { writerOpts } = require('./semantic-release/writerChangelog.js');

// Definir archivo de versión (puede ser definido como variable de entorno)
const versionFile = process.env.VERSION_FILE || 'version.txt';
const resolvedVersionFile = path.resolve(versionFile);

// Verificar si el archivo de versión existe
if (!fs.existsSync(resolvedVersionFile)) {
    console.warn(`⚠️ Warning: The configured version file (${versionFile}) was not found in the repository.`);
}

module.exports = {
    // Definición de ramas de lanzamiento
    branches: [
        { name: 'stable/+([0-9])?(.{+([0-9]),x}).x', prerelease: false }, // Ramas de versiones estables
        { name: 'trunk', prerelease: false },
        { name: 'master', prerelease: false },
        { name: 'main', prerelease: false },
        'next', // Ramas para versiones futuras
        'next-major', // Ramas para versiones futuras
        { name: 'beta', prerelease: true },  // Versión beta
        { name: 'alpha', prerelease: true }  // Versión alpha
    ],

    plugins: [
        // Analiza los commits y determina el tipo de versión a lanzar
        [
            "@semantic-release/commit-analyzer",
            {
                preset: "angular",
                releaseRules: './semantic-release/release-rules.js'
            }
        ],

        // Genera notas de la versión basadas en los commits
        [
            "@semantic-release/release-notes-generator",
            { writerOpts }
        ],

        // Actualiza el archivo CHANGELOG.md con los cambios de la nueva versión
        [
            "@semantic-release/changelog",
            { changelogFile: "docs/CHANGELOG.md" }
        ],

        // Ejecuta comandos antes de la liberación
        [
            "@semantic-release/exec",
            {
                prepareCmd: `node semantic-release/create-release-branch.js \${branch.name} \${nextRelease.type} \${lastRelease.version} && echo \${nextRelease.version} > ${versionFile}`
            }
        ],

        // Confirma los cambios en Git (CHANGELOG y archivo de versión)
        [
            "@semantic-release/git",
            {
                assets: ["docs/CHANGELOG.md", versionFile],
                message: "chore(release): ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}"
            }
        ],

        // Publica la versión en GitHub
        "@semantic-release/github"
    ]
};
