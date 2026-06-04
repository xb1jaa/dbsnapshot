#!/usr/bin/env node
// 🗄️ dbsnapshot — Database Schema Versioning Tool

const fs   = require('fs');
const path = require('path');

const GREEN  = '\x1b[32m'; const RED    = '\x1b[31m';
const YELLOW = '\x1b[33m'; const CYAN   = '\x1b[36m';
const BOLD   = '\x1b[1m';  const DIM    = '\x1b[2m';
const NC     = '\x1b[0m';

const SNAPSHOTS_DIR = './snapshots';

function ensureDir(dir) {
  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
}

// ── Mock schema generator (replace with real DB driver) ──
function getMockSchema(label = 'mydb') {
  return {
    database: label,
    captured_at: new Date().toISOString(),
    tables: {
      users: {
        columns: {
          id:         { type: 'INTEGER', primary: true, nullable: false },
          username:   { type: 'VARCHAR(50)', nullable: false, unique: true },
          email:      { type: 'VARCHAR(255)', nullable: false, unique: true },
          created_at: { type: 'TIMESTAMP', default: 'NOW()', nullable: false },
          is_active:  { type: 'BOOLEAN', default: 'TRUE', nullable: false },
        },
        indexes: ['idx_users_email', 'idx_users_username'],
        foreign_keys: [],
      },
      posts: {
        columns: {
          id:         { type: 'INTEGER', primary: true, nullable: false },
          user_id:    { type: 'INTEGER', nullable: false },
          title:      { type: 'VARCHAR(255)', nullable: false },
          body:       { type: 'TEXT', nullable: true },
          published:  { type: 'BOOLEAN', default: 'FALSE', nullable: false },
          created_at: { type: 'TIMESTAMP', default: 'NOW()', nullable: false },
        },
        indexes: ['idx_posts_user_id'],
        foreign_keys: [{ column: 'user_id', references: 'users(id)' }],
      },
      tags: {
        columns: {
          id:   { type: 'INTEGER', primary: true },
          name: { type: 'VARCHAR(50)', nullable: false, unique: true },
          slug: { type: 'VARCHAR(50)', nullable: false, unique: true },
        },
        indexes: [],
        foreign_keys: [],
      },
    },
    views: [],
    functions: [],
  };
}

function capture(options = {}) {
  ensureDir(SNAPSHOTS_DIR);
  const label   = options.label || `snapshot-${Date.now()}`;
  const schema  = getMockSchema(options.db || 'mydb');
  const outPath = path.join(SNAPSHOTS_DIR, `${label}.json`);
  fs.writeFileSync(outPath, JSON.stringify(schema, null, 2));
  console.log(`\n${GREEN}✅ Schema captured → ${outPath}${NC}`);
  console.log(`${DIM}Tables: ${Object.keys(schema.tables).join(', ')}${NC}\n`);
  return schema;
}

function diff(fileA, fileB) {
  if (!fs.existsSync(fileA)) { console.error(`${RED}❌ Not found: ${fileA}${NC}`); process.exit(1); }
  if (!fs.existsSync(fileB)) { console.error(`${RED}❌ Not found: ${fileB}${NC}`); process.exit(1); }

  const a = JSON.parse(fs.readFileSync(fileA, 'utf8'));
  const b = JSON.parse(fs.readFileSync(fileB, 'utf8'));

  console.log(`\n${CYAN}${BOLD}🗄️  dbsnapshot diff${NC}`);
  console.log(`${DIM}${path.basename(fileA)} → ${path.basename(fileB)}${NC}`);
  console.log('─'.repeat(60));

  let added = 0, removed = 0, modified = 0;
  const allTables = new Set([...Object.keys(a.tables || {}), ...Object.keys(b.tables || {})]);

  allTables.forEach(table => {
    const inA = a.tables?.[table];
    const inB = b.tables?.[table];

    if (!inA && inB) {
      console.log(`\n${GREEN}+ Table added: ${table}${NC}`);
      Object.entries(inB.columns || {}).forEach(([col, def]) => {
        console.log(`    ${GREEN}+ ${col.padEnd(20)} ${def.type}${def.primary ? ' PRIMARY KEY' : ''}${NC}`);
      });
      added++;
    } else if (inA && !inB) {
      console.log(`\n${RED}- Table removed: ${table}${NC}`);
      removed++;
    } else if (inA && inB) {
      const colsA = inA.columns || {};
      const colsB = inB.columns || {};
      const allCols = new Set([...Object.keys(colsA), ...Object.keys(colsB)]);
      let tableChanged = false;
      const changes = [];

      allCols.forEach(col => {
        if (!colsA[col] && colsB[col]) {
          changes.push(`${GREEN}    + ${col.padEnd(20)} ${colsB[col].type}${NC}`);
        } else if (colsA[col] && !colsB[col]) {
          changes.push(`${RED}    - ${col.padEnd(20)} ${colsA[col].type} [DROPPED]${NC}`);
        } else if (JSON.stringify(colsA[col]) !== JSON.stringify(colsB[col])) {
          changes.push(`${YELLOW}    ~ ${col.padEnd(20)} ${colsA[col].type} → ${colsB[col].type}${NC}`);
        }
      });

      if (changes.length) {
        console.log(`\n${YELLOW}~ Table modified: ${table}${NC}`);
        changes.forEach(c => console.log(c));
        modified++;
      }
    }
  });

  console.log('\n' + '─'.repeat(60));
  console.log(`${GREEN}+ ${added} added${NC}  ${YELLOW}~ ${modified} modified${NC}  ${RED}- ${removed} removed${NC}\n`);
}

function listSnapshots() {
  ensureDir(SNAPSHOTS_DIR);
  const files = fs.readdirSync(SNAPSHOTS_DIR).filter(f => f.endsWith('.json'));
  console.log(`\n${CYAN}${BOLD}🗄️  dbsnapshot — Snapshots (${files.length})${NC}\n`);
  if (!files.length) { console.log(`${DIM}No snapshots yet. Run: node src/snapshot.js capture${NC}\n`); return; }
  files.forEach(f => {
    const data = JSON.parse(fs.readFileSync(path.join(SNAPSHOTS_DIR, f), 'utf8'));
    const tables = Object.keys(data.tables || {}).length;
    console.log(`  📸 ${f.padEnd(35)} ${DIM}${tables} tables | ${data.captured_at?.slice(0,19)}${NC}`);
  });
  console.log();
}

// ── CLI ─────────────────────────────────────────────────
const cmd  = process.argv[2] || 'help';
const arg1 = process.argv[3];
const arg2 = process.argv[4];

console.log(`\n${CYAN}${BOLD}🗄️  dbsnapshot${NC}\n`);

if (cmd === 'capture') {
  capture({ db: arg1, label: arg2 || `v${Date.now()}` });
} else if (cmd === 'diff' && arg1 && arg2) {
  diff(arg1, arg2);
} else if (cmd === 'diff' && !arg1) {
  const files = fs.existsSync(SNAPSHOTS_DIR)
    ? fs.readdirSync(SNAPSHOTS_DIR).filter(f => f.endsWith('.json')).sort() : [];
  if (files.length >= 2) {
    diff(path.join(SNAPSHOTS_DIR, files[files.length-2]), path.join(SNAPSHOTS_DIR, files[files.length-1]));
  } else { console.log(`${YELLOW}Need at least 2 snapshots. Run capture twice.${NC}\n`); }
} else if (cmd === 'list') {
  listSnapshots();
} else if (cmd === 'demo') {
  const s1 = path.join(SNAPSHOTS_DIR, 'v1-demo.json');
  const s2 = path.join(SNAPSHOTS_DIR, 'v2-demo.json');
  ensureDir(SNAPSHOTS_DIR);
  const schema1 = getMockSchema();
  const schema2 = JSON.parse(JSON.stringify(schema1));
  schema2.tables.user_sessions = { columns: { id: { type: 'UUID', primary: true }, user_id: { type: 'INTEGER' }, created_at: { type: 'TIMESTAMP' } }, indexes: [], foreign_keys: [] };
  schema2.tables.users.columns.email_verified = { type: 'BOOLEAN', default: 'FALSE' };
  schema2.tables.users.columns.username.type = 'VARCHAR(100)';
  delete schema2.tables.tags;
  fs.writeFileSync(s1, JSON.stringify(schema1, null, 2));
  fs.writeFileSync(s2, JSON.stringify(schema2, null, 2));
  diff(s1, s2);
} else {
  console.log(`Usage:`);
  console.log(`  node src/snapshot.js capture [--db <connection>] [label]`);
  console.log(`  node src/snapshot.js diff <snapshot-a.json> <snapshot-b.json>`);
  console.log(`  node src/snapshot.js diff          (diffs last two snapshots)`);
  console.log(`  node src/snapshot.js list`);
  console.log(`  node src/snapshot.js demo\n`);
}
