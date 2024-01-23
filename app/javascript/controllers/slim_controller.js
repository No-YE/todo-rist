import { Controller } from '@hotwired/stimulus'
import SlimSelect from 'slim-select'

export default class extends Controller {
  static values = { searchUrl: String }

  connect() {
    this.select = new SlimSelect({
      select: this.element,
      events: {
        search: async (search, currentData) => {
          const response = await fetch(this.searchUrlValue + '?q=' + search)
          const data = await response.json()

          return data.map(({ text, value }) => ({ text, value }))
        },
      },
    })

    this.element.classList.remove('hidden')
  }
}
