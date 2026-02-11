const apiFiles = [
    "nosoconsensus.md", "nosocrypto.md", "mpsignerutils.md", "nosounit.md", "nosomasternodes.md",
    "mpcoin.md", "nosogvts.md", "nosopsos.md", "mpblock.md", "nosoblock.md",
    "nosonetwork.md", "mpprotocol.md", "mpred.md", "mpmn.md", "nosotime.md", "nosonosocfg.md",
    "masterpaskalform.md", "mpparser.md", "mprpc.md", "mpgui.md", "mplang.md", "translation.md",
    "nosogeneral.md", "mpdisk.md", "nosowallcon.md", "nosoheaders.md", "nosodebug.md",
    "nosoipcontrol.md", "mpsyscheck.md", "formexplore.md", "nosoclient.md"
];

const contentElement = document.getElementById('content');
const apiLinksElement = document.getElementById('api-links');
const menuToggle = document.getElementById('menu-toggle');
const sidebar = document.getElementById('sidebar');

// Initialize API links
function initSidebar() {
    apiLinksElement.innerHTML = apiFiles.map(file => {
        const name = file.replace('.md', '');
        return `<a href="#api/${file}" class="sidebar-link">${name}</a>`;
    }).join('');

    // Responsive Search
    const searchInput = document.getElementById('api-search');
    searchInput.addEventListener('input', (e) => {
        const term = e.target.value.toLowerCase();
        const links = document.querySelectorAll('.sidebar-link');
        links.forEach(link => {
            const visible = link.textContent.toLowerCase().includes(term);
            link.style.display = visible ? 'block' : 'none';
        });

        // Hide empty sections
        document.querySelectorAll('.sidebar-section').forEach(section => {
            const hasVisible = Array.from(section.querySelectorAll('.sidebar-link'))
                .some(link => link.style.display !== 'none');
            const title = section.querySelector('.sidebar-title');
            if (title) title.style.display = hasVisible ? 'block' : 'none';
        });
    });
}

// Load Markdown content with smooth transition
async function loadContent() {
    let hash = window.location.hash.substring(1) || 'PROJECT_OVERVIEW.md';
    let path = 'docs/' + hash;

    // Reset active states
    document.querySelectorAll('.sidebar-link').forEach(link => {
        link.classList.toggle('active', link.getAttribute('href') === '#' + hash);
    });

    // Content fade out
    contentElement.style.opacity = '0.3';

    try {
        const response = await fetch(path);
        if (!response.ok) throw new Error('Not found');
        const markdown = await response.text();

        contentElement.innerHTML = marked.parse(markdown);
        contentElement.style.opacity = '1';

        // Auto-fix internal links
        contentElement.querySelectorAll('a').forEach(a => {
            const href = a.getAttribute('href');
            if (href && !href.startsWith('http') && !href.startsWith('#')) {
                // If it's a relative link (to another .md or subfolder)
                a.setAttribute('href', '#' + href);
            }
        });

        window.scrollTo({ top: 0, behavior: 'smooth' });
    } catch (err) {
        contentElement.innerHTML = `<h1>404</h1><p>The document <code>${hash}</code> could not be located.</p>`;
        contentElement.style.opacity = '1';
    }
}

// Burger Menu State
menuToggle.addEventListener('click', () => {
    sidebar.classList.toggle('show');
    menuToggle.classList.toggle('show');
});

// Close menu on navigation
sidebar.addEventListener('click', (e) => {
    if (e.target.classList.contains('sidebar-link') && window.innerWidth <= 1024) {
        sidebar.classList.remove('show');
        menuToggle.classList.remove('show');
    }
});

// Routing
window.addEventListener('hashchange', loadContent);

// Boot
document.addEventListener('DOMContentLoaded', () => {
    initSidebar();
    loadContent();
    contentElement.style.transition = 'opacity 0.2s ease-in-out';
});
