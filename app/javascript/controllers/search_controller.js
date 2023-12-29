import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  TIMEOUT = 300

  search() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, this.TIMEOUT)
  }
}
