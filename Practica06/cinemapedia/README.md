# Práctica 06 — Cinemapedia

Cinemapedia es una aplicación móvil desarrollada con Flutter para explorar películas y series. La información de títulos, reparto y videos se consulta desde [The Movie Database (TMDB)](https://www.themoviedb.org/).

## Funcionalidades

- Catálogos de películas en cartelera, próximas, populares y mejor valoradas.
- Búsqueda de películas y vista de detalles con sinopsis, géneros y reparto.
- Inicio de series con tendencias, títulos populares y series en emisión.
- Detalles de series con reparto, tráilers y favoritos persistentes.
- Favoritos de películas y series guardados por separado.
- Interfaz disponible en español, inglés, alemán, coreano, francés, japonés y portugués.
- Pantalla de configuración para cambiar el idioma de la aplicación.
- Navegación con `go_router` y estado administrado con Riverpod.

## Arquitectura

- **Diagrama interactivo:** [Abrir en GitHub Pages](https://devfntxy.github.io/Practicas_DMI_230892/Practica06/assets/diagram/diagrama_arquitectura.html).
- **Archivo fuente del diagrama:** [diagrama_arquitectura.html](../assets/diagram/diagrama_arquitectura.html).


### Inicio y navegación

| Pantalla de carga | Menú lateral |
|---|---|
| <img src="assets/caps/pantallaCarga.png" alt="Pantalla de carga de Cinemapedia" width="300"> | <img src="assets/caps/slidebarFuncionIdioma.png" alt="Menú lateral y acceso a configuración" width="300"> |

### Búsqueda y detalles

| Búsqueda de películas | Resultados de búsqueda |
|---|---|
| <img src="assets/caps/funcionBusqueda.png" alt="Búsqueda de películas" width="300"> | <img src="assets/caps/pantallaBusqueda.png" alt="Resultados para la búsqueda de Buddy" width="300"> |

| Detalle de película y reparto |
|---|
| <img src="assets/caps/pantallaActoresBusqueda.png" alt="Detalle de película con sinopsis, géneros y reparto" width="300"> |

### Selección de idioma

La aplicación permite elegir español, inglés, alemán, coreano, francés, japonés o portugués desde Configuración. El idioma elegido también se envía a TMDB para recibir los títulos, sinopsis, géneros y datos del reparto localizados:

| Español | Inglés |
|---|---|
| <img src="assets/caps/idiomaEspa%C3%B1ol.png" alt="Selección de español" width="300"> | <img src="assets/caps/idiomaIngles.png" alt="Selección de inglés" width="300"> |

| Alemán | Coreano |
|---|---|
| <img src="assets/caps/idiomaAleman.png" alt="Selección de alemán" width="300"> | <img src="assets/caps/idiomaCoreano.png" alt="Selección de coreano" width="300"> |

### Pantalla de inicio por idioma

| Español | Inglés |
|---|---|
| <img src="assets/caps/pantallaEspa%C3%B1ol.png" alt="Pantalla de inicio en español" width="300"> | <img src="assets/caps/pantallaIngles.png" alt="Pantalla de inicio en inglés" width="300"> |

| Alemán | Coreano |
|---|---|
| <img src="assets/caps/pantallaAleman.png" alt="Pantalla de inicio en alemán" width="300"> | <img src="assets/caps/pantallaCoreano.png" alt="Pantalla de inicio en coreano" width="300"> |

### Icono instalado

| Cinemapedia instalada | Icono usado para la aplicación |
|---|---|
| <img src="assets/caps/appInstalada.png" alt="Cinemapedia instalada en el dispositivo" width="300"> | <img src="assets/fanso-cinemapedia-app-icon.png" alt="Icono de Cinemapedia" width="300"> |

### Categorías y favoritos

| Categorías | Resultados de una categoría |
|---|---|
| <img src="assets/caps/pantallaCategoria.png" alt="Listado de categorías" width="300"> | <img src="assets/caps/pantallaCategoria-resultado.png" alt="Películas de una categoría" width="300"> |

| Películas favoritas | Series favoritas |
|---|---|
| <img src="assets/caps/pantallaFavoritopelicula.png" alt="Favoritos de películas" width="300"> | <img src="assets/caps/pantallaFavoritoSerie.png" alt="Favoritos de series" width="300"> |

## Reto

### Series

| Inicio de series | Búsqueda |
|---|---|
| <img src="assets/caps/reto/pantallaInicioSeries.png" alt="Pantalla de inicio de series" width="300"> | <img src="assets/caps/reto/funcionBusqueda.png" alt="Búsqueda de títulos" width="300"> |

| Resultados de búsqueda | Serie favorita |
|---|---|
| <img src="assets/caps/reto/resultadosBusqueda.png" alt="Resultados de búsqueda con series y películas" width="300"> | <img src="assets/caps/reto/serieFavorita.png" alt="Detalle de una serie favorita" width="300"> |

### Películas

| Descripción, reparto y géneros | Tráiler y recomendaciones |
|---|---|
| <img src="assets/caps/reto/pantallaPelicula-descripcion-reparto-genero.png" alt="Descripción, reparto y géneros de una película" width="300"> | <img src="assets/caps/reto/pantallaPelicula-trailer-recomendaciones.png" alt="Tráiler y recomendaciones de películas" width="300"> |

## Requisitos

- Flutter SDK compatible con la versión indicada en `pubspec.yaml`.
- Una clave de API de TMDB para cargar datos de películas.

## Configuración y ejecución

Desde la raíz del repositorio, entra al proyecto:

```shell
cd Practica06/cinemapedia
```

Crea un archivo `.env` junto a `pubspec.yaml` con tu clave de TMDB:

```dotenv
THE_MOVIEDB_KEY=tu_clave_de_tmdb
```

Después instala las dependencias e inicia la aplicación:

```shell
flutter pub get
flutter run
```

Para ejecutar las pruebas:

```shell
flutter test
```
