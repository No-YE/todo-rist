import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = [ "collapse" ]

  toggle() {
    this.collapseTarget.classList.toggle('hidden')
  }
}
