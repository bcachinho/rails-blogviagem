import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template", "container"]

  add(event) {
    event.preventDefault()
    let content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    this.containerTarget.insertAdjacentHTML("beforeend", content)
  }

  remove(event) {
    event.preventDefault()
    let wrapper = event.target.closest(".embed-fields")
    if (wrapper.querySelector("input[name*='_destroy']")) {
      wrapper.querySelector("input[name*='_destroy']").value = "1"
      wrapper.style.display = "none"
    } else {
      wrapper.remove()
    }
  }
}
