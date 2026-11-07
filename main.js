// Mobile menu
const menuBtn = document.querySelector('.menu-btn');
const links = document.getElementById('nav-links');
menuBtn.addEventListener('click', () => {
  const open = links.classList.toggle('open');
  menuBtn.setAttribute('aria-expanded', String(open));
});
links.addEventListener('click', (e) => {
  if (e.target.closest('a')) {
    links.classList.remove('open');
    menuBtn.setAttribute('aria-expanded', 'false');
  }
});

document.getElementById('year').textContent = new Date().getFullYear();

// Fill the download box from the latest GitHub release
const fmtSize = (b) => (b / 1024 ** 3).toFixed(2).replace('.', ',') + ' GB';

fetch('https://api.github.com/repos/Labtoso/LithOS/releases?per_page=10', {
  headers: { Accept: 'application/vnd.github+json' },
})
  .then((r) => (r.ok ? r.json() : null))
  .then((list) => {
    const rel = Array.isArray(list) ? list.find((r) => !r.draft) : null;
    if (!rel || !rel.assets) return;
    const iso = rel.assets.find((a) => a.name.toLowerCase().endsWith('.iso'));
    if (!iso) return;

    document.getElementById('dl-version').textContent =
      (rel.name || rel.tag_name) + (rel.prerelease ? ' · Vorschau' : '');
    document.getElementById('dl-btn').href = iso.browser_download_url;
    const date = new Date(rel.published_at).toLocaleDateString('de-DE');
    document.getElementById('dl-meta').textContent =
      `${fmtSize(iso.size)} · veröffentlicht am ${date} · x86_64 · UEFI und BIOS`;
    document.getElementById('dl-note').innerHTML =
      `Ältere Versionen und Änderungen findest du unter <a href="${rel.html_url.replace(/\/tag\/.*/, '')}" rel="noopener">GitHub Releases</a>.`;

    if (iso.digest && iso.digest.startsWith('sha256:')) {
      document.getElementById('dl-sha').textContent = iso.digest.slice(7);
      document.getElementById('dl-sum').hidden = false;
    }
  })
  .catch(() => {});
