# Módulo de Automatización - SauceDemo


## Requisitos previos

- [Node.js](https://nodejs.org/) (v18 o superior recomendado)
- npm

## Instalación

```bash
npm install
```

### Verificación automática del entorno

El script [verify-setup.ps1](verify-setup.ps1) (PowerShell) verifica que Node.js, npm y Cypress
estén correctamente instalados, instala lo que falte y finalmente ejecuta el Test Runner
de Cypress (`npm run cypress:open`):

```powershell
.\verify-setup.ps1
```

## Ejecución de las pruebas

**Modo interactivo (Cypress Test Runner):**

```bash
npm run cypress:open
```

**Modo headless (línea de comandos):**


```bash
npm test
npm run cypress:open
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
├── verify-setup.ps1              # Script de verificación/instalación del entorno
└── package.json
```

