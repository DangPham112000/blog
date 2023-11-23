---
title: "Git TIP"
weight: 20
date: 2023-11-15T01:47:46+07:00
---

# GIT

## Terminology

- `HEAD`: your current local working branch
- `origin`: the address to your remote git, represent for remote repo
- tracked file: the file git already had before, so when you edit it, git know this file is modified (`M` files)

- untracked, new file: the file recently add and git don’t know anything about it (`U` files)

## Commit

```
git add .
git commit -m "commit message"
```

These 2 commands can combie into 1

```
git commit -am "commit message"
```

Note this only work with tracked files

## Change previous commit message

### Commit amend

```
git commit --amend -m "new message to replace the previous message"
```

Note this `amend` can also simplify by `amen` :))))

### Rebase reword

```
git rebase -i HEAD~1
```

[Vim IDE appear and show a latest commit] <br>
→ type `i` to change into insert mode <br>
→ change `“pick”` to `“r”` or `“reword”` → means you will change this commit message <br>
→ press `“escape”` key to out insert mode <br>
→ type `wq` to save <br>
→ new vim ide appear to let you change the commit message <br>
→ change and save <br>

```
git push -f
```

## Opps! Code on wrong branch

### Stash

```
git stash
git checkout correct-branch
git stash pop
```

<u>Note</u> git stash will only bring the changes on `tracked files` to store but don’t worry when checkout to other branch, the `untracked files` will move to there also

## Opps! Commit into local main branch

### Reset

Solution 1: Erase the current commit and back to the earlier commit

```
git reset --hard HEAD~1
```

Solution 2: Bring the current commit to staged change and go back to the earlier commit

```
git reset --soft HEAD~1
```

## Update the outdated feature branch

### Relocate branch: rebase

[figure] => [figure]

```
git checkout master
git pull
git rebase master topic
git push -f
```

### Pull origin

Collect code from master to feature branch. feature branch in this example is topic branch

```
git checkout master
git pull
git checkout topic
git pull origin master
```

<u>Note:</u> never tried yet

## Clean up messy commits

### Accumulate commits: rebase fixup

If you have 3 messy commits per 4 commits on your feature branch

[figure] => [figure]

```
git rebase -i HEAD~4
```

[vim ide appear and show 4 latest commits] <br>
→ type “i” to change into insert mode <br>
→ change “pick” to “f” or “fixup” → means you accumulate this 3 commits <br>
[figure] => [figure] <br>
→ out insert mode with “escape” key <br>
→ type “wq” to save <br>
[figure]

```
git push -f
```

Note: this commit will have all changes from 3 previous commits

## Delete all local branches except main branch

```
git branch | grep -v "main" | xargs git branch -D
```

Explanation:

- Get all branches (except for the main) via git branch | grep -v "main" command
- Select every branch with xargs command
- Delete branch with xargs git branch -D

## Refresh outdated local branch

- If you pull but show some warnings or errors and git show a recommend that is need to type some rebase commands
- Just checkout to another branch, delete your local conflict branch and then checkout to this branch again to download a latest one in remote repo

```
git checkout dev
git branch -D feature-branch
git fetch
git checkout feature-branch
```

## Merge PR but get stuck in conflict

### Relocate branch: rebase

```
git checkout main
git pull
checkout feature-branch
git rebase main feature-branch
```

[Conflict appears in IDE]
→ Resolve conflict and save file

```
git add .
git rebase --continue
```

[vim ide appear to make you confirm change]
→ `:wq`

```
git push -f
```

## Log pretty

```
git log --graph --decorate --oneline
```

or

```
git log --graph --decorate
```

## Config

### Show current global credential

```
git config --global --list
```

### Configure local repo’s credential when you want it’s different with the global one

```
git config user.name DangPham112000
git config user.email dangpham112000@gmail.com
```

### Switch git user

https://github.com/geongeorge/Git-User-Switch
