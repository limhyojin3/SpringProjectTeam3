window.addEventListener('load', function() {
    const currentPath = window.location.pathname;
    document.querySelectorAll('.nav-btn').forEach(btn => {
        const onclick = btn.getAttribute('onclick');
        if (!onclick) return;
        const match = onclick.match(/'([^']+)'/);
        if (!match) return;
        if (currentPath.endsWith(match[1])) {
            btn.classList.add('active');
        }
    });
});