module.exports = {
    preset: 'angular',
    writerOpts: {
        transform: (commit, context) => {
            if (!commit.hash || !commit.subject) return;

            // Definir el scope si no está presente
            const specialTypes = ['fixpatchrelease', 'securitypatchrelease', 'featurerelease', 'breakingrelease'];
            commit.scope = commit.scope || (specialTypes.includes(commit.type) ? " " : "General");

            // Extraer información esencial
            commit.shortHash = commit.hash.substring(0, 7);
            commit.subject = commit.subject.substring(0, 70);
            const repoUrl = `${context.host}/${context.owner}/${context.repository}`;
            commit.commitUrl = `${repoUrl}/commit/${commit.hash}`;
            context.linkCompare = `${repoUrl}/compare/${context.previousTag}...${context.currentTag}`;

            // Definir el nombre del autor
            commit.authorName = commit.author?.name || commit.committer?.name || 'Unknown';

            // Extraer el módulo del commit
            const moduleMatch = commit.subject.match(/\(([^)]+)\)/);
            commit.module = moduleMatch ? moduleMatch[1] : 'General';

            // Extraer el número del PR si está presente en el subject
            const prMatch = commit.subject.match(/\(#(\d+)\)$/);
            if (prMatch) {
                commit.pullRequest = prMatch[1];
                commit.pullRequestUrl = `${repoUrl}/pull/${commit.pullRequest}`;
                commit.subject = commit.subject.replace(
                    `(#${commit.pullRequest})`,
                    `([#${commit.pullRequest}](${commit.pullRequestUrl}))`
                );
            }

            // Asignar tipos de commit con descripciones más legibles
            const typeMap = {
                'feat': 'Feature',
                'fix': 'Bug Fixed',
                'docs': 'Documentation',
                'style': 'Styles',
                'refactor': 'Code Refactoring',
                'perf': 'Performance Improvements',
                'test': 'Tests',
                'build': 'Build System',
                'ci': 'Continuous Integration',
                'removed': 'Removed Feature',
                'deprecated': 'Deprecated Feature',
                'security': 'Security Fixed',
                'securitypatchrelease': 'Security Patch Release',
                'fixpatchrelease': 'Fix Patch Release',
                'featurerelease': 'Features Release',
                'breakingrelease': 'Breaking Release'
            };

            commit.type = typeMap[commit.type] || null;
            if (!commit.type) return; // Omitir commits que no coincidan con los tipos mapeados

            // Definir encabezados especiales para algunos tipos de releases
            const typeHeaders = {
                'Security Patch Release': '### 🔒 Security Patch Release',
                'Fix Patch Release': '### 🐛 Fix Patch Release',
                'Features Release': '### 🚀 Features Release',
                'Breaking Release': '### ⚠️ Breaking Release'
            };

            // Formatear la descripción del commit
            commit.description = typeHeaders[commit.type]
                ? `${typeHeaders[commit.type]}: ${commit.subject} ([${commit.shortHash}](${commit.commitUrl})) - Contribuidor: ${commit.authorName}\n${commit.body || ''}`
                : `- ${commit.type}: ${commit.subject} ([${commit.shortHash}](${commit.commitUrl})) - Contribuidor: ${commit.authorName}\n${commit.body || ''}`;

            return commit;
        },

        // Configuración de encabezado y commits
        headerPartial: "## [[{{version}}]({{linkCompare}})] - {{date}}",
        commitPartial: `{{description}}`,

        // Agrupar por scope y ordenar los commits
        groupBy: 'scope',
        commitGroupsSort: (a, b) => {
            const order = [
                'Features Release', 'Breaking Release', 'Fix Patch Release', 'Security Patch Release',
                'Feature', 'Bug Fixed', 'Documentation', 'Styles', 'Code Refactoring',
                'Performance Improvements', 'Tests', 'Build System', 'Continuous Integration',
                'Removed Feature', 'Deprecated Feature', 'Security Fixed', 'Chore'
            ];
            return order.indexOf(a.title) - order.indexOf(b.title);
        },
        commitsSort: ['type', 'subject']
    }
};
