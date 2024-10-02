# Hugo quick start

### first come
- Verify the existence of **Golang**: cmd -> `go version`
- Verify the existence of **Dart Sass**: cmd -> `dart-sass --version`
- Verify the existence of **Hugo**: cmd -> `hugo version`
- Setup all submodule (github page and book theme):
    - Clear all files in `public` folder: `rm -rf engineerblog/public`
    - Also clear in `themes` folder: `rm -rf engineerblog/themes`
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