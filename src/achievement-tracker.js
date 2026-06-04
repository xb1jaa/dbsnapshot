#!/usr/bin/env node
// 🏆 Achievement Tracker
const { execSync } = require('child_process');

function run(cmd) {
  try { return execSync(cmd, { encoding: 'utf8', stdio: ['pipe','pipe','pipe'] }).trim(); }
  catch { return '0'; }
}

const user    = run('gh api user -q .login');
const merged  = parseInt(run('gh pr list --state merged --author "@me" --json number -q "length"')) || 0;
const releases= parseInt(run('gh release list --json tagName -q "length"')) || 0;

function tier(n, thresholds) {
  const labels = ['○ None','🥉 Bronze','🥈 Silver','🥇 Gold','💎 Diamond'];
  let t = 0;
  thresholds.forEach((th, i) => { if (n >= th) t = i + 1; });
  return labels[t];
}
function next(n, thresholds) {
  const found = thresholds.find(th => n < th);
  return found ? `${found - n} more for next tier` : 'MAX TIER 💎';
}

const prTiers = [2, 16, 128, 1024];

console.log(`
╔══════════════════════════════════════════════════╗
║          🏆 GitHub Achievement Tracker           ║
║          👤 @${(user||'unknown').padEnd(35)}║
╚══════════════════════════════════════════════════╝

  ⚡ Quickdraw          → bash scripts/quickdraw.sh
  🤠 YOLO               → bash scripts/yolo.sh
  📢 Publicist          → ${releases > 0 ? '✅ Done (' + releases + ' release' + (releases>1?'s':'')+')' : '○ Run: bash scripts/publicist.sh'}
  🦈 Pull Shark         → ${merged} merged PRs | ${tier(merged, prTiers)} | ${next(merged, prTiers)}
  🤝 Pair Extraordinaire→ bash scripts/pair-extraordinaire.sh "Name" "email"
  ❤️  Heart On Sleeve    → React ❤️ on any GitHub issue/PR (manual)
  🌌 Galaxy Brain       → Answer GitHub Discussions (manual)
  🌟 Starstruck         → Get 16+ stars on a repo (manual)

  🔗 Profile: https://github.com/${user||'yourusername'}
`);

if (process.argv[2] === 'roadmap') {
  console.log(`📋 ROADMAP
  Day 1:   ⚡ Quickdraw → 🤠 YOLO → 📢 Publicist → ❤️ Heart On Sleeve
  Week 1:  🦈 Pull Shark (run with 2, then 16) → 🤝 Pair Extraordinaire
  Month 1: 🌌 Galaxy Brain → 🌊 Open Sourcerer → 🌟 Starstruck
`);
}
