import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['dialog']

  connect() {
    this.dialogTarget.addEventListener('click', (event) => {
      if (event.target === this.dialogTarget) {
        this.close()
      }
    })
  }

  open() {
    this.dialogTarget.showModal()
    document.body.classList.add('overflow-hidden')
  }

  close() {
    this.dialogTarget.close()
    document.body.classList.remove('overflow-hidden')
  }
}
