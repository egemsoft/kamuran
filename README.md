kamuran
=======

Random suggestion helper, unnecessary at all.

##Install

```bash
	$ npm install -g kamuran
```

##Usage

Suggest an appropriate place based on time:

```bash
 $ kamuran -s
```

Suggest a place based on type:
```bash
 $ kamuran -s --type lunch
```

Ask a question (also supports type):
```bash
 $ kamuran -q "nereye gidelim?"
```

## Update places cache

Places are stored in a json file placed at `~/.kamuran/places.json`. It can be updated from this repo by running:

```bash
 $ kamuran --update
```