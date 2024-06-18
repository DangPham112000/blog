# Hugo quick start

### first come
- Install `golang`,`dart-sass`,`hugo`
- Setup all submodule (github page and book theme):
    - Clear all files in `public` folder: `engineerblog/public`
    - Also clear in `themes` folder: `engineerblog/themes`
    - Clone and connect to submodule: `git submodule update --init --recursive`

### run dev

```zsh
hugo server
```

### build hugo

```zsh
hugo -t [theme-name]
hugo -t hugo-book
```

Then publish it to github page

```zsh
cd public
git add .
git commit -m "update"
git push
```

- Go to git action of github page repo check the publishing complete
- Then go to page to see the result: https://dangpham112000.github.io/