# 🏆 Step-by-Step Instructions — dbsnapshot

## 1. Create Your GitHub Repo
1. Go to [github.com/new](https://github.com/new)
2. Name it `dbsnapshot`
3. Set to **Public** ← required for Publicist badge
4. Check "Add a README file" → **Create repository**

## 2. Upload Project Files
1. Extract the ZIP on your computer
2. Open the `dbsnapshot` folder
3. Select **all files inside** (Ctrl+A / Cmd+A)
4. On GitHub: **Add file → Upload files** → drag them in
5. Commit to `main`

## 3. Open in GitHub Codespace
1. Click the green **Code** button on your repo
2. Click **Codespaces** tab → **Create codespace on main**
3. Wait ~60 seconds for it to build

## 4. Authenticate GitHub CLI
```bash
unset GITHUB_TOKEN
gh auth login
gh auth setup-git
```

## 5. Run Setup
```bash
bash scripts/setup.sh
```

## 6. Unlock All Achievements
```bash
bash scripts/unlock-all.sh
```
Pick **Option 5 — Full Blast** or run individually:
```bash
bash scripts/quickdraw.sh
bash scripts/yolo.sh
bash scripts/publicist.sh
bash scripts/pull-shark.sh 2
bash scripts/pair-extraordinaire.sh "Name" "email@github.com"
```

## 7. Check Progress
```bash
node src/achievement-tracker.js
node src/achievement-tracker.js roadmap
```

## 8. View Your Badges
Visit: https://github.com/YOUR_USERNAME
Badges appear within **2–24 hours**.
