#!/bin/bash
# 从上游 NextAgentX 拉最新代码并合并进你的 fork
# 用法: ./同步上游.sh          → 合并（有冲突会停下来让你处理）
#       ./同步上游.sh --ffonly → 只快进，不产生合并提交（你没改过时用这个最干净）
set -e
cd "$(dirname "$0")"
git fetch upstream
BEHIND=$(git rev-list --count HEAD..upstream/main || echo 0)
echo "上游比你多 $BEHIND 个提交"
if [ "$BEHIND" = "0" ]; then echo "已是最新，无需同步"; exit 0; fi
if [ "$1" = "--ffonly" ]; then
  git merge --ff-only upstream/main
else
  git merge upstream/main --no-edit || { echo "⚠️ 有冲突：解决后 git add . && git commit，然后 git push"; exit 1; }
fi
git push origin main
echo "✅ 已同步并推送。要出新安装包就发一个 tag："
echo "   git tag v$(date +%Y.%m.%d) && git push origin v$(date +%Y.%m.%d)"
