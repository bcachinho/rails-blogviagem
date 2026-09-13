import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "output"]

  connect() {
    this.update() // Atualiza na primeira vez que carrega
  }

  update() {
    const value = this.inputTarget.value
    this.outputTarget.style.textAlign = value

    const alignmentNames = {
      left: "à esquerda",
      center: "centralizado",
      right: "à direita",
      justify: "justificado"
    }

    this.outputTarget.innerHTML = `
      <p>Este é um exemplo de texto <strong>${alignmentNames[value]}</strong>.
      Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
    `
  }
}
