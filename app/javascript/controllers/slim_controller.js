import { Controller } from '@hotwired/stimulus'
import SlimSelect from 'slim-select'

export default class extends Controller {
  static values = { searchUrl: String, placeholder: String }

  connect() {
    this.#initializeSlimSelect()
  }

  #initializeSlimSelect() {
    this.select = new SlimSelect({
      select: this.element,
      settings: {
        placeholderText: this.placeholderValue,
      },
      events: {
        search: async (search, currentData) => {
          const response = await fetch(this.searchUrlValue + '?q=' + search)
          const data = await response.json()

          return data.map(({ text, value }) => ({ text, value }))
        },
      },
    })

    document.getElementsByClassName('ss-content')[0].setAttribute('data-turbo-permanent', '')

    this.element.classList.remove('hidden')
  }
}
