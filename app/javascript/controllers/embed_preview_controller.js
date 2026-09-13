import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "output"]

  update() {
    const code = this.inputTarget.value.trim()

    if (code.length > 0) {
      // Verifica se é um iframe válido
      if (code.includes('<iframe') && code.includes('</iframe>')) {
        this.outputTarget.innerHTML = code
      } else {
        this.outputTarget.innerHTML = `
          <div class="alert alert-warning">
            <small>⚠️ Cole um código &lt;iframe&gt; válido (Google Maps, YouTube, etc.)</small>
          </div>
        `
      }
    } else {
      this.outputTarget.innerHTML = "<p class='text-muted'>Cole aqui um código para ver a prévia 👇</p>"
    }
  }
}
