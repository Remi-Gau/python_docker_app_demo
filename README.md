## install

```bash
pip install .
```

editable mode

```bash
pip install -e .
```

## run

```bash
my_app
```

## docker

use make to create `Dockerfile` and `image`

```bash
make Docker_build
```

run it with

```bash
docker run -it --rm my_app:dev
```
