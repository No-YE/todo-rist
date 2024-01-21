import { Controller } from '@hotwired/stimulus'
import { marked } from 'marked'

export default class extends Controller {
  TIMEOUT = 500
  static targets = ['input', 'output']

  connect() {
    this.render()
  }

  render() {
    const input = this.inputTarget
    const output = this.outputTarget

    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      output.innerHTML = marked(input.value)
    }, this.TIMEOUT)
  }
}
