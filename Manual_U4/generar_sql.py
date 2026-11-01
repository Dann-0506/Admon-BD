"""Genera los scripts .sql de implementacion/ a partir de los bloques verbatim del manual.

Uso, desde cualquier carpeta:  python generar_sql.py  (en la raiz del proyecto)
No forma parte de la entrega de implementacion/: requiere los .tex del manual.
Ejecutalo cada vez que cambie un bloque de codigo de los capitulos 1, 2, 6, 7, 8, 9, 10, 11 o 12.
Los bloques se identifican por su posicion: si agregas o quitas un bloque
verbatim en esos capitulos, ajusta los indices de este archivo.
"""
import glob
import os
import re
import sys

ROOT = sys.argv[1] if len(sys.argv) > 1 else os.path.dirname(os.path.abspath(__file__))
CAP = os.path.join(ROOT, "capitulos")
OUT = os.path.join(ROOT, "implementacion")


def bloques(nombre):
    with open(os.path.join(CAP, nombre), encoding="utf-8") as fh:
        texto = fh.read()
    res = []
    for b in re.findall(r"\\begin\{verbatim\}\n(.*?)\\end\{verbatim\}", texto, re.S):
        lineas = [l[1:] if l.startswith("\t") else l for l in b.rstrip("\n").split("\n")]
        res.append("\n".join(lineas).strip("\n"))
    return res


B = {n: bloques(f) for n, f in {
    "01": "01-introduccion.tex", "02": "02-entorno.tex", "09": "09-tablespaces.tex", "10": "10-multiinstancias.tex", "11": "11-particiones.tex", "12": "12-segmentacion.tex", "06": "06-usuarios.tex",
    "07": "07-implementacion.tex", "08": "08-bitacora.tex"}.items()}


def parte(cap, i, desde=None, hasta=None):
    """Fragmento de un bloque, delimitado por las líneas que empiezan con `desde`/`hasta`."""
    lineas = B[cap][i].split("\n")
    ini = next(k for k, l in enumerate(lineas) if l.startswith(desde)) if desde else 0
    fin = next(k for k, l in enumerate(lineas) if l.startswith(hasta)) if hasta else len(lineas)
    return "\n".join(lineas[ini:fin]).strip("\n")


def escribir(ruta, titulo, ejecuta, origen, cuerpo, preambulo=()):
    enc = ["-- " + "=" * 72,
           f"-- {titulo}",
           f"-- Ejecuta: {ejecuta}",
           f"-- Origen:  {origen}",
           "-- Generado a partir del manual; no editar a mano.",
           "-- " + "=" * 72, ""]
    contenido = "\n".join(enc + list(preambulo)) + ("\n" if preambulo else "")
    contenido += "\n\n".join(cuerpo) + "\n"
    destino = os.path.join(OUT, ruta)
    os.makedirs(os.path.dirname(destino), exist_ok=True)
    with open(destino, "w", encoding="utf-8", newline="\n") as fh:
        fh.write(contenido)


# Carpeta de cada captura, según el capítulo donde aparece \captura{nombre.png}
CARPETA = {}
for _f in glob.glob(os.path.join(CAP, "*.tex")):
    for _n in re.findall(r"\\captura\{([^}]+)\.png\}", open(_f, encoding="utf-8").read()):
        CARPETA[_n] = os.path.basename(_f)[:-4]


def ruta_captura(nombre):
    """Ruta de la captura que produce una consulta. Las consultas que forman
    parte de una misma captura (p. ej. pg-integridad-dba) usan la de su prefijo."""
    while nombre not in CARPETA:
        nombre = nombre.rsplit("-", 1)[0]
    return f"recursos/{CARPETA[nombre]}/{nombre}.png"


PG_ENC = ["SET client_encoding = 'UTF8';", ""]
PG_DBA = PG_ENC[:1] + ["SET ROLE rol_admin_bd;", ""]
MY_ENC = ["SET NAMES utf8mb4;", ""]

# ---------------------------------------------------------------- PostgreSQL
pg = [
    ("01_postgres_rol_dba.sql", "postgres (base postgres)", "Usuarios y roles > Creación en PostgreSQL (superusuario)", PG_ENC, [B["06"][0]]),
    ("02_postgres_base_datos.sql", "postgres (base postgres)", "Implementación física > PostgreSQL > Base de datos", PG_ENC, [B["07"][0]]),
    ("03_dba_roles_usuarios.sql", "dlandero (base inversiones)", "Usuarios y roles > Creación en PostgreSQL (DBA)", PG_ENC, [B["06"][1]]),
    ("04_dba_esquema.sql", "dlandero (base inversiones)", "Implementación física > PostgreSQL > Base de datos", PG_ENC, [B["07"][1]]),
    ("05_dba_tablas.sql", "dlandero (base inversiones)", "Implementación física > PostgreSQL > Tablas", PG_ENC, [B["07"][3]]),
    ("06_dba_objetos.sql", "dlandero (base inversiones)", "Implementación física > PostgreSQL > Objetos programados", PG_DBA, [B["07"][5], B["07"][6]]),
    ("07_dba_permisos.sql", "dlandero (base inversiones)", "Implementación física > PostgreSQL > Permisos", PG_ENC, [B["07"][8]]),
    ("08_dba_datos.sql", "dlandero (base inversiones)", "Implementación física > Datos de prueba (comunes + PostgreSQL)", PG_DBA, [B["07"][19], B["07"][20]]),
    ("09_dba_bitacora.sql", "dlandero (base inversiones)", "Bitácora > PostgreSQL", PG_ENC, [B["08"][0]]),
    ("10_alcance_gerente.sql", "dmejia (base inversiones)", "Implementación física > Pruebas de alcance", PG_ENC, [B["07"][23]]),
    ("11_alcance_ejecutivo.sql", "pzuniga (base inversiones)", "Implementación física > Pruebas de alcance", PG_ENC, [B["07"][24]]),
    ("12_alcance_tesoreria.sql", "xzaleta (base inversiones)", "Implementación física > Pruebas de alcance", PG_ENC, [B["07"][25]]),
    ("13_alcance_auditor.sql", "enovoa (base inversiones)", "Implementación física > Pruebas de alcance", PG_ENC, [B["07"][26]]),
    ("14_alcance_respaldo.sql", "respaldo (base inversiones)", "Implementación física > Pruebas de alcance", PG_ENC, [B["07"][27]]),
    ("15_postgres_tablespaces.sql", "postgres (base postgres)", "Tablespaces > PostgreSQL > Creación", PG_ENC, [B["09"][1]]),
    ("16_dba_tablespaces.sql", "dlandero (base inversiones)", "Tablespaces > PostgreSQL > Asignación", PG_ENC, [B["09"][2]]),
]
for nombre, ejecuta, origen, pre, cuerpo in pg:
    escribir(f"postgresql/{nombre}", f"Sistema de Inversiones · PostgreSQL · {nombre}", ejecuta, origen, cuerpo, pre)

pg_consultas = [
    ("pg-version", "postgres", "Configuración del entorno", B["02"][0]),
    ("pg-parametros", "postgres", "Configuración del entorno", B["02"][1]),
    ("pg-registro", "postgres", "Configuración del entorno", B["02"][2]),
    ("pg-remota", "dmejia, desde un equipo cliente", "Configuración del entorno", B["02"][3]),
    ("pg-roles", "dlandero", "Usuarios y roles", B["06"][2]),
    ("pg-base-datos", "dlandero", "Implementación física", B["07"][2]),
    ("pg-tablas", "dlandero", "Implementación física", B["07"][4]),
    ("pg-objetos", "dlandero", "Implementación física", B["07"][7]),
    ("pg-permisos", "dlandero", "Implementación física", B["07"][9]),
    ("pg-datos-conteo", "dlandero", "Implementación física", B["07"][22]),
    ("pg-bitacora-triggers", "dlandero", "Bitácora", B["08"][1]),
    ("pg-bitacora-registros", "enovoa", "Bitácora", B["08"][4]),
    ("pg-objetivo1", "dmejia", "Introducción > Consultas de los objetivos", B["01"][0]),
    ("pg-objetivo2", "dmejia", "Introducción > Consultas de los objetivos", B["01"][2]),
    ("pg-objetivo3", "dmejia", "Introducción > Consultas de los objetivos", B["01"][4]),
    ("pg-objetivo4", "dmejia", "Introducción > Consultas de los objetivos", B["01"][5] + "\n\n" + B["01"][7]),
    ("pg-objetivo5", "dmejia", "Introducción > Consultas de los objetivos", B["01"][8]),
    ("pg-tablespaces", "dlandero", "Tablespaces", B["09"][3]),
    ("pg-tablespaces-objetos", "dlandero", "Tablespaces", B["09"][4]),
]
for nombre, ejecuta, origen, sql in pg_consultas:
    escribir(f"postgresql/consultas/{nombre}.sql", f"Captura {ruta_captura(nombre)}", ejecuta, origen, [sql], PG_ENC)

# --------------------------------------------------------------------- MySQL
my = [
    ("01_root_rol_dba.sql", "root", "Usuarios y roles > Creación en MySQL (superusuario)", [B["06"][3]]),
    ("02_dba_base_datos.sql", "dlandero", "Implementación física > MySQL > Base de datos", [B["07"][10]]),
    ("03_dba_roles_usuarios.sql", "dlandero", "Usuarios y roles > Creación en MySQL (DBA)", [B["06"][4], parte("06", 5, hasta="-- Superusuario")]),
    ("04_root_privilegios.sql", "root", "Usuarios y roles (respaldo) y Bitácora > MySQL", [parte("06", 5, desde="-- Superusuario"), B["08"][2]]),
    ("05_dba_tablas.sql", "dlandero", "Implementación física > MySQL > Tablas", [B["07"][12]]),
    ("06_dba_objetos.sql", "dlandero (base inversiones)", "Implementación física > MySQL > Objetos programados", [B["07"][14], B["07"][15]]),
    ("07_dba_permisos.sql", "dlandero", "Implementación física > MySQL > Permisos", [B["07"][17]]),
    ("08_dba_datos.sql", "dlandero (base inversiones)", "Implementación física > Datos de prueba (comunes + MySQL)", [B["07"][19], B["07"][21]]),
    ("09_dba_bitacora.sql", "dlandero (base inversiones)", "Bitácora > MySQL", [B["08"][3]]),
    ("10_alcance_gerente.sql", "dmejia (base inversiones)", "Implementación física > Pruebas de alcance", [B["07"][23]]),
    ("11_alcance_ejecutivo.sql", "pzuniga (base inversiones)", "Implementación física > Pruebas de alcance", [B["07"][24]]),
    ("12_alcance_tesoreria.sql", "xzaleta (base inversiones)", "Implementación física > Pruebas de alcance", [B["07"][25]]),
    ("13_alcance_auditor.sql", "enovoa (base inversiones)", "Implementación física > Pruebas de alcance", [B["07"][26]]),
    ("14_alcance_respaldo.sql", "respaldo (base inversiones)", "Implementación física > Pruebas de alcance", [B["07"][27]]),
    ("15_root_tablespaces.sql", "root", "Tablespaces > MySQL > Creación", [B["09"][8]]),
    ("16_dba_tablespaces.sql", "dlandero (base inversiones)", "Tablespaces > MySQL > Asignación", [B["09"][9]]),
]
for nombre, ejecuta, origen, cuerpo in my:
    escribir(f"mysql/{nombre}", f"Sistema de Inversiones · MySQL · {nombre}", ejecuta, origen, cuerpo, MY_ENC)

l02_7 = B["02"][8].split("\n")
my_consultas = [
    ("mysql-version", "root", "Configuración del entorno", B["02"][4]),
    ("mysql-parametros", "root", "Configuración del entorno", B["02"][5]),
    ("mysql-registro", "root", "Configuración del entorno", B["02"][6]),
    ("mysql-cuentas", "root", "Configuración del entorno", l02_7[0]),
    ("mysql-remota", "dmejia, desde un equipo cliente", "Configuración del entorno", l02_7[1]),
    ("mysql-roles", "root", "Usuarios y roles", B["06"][6]),
    ("mysql-base-datos", "dlandero", "Implementación física", B["07"][11]),
    ("mysql-tablas", "dlandero", "Implementación física", B["07"][13]),
    ("mysql-objetos", "dlandero", "Implementación física", B["07"][16]),
    ("mysql-permisos", "root (SHOW GRANTS de otras cuentas requiere leer el esquema mysql)", "Implementación física", B["07"][18]),
    ("mysql-datos-conteo", "dlandero", "Implementación física", B["07"][22]),
    ("mysql-bitacora-triggers", "dlandero", "Bitácora", B["08"][1]),
    ("mysql-bitacora-registros", "enovoa", "Bitácora", B["08"][4]),
    ("mysql-objetivo1", "dmejia", "Introducción > Consultas de los objetivos", B["01"][1]),
    ("mysql-objetivo2", "dmejia", "Introducción > Consultas de los objetivos", B["01"][3]),
    ("mysql-objetivo3", "dmejia", "Introducción > Consultas de los objetivos", B["01"][4]),
    ("mysql-objetivo4", "dmejia", "Introducción > Consultas de los objetivos", B["01"][6] + "\n\n" + B["01"][7]),
    ("mysql-objetivo5", "dmejia", "Introducción > Consultas de los objetivos", B["01"][8]),
    ("mysql-tablespaces", "root (requiere el privilegio PROCESS)", "Tablespaces", B["09"][10]),
    ("mysql-tablespaces-objetos", "root (requiere el privilegio PROCESS)", "Tablespaces", B["09"][11]),
]
for nombre, ejecuta, origen, sql in my_consultas:
    escribir(f"mysql/consultas/{nombre}.sql", f"Captura {ruta_captura(nombre)}", ejecuta, origen, [sql], MY_ENC)

# --------------------------------------------------------- Segunda instancia
def segunda_instancia(sql, gestor, crear):
    """Adapta un script de tablespaces de la primera instancia a la segunda:
    cambia el directorio y omite pago y bitacora, que se ubican al
    particionarlas (cap. 9). En MySQL no se crea ts_bitacora."""
    sql = sql.replace("/pg1/", "/pg2/").replace("/mysql1/", "/mysql2/")
    res = []
    for b in sql.split("\n\n"):
        if crear:
            if gestor == "mysql":
                b = re.sub(r"CREATE TABLESPACE ts_bitacora\n.*?;\n?", "", b, flags=re.S)
        else:
            if b.lstrip().startswith("-- Bitácora"):
                continue
            b = "\n".join(l for l in b.split("\n") if not re.search(r"\b(pago|pk_pago)\b", l))
        if b.strip():
            res.append(b.rstrip("\n"))
    return "\n\n".join(res)

DERIVADO = "Tablespaces, adaptado a la segunda instancia (sin pago ni bitacora)"
escribir("postgresql/instancia2/10_postgres_tablespaces.sql", "Sistema de Inversiones · PostgreSQL 2 · 10_postgres_tablespaces.sql",
         "postgres (puerto 5434, base postgres)", DERIVADO, [segunda_instancia(B["09"][1], "pg", True)], PG_ENC)
escribir("postgresql/instancia2/11_dba_tablespaces.sql", "Sistema de Inversiones · PostgreSQL 2 · 11_dba_tablespaces.sql",
         "dlandero (puerto 5434, base inversiones)", DERIVADO, [segunda_instancia(B["09"][2], "pg", False)], PG_ENC)
escribir("postgresql/instancia2/20_dba_particionamiento.sql", "Sistema de Inversiones · PostgreSQL 2 · 20_dba_particionamiento.sql",
         "dlandero (puerto 5434, base inversiones)", "Particionamiento > PostgreSQL", [B["11"][0]], PG_ENC)
escribir("postgresql/instancia2/30_dba_segmentacion.sql", "Sistema de Inversiones · PostgreSQL 2 · 30_dba_segmentacion.sql",
         "dlandero (puerto 5434, base inversiones), DESPUES del particionamiento", "Segmentación > PostgreSQL", [B["12"][0]], PG_ENC)
escribir("mysql/instancia2/10_root_tablespaces.sql", "Sistema de Inversiones · MySQL 2 · 10_root_tablespaces.sql",
         "root (puerto 3308)", DERIVADO, [segunda_instancia(B["09"][8], "mysql", True)], MY_ENC)
escribir("mysql/instancia2/11_dba_tablespaces.sql", "Sistema de Inversiones · MySQL 2 · 11_dba_tablespaces.sql",
         "dlandero (puerto 3308, base inversiones)", DERIVADO, [segunda_instancia(B["09"][9], "mysql", False)], MY_ENC)
escribir("mysql/instancia2/20_dba_particionamiento.sql", "Sistema de Inversiones · MySQL 2 · 20_dba_particionamiento.sql",
         "dlandero (puerto 3308, base inversiones)", "Particionamiento > MySQL", [B["11"][5]], MY_ENC)
escribir("mysql/instancia2/30_dba_segmentacion.sql", "Sistema de Inversiones · MySQL 2 · 30_dba_segmentacion.sql",
         "dlandero (puerto 3308, base inversiones), DESPUES del particionamiento", "Segmentación > MySQL", [B["12"][4]], MY_ENC)

for gestor, pre, enc in (("postgresql", "pg", PG_ENC), ("mysql", "mysql", MY_ENC)):
    consultas = [
        (f"{pre}-instancia2", "superusuario (segunda instancia)", "Multi-instancias", B["10"][5 if pre == "pg" else 10]),
        (f"{pre}-instancias-datos", "dlandero (en AMBAS instancias)", "Multi-instancias", B["10"][13]),
        (f"{pre}-particiones", "dlandero (segunda instancia)", "Particionamiento", B["11"][1 if pre == "pg" else 6]),
        (f"{pre}-poda", "dlandero (segunda instancia)", "Particionamiento", B["11"][2]),
        (f"{pre}-integridad-tesoreria", "xzaleta (segunda instancia)", "Particionamiento", B["11"][3]),
        (f"{pre}-integridad-dba", "dlandero (segunda instancia)", "Particionamiento", B["11"][4]),
        (f"{pre}-segmentacion-vistas", "dlandero (segunda instancia)", "Segmentación", B["12"][1]),
        (f"{pre}-segmentacion-horizontal", "dlandero (segunda instancia)", "Segmentación", B["12"][2]),
        (f"{pre}-segmentacion-vertical", "dlandero (segunda instancia)", "Segmentación", B["12"][3]),
    ]
    for nombre, ejecuta, origen, sql in consultas:
        escribir(f"{gestor}/consultas/{nombre}.sql", f"Captura {ruta_captura(nombre)}", ejecuta, origen, [sql], enc)

print("listo")
