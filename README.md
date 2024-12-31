# Hugo quick start

### first come
- Verify the existence of **Golang**: cmd -> `go version`
- Verify the existence of **Dart Sass**: cmd -> `dart-sass --version`
- Verify the existence of **Hugo**: cmd -> `hugo version`
- Setup submodules (github page and book theme):
    - Github page module: `public` folder
        - Clear folder: `rm -rf ./engineerblog/public`
    - Hugo-book theme module: `themes/hugo-book` folder
        - Clear folder: `rm -rf ./engineerblog/themes`
    - Clone and connect to submodules: `git submodule update --init --recursive`
    - Switch to the main branch for the upcoming deployment:
        - `cd engineerblog/public`
        - `git checkout main`
        - `git pull`
        - Repeat the same steps for the `hugo-book` module

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