"""ToDo mínimo: o app é pretexto, quem está em cena é o Nix."""

from flask import Flask, redirect, request

app = Flask(__name__)
tarefas = []

PAGINA = """<!doctype html><title>ToDo</title>
<h1>ToDo</h1>
<form method=post action=/add><input name=texto autofocus>
<button>adicionar</button></form>
<ul>{itens}</ul>"""


@app.get("/")
def index():
    itens = "".join(f"<li>{t}</li>" for t in tarefas)
    return PAGINA.format(itens=itens)


@app.post("/add")
def add():
    texto = request.form.get("texto", "").strip()
    if texto:
        tarefas.append(texto)
    return redirect("/")


def main():
    app.run(host="127.0.0.1", port=8000)
