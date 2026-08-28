describe("Login test", () => {
  let users;

  before(() => {
    cy.fixture("users").then((data) => {
      users = data;
    });
  });

  beforeEach(() => {
    cy.visit("https://www.saucedemo.com/");
  });

  it("Login exitoso con credenciales válidas", () => {
    cy.log(users.valid.username);
    cy.log(users.valid.password);
    cy.login(users.valid.username, users.valid.password);
    cy.url().should("include", "/inventory.html");
    cy.get(".title").should("have.text", "Products");           
  });
    it("Login fallido con contraseña incorrecta", () => {
    cy.log(users.incorrectPassword.username);
    cy.log(users.incorrectPassword.password);
    cy.login(users.incorrectPassword.username, users.incorrectPassword.password);
    cy.url().should("eq", "https://www.saucedemo.com/");    
    cy.get('[data-test="error"]')
      .should("be.visible")
      .and(
        "contain.text",
        "Epic sadface: Username and password do not match any user in this service"
      );
    cy.get("#login-button").should("be.visible");          
  });
   it("Validación de campos obligatorios", () => {
   
    cy.get("#user-name").should("have.value", "");
    cy.get("#password").should("have.value", "");
    cy.get("#login-button").click();
    cy.get('[data-test="error"]')
      .should("be.visible")
      .and("contain.text", "Epic sadface: Username is required");
    
    cy.log(users.valid.username);
    cy.get("#user-name").clear().type(users.valid.username);
    cy.get("#login-button").click();
    cy.get('[data-test="error"]')
      .should("be.visible")
      .and("contain.text", "Epic sadface: Password is required");

        cy.url().should("eq", "https://www.saucedemo.com/");
  });
});
