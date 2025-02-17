const { execSync } = require('child_process');

const [currentBranch, releaseType, currentVersion] = process.argv.slice(2);
const releasesBranches = ["main", "master", "trunk"];
const LTS_SUPPORT = 'major'; // Define el nivel de soporte LTS: 'major' o 'minor'

console.log(`Vars: currentVersion=${currentVersion}, currentBranch=${currentBranch}, releaseType=${releaseType}`);

// Validar los argumentos
if (!currentVersion || !currentBranch || !releaseType) {
    console.error("Error: Se requieren los parámetros <currentBranch> <releaseType> <currentVersion>.");
    process.exit(1);
}

// Extraer los números de versión major y minor
const [major, minor] = currentVersion.split('.');
if (!major || isNaN(major)) {
    console.error("Error: El formato de la versión es inválido.");
    process.exit(1);
}

let newBranchName = null;

if (releasesBranches.includes(currentBranch)) {
    if (LTS_SUPPORT === 'minor' && (releaseType === 'major' || releaseType === 'minor')) {
        newBranchName = `stable/${major}.${minor}.x`;
    } else if (LTS_SUPPORT === 'major' && releaseType === 'major') {
        newBranchName = `stable/${major}.x`;
    }
}

if (newBranchName) {
    try {
        console.log(`Creating and pushing new branch: ${newBranchName}`);

        execSync(`git checkout -b ${newBranchName} v${currentVersion}`, { stdio: 'inherit' });
        execSync(`git push --set-upstream origin ${newBranchName}`, { stdio: 'inherit' });
        execSync(`git checkout ${currentBranch}`, { stdio: 'inherit' });

        console.log(`Branch ${newBranchName} created and pushed successfully.`);
    } catch (error) {
        console.error(`Failed to create and push branch ${newBranchName}:`, error.message);
        process.exit(1);
    }
} else {
    console.log("No new branch needs to be created based on the release type and LTS support policy.");
}
