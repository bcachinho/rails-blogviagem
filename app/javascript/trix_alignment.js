// document.addEventListener("trix-initialize", (event) => {
//   const toolbar = event.target.toolbarElement

//   // Criar um grupo de botões para alinhamento
//   let group = document.createElement("span")
//   group.className = "trix-button-group trix-button-group--text-tools"

//   const buttons = [
//     { label: "⯇", command: "justifyLeft", title: "Alinhar à esquerda" },
//     { label: "⭗", command: "justifyCenter", title: "Centralizar" },
//     { label: "⯈", command: "justifyRight", title: "Alinhar à direita" },
//     { label: "≡", command: "justifyFull", title: "Justificar" }
//   ]

//   buttons.forEach(btn => {
//     let button = document.createElement("button")
//     button.type = "button"
//     button.className = "trix-button"
//     button.innerHTML = btn.label
//     button.setAttribute("title", btn.title)

//     button.addEventListener("click", (e) => {
//       e.preventDefault()
//       document.execCommand(btn.command, false, null)
//     })

//     group.appendChild(button)
//   })

//   // Adicionar o grupo na toolbar do Trix
//   toolbar.querySelector(".trix-button-row").appendChild(group)
// })
