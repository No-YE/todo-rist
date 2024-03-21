import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['dialog']

  connect() {
    this.element.dataset.action = 'modal#show';
  }

  show(event) {
    const dialog = document.getElementById(event.params.dialog)
    dialog.showModal()

    dialog.addEventListener('click', (event) => {
      if (event.target === dialog) {
        dialog.close()
      }
    })
  }
}
