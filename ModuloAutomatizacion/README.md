# Módulo de Automatización - SauceDemo


## Requisitos previos

- [Node.js](https://nodejs.org/) (v18 o superior recomendado)
- npm

## Instalación

```bash
npm install
```

## Ejecución de las pruebas

**Modo interactivo (Cypress Test Runner):**

```bash
npm run cypress:open
```

**Modo headless (línea de comandos):**


```bash
npm test
```

## Estructura del proyecto

```
ModuloAutomatizacion/
├── cypress/
│   ├── e2e/
│   │   └── getting-started/
│   │       └── login.cy.js      # Casos de prueba de login
│   ├── fixtures/
│   │   └── users.json           # Datos de usuarios de prueba
│   └── support/
│       ├── commands.js          # Comando custom cy.login()
│       └── e2e.js
├── cypress.config.js
└── package.json
```

