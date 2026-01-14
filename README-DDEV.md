# Development a C2Distro-based project with DDEV

Because all required DDEV configuration files are already included in the
project, you can start using DDEV right away.

## Basic DDEV commands

### Start DDEV

```shell script
ddev start
```

### Stop DDEV

```shell script
ddev stop
```

### Reload DDEV

```shell script
ddev restart
```

### Open the project in the browser

```shell script
ddev launch
```

## First start

### 1. Start DDEV

```shell script
ddev start
```

### 2. Run `composer install`

```shell script
ddev composer install
```

### 3. Import DB dump

```shell script
ddev import-db --file=path-to-database.dump.gz
```

### 4. Open the project in the browser

```shell script
ddev launch
```

## Frontend development

### 1. Install frontend dependencies

in a new terminal tab/window:

```shell script
cd to/the/theme/folder
ddev yarn install
```

### 2. Start yarn watch

```shell script
ddev yarn start
```

### 3. Start browsersync

switch back to the first terminal tab/window or open a new one:

```shell script
ddev browsersync
```

### 4. Open the project in the browser with live reload

Put the `:3000` port to the URL, e.g. `http://c2distro.ddev.site:3000`.

### 5. Ready to commit changes

When you are done with the changes, you can commit them to the repository.

#### Stop the `yarn start` process

`Ctrl + C`

#### Build the assets

```shell script
ddev yarn build
```

#### Increment the version number of the related libraries
