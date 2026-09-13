import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.updateCounter()
    this.element.addEventListener("input", this.updateCounter.bind(this))
  }

  updateCounter() {
    const input = this.element
    const maxLength = input.getAttribute("maxlength")
    const currentLength = input.value.length
    const counterId = input.dataset.target
    const counter = document.getElementById(counterId)

    if (counter) {
      counter.textContent = currentLength

      // Muda cor quando próximo do limite
      if (currentLength >= maxLength * 0.9) {
        counter.style.color = "red"
      } else if (currentLength >= maxLength * 0.7) {
        counter.style.color = "orange"
      } else {
        counter.style.color = "green"
      }
    }
  }
}
