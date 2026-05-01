// =============================================================================
//  main.typ
//  Example report using the template
// =============================================================================
#import "@local/undav:1.0.0": report

#show: report.with(
  titulo:  "TP1: Título del trabajo práctico",
  materia: "Nombre de la materia",
  carrera: "Ingeniería Informática",
  autor:   "Manuel Lopez Cosmitz",
)

// Table of contents
#outline()
#pagebreak()

// =============================================================================
//  Sections  (each one would normally live in its own .typ file)
// =============================================================================

= Introducción

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Typst genera
documentos justificados de forma predeterminada y el idioma queda configurado
en el template, por lo que la separación silábica es en español.

== Subsección de ejemplo

Texto de la subsección. Se puede referenciar la @fig-ejemplo o la @tabla-ejemplo
más abajo.

= Código

Bloques de código sin configuración extra:

```php
<?php

function saludar(string $nombre): string
{
    return "Hola, {$nombre}!";
}

echo saludar("Manuel");
```

Inline también funciona: `$variable = 42;`

= Imágenes y figuras

#figure(
  rect(width: 6cm, height: 3cm, fill: luma(220)),   // reemplazar con image(...)
  caption: [Descripción de la figura],
) <fig-ejemplo>

= Tablas

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    [*ID*], [*Nombre*], [*Valor*],
    [1],    [Alpha],    [42],
    [2],    [Beta],     [17],
    [3],    [Gamma],    [99],
  ),
  caption: [Tabla de ejemplo],
) <tabla-ejemplo>

= Matemáticas

Typst tiene soporte matemático nativo. Ecuación en línea: $E = m c^2$.

Ecuación en bloque:

$ integral_0^infinity e^(-x^2) d x = sqrt(pi) / 2 $

= Conclusión

Texto de la conclusión del trabajo.
