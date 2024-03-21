Turbo.StreamActions.show_remote_modal = function () {
  const container = document.querySelector('remote-modal-container')
  container.replaceChildren(this.templateContent)
  const dialog = container.querySelector("dialog")

  dialog.showModal()

  dialog.addEventListener('click', handle)

  function handle(event) {
    if (event.target === this.element) {
      dialog.close()
      dialog.removeEventListener('click', handle)
    }
  }
}
